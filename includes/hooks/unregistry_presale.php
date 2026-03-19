<?php
/**
 * WHMCS Hooks for Unregistry Pre-sale
 *
 * Intercepts domain lookup, search, and order for custom TLDs
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Domains\DomainLookup\SearchResult;
use WHMCS\Database\Capsule;

// Custom TLDs managed by this module
if (!defined('UNREGISTRY_CUSTOM_TLDS')) {
    define('UNREGISTRY_CUSTOM_TLDS', [
        '.degen', '.fio', '.com.store', '.com.film', '.com.supply',
        '.com.bond', '.com.barcelona', '.app.onl', '.org.onl', '.site.onl'
    ]);
}

/**
 * Check if a domain ends with one of our custom TLDs
 */
function unregistry_presale_isCustomTld($domain)
{
    $domain = strtolower($domain);
    foreach (UNREGISTRY_CUSTOM_TLDS as $tld) {
        if (str_ends_with($domain, $tld)) {
            return true;
        }
    }
    return false;
}

/**
 * Get TLD from domain
 */
function unregistry_presale_getTldFromDomain($domain)
{
    $domain = strtolower($domain);
    foreach (UNREGISTRY_CUSTOM_TLDS as $tld) {
        if (str_ends_with($domain, $tld)) {
            return $tld;
        }
    }
    return null;
}

/**
 * Check domain against reserved/restricted/premium lists
 */
function unregistry_presale_checkDomainList($domain)
{
    $tld = unregistry_presale_getTldFromDomain($domain);
    if (!$tld) {
        return null;
    }

    // Get TLD ID
    $tldInfo = Capsule::table('mod_unregistry_presale_tlds')
        ->where('tld', $tld)
        ->where('enabled', 1)
        ->first();

    $tldId = $tldInfo ? $tldInfo->id : null;

    // Check exact match
    $listEntry = Capsule::table('mod_unregistry_domain_lists')
        ->where('domain', strtolower($domain))
        ->where(function($query) use ($tldId) {
            $query->where('tld_id', $tldId)
                  ->orWhereNull('tld_id');
        })
        ->first();

    if ($listEntry) {
        return $listEntry;
    }

    // Check wildcard patterns
    $allPatterns = Capsule::table('mod_unregistry_domain_lists')
        ->where(function($query) use ($tldId) {
            $query->where('tld_id', $tldId)
                  ->orWhereNull('tld_id');
        })
        ->get();

    foreach ($allPatterns as $pattern) {
        if (strpos($pattern->domain, '*') !== false) {
            $regex = str_replace('\*', '.*', preg_quote($pattern->domain, '/'));
            if (preg_match('/^' . $regex . '$/i', $domain)) {
                return $pattern;
            }
        }
    }

    return null;
}

/**
 * Get TLD mode info
 */
function unregistry_presale_getTldMode($tld)
{
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
        
        return [
            'mode' => $mode,
            'display' => $display,
            'class' => $class,
        ];
    }
    return null;
}

/**
 * Hook: Intercept domain lookup results
 */
add_hook('DomainLookupResultsLoaded', 1, function($results) {
    if (!is_array($results) && !($results instanceof \WHMCS\Domains\DomainLookup\ResultsList)) {
        return $results;
    }

    foreach ($results as $domain => $result) {
        if (!unregistry_presale_isCustomTld($domain)) {
            continue;
        }

        $tld = unregistry_presale_getTldFromDomain($domain);
        $tldMode = unregistry_presale_getTldMode($tld);
        
        // Add TLD mode to result
        if ($tldMode) {
            $result->tldMode = $tldMode['mode'];
            $result->tldModeDisplay = $tldMode['display'];
            $result->tldModeClass = $tldMode['class'];
        }

        // Handle TLD modes
        if ($tldMode && in_array($tldMode['mode'], ['reservation', 'coming_soon', 'disabled'])) {
            // For reservation/coming_soon/disabled - mark as unavailable for regular purchase
            $result->setStatus(SearchResult::STATUS_RESERVED);
            $result->tldSpecialMode = true;
        }

        $listEntry = unregistry_presale_checkDomainList($domain);

        if ($listEntry) {
            if ($listEntry->list_type === 'reserved') {
                // Mark as taken
                $result->setStatus(SearchResult::STATUS_REGISTERED);
            } elseif ($listEntry->list_type === 'premium') {
                // Set premium pricing
                $result->setPremiumDomain(true);
                $result->setPremiumCostPricing([
                    'register' => $listEntry->premium_price,
                    'renew' => $listEntry->premium_price,
                    'CurrencyCode' => 'USD',
                ]);
            }
        }
    }

    return $results;
});

