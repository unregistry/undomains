<?php
/**
 * WHMCS Hooks for Unregistry Pre-sale - Simplified Version
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

// Define custom TLDs
if (!defined('UNREGISTRY_CUSTOM_TLDS')) {
    define('UNREGISTRY_CUSTOM_TLDS', [
        '.degen', '.fio', '.com.store', '.com.film', '.com.supply',
        '.com.bond', '.com.barcelona', '.app.onl', '.org.onl', '.site.onl'
    ]);
}

// Simple hook for domain checker page
add_hook('ClientAreaPageDomainChecker', 1, function($vars) {
    // Get enabled TLDs with their modes
    $tlds = Capsule::table('mod_unregistry_presale_tlds')
        ->where('enabled', 1)
        ->get();
    
    $vars['unregistryDisabledTlds'] = [];
    $vars['unregistryTldModes'] = [];
    
    foreach ($tlds as $tld) {
        $mode = $tld->tld_mode ?: 'live';
        // Store both with and without dot for compatibility
        $nameWithDot = $tld->tld;
        $nameWithoutDot = ltrim($tld->tld, '.');
        
        $vars['unregistryTldModes'][$nameWithDot] = $mode;
        $vars['unregistryTldModes'][$nameWithoutDot] = $mode;
        
        if ($mode === 'disabled') {
            $vars['unregistryDisabledTlds'][] = $nameWithDot;
            $vars['unregistryDisabledTlds'][] = $nameWithoutDot;
        }
    }
    
    return $vars;
});

// Also hook into cart page
add_hook('ClientAreaPageCart', 1, function($vars) {
    // Get enabled TLDs with their modes
    $tlds = Capsule::table('mod_unregistry_presale_tlds')
        ->where('enabled', 1)
        ->get();
    
    $vars['unregistryDisabledTlds'] = [];
    $vars['unregistryTldModes'] = [];
    
    foreach ($tlds as $tld) {
        $mode = $tld->tld_mode ?: 'live';
        $nameWithDot = $tld->tld;
        $nameWithoutDot = ltrim($tld->tld, '.');
        
        $vars['unregistryTldModes'][$nameWithDot] = $mode;
        $vars['unregistryTldModes'][$nameWithoutDot] = $mode;
        
        if ($mode === 'disabled') {
            $vars['unregistryDisabledTlds'][] = $nameWithDot;
            $vars['unregistryDisabledTlds'][] = $nameWithoutDot;
        }
    }
    
    return $vars;
});
