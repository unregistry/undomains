<?php
/**
 * Newsletter Subscribers Admin Page
 * View and export subscriber list
 */

// Start session
session_start();

// Load database credentials from WHMCS configuration
require_once __DIR__ . '/../../configuration.php';

// Simple check - if we're in the admin area and have any WHMCS session data, we're likely authenticated
// This checks for the presence of a WHMCS session cookie
$authenticated = false;

// Check for WHMCS session cookie (the session name might vary)
foreach ($_COOKIE as $name => $value) {
    if (strpos($name, 'WHMCS') !== false || strpos($name, 'whmcs') !== false) {
        $authenticated = true;
        break;
    }
}

// Also check if there's an adminid in session
if (isset($_SESSION['adminid']) && $_SESSION['adminid'] > 0) {
    $authenticated = true;
}

// If the request comes from the admin area (referer check)
if (isset($_SERVER['HTTP_REFERER']) && strpos($_SERVER['HTTP_REFERER'], '/admin/') !== false) {
    $authenticated = true;
}

// If not authenticated, show a simple login required message instead of redirect
if (!$authenticated) {
    // Try to check if user has access by looking for admin session in WHMCS session path
    if (isset($_COOKIE['PHPSESSID'])) {
        $session_file = '/home/undomains/whmcs_data/sessions/sess_' . $_COOKIE['PHPSESSID'];
        if (file_exists($session_file)) {
            $session_data = file_get_contents($session_file);
            if (strpos($session_data, 'adminid') !== false) {
                $authenticated = true;
            }
        }
    }
}

if (!$authenticated) {
    die('<!DOCTYPE html>
<html>
<head><title>Access Denied</title></head>
<body style="padding: 50px; text-align: center; font-family: sans-serif;">
    <h2>Access Denied</h2>
    <p>Please <a href="/admin/login.php">log in to the admin panel</a> first.</p>
    <p><small>If you are already logged in, <a href="/admin/subscribers/">click here to retry</a>.</small></p>
</body>
</html>');
}

// Connect to database
$mysqli = new mysqli($db_host, $db_username, $db_password, $db_name);
if ($mysqli->connect_error) {
    die('Database connection failed: ' . $mysqli->connect_error);
}

// Handle export request
if (isset($_GET['export']) && $_GET['export'] === 'csv') {
    header('Content-Type: text/csv');
    header('Content-Disposition: attachment; filename="newsletter_subscribers_' . date('Y-m-d') . '.csv"');
    
    $output = fopen('php://output', 'w');
    fputcsv($output, ['Email', 'Subscribed Date', 'Status', 'IP Address']);
    
    $result = $mysqli->query("SELECT email, subscribed_at, status, ip_address FROM mod_newsletter_subscribers ORDER BY subscribed_at DESC");
    while ($row = $result->fetch_assoc()) {
        fputcsv($output, [$row['email'], $row['subscribed_at'], $row['status'], $row['ip_address']]);
    }
    fclose($output);
    exit;
}

// Get subscriber stats
$total_result = $mysqli->query("SELECT COUNT(*) as total FROM mod_newsletter_subscribers");
$total = $total_result->fetch_assoc()['total'];

$active_result = $mysqli->query("SELECT COUNT(*) as active FROM mod_newsletter_subscribers WHERE status = 'active'");
$active = $active_result->fetch_assoc()['active'];

// Get recent subscribers
$recent = $mysqli->query("SELECT * FROM mod_newsletter_subscribers ORDER BY subscribed_at DESC LIMIT 50");
?>
<!DOCTYPE html>
<html>
<head>
    <title>Newsletter Subscribers</title>
    <link rel="stylesheet" href="/admin/templates/blend/css/all.min.css">
    <style>
        body { padding: 20px; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
        .stats { margin-bottom: 20px; }
        .stats .stat-box { display: inline-block; padding: 15px 25px; background: #f5f5f5; border-radius: 5px; margin-right: 15px; }
        .stats .stat-box strong { display: block; font-size: 24px; color: #333; }
        .stats .stat-box span { color: #666; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #1a4d80; color: #fff; }
        .label { padding: 4px 8px; border-radius: 3px; font-size: 12px; }
        .label-success { background: #5cb85c; color: white; }
        .label-default { background: #777; color: white; }
        .btn { display: inline-block; padding: 8px 16px; background: #337ab7; color: white; text-decoration: none; border-radius: 4px; }
        .btn:hover { background: #286090; }
        h1 { margin-bottom: 20px; }
        .back-link { margin-bottom: 20px; }
        .back-link a { color: #337ab7; text-decoration: none; }
    </style>
</head>
<body>
    <div class="back-link">
        <a href="/admin/index.php">&larr; Back to Admin</a>
    </div>
    
    <h1>Newsletter Subscribers</h1>
    
    <div class="stats">
        <div class="stat-box">
            <strong><?php echo $total; ?></strong>
            <span>Total Subscribers</span>
        </div>
        <div class="stat-box">
            <strong><?php echo $active; ?></strong>
            <span>Active</span>
        </div>
    </div>
    
    <p>
        <a href="?export=csv" class="btn"><i class="fas fa-download"></i> Export to CSV</a>
    </p>
    
    <table>
        <thead>
            <tr>
                <th>Email</th>
                <th>Subscribed Date</th>
                <th>Status</th>
                <th>IP Address</th>
            </tr>
        </thead>
        <tbody>
            <?php while ($row = $recent->fetch_assoc()): ?>
            <tr>
                <td><?php echo htmlspecialchars($row['email']); ?></td>
                <td><?php echo $row['subscribed_at']; ?></td>
                <td>
                    <span class="label label-<?php echo $row['status'] === 'active' ? 'success' : 'default'; ?>">
                        <?php echo ucfirst($row['status']); ?>
                    </span>
                </td>
                <td><?php echo htmlspecialchars($row['ip_address']); ?></td>
            </tr>
            <?php endwhile; ?>
        </tbody>
    </table>
</body>
</html>
