<?php
/**
 * WHMCS Hooks for Unregistry Pre-sale - Working Version
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Domains\DomainLookup\SearchResult;
use WHMCS\Database\Capsule;

// Define custom TLDs
if (!defined('UNREGISTRY_CUSTOM_TLDS')) {
    define('UNREGISTRY_CUSTOM_TLDS', [
        '.degen', '.fio', '.com.store', '.com.film', '.com.supply',
        '.com.bond', '.com.barcelona', '.app.onl', '.org.onl', '.site.onl'
    ]);
}

/**
 * Check if a domain ends with one of our custom TLDs
 */
function unregistry_presale_isCustomTld($domain) {
    $domain = strtolower($domain);
    foreach (UNREGISTRY_CUSTOM_TLDS as $tld) {
        if (str_ends_with($domain, $tld)) return true;
    }
    return false;
}

/**
 * Get TLD from domain
 */
function unregistry_presale_getTldFromDomain($domain) {
    $domain = strtolower($domain);
    foreach (UNREGISTRY_CUSTOM_TLDS as $tld) {
        if (str_ends_with($domain, $tld)) return $tld;
    }
    return null;
}

/**
 * Push Unregistry TLD modes from DB to Smarty templates
 * Uses ClientAreaInit to set globals early, then ClientAreaPageCart
 * to pass them as template variables
 */

// Store in globals so they're available everywhere
add_hook('ClientAreaInit', 1, function() {
    $tldModes = [];
    $tldDisabled = [];

    try {
        $tlds = Capsule::table('mod_unregistry_presale_tlds')
            ->where('enabled', 1)
            ->get();

        foreach ($tlds as $tld) {
            $mode = $tld->tld_mode ?: 'live';
            $name = ltrim($tld->tld, '.');
            $tldModes[$name] = $mode;
            if ($mode === 'disabled') {
                $tldDisabled[] = $name;
            }
        }
    } catch (Exception $e) {
        // DB unavailable
    }

    $GLOBALS['unregistryTldModes'] = $tldModes;
    $GLOBALS['unregistryDisabledTlds'] = $tldDisabled;
});

// Pass to template on cart pages
add_hook('ClientAreaPageCart', 1, function($vars) {
    $vars['unregistryTldModes'] = $GLOBALS['unregistryTldModes'] ?? [];
    $vars['unregistryDisabledTlds'] = $GLOBALS['unregistryDisabledTlds'] ?? [];
    return $vars;
});
