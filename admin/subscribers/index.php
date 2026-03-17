<?php
/**
 * Newsletter Subscribers Admin Page
 * View and export subscriber list - Styled for WHMCS Admin
 */

// Start session
session_start();

// Load database credentials from WHMCS configuration
require_once __DIR__ . '/../../configuration.php';

// Simple check - if we're in the admin area and have any WHMCS session data, we're likely authenticated
$authenticated = false;

// Check for WHMCS session cookie
foreach ($_COOKIE as $name => $value) {
    if (strpos($name, 'WHMCS') !== false || strpos($name, 'whmcs') !== false) {
        $authenticated = true;
        break;
    }
}

if (isset($_SESSION['adminid']) && $_SESSION['adminid'] > 0) {
    $authenticated = true;
}

// Check admin session in WHMCS session path
if (isset($_COOKIE['PHPSESSID'])) {
    $session_file = '/home/undomains/whmcs_data/sessions/sess_' . $_COOKIE['PHPSESSID'];
    if (file_exists($session_file)) {
        $session_data = file_get_contents($session_file);
        if (strpos($session_data, 'adminid') !== false) {
            $authenticated = true;
        }
    }
}

if (!$authenticated) {
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

// Get admin user info for gravatar
$admin_email = '';
if (isset($_SESSION['adminemail'])) {
    $admin_email = $_SESSION['adminemail'];
}
$gravatar_hash = md5(strtolower(trim($admin_email)));
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="referrer" content="same-origin">

    <title>Undomains - Newsletter Subscribers</title>

    <link rel="icon" type="image/png" href="/admin/templates/blend/images/favicon.png" />

    <link href="/assets/fonts/css/open-sans-family.css" rel="stylesheet" type="text/css" />
    <link href="/admin/templates/blend/css/all.min.css" rel="stylesheet" />
    <link href="/admin/templates/blend/css/theme.min.css" rel="stylesheet" />
    <link href="/admin/templates/blend/css/undomains-theme.css" rel="stylesheet" />
    <link href="/assets/fonts/css/fontawesome.min.css" rel="stylesheet" />
    <link href="/assets/fonts/css/fontawesome-solid.min.css" rel="stylesheet" />
    
    <script type="text/javascript" src="/admin/templates/blend/js/vendor.min.js"></script>
    <script type="text/javascript" src="/admin/templates/blend/js/scripts.min.js"></script>
</head>
<body>

    <div class="navigation">
        <a href="/admin/index.php" class="logo" title="Home">
            <img src="/admin/templates/blend/images/undomains-dark-logo.png" style="max-height: 40px; padding-top: 5px;">
        </a>

        <ul class="left-nav">
            <li class="bt visible-sidebar">
                <a href="#" class="nav-toggle" id="btnNavbarToggle" aria-label="Navigation">
                    <i aria-hidden="true" class="fas fa-bars always"></i>
                </a>
            </li>
        </ul>

        <div class="navbar-collapse">
            <ul>
                <li class="has-dropdown">
                    <a id="Menu-Utilities" href="#" onclick="return false;">
                        <i class="fas fa-file-alt"></i>
                        Utilities
                        <span class="caret"></span>
                    </a>
                    <ul>
                        <li><a id="Menu-Utilities-Newsletter_Subscribers" href="/admin/subscribers/"><i class="fas fa-envelope"></i> Newsletter Subscribers</a></li>
                    </ul>
                </li>
            </ul>

            <ul class="right-nav">
                <li class="bt account has-dropdown">
                    <a id="Menu-Account" href="#" onclick="return false;">
                        <img src="https://www.gravatar.com/avatar/<?php echo $gravatar_hash; ?>?s=25&d=mp" class="profile-icon" alt="Account" />
                        <span class="visible-sidebar">Account</span>
                    </a>
                    <ul class="slim drop-left">
                        <li><a href="/admin/myaccount.php">My Account</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/admin/logout.php">Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>

    <div class="sidebar" id="sidebar">
        <a href="#" class="sidebar-collapse-expand" id="sidebarCollapseExpand">
            <i class="fa fa-chevron-down"></i>
        </a>
        <div class="sidebar-collapse">
            <div class="sidebar-header">
                <i class="fas fa-cubes"></i>
                Utilities
            </div>
            <ul class="menu">
                <li><a href="/admin/subscribers/"><i class="fas fa-envelope"></i> Newsletter Subscribers</a></li>
            </ul>
        </div>
    </div>
    <a href="#" class="sidebar-opener" id="sidebarOpener">Open Sidebar</a>

    <div class="contentarea" id="contentarea">
        <div style="float:left;width:100%;">
            <h1><i class="fas fa-envelope"></i> Newsletter Subscribers</h1>

            <div class="row">
                <div class="col-md-3 col-sm-6">
                    <div class="health-status-block status-badge-blue clearfix">
                        <div class="icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="detail">
                            <span class="count"><?php echo $total; ?></span>
                            <span class="desc">Total Subscribers</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="health-status-block status-badge-green clearfix">
                        <div class="icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="detail">
                            <span class="count"><?php echo $active; ?></span>
                            <span class="desc">Active</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="fas fa-list"></i> Subscriber List
                        <div class="pull-right">
                            <a href="?export=csv" class="btn btn-success btn-sm">
                                <i class="fas fa-download"></i> Export to CSV
                            </a>
                        </div>
                    </h3>
                </div>
                <div class="panel-body">
                    <table class="datatable table table-striped table-bordered">
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
                </div>
            </div>
        </div>
        <div class="clear"></div>
    </div>

    <div class="footerbar">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-6 copyright">
                    <i class="fas fa-copyright"></i> Copyright <?php echo date('Y'); ?> 
                    <a href="https://undomains.com/" target="_blank">Undomains</a>.
                    Part of <a href="https://un4.com/" target="_blank">UN4</a>
                </div>
                <div class="col-md-6 links text-right">
                    <a href="https://undomains.com/" target="_blank" title="Visit Undomains"><i class="fas fa-globe"></i> Website</a>
                    <span class="divider">|</span>
                    <a href="https://go.whmcs.com/1893/docs" target="_blank"><i class="fas fa-book"></i> Documentation</a>
                    <span class="divider">|</span>
                    <a href="https://www.whmcs.com/report-a-bug" target="_blank"><i class="fas fa-bug"></i> Report Bug</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // Sidebar toggle
            $('#sidebarCollapseExpand').click(function(e) {
                e.preventDefault();
                $(this).toggleClass('expanded');
                $('.sidebar-collapse').slideToggle();
            });

            $('#sidebarOpener').click(function(e) {
                e.preventDefault();
                $(this).fadeOut();
                $('#contentarea').removeClass('sidebar-minimized');
                $('#sidebar').delay(400).fadeIn('fast');
            });

            $('#sidebarClose').click(function(e) {
                e.preventDefault();
                $('#sidebar').fadeOut('fast', function(){
                    $('#contentarea').addClass('sidebar-minimized');
                    $('#sidebarOpener').fadeIn();
                });
            });
        });
    </script>
</body>
</html>
