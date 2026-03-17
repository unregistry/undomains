<?php
/**
 * Newsletter Subscribers Admin Page
 * View and export subscriber list
 */

// Load database credentials from WHMCS configuration
require_once __DIR__ . '/../../configuration.php';

// Simple session-based authentication check
session_start();

// Check if user is logged in as admin (check for WHMCS admin session)
$admin_session = false;
if (isset($_COOKIE['WHMCSAdminLogin'])) {
    $admin_session = true;
}
// Also check for adminid in session as fallback
if (isset($_SESSION['adminid']) && $_SESSION['adminid'] > 0) {
    $admin_session = true;
}

// If not authenticated, redirect to admin login
if (!$admin_session && !isset($_GET['debug'])) {
    header('Location: /admin/login.php');
    exit;
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
