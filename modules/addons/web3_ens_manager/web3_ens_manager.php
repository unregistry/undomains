<?php
/**
 * Web3 ENS Manager - WHMCS Addon Module
 * Manages Ethereum Name Service (.eth) TLDs
 *
 * @package    Web3EnsManager
 * @author     Undomains
 * @version    1.0.0
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

function web3_ens_manager_config()
{
    return [
        'name' => 'Web3 (ENS) TLD Manager',
        'description' => 'Manage Ethereum Name Service (.eth) TLDs',
        'version' => '1.0.0',
        'author' => 'Undomains',
        'language' => 'english',
        'fields' => [],
    ];
}

function web3_ens_manager_activate()
{
    try {
        if (!Capsule::schema()->hasTable('mod_web3_ens_tlds')) {
            Capsule::schema()->create('mod_web3_ens_tlds', function ($table) {
                $table->increments('id');
                $table->string('tld', 50)->notNullable();
                $table->string('extension', 50)->notNullable();
                $table->tinyInteger('enabled')->default(1);
                $table->tinyInteger('presale_mode')->default(0);
                $table->string('tld_mode', 50)->default('coming_soon');
                $table->integer('display_order')->default(0);
                $table->decimal('register_price', 10, 2)->default(0);
                $table->decimal('transfer_price', 10, 2)->default(0);
                $table->decimal('renew_price', 10, 2)->default(0);
                $table->timestamp('created_at')->nullable();
                $table->timestamp('updated_at')->nullable();
            });

            // Seed starter TLD
            Capsule::table('mod_web3_ens_tlds')->insert([
                'tld' => '.eth',
                'extension' => '.eth',
                'enabled' => 1,
                'presale_mode' => 0,
                'tld_mode' => 'coming_soon',
                'display_order' => 1,
                'register_price' => 0,
                'transfer_price' => 0,
                'renew_price' => 0,
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),
            ]);
        }

        return ['status' => 'success', 'description' => 'Web3 (ENS) TLD Manager activated successfully'];
    } catch (Exception $e) {
        return ['status' => 'error', 'description' => 'Error activating module: ' . $e->getMessage()];
    }
}

function web3_ens_manager_deactivate()
{
    return ['status' => 'success', 'description' => 'Web3 (ENS) TLD Manager deactivated. Data preserved.'];
}

function web3_ens_manager_output($vars)
{
    $modulelink = $vars['modulelink'];

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        web3_ens_manager_handlePost($modulelink);
    }

    web3_ens_manager_pageTlds($modulelink, $vars);
}

function web3_ens_manager_handlePost($modulelink)
{
    $action = $_POST['action'] ?? '';

    switch ($action) {
        case 'update_tld_mode':
            $tldId = $_POST['tld_id'] ?? 0;
            $mode = $_POST['tld_mode'] ?? 'coming_soon';
            if ($tldId && in_array($mode, ['live', 'presale', 'reservation', 'coming_soon', 'disabled'])) {
                Capsule::table('mod_web3_ens_tlds')->where('id', $tldId)->update([
                    'tld_mode' => $mode,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
            }
            header("Location: $modulelink&updated=1");
            exit;

        case 'add_tld':
            $tld = trim($_POST['tld'] ?? '');
            $tld = (strpos($tld, '.') === 0) ? $tld : '.' . $tld;
            $extension = $tld;
            $mode = $_POST['tld_mode'] ?? 'coming_soon';
            $registerPrice = floatval($_POST['register_price'] ?? 0);
            $transferPrice = floatval($_POST['transfer_price'] ?? 0);
            $renewPrice = floatval($_POST['renew_price'] ?? 0);

            if ($tld) {
                Capsule::table('mod_web3_ens_tlds')->insert([
                    'tld' => $tld,
                    'extension' => $extension,
                    'enabled' => 1,
                    'presale_mode' => 0,
                    'tld_mode' => $mode,
                    'display_order' => Capsule::table('mod_web3_ens_tlds')->max('display_order') + 1,
                    'register_price' => $registerPrice,
                    'transfer_price' => $transferPrice,
                    'renew_price' => $renewPrice,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
            }
            header("Location: $modulelink&added=1");
            exit;

        case 'delete_tld':
            $tldId = $_POST['tld_id'] ?? 0;
            if ($tldId) {
                Capsule::table('mod_web3_ens_tlds')->where('id', $tldId)->delete();
            }
            header("Location: $modulelink&deleted=1");
            exit;

        case 'update_tld':
            $tldId = $_POST['tld_id'] ?? 0;
            $tld = trim($_POST['tld'] ?? '');
            if (strpos($tld, '.') !== 0 && $tld) {
                $tld = '.' . $tld;
            }
            $extension = $tld;
            $registerPrice = floatval($_POST['register_price'] ?? 0);
            $transferPrice = floatval($_POST['transfer_price'] ?? 0);
            $renewPrice = floatval($_POST['renew_price'] ?? 0);
            if ($tldId && $tld) {
                Capsule::table('mod_web3_ens_tlds')->where('id', $tldId)->update([
                    'tld' => $tld,
                    'extension' => $extension,
                    'register_price' => $registerPrice,
                    'transfer_price' => $transferPrice,
                    'renew_price' => $renewPrice,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
            }
            header("Location: $modulelink&updated=1");
            exit;
    }
}

function web3_ens_manager_pageTlds($modulelink, $vars)
{
    $updated = $_GET['updated'] ?? null;
    $added = $_GET['added'] ?? null;
    $deleted = $_GET['deleted'] ?? null;

    $tlds = Capsule::table('mod_web3_ens_tlds')
        ->orderBy('display_order')
        ->get();

    echo '<div class="web3-ens-manager">';

    if ($updated) {
        echo '<div class="alert alert-success"><i class="fas fa-check-circle"></i> TLD updated successfully!</div>';
    }
    if ($added) {
        echo '<div class="alert alert-success"><i class="fas fa-check-circle"></i> TLD added successfully!</div>';
    }
    if ($deleted) {
        echo '<div class="alert alert-success"><i class="fas fa-check-circle"></i> TLD deleted successfully!</div>';
    }

    // Add TLD form
    echo '<div class="panel panel-primary"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important"><i class="fas fa-plus"></i> Add TLD</h3></div>';
    echo '<div class="panel-body">';
    echo '<form method="post" class="form-horizontal">';
    echo '<input type="hidden" name="action" value="add_tld">';

    echo '<div class="form-group"><label class="col-sm-2 control-label">TLD *</label>';
    echo '<div class="col-sm-4"><input type="text" name="tld" class="form-control" placeholder="e.g., .eth" required></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Mode</label>';
    echo '<div class="col-sm-4"><select name="tld_mode" class="form-control">';
    $modes = ['coming_soon' => 'Coming Soon', 'live' => 'Live', 'presale' => 'Pre-Sale', 'reservation' => 'Reservation', 'disabled' => 'Disabled'];
    foreach ($modes as $value => $label) {
        echo '<option value="' . $value . '">' . $label . '</option>';
    }
    echo '</select></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Register Price ($)</label>';
    echo '<div class="col-sm-2"><input type="number" name="register_price" class="form-control" step="0.01" value="0"></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Transfer Price ($)</label>';
    echo '<div class="col-sm-2"><input type="number" name="transfer_price" class="form-control" step="0.01" value="0"></div></div>';

    echo '<div class="form-group"><label class="col-sm-2 control-label">Renew Price ($)</label>';
    echo '<div class="col-sm-2"><input type="number" name="renew_price" class="form-control" step="0.01" value="0"></div></div>';

    echo '<div class="form-group"><div class="col-sm-offset-2 col-sm-10">';
    echo '<button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i> Add TLD</button>';
    echo '</div></div></form></div></div>';

    // TLD list
    echo '<div class="panel panel-default"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Configured TLDs</h3></div>';
    echo '<div class="panel-body">';
    echo '<table class="table table-striped"><thead><tr><th>TLD</th><th>Status</th><th>Mode</th><th>Register</th><th>Transfer</th><th>Renew</th><th>Actions</th></tr></thead><tbody>';

    foreach ($tlds as $tld) {
        $statusLabel = $tld->enabled
            ? '<span class="label label-success" style="color:#000 !important">Enabled</span>'
            : '<span class="label label-default" style="color:#000 !important">Disabled</span>';

        $mode = $tld->tld_mode ?? 'coming_soon';
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
        echo '<td><input type="text" name="tld" class="form-control input-sm" value="' . htmlspecialchars($tld->tld) . '" style="width:80px"></td>';
        echo '<td>' . $statusLabel . '</td>';
        echo '<td>';
        echo '<select name="tld_mode" class="form-control input-sm">';
        foreach ($modes as $value => $label) {
            $selected = ($mode === $value) ? ' selected' : '';
            echo '<option value="' . $value . '"' . $selected . '>' . $label . '</option>';
        }
        echo '</select></td>';
        echo '<td><div class="input-group input-group-sm" style="width:100px"><input type="number" name="register_price" class="form-control" step="0.01" value="' . number_format($tld->register_price, 2, '.', '') . '"></div></td>';
        echo '<td><div class="input-group input-group-sm" style="width:100px"><input type="number" name="transfer_price" class="form-control" step="0.01" value="' . number_format($tld->transfer_price, 2, '.', '') . '"></div></td>';
        echo '<td><div class="input-group input-group-sm" style="width:100px"><input type="number" name="renew_price" class="form-control" step="0.01" value="' . number_format($tld->renew_price, 2, '.', '') . '"></div></td>';
        echo '<td>';
        echo '<button type="submit" class="btn btn-xs btn-success" title="Save"><i class="fas fa-save"></i></button> ';
        echo '</td>';
        echo '</tr>';
        echo '</form>';
        echo '<tr><td colspan="7" style="padding:0;border:none">';
        echo '<form method="post" style="display:inline" onsubmit="return confirm(\'Delete ' . htmlspecialchars($tld->tld) . '?\')">';
        echo '<input type="hidden" name="action" value="delete_tld">';
        echo '<input type="hidden" name="tld_id" value="' . $tld->id . '">';
        echo '<button type="submit" class="btn btn-xs btn-danger" style="color:#000 !important" style="margin:2px 0 4px 8px"><i class="fas fa-trash"></i> Delete</button>';
        echo '</form></td></tr>';
    }

    echo '</tbody></table></div></div>';

    // Mode Legend
    echo '<div class="panel panel-info"><div class="panel-heading" style="background-color:#333 !important"><h3 class="panel-title" style="color:#fff !important">Mode Descriptions</h3></div>';
    echo '<div class="panel-body">';
    echo '<ul>';
    echo '<li><span class="label label-success" style="color:#000 !important">Live</span> - Domain is fully available for registration</li>';
    echo '<li><span class="label label-info" style="color:#000 !important">Pre-Sale</span> - Pre-orders are being accepted</li>';
    echo '<li><span class="label label-warning" style="color:#000 !important">Reservation</span> - Domain is in reservation mode</li>';
    echo '<li><span class="label label-primary" style="color:#000 !important">Coming Soon</span> - Domain will be available soon</li>';
    echo '<li><span class="label label-default" style="color:#000 !important">Disabled</span> - Domain is not available</li>';
    echo '</ul>';
    echo '</div></div>';

    echo '</div>';
}
