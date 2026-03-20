<?php
/**
 * Unregistry Manager - WHMCS Addon Module
 *
 * @package    UnregistryManager
 * @author     Undomains
 * @version    1.0.0
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

/**
 * Module configuration
 */
function unregistry_manager_config()
{
    return [
        'name' => 'Unregistry TLD Manager',
        'description' => 'Manage custom TLDs, domain lists, and pre-order queue',
        'version' => '1.0.0',
        'author' => 'Undomains',
        'language' => 'english',
        'fields' => [
            'enablePresale' => [
                'FriendlyName' => 'Enable Pre-Sale Mode',
                'Type' => 'yesno',
                'Description' => 'Accept pre-orders for custom TLDs',
            ],
            'notificationEmail' => [
                'FriendlyName' => 'Notification Email',
                'Type' => 'text',
                'Description' => 'Email to notify of new pre-orders',
            ],
            'autoCompleteOrders' => [
                'FriendlyName' => 'Auto-complete orders',
                'Type' => 'yesno',
                'Description' => 'Mark orders as complete after queueing',
            ],
        ],
    ];
}

/**
 * Module activation
 */
function unregistry_manager_activate()
{
    try {
        // Create table for custom supported domains
        if (!Capsule::schema()->hasTable('mod_unregistry_supported_domains')) {
            Capsule::schema()->create('mod_unregistry_supported_domains', function ($table) {
                $table->increments('id');
                $table->string('domain', 255);
                $table->string('tld', 50);
                $table->text('description')->nullable();
                $table->string('category', 50)->default('general');
                $table->tinyInteger('is_active')->default(1);
                $table->timestamp('created_at')->nullable();
                $table->timestamp('updated_at')->nullable();
                $table->index(['domain', 'tld']);
                $table->index('is_active');
                $table->index('category');
            });
        }
        
        // Add tld_mode column to mod_unregistry_presale_tlds if not exists
        if (Capsule::schema()->hasTable('mod_unregistry_presale_tlds')) {
            if (!Capsule::schema()->hasColumn('mod_unregistry_presale_tlds', 'tld_mode')) {
                Capsule::schema()->table('mod_unregistry_presale_tlds', function ($table) {
                    $table->string('tld_mode', 50)->default('presale')->after('presale_mode');
                });
            }
        }
        
        return ['status' => 'success', 'description' => 'Unregistry TLD Manager activated successfully with custom domains support'];
    } catch (Exception $e) {
        return ['status' => 'error', 'description' => 'Error activating module: ' . $e->getMessage()];
    }
}

/**
 * Module deactivation
 */
function unregistry_manager_deactivate()
{
    return ['status' => 'success', 'description' => 'Unregistry TLD Manager deactivated. Data preserved.'];
}

/**
 * Module output - Admin UI
 */
function unregistry_manager_output($vars)
{
    $modulelink = $vars['modulelink'];
    $action = isset($_REQUEST['action']) ? $_REQUEST['action'] : 'dashboard';

    // Handle form submissions
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        unregistry_manager_handlePost($modulelink);
    }

    // Get statistics
    $stats = [
        'totalTlds' => Capsule::table('mod_unregistry_presale_tlds')->count(),
        'enabledTlds' => Capsule::table('mod_unregistry_presale_tlds')->where('enabled', 1)->count(),
        'queuedOrders' => Capsule::table('mod_unregistry_order_queue')->where('status', 'queued')->count(),
        'processingOrders' => Capsule::table('mod_unregistry_order_queue')->where('status', 'processing')->count(),
        'completedOrders' => Capsule::table('mod_unregistry_order_queue')->where('status', 'completed')->count(),
        'failedOrders' => Capsule::table('mod_unregistry_order_queue')->where('status', 'failed')->count(),
        'reservedDomains' => Capsule::table('mod_unregistry_domain_lists')->where('list_type', 'reserved')->count(),
        'restrictedDomains' => Capsule::table('mod_unregistry_domain_lists')->where('list_type', 'restricted')->count(),
        'premiumDomains' => Capsule::table('mod_unregistry_domain_lists')->where('list_type', 'premium')->count(),
    ];

    // Route to different pages
    switch ($action) {
        case 'tlds':
            unregistry_manager_pageTlds($modulelink, $vars);
            break;
        case 'domain_lists':
            unregistry_manager_pageDomainLists($modulelink, $vars);
            break;
        case 'order_queue':
            unregistry_manager_pageOrderQueue($modulelink, $vars);
            break;
        case 'custom_domains':
            unregistry_manager_pageCustomDomains($modulelink, $vars);
            break;
        case 'settings':
            unregistry_manager_pageSettings($modulelink, $vars);
            break;
        default:
            unregistry_manager_pageDashboard($modulelink, $vars, $stats);
            break;
    }
}

/**
 * Handle POST requests
 */
