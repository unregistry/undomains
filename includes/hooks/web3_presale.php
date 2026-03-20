<?php
/**
 * Web3 Presale Hook
 *
 * Loads TLD modes from all three Web3 DB tables into Smarty variables
 * for use in the domain register template.
 *
 * @package    Web3Presale
 * @author     Undomains
 * @version    1.0.0
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

// Pass Web3 TLD modes to the cart page template
add_hook('ClientAreaPageCart', 1, function($vars) {
    $web3TldModes = [];

    // Web3 categories
    $web3Types = [
        'ud' => 'Web3 (UD)',
        'fio' => 'Web3 (FIO)',
        'ens' => 'Web3 (ENS)',
    ];

    foreach ($web3Types as $type => $category) {
        try {
            $tlds = Capsule::table('mod_web3_' . $type . '_tlds')
                ->where('enabled', 1)
                ->orderBy('display_order')
                ->get();

            foreach ($tlds as $tld) {
                $name = ltrim($tld->tld, '.');
                $mode = $tld->tld_mode ?: 'coming_soon';
                $web3TldModes[$category][$name] = [
                    'tld' => $tld->tld,
                    'extension' => $tld->extension,
                    'mode' => $mode,
                    'register_price' => $tld->register_price,
                ];
            }
        } catch (Exception $e) {
            // Table doesn't exist yet - module not activated
        }
    }

    // Pre-Reserve category
    try {
        $tlds = Capsule::table('mod_prereserve_tlds')
            ->where('enabled', 1)
            ->orderBy('display_order')
            ->get();

        foreach ($tlds as $tld) {
            $name = ltrim($tld->tld, '.');
            $mode = $tld->tld_mode ?: 'coming_soon';
            $web3TldModes['Pre-Reserve'][$name] = [
                'tld' => $tld->tld,
                'extension' => $tld->extension,
                'mode' => $mode,
                'register_price' => $tld->register_price,
            ];
        }
    } catch (Exception $e) {
        // Table doesn't exist yet
    }

    $vars['web3TldModes'] = $web3TldModes;
    return $vars;
});
