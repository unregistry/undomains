<?php
/**
 * Contact Form Submissions Admin Page
 * View, add, import contact form submissions - Full WHMCS Admin Theme
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

$message = '';
$message_type = '';

// Handle manual add
if (isset($_POST['action']) && $_POST['action'] === 'add_manual' && isset($_POST['email'])) {
    $name = trim($_POST['name'] ?? '');
    $email = filter_var($_POST['email'], FILTER_VALIDATE_EMAIL);
    $subject = trim($_POST['subject'] ?? '');
    $message_text = trim($_POST['message'] ?? '');
    
    if ($email && $name && $subject) {
        $ip_address = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? '';
        if (strpos($ip_address, ',') !== false) {
            $ip_address = trim(explode(',', $ip_address)[0]);
        }
        
        $stmt = $mysqli->prepare("INSERT INTO mod_contact_form_submissions (name, email, subject, message, ip_address) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("sssss", $name, $email, $subject, $message_text, $ip_address);
        if ($stmt->execute()) {
            $message = 'Contact added successfully!';
            $message_type = 'success';
        } else {
            $message = 'Error adding contact.';
            $message_type = 'error';
        }
        $stmt->close();
    } else {
        $message = 'Please fill in all required fields.';
        $message_type = 'error';
    }
}

// Handle CSV import
if (isset($_POST['action']) && $_POST['action'] === 'import_csv' && isset($_FILES['csv_file'])) {
    $file = $_FILES['csv_file']['tmp_name'];
    if ($file && file_exists($file)) {
        $handle = fopen($file, 'r');
        $header = fgetcsv($handle);
        $added = 0;
        $errors = 0;
        
        while (($data = fgetcsv($handle)) !== false) {
            $name = isset($data[0]) ? trim($data[0]) : '';
            $email = isset($data[1]) ? trim($data[1]) : '';
            $subject = isset($data[2]) ? trim($data[2]) : '';
            $message_text = isset($data[3]) ? trim($data[3]) : '';
            
            if ($name && filter_var($email, FILTER_VALIDATE_EMAIL) && $subject) {
                $ip_address = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? '';
                $stmt = $mysqli->prepare("INSERT INTO mod_contact_form_submissions (name, email, subject, message, ip_address) VALUES (?, ?, ?, ?, ?)");
                $stmt->bind_param("sssss", $name, $email, $subject, $message_text, $ip_address);
                if ($stmt->execute()) {
                    $added++;
                }
                $stmt->close();
            } else {
                $errors++;
            }
        }
        fclose($handle);
        $message = "Import complete: $added added, $errors errors.";
        $message_type = $errors > 0 ? 'warning' : 'success';
    } else {
        $message = 'Error uploading file.';
        $message_type = 'error';
    }
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

// Download template
if (isset($_GET['download']) && $_GET['download'] === 'template') {
    header('Content-Type: text/csv');
    header('Content-Disposition: attachment; filename="contact_template.csv"');
    $output = fopen('php://output', 'w');
    fputcsv($output, ['name', 'email', 'subject', 'message']);
    fputcsv($output, ['John Doe', 'john@example.com', 'Inquiry about services', 'I would like to know more about your domain services.']);
    fputcsv($output, ['Jane Smith', 'jane@example.com', 'Support request', 'I need help with my account.']);
    fclose($output);
    exit;
}

// Export CSV
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
    <title>Contacts - Undomains</title>
    <link rel="icon" type="image/png" href="/admin/templates/blend/images/favicon.png" />
    <link href="/assets/fonts/css/open-sans-family.css" rel="stylesheet" type="text/css" />
    <link href="/admin/templates/blend/css/all.min.css" rel="stylesheet" />
    <link href="/admin/templates/blend/css/theme.min.css" rel="stylesheet" />
    <link href="/admin/templates/blend/css/undomains-theme.css" rel="stylesheet" />
    <link href="/admin/templates/blend/css/theme-toggle.css" rel="stylesheet" />
    <link href="/assets/fonts/css/fontawesome.min.css" rel="stylesheet" />
    <link href="/assets/fonts/css/fontawesome-solid.min.css" rel="stylesheet" />
    <script type="text/javascript" src="/admin/templates/blend/js/vendor.min.js"></script>
    <script type="text/javascript" src="/admin/templates/blend/js/scripts.min.js"></script>
    <script>
        // Initialize theme before page renders
        (function() {
            try {
                var theme = localStorage.getItem('undomains_admin_theme');
                if (theme === 'dark') {
                    document.documentElement.setAttribute('data-theme', 'dark');
                }
            } catch(e) {}
        })();
    </script>
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
            <li class="bt">
                <a href="#" onclick="UndoTheme.toggle(); return false;" id="mobile-theme-toggle" aria-label="Toggle Dark Mode" title="Switch to Dark Mode">
                    <i class="fas fa-moon" id="mobile-theme-icon"></i>
                </a>
            </li>
        </ul>

<div class="navbar-collapse">
            <ul>
                <!-- Add New -->
                <li class="bt has-dropdown">
                    <a href="#" onclick="return false;">
                        <i class="fas fa-plus always"></i>
                        <span class="visible-sidebar">Add New</span>
                    </a>
                    <ul class="slim">
                        <li><a href="/admin/clientsadd.php">New Client</a></li>
                        <li><a href="/admin/ordersadd.php">New Order</a></li>
                        <li><a href="/admin/index.php?rp=/admin/billing/invoice/new">New Invoice</a></li>
                        <li><a href="/admin/quotes.php?action=manage">New Quote</a></li>
                        <li><a href="/admin/supporttickets.php?action=open">New Ticket</a></li>
                    </ul>
                </li>

                <!-- Clients -->
                <li class="has-dropdown">
                    <a id="Menu-Clients" href="#" onclick="return false;">
                        <i class="fas fa-user"></i>
                        Clients
                        <span class="caret"></span>
                    </a>
                    <ul>
                        <li><a href="/admin/clients.php">View/Search Clients</a></li>
                        <li><a href="/admin/index.php?rp=/admin/user/list">Manage Users</a></li>
                        <li><a href="/admin/clientsadd.php">Add New Client</a></li>
                        <li class="has-dropdown sub-menu expand">
                            <a href="/admin/index.php?rp=/admin/services">Products/Services</a>
                            <ul>
                                <li><a href="/admin/index.php?rp=/admin/services/shared">- Shared Hosting</a></li>
                                <li><a href="/admin/index.php?rp=/admin/services/reseller">- Reseller Accounts</a></li>
                                <li><a href="/admin/index.php?rp=/admin/services/server">- VPS/Servers</a></li>
                                <li><a href="/admin/index.php?rp=/admin/services/other">- Other Services</a></li>
                            </ul>
                        </li>
                        <li><a href="/admin/index.php?rp=/admin/addons">Service Addons</a></li>
                        <li><a href="/admin/index.php?rp=/admin/domains">Domain Registrations</a></li>
                        <li><a href="/admin/cancelrequests.php">Cancellation Requests</a></li>
                        <li><a href="/admin/affiliates.php">Manage Affiliates</a></li>
                    </ul>
                </li>

                <!-- Orders -->
                <li class="has-dropdown">
                    <a id="Menu-Orders" href="#" onclick="return false;">
                        <i class="fas fa-shopping-cart"></i>
                        Orders
                        <span class="caret"></span>
                    </a>
                    <ul>
                        <li><a href="/admin/orders.php">List All Orders</a></li>
                        <li><a href="/admin/orders.php?status=Pending">- Pending Orders</a></li>
                        <li><a href="/admin/orders.php?status=Active">- Active Orders</a></li>
                        <li><a href="/admin/orders.php?status=Fraud">- Fraud Orders</a></li>
                        <li><a href="/admin/orders.php?status=Cancelled">- Cancelled Orders</a></li>
                        <li><a href="/admin/ordersadd.php">Add New Order</a></li>
                    </ul>
                </li>

                <!-- Billing -->
                <li class="has-dropdown">
                    <a id="Menu-Billing" href="#" onclick="return false;">
                        <i class="fas fa-credit-card"></i>
                        Billing
                        <span class="caret"></span>
                    </a>
                    <ul>
                        <li><a href="/admin/transactions.php">Transactions List</a></li>
                        <li class="has-dropdown expand">
                            <a href="/admin/invoices.php">Invoices</a>
                            <ul>
                                <li><a href="/admin/invoices.php?status=Paid">- Paid</a></li>
                                <li><a href="/admin/invoices.php?status=Draft">- Draft</a></li>
                                <li><a href="/admin/invoices.php?status=Unpaid">- Unpaid</a></li>
                                <li><a href="/admin/invoices.php?status=Overdue">- Overdue</a></li>
                                <li><a href="/admin/invoices.php?status=Cancelled">- Cancelled</a></li>
                                <li><a href="/admin/invoices.php?status=Refunded">- Refunded</a></li>
                                <li><a href="/admin/invoices.php?status=Collections">- Collections</a></li>
                            </ul>
                        </li>
                        <li><a href="/admin/billableitems.php">Billable Items</a></li>
                        <li><a href="/admin/quotes.php">Quotes</a></li>
                        <li><a href="/admin/offlineccprocessing.php">Offline CC Processing</a></li>
                        <li><a href="/admin/index.php?rp=/admin/billing/disputes">Disputes</a></li>
                        <li><a href="/admin/gatewaylog.php">Gateway Log</a></li>
                    </ul>
                </li>

                <!-- Support -->
                <li class="has-dropdown">
                    <a id="Menu-Support" href="#" onclick="return false;">
                        <i class="fas fa-life-ring"></i>
                        Support
                        <span class="caret"></span>
                    </a>
                    <ul>
                        <li><a href="/admin/supportcenter.php">Support Overview</a></li>
                        <li class="has-dropdown expand">
                            <a href="/admin/supporttickets.php">Support Tickets</a>
                            <ul>
                                <li><a href="/admin/supporttickets.php?view=flagged">- Flagged Tickets</a></li>
                                <li><a href="/admin/supporttickets.php?view=active">- All Active Tickets</a></li>
                                <li><a href="/admin/supporttickets.php?view=Open">- Open</a></li>
                                <li><a href="/admin/supporttickets.php?view=Answered">- Answered</a></li>
                                <li><a href="/admin/supporttickets.php?view=Customer-Reply">- Customer-Reply</a></li>
                                <li><a href="/admin/supporttickets.php?view=Closed">- Closed</a></li>
                            </ul>
                        </li>
                        <li><a href="/admin/supporttickets.php?action=open">Open New Ticket</a></li>
                        <li><a href="/admin/supportticketpredefinedreplies.php">Predefined Replies</a></li>
                        <li><a href="/admin/supportannouncements.php">Announcements</a></li>
                        <li><a href="/admin/supportdownloads.php">Downloads</a></li>
                        <li><a href="/admin/supportkb.php">Knowledgebase</a></li>
                        <li><a href="/admin/networkissues.php">Network Issues</a></li>
                    </ul>
                </li>

                <!-- Reports -->
                <li class="has-dropdown">
                    <a id="Menu-Reports" href="#" onclick="return false;">
                        <i class="fas fa-chart-bar"></i>
                        Reports
                        <span class="caret"></span>
                    </a>
                    <ul>
                        <li><a href="/admin/reports.php">Reports</a></li>
                        <li><a href="/admin/reports.php?report=daily_performance">Daily Performance</a></li>
                        <li><a href="/admin/reports.php?report=income_forecast">Income Forecast</a></li>
                        <li><a href="/admin/reports.php?report=annual_income_report">Annual Income Report</a></li>
                        <li><a href="/admin/reports.php?report=new_customers">New Customers</a></li>
                        <li><a href="/admin/reports.php?report=ticket_feedback_scores">Ticket Feedback Scores</a></li>
                        <li><a href="/admin/reports.php?report=pdf_batch">Batch Invoice PDF Export</a></li>
                    </ul>
                </li>

                <!-- Utilities -->
                <li class="has-dropdown">
                    <a id="Menu-Utilities" href="#" onclick="return false;">
                        <i class="fas fa-file-alt"></i>
                        Utilities
                        <span class="caret"></span>
                    </a>
                    <ul>
                        <li><a href="/admin/update.php">Update WHMCS</a></li>
                        <li><a href="/admin/whmcsconnect.php">WHMCS Connect</a></li>
                        <li><a href="/admin/automationstatus.php">Automation Status</a></li>
                        <li><a href="/admin/modulequeue.php">Module Queue</a></li>
                        <li><a href="/admin/index.php?rp=/admin/utilities/sitejet/builder">Sitejet Builder <span class="label label-success">New</span></a></li>
                        <li><a href="/admin/index.php?rp=/admin/utilities/tools/tldsync/import">Registrar TLD Sync</a></li>
                        <li><a href="/admin/index.php?rp=/admin/utilities/tools/email/campaigns">Email Campaigns</a></li>
                        <li><a href="/admin/utilitiesemailmarketer.php">Email Marketer</a></li>
                        <li><a href="/admin/utilitieslinktracking.php">Link Tracking</a></li>
                        <li><a href="/admin/calendar.php">Calendar</a></li>
                        <li><a href="/admin/todolist.php">To-Do List</a></li>
                        <li><a href="/admin/whois.php">WHOIS Lookup</a></li>
                        <li><a href="/admin/utilitiesresolvercheck.php">Domain Resolver</a></li>
                        <li><a href="/admin/systemintegrationcode.php">Integration Code</a></li>
                        <li class="has-dropdown expand">
                            <a href="#">System</a>
                            <ul>
                                <li><a href="/admin/systemdatabase.php">Database Status</a></li>
                                <li><a href="/admin/systemcleanup.php">System Cleanup</a></li>
                                <li><a href="/admin/systemphpinfo.php">PHP Info</a></li>
                                <li><a href="/admin/index.php?rp=/admin/utilities/system/php-compat">PHP Version Compatibility</a></li>
                            </ul>
                        </li>
                        <li><a href="/admin/subscribers/"><i class="fas fa-envelope"></i> Subscribers</a></li>
                        <li><a href="/admin/contact-submissions/"><i class="fas fa-address-card"></i> Contacts</a></li>
                    </ul>
                </li>

                <!-- Addons -->
                <li class="has-dropdown">
                    <a id="Menu-Addons" href="#" onclick="return false;">
                        <i class="fas fa-cube"></i>
                        Addons
                        <span class="caret"></span>
                    </a>
                    <ul>
                        <li><a href="/admin/addonmodules.php?module=unregistry_manager">Unregistry TLD Manager</a></li>
                    </ul>
                </li>

                <!-- Unregistry -->
                <li class="has-dropdown">
                    <a id="Menu-Domains" href="#" onclick="return false;">
                        <i class="fas fa-globe"></i>
                        Unregistry
                        <span class="caret"></span>
                    </a>
                    <ul>
                        <li><a href="/admin/addonmodules.php?module=unregistry_manager"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                        <li><a href="/admin/addonmodules.php?module=unregistry_manager&action=custom_domains"><i class="fas fa-plus-circle"></i> Add Custom Domains</a></li>
                        <li><a href="/admin/addonmodules.php?module=unregistry_manager&action=tlds"><i class="fas fa-globe"></i> Manage TLDs</a></li>
                        <li><a href="/admin/addonmodules.php?module=unregistry_manager&action=domain_lists"><i class="fas fa-list"></i> Domain Lists</a></li>
                        <li><a href="/admin/addonmodules.php?module=unregistry_manager&action=order_queue"><i class="fas fa-tasks"></i> Order Queue</a></li>
                    </ul>
                </li>
            </ul>

            <!-- Right Nav -->
            <ul class="right-nav">
                <li class="bt">
                    <a href="/admin/automationstatus.php" id="Menu-Automation-Status" data-toggle="tooltip" data-placement="bottom" title="Automation Status">
                        <i class="fas fa-cogs always"></i>
                        <span class="visible-sidebar">Automation Status</span>
                    </a>
                </li>
                <li class="bt has-dropdown">
                    <a id="Menu-Setup" href="#" onclick="return false;">
                        <i class="fas fa-wrench always"></i>
                        <span class="visible-sidebar">Configuration</span>
                    </a>
                    <ul class="drop-icons">
                        <li><a href="/admin/configgeneral.php"><span class="ico-container"><i class="fad fa-sliders-h"></i></span> System Settings</a></li>
                        <li><a href="/admin/index.php?rp=/admin/apps"><span class="ico-container wizard"><i class="fad fa-cubes"></i></span> Apps & Integrations</a></li>
                        <li><a href="/admin/configadmins.php"><span class="ico-container health"><i class="fad fa-user-friends"></i></span> Manage Admins</a></li>
                        <li><a href="/admin/systemhealthandupdates.php"><span class="ico-container health"><i class="fad fa-heart-rate"></i></span> System Health</a></li>
                        <li><a href="/admin/systemactivitylog.php"><span class="ico-container logs"><i class="fad fa-copy"></i></span> System Logs</a></li>
                    </ul>
                </li>
                <li class="bt account has-dropdown">
                    <a id="Menu-Account" href="#" onclick="return false;">
                        <img src="https://www.gravatar.com/avatar/<?php echo $gravatar_hash; ?>?s=25&d=mp" class="profile-icon" alt="Account" />
                        <span class="visible-sidebar">Account</span>
                    </a>
                    <ul class="slim drop-left">
                        <li><a href="/admin/myaccount.php">My Account</a></li>
                        <li><a href="#" data-toggle="modal" data-target="#modalMyNotes">My Notes</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/">Visit Client Area</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/admin/logout.php">Logout</a></li>
                    </ul>
                </li>
                <li class="bt help has-dropdown">
                    <a id="Menu-Help" href="#" onclick="return false;">
                        <i class="far fa-question-circle always"></i>
                        <span class="visible-sidebar">Help</span>
                    </a>
                    <ul class="drop-left">
                        <li><a href="https://docs.whmcs.com/" target="_blank">Documentation</a></li>
                        <li><a href="/admin/systemsupportrequest.php">Technical Support</a></li>
                        <li><a href="https://whmcs.community/" target="_blank">Community Forums</a></li>
                        <li><a href="javascript:openFeatureHighlights()">What's New</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/admin/index.php?rp=/admin/help/license">License Information</a></li>
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
                <li><a href="/admin/update.php"><i class="fas fa-sync"></i> Update WHMCS</a></li>
                <li><a href="/admin/whmcsconnect.php"><i class="fas fa-plug"></i> WHMCS Connect</a></li>
                <li><a href="/admin/automationstatus.php"><i class="fas fa-cogs"></i> Automation Status</a></li>
                <li><a href="/admin/modulequeue.php"><i class="fas fa-tasks"></i> Module Queue</a></li>
                <li><a href="/admin/index.php?rp=/admin/utilities/tools/tldsync/import"><i class="fas fa-globe"></i> Registrar TLD Sync</a></li>
                <li><a href="/admin/index.php?rp=/admin/utilities/tools/email/campaigns"><i class="fas fa-envelope-open-text"></i> Email Campaigns</a></li>
                <li><a href="/admin/utilitiesemailmarketer.php"><i class="fas fa-bullhorn"></i> Email Marketer</a></li>
                <li><a href="/admin/utilitieslinktracking.php"><i class="fas fa-link"></i> Link Tracking</a></li>
                <li><a href="/admin/calendar.php"><i class="fas fa-calendar-alt"></i> Calendar</a></li>
                <li><a href="/admin/todolist.php"><i class="fas fa-check-square"></i> To-Do List</a></li>
                <li><a href="/admin/whois.php"><i class="fas fa-search"></i> WHOIS Lookup</a></li>
                <li><a href="/admin/utilitiesresolvercheck.php"><i class="fas fa-server"></i> Domain Resolver</a></li>
                <li><a href="/admin/systemintegrationcode.php"><i class="fas fa-code"></i> Integration Code</a></li>
                <li><a href="/admin/systemdatabase.php"><i class="fas fa-database"></i> Database Status</a></li>
                <li><a href="/admin/systemcleanup.php"><i class="fas fa-broom"></i> System Cleanup</a></li>
                <li><a href="/admin/systemphpinfo.php"><i class="fab fa-php"></i> PHP Info</a></li>
                <li><a href="/admin/subscribers/"><i class="fas fa-envelope"></i> Subscribers</a></li>
                <li><a href="/admin/contact-submissions/"><i class="fas fa-address-card"></i> Contacts</a></li>
            </ul>
            <a href="#" class="btn-min-sidebar" id="sidebarClose" onclick="var s=document.getElementById('sidebar');s.style.left='-240px';setTimeout(function(){s.style.display='none';},300);document.getElementById('sidebarOpener').style.display='block';return false;">
                &laquo; Minimise Sidebar
            </a>
        </div>
    </div>
    <a href="#" class="sidebar-opener" id="sidebarOpener" onclick="var s=document.getElementById('sidebar');s.style.display='block';setTimeout(function(){s.style.left='0';},10);this.style.display='none';return false;">Open Sidebar</a>

    <!-- Content Area -->
    <div class="contentarea" id="contentarea">
        <div style="width:100%;">
            <h1><i class="fas fa-address-card"></i> Contacts</h1>

            <?php if ($message): ?>
            <div class="alert alert-<?php echo $message_type === 'success' ? 'success' : ($message_type === 'warning' ? 'warning' : 'danger'); ?>">
                <?php echo htmlspecialchars($message); ?>
            </div>
            <?php endif; ?>

            <!-- Stats -->
            <div class="row">
                <div class="col-md-3 col-sm-6">
                    <div class="health-status-block status-badge-blue clearfix">
                        <div class="icon"><i class="fas fa-inbox"></i></div>
                        <div class="detail">
                            <span class="count"><?php echo $total; ?></span>
                            <span class="desc">Total Contacts</span>
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

            <!-- Add Contact Panel -->
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fas fa-user-plus"></i> Add Contact</h3>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h4>Manual Add</h4>
                            <form method="post">
                                <input type="hidden" name="action" value="add_manual">
                                <div class="form-group">
                                    <input type="text" name="name" class="form-control" placeholder="Name" required>
                                </div>
                                <div class="form-group">
                                    <input type="email" name="email" class="form-control" placeholder="Email Address" required>
                                </div>
                                <div class="form-group">
                                    <input type="text" name="subject" class="form-control" placeholder="Subject" required>
                                </div>
                                <div class="form-group">
                                    <textarea name="message" class="form-control" rows="3" placeholder="Message"></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i> Add Contact</button>
                            </form>
                        </div>
                        <div class="col-md-6">
                            <h4>Bulk Import (CSV)</h4>
                            <form method="post" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="import_csv">
                                <div class="form-group">
                                    <input type="file" name="csv_file" class="form-control" accept=".csv" required>
                                </div>
                                <button type="submit" class="btn btn-success"><i class="fas fa-upload"></i> Import</button>
                            </form>
                            <p class="help-block">
                                <a href="?download=template" class="btn btn-link btn-sm"><i class="fas fa-download"></i> Download Template</a>
                                <br><small>CSV columns: name, email, subject, message</small>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Panel -->
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="fas fa-list"></i> Contact List
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
                                        <form method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="update_status">
                                            <input type="hidden" name="id" value="<?php echo $row['id']; ?>">
                                            <select name="status" class="form-control input-sm" onchange="this.form.submit()" style="width:auto;">
                                                <option value="new" <?php echo $row['status'] === 'new' ? 'selected' : ''; ?>>New</option>
                                                <option value="read" <?php echo $row['status'] === 'read' ? 'selected' : ''; ?>>Read</option>
                                                <option value="replied" <?php echo $row['status'] === 'replied' ? 'selected' : ''; ?>>Replied</option>
                                            </select>
                                        </form>
                                    </td>
                                    <td>
                                        <a href="mailto:<?php echo htmlspecialchars($row['email']); ?>?subject=Re: <?php echo urlencode($row['subject']); ?>" class="btn btn-primary btn-sm" title="Reply"><i class="fas fa-reply"></i></a>
                                        <a href="?delete=<?php echo $row['id']; ?>" class="btn btn-danger btn-sm" onclick="return confirm('Delete this contact?');" title="Delete"><i class="fas fa-trash"></i></a>
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

    <script type="text/javascript" src="/admin/templates/blend/js/theme-toggle.js"></script>
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
