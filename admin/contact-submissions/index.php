<?php
/**
 * Contact Form Submissions Admin Page
 * View and manage contact form submissions
 */

session_start();
require_once __DIR__ . '/../../configuration.php';

// Authentication check
$authenticated = false;
foreach ($_COOKIE as $name => $value) {
    if (strpos($name, 'WHMCS') !== false || strpos($name, 'whmcs') !== false) {
        $authenticated = true;
        break;
    }
}
if (isset($_SESSION['adminid']) && $_SESSION['adminid'] > 0) {
    $authenticated = true;
}
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

// Database connection
$mysqli = new mysqli($db_host, $db_username, $db_password, $db_name);
if ($mysqli->connect_error) {
    die('Database connection failed: ' . $mysqli->connect_error);
}

// Handle status update
if (isset($_POST['action']) && $_POST['action'] === 'update_status' && isset($_POST['id']) && isset($_POST['status'])) {
    $id = intval($_POST['id']);
    $status = $_POST['status'] === 'read' ? 'read' : ($_POST['status'] === 'replied' ? 'replied' : 'new');
    $stmt = $mysqli->prepare("UPDATE mod_contact_form_submissions SET status = ? WHERE id = ?");
    $stmt->bind_param("si", $status, $id);
    $stmt->execute();
    $stmt->close();
    header('Location: ' . $_SERVER['PHP_SELF']);
    exit;
}