/**
 * Hook: Queue order after payment for custom TLDs
 */
add_hook('OrderPaid', 1, function($vars) {
    $orderId = $vars['OrderId'];

    // Get domains in this order
    $orderDomains = Capsule::table('tbldomains')
        ->where('orderid', $orderId)
        ->get();

    foreach ($orderDomains as $domain) {
        $domainName = $domain->domain;
        $tld = '.' . $domain->tld;

        // Check if this is a custom TLD
        if (!in_array(strtolower($tld), array_map('strtolower', UNREGISTRY_CUSTOM_TLDS))) {
            continue;
        }

        // Get TLD info
        $tldInfo = Capsule::table('mod_unregistry_presale_tlds')
            ->where('tld', strtolower($tld))
            ->first();

        if ($tldInfo && $tldInfo->presale_mode) {
            // Check if already queued
            $existing = Capsule::table('mod_unregistry_order_queue')
                ->where('domain', $domainName)
                ->where('status', 'queued')
                ->first();

            if ($existing) {
                continue;
            }

            // Add to queue
            Capsule::table('mod_unregistry_order_queue')->insert([
                'order_id' => $orderId,
                'domain_id' => $domain->id,
                'domain' => $domainName,
                'tld' => $tld,
                'action' => $domain->type ?? 'register',
                'years' => $domain->registrationperiod ?? 1,
                'status' => 'queued',
                'queued_at' => date('Y-m-d H:i:s'),
            ]);

            // Log activity
            logActivity("Unregistry Pre-Sale: Domain {$domainName} queued for processing");
        }
    }
});

/**
 * Hook: Add pre-sale notice to client area domain details
 */
add_hook('ClientAreaDomainDetails', 1, function($vars) {
    $domain = $vars['domain'] ?? null;

    if (!$domain) {
        return $vars;
    }

    $tld = '.' . ($domain->tld ?? '');

    if (!in_array(strtolower($tld), array_map('strtolower', UNREGISTRY_CUSTOM_TLDS))) {
        return $vars;
    }

    // Check if in pre-sale mode
    $tldInfo = Capsule::table('mod_unregistry_presale_tlds')
        ->where('tld', strtolower($tld))
        ->where('presale_mode', 1)
        ->first();

    if ($tldInfo) {
        $vars['presaleNotice'] = true;
        $vars['presaleMessage'] = 'This domain is a pre-order. Registration will be processed when the TLD launches.';
    }

    return $vars;
});

/**
 * Hook: Add pre-sale indicator to domain checker page
 */
