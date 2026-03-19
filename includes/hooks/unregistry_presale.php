<?php
/**
 * WHMCS Hooks for Unregistry Pre-sale - Optimized
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Domains\DomainLookup\SearchResult;
use WHMCS\Database\Capsule;

// Custom TLDs
if (!defined('UNREGISTRY_CUSTOM_TLDS')) {
    define('UNREGISTRY_CUSTOM_TLDS', [
        '.degen', '.fio', '.com.store', '.com.film', '.com.supply',
        '.com.bond', '.com.barcelona', '.app.onl', '.org.onl', '.site.onl'
    ]);
}

/**
 * Get cached TLD modes for domain checker page
 */
function unregistry_get_tld_modes_cached() {
    static $cached = null;
    
    if ($cached === null) {
        $cached = [
            'modes' => [],
            'disabled' => []
        ];
        
        try {
            $tlds = Capsule::table('mod_unregistry_presale_tlds')
                ->where('enabled', 1)
                ->select(['tld', 'tld_mode', 'presale_mode'])
                ->get();
            
            foreach ($tlds as $tld) {
                $mode = $tld->tld_mode ?: ($tld->presale_mode ? 'presale' : 'live');
                $name = ltrim($tld->tld, '.');
                $cached['modes'][$name] = $mode;
                if ($mode === 'disabled') {
                    $cached['disabled'][] = $name;
                }
            }
        } catch (Exception $e) {
            // Use defaults on error
        }
    }
    
    return $cached;
}

/**
 * Hook: Add TLD modes to domain checker page
 */
add_hook('ClientAreaPageDomainChecker', 1, function($vars) {
    $data = unregistry_get_tld_modes_cached();
    $vars['unregistryTldModes'] = $data['modes'];
    $vars['unregistryDisabledTlds'] = $data['disabled'];
    return $vars;
});

/**
 * Hook: Add TLD modes to cart page
 */
add_hook('ClientAreaPageCart', 1, function($vars) {
    $data = unregistry_get_tld_modes_cached();
    $vars['unregistryTldModes'] = $data['modes'];
    $vars['unregistryDisabledTlds'] = $data['disabled'];
    return $vars;
});

/**
 * Hook: Intercept domain lookup results
 */
add_hook('DomainLookupResultsLoaded', 1, function($results) {
    if (!is_array($results) && !($results instanceof \WHMCS\Domains\DomainLookup\ResultsList)) {
        return $results;
    }

    foreach ($results as $domain => $result) {
        $tld = unregistry_presale_getTldFromDomain($domain);
        if (!$tld) continue;

        $tldMode = unregistry_presale_getTldMode($tld);
        
        if ($tldMode) {
            $result->tldMode = $tldMode['mode'];
            $result->tldModeDisplay = $tldMode['display'];
            $result->tldModeClass = $tldMode['class'];
        }

        if ($tldMode && in_array($tldMode['mode'], ['reservation', 'coming_soon', 'disabled'])) {
            $result->setStatus(SearchResult::STATUS_RESERVED);
            $result->tldSpecialMode = true;
        }
    }

    return $results;
});

// Helper functions
function unregistry_presale_isCustomTld($domain) {
    $domain = strtolower($domain);
    foreach (UNREGISTRY_CUSTOM_TLDS as $tld) {
        if (str_ends_with($domain, $tld)) return true;
    }
    return false;
}

function unregistry_presale_getTldFromDomain($domain) {
    $domain = strtolower($domain);
    foreach (UNREGISTRY_CUSTOM_TLDS as $tld) {
        if (str_ends_with($domain, $tld)) return $tld;
    }
    return null;
}

function unregistry_presale_getTldMode($tld) {
    $tldInfo = Capsule::table('mod_unregistry_presale_tlds')
        ->where('tld', $tld)
        ->where('enabled', 1)
        ->first();

    if ($tldInfo) {
        $mode = $tldInfo->tld_mode ?: ($tldInfo->presale_mode ? 'presale' : 'live');
        
        $display = ucfirst($mode);
        if ($mode === 'live') $display = 'Live';
        elseif ($mode === 'presale') $display = 'Pre-Sale';
        elseif ($mode === 'reservation') $display = 'Reservation';
        elseif ($mode === 'coming_soon') $display = 'Coming Soon';
        elseif ($mode === 'disabled') $display = 'Disabled';
        
        $class = 'info';
        if ($mode === 'live') $class = 'success';
        elseif ($mode === 'presale') $class = 'info';
        elseif ($mode === 'reservation') $class = 'warning';
        elseif ($mode === 'coming_soon') $class = 'primary';
        elseif ($mode === 'disabled') $class = 'default';
        
        return ['mode' => $mode, 'display' => $display, 'class' => $class];
    }
    return null;
}
