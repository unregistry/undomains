<?php
/**
 * Newsletter Subscribers Admin Page
 * View and export subscriber list
 */

require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../includes/functions.php';

// Check admin authentication
if (!isset($_SESSION['adminid'])) {
    header('Location: ../login.php');
    exit;
}

// Load database credentials
require_once __DIR__ . '/../../configuration.php';

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
    <link rel="stylesheet" href="../templates/blend/css/all.min.css">
    <style>
        body { padding: 20px; }
        .stats { margin-bottom: 20px; }
        .stats .stat-box { display: inline-block; padding: 15px 25px; background: #f5f5f5; border-radius: 5px; margin-right: 15px; }
        .stats .stat-box strong { display: block; font-size: 24px; color: #333; }
        .stats .stat-box span { color: #666; }
    </style>
</head>
<body>
    <h1><i class="fas fa-envelope"></i> Newsletter Subscribers</h1>
    
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
        <a href="?export=csv" class="btn btn-primary"><i class="fas fa-download"></i> Export to CSV</a>
    </p>
    
    <table class="datatable" style="width: 100%;">
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