add_hook('ClientAreaPageDomainChecker', 1, function($vars) {
    // Get custom TLDs (enabled only)
    $allCustomTlds = Capsule::table('mod_unregistry_presale_tlds')
        ->leftJoin('mod_unregistry_presale_pricing',
               'mod_unregistry_presale_tlds.id',
               '=',
               'mod_unregistry_presale_pricing.tld_id')
        ->where('mod_unregistry_presale_tlds.enabled', 1)
        ->get();

    $vars['customTlds'] = [];
    $vars['unregistryTlds'] = [];
    $vars['unregistryDisabledTlds'] = [];
    $vars['unregistryTldModes'] = [];
    
    foreach ($allCustomTlds as $tld) {
        $mode = $tld->tld_mode ?: ($tld->presale_mode ? 'presale' : 'live');
        $tldName = ltrim($tld->tld, '.');
        
        $vars['unregistryTldModes'][$tldName] = $mode;
        
        if ($mode === 'disabled') {
            $vars['unregistryDisabledTlds'][] = $tldName;
            continue;
        }
        
        // Use simple if/else instead of match() for PHP 8.0 compatibility
        $modeDisplay = ucfirst($mode);
        if ($mode === 'live') $modeDisplay = 'Live';
        elseif ($mode === 'presale') $modeDisplay = 'Pre-Sale';
        elseif ($mode === 'reservation') $modeDisplay = 'Reservation';
        elseif ($mode === 'coming_soon') $modeDisplay = 'Coming Soon';
        
        $modeClass = 'info';
        if ($mode === 'live') $modeClass = 'success';
        elseif ($mode === 'presale') $modeClass = 'info';
        elseif ($mode === 'reservation') $modeClass = 'warning';
        elseif ($mode === 'coming_soon') $modeClass = 'primary';
        
        $description = 'Domain availability varies';
        if ($mode === 'live') $description = 'Available for immediate registration';
        elseif ($mode === 'presale') $description = 'Pre-order now for early access';
        elseif ($mode === 'reservation') $description = 'Reserve your domain now';
        elseif ($mode === 'coming_soon') $description = 'Coming soon - check back later';
        
        $tldData = [
            'tld' => $tld->tld,
            'register' => $tld->register_price,
            'transfer' => $tld->transfer_price,
            'renew' => $tld->renew_price,
            'presale' => $tld->presale_mode ? true : false,
            'mode' => $mode,
            'modeDisplay' => $modeDisplay,
            'modeClass' => $modeClass,
            'description' => $description,
        ];
        
        $vars['customTlds'][] = $tldData;
        $vars['unregistryTlds'][] = $tldData;
    }

    return $vars;
});

/**
 * Hook: Add custom TLDs to domain search suggestions
 */
add_hook('DomainSearchResults', 1, function($results) {
    // This hook allows adding custom suggestions to domain search results
    return $results;
});

/**
 * Hook: Process domain search from URL (/search/domain)
 * and default to .com when no TLD extension is provided
 */
add_hook('ClientAreaPageCart', 1, function($vars) {
    $requestUri = $_SERVER['REQUEST_URI'] ?? '';
    
    // Debug logging
    logActivity("Unregistry Hook: ClientAreaPageCart - URI: " . $requestUri);
    logActivity("Unregistry Hook: GET vars: " . print_r($_GET, true));
    logActivity("Unregistry Hook: lookupTerm in vars: " . ($vars['lookupTerm'] ?? 'not set'));
    
    // Check if this is a search URL (/search/domain)
    if (preg_match('#^/search/(.+)$#', $requestUri, $matches)) {
        logActivity("Unregistry Hook: Search URL detected - matches: " . print_r($matches, true));
        $domain = urldecode($matches[1]);
        $domain = trim($domain);
        logActivity("Unregistry Hook: Domain extracted: " . $domain);
        
        // Check if domain has an extension
        if ($domain && strpos($domain, '.') === false) {
            // No extension provided, redirect to .com version
            header('Location: /search/' . urlencode($domain . '.com'));
            exit;
        }
        
        // Set the lookupTerm for the template
        if ($domain) {
            $vars['lookupTerm'] = $domain;
            $_REQUEST['domain'] = $domain;
            $_GET['domain'] = $domain;
            $_GET['query'] = $domain;
            logActivity("Unregistry Hook: Set lookupTerm to: " . $domain);
        }
    }
    
    // Check if this is a POST domain check action
    if (isset($_POST['a']) && $_POST['a'] === 'checkDomain') {
        $domain = $_POST['domain'] ?? '';
        $domain = trim($domain);
        
        // Check if domain has an extension
        if ($domain && strpos($domain, '.') === false) {
            // No extension provided, default to .com
            $_POST['domain'] = $domain . '.com';
            $_REQUEST['domain'] = $domain . '.com';
            
            // Also update the POST/REQUEST superglobals for WHMCS to pick up
            $GLOBALS['_POST']['domain'] = $domain . '.com';
            $GLOBALS['_REQUEST']['domain'] = $domain . '.com';
        }
    }
    
    return $vars;
});