// Handle delete
if (isset($_GET['delete']) && is_numeric($_GET['delete'])) {
    $id = intval($_GET['delete']);
    $stmt = $mysqli->prepare("DELETE FROM mod_contact_form_submissions WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $stmt->close();
    header('Location: ' . $_SERVER['PHP_SELF']);
    exit;
}

// Handle export
if (isset($_GET['export']) && $_GET['export'] === 'csv') {
    header('Content-Type: text/csv');
    header('Content-Disposition: attachment; filename="contact_submissions_' . date('Y-m-d') . '.csv"');
    $output = fopen('php://output', 'w');
    fputcsv($output, ['Date', 'Name', 'Email', 'Subject', 'Message', 'IP Address', 'Status']);
    $result = $mysqli->query("SELECT * FROM mod_contact_form_submissions ORDER BY submitted_at DESC");
    while ($row = $result->fetch_assoc()) {
        fputcsv($output, [$row['submitted_at'], $row['name'], $row['email'], $row['subject'], $row['message'], $row['ip_address'], $row['status']]);
    }
    fclose($output);
    exit;
}

// Stats
$total_result = $mysqli->query("SELECT COUNT(*) as total FROM mod_contact_form_submissions");
$total = $total_result->fetch_assoc()['total'];

$new_result = $mysqli->query("SELECT COUNT(*) as new FROM mod_contact_form_submissions WHERE status = 'new'");
$new_count = $new_result->fetch_assoc()['new'];

// Get submissions
$page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
$per_page = 20;
$offset = ($page - 1) * $per_page;

$submissions = $mysqli->query("SELECT * FROM mod_contact_form_submissions ORDER BY submitted_at DESC LIMIT $per_page OFFSET $offset");
$total_pages = ceil($total / $per_page);

// Admin info
$admin_email = $_SESSION['adminemail'] ?? '';
$gravatar_hash = md5(strtolower(trim($admin_email)));
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Contact Form Submissions - Undomains</title>
    <link rel="icon" type="image/png" href="/admin/templates/blend/images/favicon.png" />
    <link href="/assets/fonts/css/open-sans-family.css" rel="stylesheet" type="text/css" />
    <link href="/admin/templates/blend/css/all.min.css" rel="stylesheet" />
    <link href="/admin/templates/blend/css/theme.min.css" rel="stylesheet" />
    <link href="/admin/templates/blend/css/undomains-theme.css" rel="stylesheet" />
    <link href="/assets/fonts/css/fontawesome.min.css" rel="stylesheet" />
    <link href="/assets/fonts/css/fontawesome-solid.min.css" rel="stylesheet" />
    <script type="text/javascript" src="/admin/templates/blend/js/vendor.min.js"></script>
    <script type="text/javascript" src="/admin/templates/blend/js/scripts.min.js"></script>
    <style>
        .submission-message { max-width: 300px; max-height: 100px; overflow: auto; }
        .status-new { background: #5bc0de; }
        .status-read { background: #f0ad4e; }
        .status-replied { background: #5cb85c; }
    </style>
</head>
<body>

    <!-- Navigation -->
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
                        <li><a href="/admin/subscribers/"><i class="fas fa-envelope"></i> Newsletter Subscribers</a></li>
                        <li><a href="/admin/contact-submissions/"><i class="fas fa-address-card"></i> Contact Form Submissions</a></li>
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
                        <li><a href="/admin/logout.php">Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>

    <!-- Sidebar -->
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
                <li><a href="/admin/contact-submissions/"><i class="fas fa-address-card"></i> Contact Form Submissions</a></li>
            </ul>
        </div>
    </div>
    <a href="#" class="sidebar-opener" id="sidebarOpener">Open Sidebar</a>

    <!-- Content Area -->
    <div class="contentarea" id="contentarea">
        <div style="float:left;width:100%;">
            <h1><i class="fas fa-address-card"></i> Contact Form Submissions</h1>

            <!-- Stats -->
            <div class="row">
                <div class="col-md-3 col-sm-6">
                    <div class="health-status-block status-badge-blue clearfix">
                        <div class="icon"><i class="fas fa-inbox"></i></div>
                        <div class="detail">
                            <span class="count"><?php echo $total; ?></span>
                            <span class="desc">Total Submissions</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="health-status-block status-badge-green clearfix">
                        <div class="icon"><i class="fas fa-envelope-open"></i></div>
                        <div class="detail">
                            <span class="count"><?php echo $new_count; ?></span>
                            <span class="desc">New</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Panel -->
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="fas fa-list"></i> Contact Form Submissions
                        <div class="pull-right">
                            <a href="?export=csv" class="btn btn-success btn-sm"><i class="fas fa-download"></i> Export to CSV</a>
                        </div>
                    </h3>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table class="datatable table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Subject</th>
                                    <th>Message</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php while ($row = $submissions->fetch_assoc()): ?>
                                <tr>
                                    <td><?php echo $row['submitted_at']; ?></td>
                                    <td><?php echo htmlspecialchars($row['name']); ?></td>
                                    <td><a href="mailto:<?php echo htmlspecialchars($row['email']); ?>"><?php echo htmlspecialchars($row['email']); ?></a></td>
                                    <td><?php echo htmlspecialchars($row['subject']); ?></td>
                                    <td class="submission-message"><?php echo nl2br(htmlspecialchars($row['message'])); ?></td>
                                    <td>
                                        <span class="label status-<?php echo $row['status']; ?>">
                                            <?php echo ucfirst($row['status']); ?>
                                        </span>
                                    </td>
                                    <td>
                                        <form method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="update_status">
                                            <input type="hidden" name="id" value="<?php echo $row['id']; ?>">
                                            <select name="status" class="form-control input-sm" onchange="this.form.submit()" style="width:auto;display:inline;">
                                                <option value="new" <?php echo $row['status'] === 'new' ? 'selected' : ''; ?>>New</option>
                                                <option value="read" <?php echo $row['status'] === 'read' ? 'selected' : ''; ?>>Read</option>
                                                <option value="replied" <?php echo $row['status'] === 'replied' ? 'selected' : ''; ?>>Replied</option>
                                            </select>
                                        </form>
                                        <a href="mailto:<?php echo htmlspecialchars($row['email']); ?>?subject=Re: <?php echo urlencode($row['subject']); ?>" class="btn btn-primary btn-sm" title="Reply"><i class="fas fa-reply"></i></a>
                                        <a href="?delete=<?php echo $row['id']; ?>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this submission?');" title="Delete"><i class="fas fa-trash"></i></a>
                                    </td>
                                </tr>
                                <?php endwhile; ?>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <?php if ($total_pages > 1): ?>
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <?php if ($page > 1): ?>
                            <li><a href="?page=<?php echo $page - 1; ?>">&laquo; Prev</a></li>
                            <?php endif; ?>
                            
                            <?php for ($i = 1; $i <= $total_pages; $i++): ?>
                            <li <?php echo $i === $page ? 'class="active"' : ''; ?>><a href="?page=<?php echo $i; ?>"><?php echo $i; ?></a></li>
                            <?php endfor; ?>
                            
                            <?php if ($page < $total_pages): ?>
                            <li><a href="?page=<?php echo $page + 1; ?>">Next &raquo;</a></li>
                            <?php endif; ?>
                        </ul>
                    </nav>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        <div class="clear"></div>
    </div>

    <!-- Footer -->
    <div class="footerbar">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-6 copyright">
                    <i class="fas fa-copyright"></i> Copyright <?php echo date('Y'); ?> 
                    <a href="https://undomains.com/" target="_blank">Undomains</a>.
                    Part of <a href="https://un4.com/" target="_blank">UN4</a>
                </div>
                <div class="col-md-6 links text-right">
                    <a href="https://undomains.com/" target="_blank"><i class="fas fa-globe"></i> Website</a>
                    <span class="divider">|</span>
                    <a href="https://go.whmcs.com/1893/docs" target="_blank"><i class="fas fa-book"></i> Documentation</a>
                </div>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        $('#sidebarCollapseExpand').click(function(e) {
            e.preventDefault();
            $(this).toggleClass('expanded');
            $('.sidebar-collapse').slideToggle();
        });
    });
    </script>
</body>
</html>
