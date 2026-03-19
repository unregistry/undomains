<?php
/**
 * WHMCS Hooks for Unregistry Pre-sale - Working Version
 * 
 * IMPORTANT: When you change TLD modes in the admin, you need to update
 * the template file: /templates/orderforms/standard_cart/domainregister.tpl
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