function unregistry_manager_handlePost($modulelink)
{
    $action = $_POST['action'] ?? '';

    switch ($action) {
        case 'add_domain':
            $domain = trim($_POST['domain'] ?? '');
            $tldId = $_POST['tld_id'] ?? null;
            $listType = $_POST['list_type'] ?? '';
            $premiumPrice = $_POST['premium_price'] ?? null;
            $restrictionReason = $_POST['restriction_reason'] ?? null;
            $notes = $_POST['notes'] ?? null;

            if ($domain && $listType) {
                Capsule::table('mod_unregistry_domain_lists')->insert([
                    'tld_id' => $tldId ?: null,
                    'domain' => strtolower($domain),
                    'list_type' => $listType,
                    'premium_price' => $premiumPrice ?: null,
                    'restriction_reason' => $restrictionReason,
                    'notes' => $notes,
                    'created_at' => date('Y-m-d H:i:s'),
                ]);
            }
            break;

        case 'delete_domain':
            $id = $_POST['id'] ?? 0;
            if ($id) {
                Capsule::table('mod_unregistry_domain_lists')->where('id', $id)->delete();
            }
            break;

        case 'update_order_status':
            $orderId = $_POST['order_id'] ?? 0;
            $status = $_POST['status'] ?? '';
            if ($orderId && in_array($status, ['queued', 'processing', 'completed', 'failed'])) {
                Capsule::table('mod_unregistry_order_queue')->where('id', $orderId)->update([
                    'status' => $status,
                    'processed_at' => $status === 'completed' ? date('Y-m-d H:i:s') : null,
                ]);
            }
            break;

        case 'add_custom_domain':
            $domain = trim($_POST['domain'] ?? '');
            $tld = trim($_POST['tld'] ?? '');
            $description = trim($_POST['description'] ?? '');
            $category = $_POST['category'] ?? 'general';
            $isActive = isset($_POST['is_active']) ? 1 : 0;

            if ($domain && $tld) {
                // Add to supported domains table
                Capsule::table('mod_unregistry_supported_domains')->insert([
                    'domain' => strtolower($domain),
                    'tld' => strtolower($tld),
                    'description' => $description,
                    'category' => $category,
                    'is_active' => $isActive,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
            }
            header("Location: $modulelink&action=custom_domains&success=1");
            exit;

        case 'update_custom_domain':
            $id = $_POST['id'] ?? 0;
            $domain = trim($_POST['domain'] ?? '');
            $tld = trim($_POST['tld'] ?? '');
            $description = trim($_POST['description'] ?? '');
            $category = $_POST['category'] ?? 'general';
            $isActive = isset($_POST['is_active']) ? 1 : 0;

            if ($id && $domain && $tld) {
                Capsule::table('mod_unregistry_supported_domains')->where('id', $id)->update([
                    'domain' => strtolower($domain),
                    'tld' => strtolower($tld),
                    'description' => $description,
                    'category' => $category,
                    'is_active' => $isActive,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
            }
            header("Location: $modulelink&action=custom_domains&success=2");
            exit;

        case 'delete_custom_domain':
            $id = $_POST['id'] ?? 0;
            if ($id) {
                Capsule::table('mod_unregistry_supported_domains')->where('id', $id)->delete();
            }
            header("Location: $modulelink&action=custom_domains&success=3");
            exit;

        case 'update_tld_mode':
            $tldId = $_POST['tld_id'] ?? 0;
            $mode = $_POST['tld_mode'] ?? 'presale';
            if ($tldId && in_array($mode, ['live', 'presale', 'reservation', 'coming_soon', 'disabled'])) {
                Capsule::table('mod_unregistry_presale_tlds')->where('id', $tldId)->update([
                    'tld_mode' => $mode,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
            }
            header("Location: $modulelink&action=tlds&updated=1");
            exit;
            break;

        case 'update_tld':
            $tldId = $_POST['tld_id'] ?? 0;
            $tld = trim($_POST['tld'] ?? '');
            if (strpos($tld, '.') !== 0 && $tld) {
                $tld = '.' . $tld;
            }
            $extension = $tld;
            $mode = $_POST['tld_mode'] ?? 'presale';
            $registerPrice = floatval($_POST['register_price'] ?? 0);
            $transferPrice = floatval($_POST['transfer_price'] ?? 0);
            $renewPrice = floatval($_POST['renew_price'] ?? 0);
            if ($tldId && $tld) {
                Capsule::table('mod_unregistry_presale_tlds')->where('id', $tldId)->update([
                    'tld' => $tld,
                    'extension' => $extension,
                    'tld_mode' => $mode,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
                // Update or insert pricing
                $existing = Capsule::table('mod_unregistry_presale_pricing')->where('tld_id', $tldId)->where('currency', 'USD')->first();
                if ($existing) {
                    Capsule::table('mod_unregistry_presale_pricing')->where('id', $existing->id)->update([
                        'register_price' => $registerPrice,
                        'transfer_price' => $transferPrice,
                        'renew_price' => $renewPrice,
                    ]);
                } else {
                    Capsule::table('mod_unregistry_presale_pricing')->insert([
                        'tld_id' => $tldId,
                        'currency' => 'USD',
                        'register_price' => $registerPrice,
                        'transfer_price' => $transferPrice,
                        'renew_price' => $renewPrice,
                    ]);
                }
            }
            header("Location: $modulelink&action=tlds&updated=1");
            exit;
            break;

        case 'bulk_add_custom_domains':
            $domainsText = trim($_POST['domains_bulk'] ?? '');
            $tld = trim($_POST['bulk_tld'] ?? '');
            $category = $_POST['bulk_category'] ?? 'general';
            $isActive = isset($_POST['bulk_is_active']) ? 1 : 0;

            if ($domainsText && $tld) {
                $lines = explode("\n", $domainsText);
                $count = 0;
                foreach ($lines as $line) {
                    $domain = trim($line);
                    if ($domain) {
                        // Remove any whitespace and validate
                        $domain = preg_replace('/\s+/', '', $domain);
                        if (preg_match('/^[a-zA-Z0-9][a-zA-Z0-9\-]*$/', $domain)) {
                            Capsule::table('mod_unregistry_supported_domains')->insert([
                                'domain' => strtolower($domain),
                                'tld' => strtolower($tld),
                                'description' => 'Bulk imported',
                                'category' => $category,
                                'is_active' => $isActive,
                                'created_at' => date('Y-m-d H:i:s'),
                                'updated_at' => date('Y-m-d H:i:s'),
                            ]);
                            $count++;
                        }
                    }
                }
                header("Location: $modulelink&action=custom_domains&bulk_success=$count");
                exit;
            }
            break;
    }
}

/**
 * Dashboard page
 */
function unregistry_manager_pageDashboard($modulelink, $vars, $stats)
{
    // Get recent orders
    $recentOrders = Capsule::table('mod_unregistry_order_queue')
        ->orderBy('queued_at', 'desc')
        ->limit(5)
        ->get();

    // Get TLDs
    $tlds = Capsule::table('mod_unregistry_presale_tlds')
        ->leftJoin('mod_unregistry_presale_pricing', 'mod_unregistry_presale_tlds.id', '=', 'mod_unregistry_presale_pricing.tld_id')
        ->orderBy('mod_unregistry_presale_tlds.display_order')
        ->get();

    echo '<div class="unregistry-manager">';

    // Statistics boxes
    echo '<div class="row">';
    echo '<div class="col-sm-6 col-md-3"><div class="panel panel-primary"><div class="panel-body text-center">';
    echo '<h2>' . $stats['totalTlds'] . '</h2><p class="text-muted">Active TLDs</p>';
    echo '</div></div></div>';

    echo '<div class="col-sm-6 col-md-3"><div class="panel panel-success"><div class="panel-body text-center">';
    echo '<h2>' . $stats['queuedOrders'] . '</h2><p class="text-muted">Queued Orders</p>';
    echo '</div></div></div>';

    echo '<div class="col-sm-6 col-md-3"><div class="panel panel-warning"><div class="panel-body text-center">';
    echo '<h2>' . $stats['reservedDomains'] . '</h2><p class="text-muted">Reserved Domains</p>';
    echo '</div></div></div>';

    echo '<div class="col-sm-6 col-md-3"><div class="panel panel-info"><div class="panel-body text-center">';
    echo '<h2>' . $stats['premiumDomains'] . '</h2><p class="text-muted">Premium Domains</p>';
    echo '</div></div></div>';
    echo '</div>';

    // Quick Actions
    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Quick Actions</h3></div>';
    echo '<div class="list-group">';
    echo '<a href="' . $modulelink . '&action=tlds" class="list-group-item"><i class="fas fa-globe"></i> Manage TLDs</a>';
    echo '<a href="' . $modulelink . '&action=domain_lists" class="list-group-item"><i class="fas fa-list"></i> Domain Lists</a>';
    echo '<a href="' . $modulelink . '&action=order_queue" class="list-group-item"><i class="fas fa-tasks"></i> Order Queue</a>';
    echo '</div></div>';

    // Recent Orders
    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Recent Pre-Orders</h3></div>';
    echo '<div class="panel-body">';
    if (count($recentOrders) > 0) {
        echo '<table class="table table-striped"><thead><tr><th>Domain</th><th>TLD</th><th>Action</th><th>Queued</th><th>Status</th></tr></thead><tbody>';
        foreach ($recentOrders as $order) {
            $statusClass = $order->status === 'queued' ? 'info' : ($order->status === 'completed' ? 'success' : ($order->status === 'failed' ? 'danger' : 'warning'));
            echo '<tr>';
            echo '<td><strong>' . htmlspecialchars($order->domain) . '</strong></td>';
            echo '<td>' . htmlspecialchars($order->tld) . '</td>';
            echo '<td>' . htmlspecialchars($order->action) . '</td>';
            echo '<td>' . $order->queued_at . '</td>';
            echo '<td><span class="label label-' . $statusClass . '" style="color:#000 !important">' . ucfirst($order->status) . '</span></td>';
            echo '</tr>';
        }
        echo '</tbody></table>';
    } else {
        echo '<p class="text-muted text-center">No pre-orders yet.</p>';
    }
    echo '</div></div>';

    echo '</div>';
}

/**
 * TLDs page
 */
function unregistry_manager_pageTlds($modulelink, $vars)
{
    $updated = $_GET['updated'] ?? null;
    
    $tlds = Capsule::table('mod_unregistry_presale_tlds')
        ->leftJoin('mod_unregistry_presale_pricing', 'mod_unregistry_presale_tlds.id', '=', 'mod_unregistry_presale_pricing.tld_id')
        ->orderBy('mod_unregistry_presale_tlds.display_order')
        ->get();

    echo '<div class="unregistry-manager">';
    echo '<div class="page-header"><h1><i class="fas fa-globe"></i> TLD Management</h1>';
    echo '<a href="' . $modulelink . '" class="btn btn-default pull-right"><i class="fas fa-arrow-left"></i> Back</a></div>';

    if ($updated) {
        echo '<div class="alert alert-success"><i class="fas fa-check-circle"></i> TLD mode updated successfully!</div>';
    }

    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Configured TLDs</h3></div>';
    echo '<div class="panel-body">';
    echo '<table class="table table-striped"><thead><tr><th>TLD</th><th>Status</th><th>Mode</th><th>Register</th><th>Transfer</th><th>Renew</th><th>Actions</th></tr></thead><tbody>';

    foreach ($tlds as $tld) {
        $statusLabel = $tld->enabled ? '<span class="label label-success" style="color:#000 !important">Enabled</span>' : '<span class="label label-default" style="color:#000 !important">Disabled</span>';
        
        // Mode display with color coding
        $mode = $tld->tld_mode ?? ($tld->presale_mode ? 'presale' : 'live');
        $modeClass = match($mode) {
            'live' => 'success',
            'presale' => 'info',
            'reservation' => 'warning',
            'coming_soon' => 'primary',
            'disabled' => 'default',
            default => 'info',
        };
        $modeDisplay = match($mode) {
            'live' => 'Live',
            'presale' => 'Pre-Sale',
            'reservation' => 'Reservation',
            'coming_soon' => 'Coming Soon',
            'disabled' => 'Disabled',
            default => ucfirst($mode),
        };
        $modeLabel = '<span class="label label-' . $modeClass . '" style="color:#000 !important">' . $modeDisplay . '</span>';
        
        echo '<form method="post" class="form-inline">';
        echo '<input type="hidden" name="action" value="update_tld">';
        echo '<input type="hidden" name="tld_id" value="' . $tld->id . '">';
        echo '<tr>';
        echo '<td><input type="text" name="tld" class="form-control input-sm" value="' . htmlspecialchars($tld->tld) . '" style="width:100px"></td>';
        echo '<td>' . $statusLabel . '</td>';
        echo '<td>';
        echo '<select name="tld_mode" class="form-control input-sm">';
        $modes = ['live' => 'Live', 'presale' => 'Pre-Sale', 'reservation' => 'Reservation', 'coming_soon' => 'Coming Soon', 'disabled' => 'Disabled'];
        foreach ($modes as $value => $label) {
            $selected = ($mode === $value) ? ' selected' : '';
            echo '<option value="' . $value . '"' . $selected . '>' . $label . '</option>';
        }
        echo '</select></td>';
        echo '<td><div class="input-group input-group-sm" style="width:100px"><input type="number" name="register_price" class="form-control" step="0.01" value="' . number_format($tld->register_price ?? 0, 2, '.', '') . '"></div></td>';
        echo '<td><div class="input-group input-group-sm" style="width:100px"><input type="number" name="transfer_price" class="form-control" step="0.01" value="' . number_format($tld->transfer_price ?? 0, 2, '.', '') . '"></div></td>';
        echo '<td><div class="input-group input-group-sm" style="width:100px"><input type="number" name="renew_price" class="form-control" step="0.01" value="' . number_format($tld->renew_price ?? 0, 2, '.', '') . '"></div></td>';
        echo '<td>';
        echo '<button type="submit" class="btn btn-xs btn-success" title="Save"><i class="fas fa-save"></i></button>';
        echo '</td>';
        echo '</tr>';
        echo '</form>';
    }

    echo '</tbody></table></div></div>';
    
    // Mode Legend
    echo '<div class="panel panel-info"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Mode Descriptions</h3></div>';
    echo '<div class="panel-body">';
    echo '<ul>';
    echo '<li><span class="label label-success" style="color:#000 !important">Live</span> - Domain is fully available for registration</li>';
    echo '<li><span class="label label-info" style="color:#000 !important">Pre-Sale</span> - Pre-orders are being accepted</li>';
    echo '<li><span class="label label-warning" style="color:#000 !important">Reservation</span> - Domain is in reservation mode (special access required)</li>';
    echo '<li><span class="label label-primary" style="color:#000 !important">Coming Soon</span> - Domain will be available soon</li>';
    echo '<li><span class="label label-default" style="color:#000 !important">Disabled</span> - Domain is not available</li>';
    echo '</ul>';
    echo '</div></div>';
    
    echo '</div>';
}

/**
 * Domain Lists page
 */
function unregistry_manager_pageDomainLists($modulelink, $vars)
{
    $listType = $_GET['list_type'] ?? 'all';
    $tlds = Capsule::table('mod_unregistry_presale_tlds')->orderBy('display_order')->get();

    // Build query
    $query = Capsule::table('mod_unregistry_domain_lists')->orderBy('created_at', 'desc');
    if ($listType !== 'all') {
        $query->where('list_type', $listType);
    }
    $domains = $query->get();

    // Counts
    $counts = [
        'total' => Capsule::table('mod_unregistry_domain_lists')->count(),
        'reserved' => Capsule::table('mod_unregistry_domain_lists')->where('list_type', 'reserved')->count(),
        'restricted' => Capsule::table('mod_unregistry_domain_lists')->where('list_type', 'restricted')->count(),
        'premium' => Capsule::table('mod_unregistry_domain_lists')->where('list_type', 'premium')->count(),
    ];

    echo '<div class="unregistry-manager">';
    echo '<div class="page-header"><h1><i class="fas fa-list"></i> Domain Lists</h1>';
    echo '<a href="' . $modulelink . '" class="btn btn-default pull-right"><i class="fas fa-arrow-left"></i> Back</a></div>';

    // Tabs
    echo '<ul class="nav nav-tabs">';
    echo '<li' . ($listType === 'all' ? ' class="active"' : '') . '><a href="' . $modulelink . '&action=domain_lists&list_type=all">All (' . $counts['total'] . ')</a></li>';
    echo '<li' . ($listType === 'reserved' ? ' class="active"' : '') . '><a href="' . $modulelink . '&action=domain_lists&list_type=reserved">Reserved (' . $counts['reserved'] . ')</a></li>';
    echo '<li' . ($listType === 'restricted' ? ' class="active"' : '') . '><a href="' . $modulelink . '&action=domain_lists&list_type=restricted">Restricted (' . $counts['restricted'] . ')</a></li>';
    echo '<li' . ($listType === 'premium' ? ' class="active"' : '') . '><a href="' . $modulelink . '&action=domain_lists&list_type=premium">Premium (' . $counts['premium'] . ')</a></li>';
    echo '</ul>';

    // Add form
    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Add Domain</h3></div>';
    echo '<div class="panel-body">';
    echo '<form method="post" class="form-horizontal">';
    echo '<input type="hidden" name="action" value="add_domain">';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Domain</label>';
    echo '<div class="col-sm-6"><input type="text" name="domain" class="form-control" placeholder="e.g., premium.degen or admin.*" required></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">TLD</label>';
    echo '<div class="col-sm-4"><select name="tld_id" class="form-control"><option value="">All TLDs</option>';
    foreach ($tlds as $tld) {
        echo '<option value="' . $tld->id . '">' . htmlspecialchars($tld->tld) . '</option>';
    }
    echo '</select></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Type</label>';
    echo '<div class="col-sm-4"><select name="list_type" class="form-control" id="listTypeSelect">';
    echo '<option value="reserved">Reserved</option>';
    echo '<option value="restricted">Restricted</option>';
    echo '<option value="premium">Premium</option>';
    echo '</select></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Premium Price</label>';
    echo '<div class="col-sm-3"><input type="number" name="premium_price" class="form-control" step="0.01" id="premiumPrice"></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Notes</label>';
    echo '<div class="col-sm-6"><input type="text" name="notes" class="form-control"></div></div>';

    echo '<div class="form-group"><div class="col-sm-offset-2 col-sm-10">';
    echo '<button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i> Add</button>';
    echo '</div></div></form></div></div>';

    // List
    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Domains</h3></div>';
    echo '<div class="panel-body"><table class="table table-striped">';
    echo '<thead><tr><th>Domain</th><th>Type</th><th>Price/Reason</th><th>Notes</th><th>Actions</th></tr></thead><tbody>';

    foreach ($domains as $domain) {
        $typeClass = $domain->list_type === 'reserved' ? 'danger' : ($domain->list_type === 'restricted' ? 'warning' : 'info');
        echo '<tr>';
        echo '<td><code>' . htmlspecialchars($domain->domain) . '</code></td>';
        echo '<td><span class="label label-' . $typeClass . '" style="color:#000 !important">' . ucfirst($domain->list_type) . '</span></td>';
        echo '<td>' . ($domain->premium_price ? '$' . number_format($domain->premium_price, 2) : ($domain->restriction_reason ?: '-')) . '</td>';
        echo '<td>' . htmlspecialchars($domain->notes ?: '-') . '</td>';
        echo '<td>';
        echo '<form method="post" style="display:inline" onsubmit="return confirm(\'Delete?\')">';
        echo '<input type="hidden" name="action" value="delete_domain">';
        echo '<input type="hidden" name="id" value="' . $domain->id . '">';
        echo '<button type="submit" class="btn btn-xs btn-danger"><i class="fas fa-trash"></i></button>';
        echo '</form></td></tr>';
    }

    echo '</tbody></table></div></div></div>';
}

/**
 * Order Queue page
 */
function unregistry_manager_pageOrderQueue($modulelink, $vars)
{
    $status = $_GET['status'] ?? 'all';

    $query = Capsule::table('mod_unregistry_order_queue')->orderBy('queued_at', 'desc');
    if ($status !== 'all') {
        $query->where('status', $status);
    }
    $orders = $query->get();

    $counts = [
        'total' => Capsule::table('mod_unregistry_order_queue')->count(),
        'queued' => Capsule::table('mod_unregistry_order_queue')->where('status', 'queued')->count(),
        'processing' => Capsule::table('mod_unregistry_order_queue')->where('status', 'processing')->count(),
        'completed' => Capsule::table('mod_unregistry_order_queue')->where('status', 'completed')->count(),
        'failed' => Capsule::table('mod_unregistry_order_queue')->where('status', 'failed')->count(),
    ];

    echo '<div class="unregistry-manager">';
    echo '<div class="page-header"><h1><i class="fas fa-tasks"></i> Order Queue</h1>';
    echo '<a href="' . $modulelink . '" class="btn btn-default pull-right"><i class="fas fa-arrow-left"></i> Back</a></div>';

    // Tabs
    echo '<ul class="nav nav-tabs">';
    echo '<li' . ($status === 'all' ? ' class="active"' : '') . '><a href="' . $modulelink . '&action=order_queue&status=all">All (' . $counts['total'] . ')</a></li>';
    echo '<li' . ($status === 'queued' ? ' class="active"' : '') . '><a href="' . $modulelink . '&action=order_queue&status=queued">Queued (' . $counts['queued'] . ')</a></li>';
    echo '<li' . ($status === 'processing' ? ' class="active"' : '') . '><a href="' . $modulelink . '&action=order_queue&status=processing">Processing (' . $counts['processing'] . ')</a></li>';
    echo '<li' . ($status === 'completed' ? ' class="active"' : '') . '><a href="' . $modulelink . '&action=order_queue&status=completed">Completed (' . $counts['completed'] . ')</a></li>';
    echo '<li' . ($status === 'failed' ? ' class="active"' : '') . '><a href="' . $modulelink . '&action=order_queue&status=failed">Failed (' . $counts['failed'] . ')</a></li>';
    echo '</ul>';

    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Orders</h3></div>';
    echo '<div class="panel-body"><table class="table table-striped">';
    echo '<thead><tr><th>ID</th><th>Domain</th><th>TLD</th><th>Action</th><th>Years</th><th>Status</th><th>Queued</th><th>Actions</th></tr></thead><tbody>';

    foreach ($orders as $order) {
        $statusClass = $order->status === 'queued' ? 'info' : ($order->status === 'completed' ? 'success' : ($order->status === 'failed' ? 'danger' : 'warning'));
        echo '<tr>';
        echo '<td>' . $order->id . '</td>';
        echo '<td><strong>' . htmlspecialchars($order->domain) . '</strong></td>';
        echo '<td>' . htmlspecialchars($order->tld) . '</td>';
        echo '<td>' . htmlspecialchars($order->action) . '</td>';
        echo '<td>' . $order->years . '</td>';
        echo '<td><span class="label label-' . $statusClass . '" style="color:#000 !important">' . ucfirst($order->status) . '</span></td>';
        echo '<td>' . $order->queued_at . '</td>';
        echo '<td>';
        echo '<form method="post" style="display:inline">';
        echo '<input type="hidden" name="action" value="update_order_status">';
        echo '<input type="hidden" name="order_id" value="' . $order->id . '">';
        echo '<select name="status" class="input-sm" onchange="this.form.submit()">';
        foreach (['queued', 'processing', 'completed', 'failed'] as $s) {
            echo '<option value="' . $s . '"' . ($order->status === $s ? ' selected' : '') . '>' . ucfirst($s) . '</option>';
        }
        echo '</select></form>';
        echo '</td></tr>';
    }

    echo '</tbody></table></div></div></div>';
}

/**
 * Settings page
 */
function unregistry_manager_pageSettings($modulelink, $vars)
{
    echo '<div class="unregistry-manager">';
    echo '<div class="page-header"><h1><i class="fas fa-cog"></i> Settings</h1>';
    echo '<a href="' . $modulelink . '" class="btn btn-default pull-right"><i class="fas fa-arrow-left"></i> Back</a></div>';

    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Module Settings</h3></div>';
    echo '<div class="panel-body">';
    echo '<p>Configure this module in <a href="configaddonmods.php">Addon Modules</a> settings.</p>';
    echo '</div></div></div>';
}

/**
 * Custom Domains page - Manage supported custom domains
 */
function unregistry_manager_pageCustomDomains($modulelink, $vars)
{
    $success = $_GET['success'] ?? null;
    $bulkSuccess = $_GET['bulk_success'] ?? null;
    $editId = $_GET['edit'] ?? null;

    // Get all supported domains
    $domains = Capsule::table('mod_unregistry_supported_domains')
        ->orderBy('created_at', 'desc')
        ->get();

    // Get unique TLDs for filtering
    $tlds = Capsule::table('mod_unregistry_supported_domains')
        ->select('tld')
        ->distinct()
        ->orderBy('tld')
        ->pluck('tld');

    // Get unique categories
    $categories = Capsule::table('mod_unregistry_supported_domains')
        ->select('category')
        ->distinct()
        ->orderBy('category')
        ->pluck('category');

    // Stats
    $stats = [
        'total' => Capsule::table('mod_unregistry_supported_domains')->count(),
        'active' => Capsule::table('mod_unregistry_supported_domains')->where('is_active', 1)->count(),
        'inactive' => Capsule::table('mod_unregistry_supported_domains')->where('is_active', 0)->count(),
    ];

    echo '<div class="unregistry-manager">';
    echo '<div class="page-header"><h1><i class="fas fa-plus-circle"></i> Custom Domains Manager</h1>';
    echo '<a href="' . $modulelink . '" class="btn btn-default pull-right"><i class="fas fa-arrow-left"></i> Back to Dashboard</a></div>';

    // Success messages
    if ($success == 1) {
        echo '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Custom domain added successfully!</div>';
    } elseif ($success == 2) {
        echo '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Custom domain updated successfully!</div>';
    } elseif ($success == 3) {
        echo '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Custom domain deleted successfully!</div>';
    } elseif ($bulkSuccess) {
        echo '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Successfully added ' . (int)$bulkSuccess . ' custom domains!</div>';
    }

    // Stats row
    echo '<div class="row">';
    echo '<div class="col-sm-4"><div class="panel panel-primary"><div class="panel-body text-center">';
    echo '<h2>' . $stats['total'] . '</h2><p class="text-muted">Total Domains</p>';
    echo '</div></div></div>';
    echo '<div class="col-sm-4"><div class="panel panel-success"><div class="panel-body text-center">';
    echo '<h2>' . $stats['active'] . '</h2><p class="text-muted">Active</p>';
    echo '</div></div></div>';
    echo '<div class="col-sm-4"><div class="panel panel-default"><div class="panel-body text-center">';
    echo '<h2>' . $stats['inactive'] . '</h2><p class="text-muted">Inactive</p>';
    echo '</div></div></div>';
    echo '</div>';

    // Edit Form (if editing)
    if ($editId) {
        $editDomain = Capsule::table('mod_unregistry_supported_domains')->where('id', $editId)->first();
        if ($editDomain) {
            echo '<div class="panel panel-warning"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important"><i class="fas fa-edit"></i> Edit Custom Domain</h3></div>';
            echo '<div class="panel-body">';
            echo '<form method="post" class="form-horizontal">';
            echo '<input type="hidden" name="action" value="update_custom_domain">';
            echo '<input type="hidden" name="id" value="' . $editId . '">';

            echo '<div class="form-group"><label class="col-sm-2 control-label">Domain Name *</label>';
            echo '<div class="col-sm-4"><input type="text" name="domain" class="form-control" value="' . htmlspecialchars($editDomain->domain) . '" required placeholder="e.g., mybrand"></div></div>';

            echo '<div class="form-group"><label class="col-sm-2 control-label">TLD *</label>';
            echo '<div class="col-sm-4"><input type="text" name="tld" class="form-control" value="' . htmlspecialchars($editDomain->tld) . '" required placeholder="e.g., .degen"></div></div>';

            echo '<div class="form-group"><label class="col-sm-2 control-label">Category</label>';
            echo '<div class="col-sm-4">';
            echo '<select name="category" class="form-control">';
            $cats = ['general', 'premium', 'reserved', 'branded', 'promotional'];
            foreach ($cats as $cat) {
                $selected = $editDomain->category === $cat ? ' selected' : '';
                echo '<option value="' . $cat . '"' . $selected . '>' . ucfirst($cat) . '</option>';
            }
            echo '</select></div></div>';

            echo '<div class="form-group"><label class="col-sm-2 control-label">Description</label>';
            echo '<div class="col-sm-6"><input type="text" name="description" class="form-control" value="' . htmlspecialchars($editDomain->description ?? '') . '" placeholder="Optional description"></div></div>';

            echo '<div class="form-group"><label class="col-sm-2 control-label">Status</label>';
            echo '<div class="col-sm-4"><div class="checkbox"><label><input type="checkbox" name="is_active" value="1"' . ($editDomain->is_active ? ' checked' : '') . '> Active</label></div></div></div>';

            echo '<div class="form-group"><div class="col-sm-offset-2 col-sm-10">';
            echo '<button type="submit" class="btn btn-warning"><i class="fas fa-save"></i> Update Domain</button> ';
            echo '<a href="' . $modulelink . '&action=custom_domains" class="btn btn-default">Cancel</a>';
            echo '</div></div></form>';
            echo '</div></div>';
        }
    }

    // Add Single Domain Form
    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important"><i class="fas fa-plus"></i> Add Single Custom Domain</h3></div>';
    echo '<div class="panel-body">';
    echo '<form method="post" class="form-horizontal">';
    echo '<input type="hidden" name="action" value="add_custom_domain">';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Domain Name *</label>';
    echo '<div class="col-sm-4"><input type="text" name="domain" class="form-control" required placeholder="e.g., mybrand"></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">TLD *</label>';
    echo '<div class="col-sm-4"><input type="text" name="tld" class="form-control" required placeholder="e.g., .degen"></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Category</label>';
    echo '<div class="col-sm-4">';
    echo '<select name="category" class="form-control">';
    echo '<option value="general">General</option>';
    echo '<option value="premium">Premium</option>';
    echo '<option value="reserved">Reserved</option>';
    echo '<option value="branded">Branded</option>';
    echo '<option value="promotional">Promotional</option>';
    echo '</select></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Description</label>';
    echo '<div class="col-sm-6"><input type="text" name="description" class="form-control" placeholder="Optional description"></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Status</label>';
    echo '<div class="col-sm-4"><div class="checkbox"><label><input type="checkbox" name="is_active" value="1" checked> Active</label></div></div></div>';

    echo '<div class="form-group"><div class="col-sm-offset-2 col-sm-10">';
    echo '<button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i> Add Custom Domain</button>';
    echo '</div></div></form>';
    echo '</div></div>';

    // Bulk Add Form
    echo '<div class="panel panel-info"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important"><i class="fas fa-list-ul"></i> Bulk Add Custom Domains</h3></div>';
    echo '<div class="panel-body">';
    echo '<form method="post" class="form-horizontal">';
    echo '<input type="hidden" name="action" value="bulk_add_custom_domains">';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Domains (one per line) *</label>';
    echo '<div class="col-sm-6"><textarea name="domains_bulk" class="form-control" rows="6" placeholder="mybrand&#10;yourname&#10;coolproject&#10;..." required></textarea>';
    echo '<p class="help-block">Enter domain names only (without TLD), one per line</p></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">TLD for all *</label>';
    echo '<div class="col-sm-4"><input type="text" name="bulk_tld" class="form-control" required placeholder="e.g., .degen"></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Category</label>';
    echo '<div class="col-sm-4">';
    echo '<select name="bulk_category" class="form-control">';
    echo '<option value="general">General</option>';
    echo '<option value="premium">Premium</option>';
    echo '<option value="reserved">Reserved</option>';
    echo '<option value="branded">Branded</option>';
    echo '<option value="promotional">Promotional</option>';
    echo '</select></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Status</label>';
    echo '<div class="col-sm-4"><div class="checkbox"><label><input type="checkbox" name="bulk_is_active" value="1" checked> Active</label></div></div></div>';

    echo '<div class="form-group"><div class="col-sm-offset-2 col-sm-10">';
    echo '<button type="submit" class="btn btn-info"><i class="fas fa-upload"></i> Bulk Add Domains</button>';
    echo '</div></div></form>';
    echo '</div></div>';

    // Domains List
    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important"><i class="fas fa-globe"></i> Custom Domains List</h3></div>';
    echo '<div class="panel-body">';

    if (count($domains) > 0) {
        echo '<div class="table-responsive"><table class="table table-striped table-hover">';
        echo '<thead><tr><th>ID</th><th>Domain</th><th>TLD</th><th>Full Domain</th><th>Category</th><th>Description</th><th>Status</th><th>Created</th><th>Actions</th></tr></thead><tbody>';

        foreach ($domains as $domain) {
            $statusLabel = $domain->is_active 
                ? '<span class="label label-success" style="color:#000 !important">Active</span>' 
                : '<span class="label label-default" style="color:#000 !important">Inactive</span>';
            
            $categoryClass = match($domain->category) {
                'premium' => 'warning',
                'reserved' => 'danger',
                'branded' => 'info',
                'promotional' => 'primary',
                default => 'default',
            };

            echo '<tr>';
            echo '<td>' . $domain->id . '</td>';
            echo '<td><code>' . htmlspecialchars($domain->domain) . '</code></td>';
            echo '<td><span class="label label-primary" style="color:#000 !important">' . htmlspecialchars($domain->tld) . '</span></td>';
            echo '<td><strong>' . htmlspecialchars($domain->domain . $domain->tld) . '</strong></td>';
            echo '<td><span class="label label-' . $categoryClass . '" style="color:#000 !important">' . ucfirst($domain->category) . '</span></td>';
            echo '<td>' . htmlspecialchars($domain->description ?: '-') . '</td>';
            echo '<td>' . $statusLabel . '</td>';
            echo '<td>' . date('Y-m-d', strtotime($domain->created_at)) . '</td>';
            echo '<td>';
            echo '<a href="' . $modulelink . '&action=custom_domains&edit=' . $domain->id . '" class="btn btn-xs btn-warning"><i class="fas fa-edit"></i></a> ';
            echo '<form method="post" style="display:inline" onsubmit="return confirm(\'Are you sure you want to delete this domain?\')">';
            echo '<input type="hidden" name="action" value="delete_custom_domain">';
            echo '<input type="hidden" name="id" value="' . $domain->id . '">';
            echo '<button type="submit" class="btn btn-xs btn-danger"><i class="fas fa-trash"></i></button>';
            echo '</form>';
            echo '</td></tr>';
        }

        echo '</tbody></table></div>';
    } else {
        echo '<p class="text-muted text-center">No custom domains added yet. Use the forms above to add domains.</p>';
    }

    echo '</div></div></div>';
}
