<?php
/**
 * Unregistry Pre-Sale Registrar Module for WHMCS
 *
 * Handles pre-orders for custom TLDs (.degen, .fio, .com.store, etc.)
 * Orders are queued for later processing when Unregistry integration is ready.
 *
 * @package    UnregistryPresale
 * @author     Undomains
 * @version    1.0.0
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Domains\DomainLookup\ResultsList;
use WHMCS\Domains\DomainLookup\SearchResult;
use WHMCS\Database\Capsule;

// Custom TLDs managed by this module
define('UNREGISTRY_CUSTOM_TLDS', [
    '.degen', '.fio', '.com.store', '.com.film', '.com.supply',
    '.com.bond', '.com.barcelona', '.app.onl', '.org.onl', '.site.onl'
]);

/**
 * Get module configuration
 */
function unregistry_presale_getConfigArray()
{
    return [
        'DisplayName' => [
            'Type' => 'text',
            'Size' => '40',
            'Default' => 'Unregistry Pre-Sale',
            'Description' => 'Display name for this registrar module',
        ],
        'PreSaleMode' => [
            'Type' => 'yesno',
            'Description' => 'Enable pre-sale mode (orders queued, not registered)',
            'Default' => 'on',
        ],
        'QueueStatusMessage' => [
            'Type' => 'text',
            'Size' => '100',
            'Default' => 'Your domain pre-order has been queued. You will be notified when registration opens.',
            'Description' => 'Message shown to customers during pre-sale',
        ],
        'AutoCompleteOrders' => [
            'Type' => 'yesno',
            'Description' => 'Automatically mark orders as complete after queueing',
            'Default' => 'on',
        ],
        'LogDebug' => [
            'Type' => 'yesno',
            'Description' => 'Enable debug logging to WHMCS module log',
        ],
        'NotificationEmail' => [
            'Type' => 'text',
            'Size' => '100',
            'Description' => 'Email to notify of new pre-orders (leave blank to disable)',
        ],
    ];
}

/**
 * Log debug message
 */
function unregistry_presale_log($message, $data = [])
{
    $params = func_get_args();
    $config = isset($params[2]) ? $params[2] : [];

    if (!empty($config['LogDebug'])) {
        logModuleCall('unregistry_presale', 'debug', $message, json_encode($data), '', '');
    }
}

/**
 * Check if a TLD is one of our custom TLDs
 */
function unregistry_presale_isCustomTld($tld)
{
    $tld = '.' . ltrim($tld, '.');
    return in_array(strtolower($tld), array_map('strtolower', UNREGISTRY_CUSTOM_TLDS));
}

/**
 * Get TLD info from our database
 */
function unregistry_presale_getTldInfo($tld)
{
    $tld = '.' . ltrim($tld, '.');
    return Capsule::table('mod_unregistry_presale_tlds')
        ->where('tld', strtolower($tld))
        ->where('enabled', 1)
        ->first();
}

/**
 * Check domain against our lists (reserved/restricted/premium)
 */
function unregistry_presale_checkDomainList($domain, $tldId = null)
{
    $query = Capsule::table('mod_unregistry_domain_lists')
        ->where('domain', strtolower($domain));

    if ($tldId) {
        $query->where(function($q) use ($tldId) {
            $q->where('tld_id', $tldId)
              ->orWhereNull('tld_id');
        });
    }

    return $query->first();
}

/**
 * Add order to queue
 */
function unregistry_presale_queueOrder($params, $action)
{
    $domain = $params['sld'] . '.' . $params['tld'];
    $tld = '.' . $params['tld'];

    // Get order info from params
    $orderId = $params['orderid'] ?? 0;
    $domainId = $params['domainid'] ?? 0;
    $years = $params['regperiod'] ?? 1;

    // Check if already queued
    $existing = Capsule::table('mod_unregistry_order_queue')
        ->where('domain', $domain)
        ->where('status', 'queued')
        ->first();

    if ($existing) {
        return ['success' => true, 'message' => 'Order already queued'];
    }

    // Insert into queue
    $queueId = Capsule::table('mod_unregistry_order_queue')->insertGetId([
        'order_id' => $orderId,
        'domain_id' => $domainId,
        'domain' => $domain,
        'tld' => $tld,
        'action' => $action,
        'years' => $years,
        'status' => 'queued',
        'queued_at' => date('Y-m-d H:i:s'),
    ]);

    // Log activity
    logActivity("Unregistry Pre-Sale: Domain {$domain} queued for {$action} (Queue ID: {$queueId})");

    // Send notification email if configured
    $config = $params;
    if (!empty($config['NotificationEmail'])) {
        $subject = "New Pre-Order: {$domain}";
        $body = "A new domain pre-order has been queued:\n\n";
        $body .= "Domain: {$domain}\n";
        $body .= "Action: {$action}\n";
        $body .= "Years: {$years}\n";
        $body .= "Queue ID: {$queueId}\n";
        mail($config['NotificationEmail'], $subject, $body);
    }

    return ['success' => true, 'queue_id' => $queueId];
}

/**
 * Check domain availability
 * Called during domain search
 */
function unregistry_presale_CheckAvailability($params)
{
    $tld = $params['tld'];
    $sld = $params['sld'];
    $domain = $sld . '.' . $tld;

    if (!unregistry_presale_isCustomTld($tld)) {
        return ['error' => 'TLD not supported by this module'];
    }

    // Get TLD info
    $tldInfo = unregistry_presale_getTldInfo($tld);
    if (!$tldInfo) {
        return ['error' => 'TLD not configured'];
    }

    // Check if domain is in our reserved/restricted/premium lists
    $listEntry = unregistry_presale_checkDomainList($domain, $tldInfo->id);

    if ($listEntry) {
        if ($listEntry->list_type === 'reserved') {
            // Domain is reserved - return as taken
            return [
                'status' => 'taken',
                'reason' => 'Domain is reserved'
            ];
        }

        if ($listEntry->list_type === 'restricted') {
            // Domain is restricted - still available but with conditions
            return [
                'status' => 'available',
                'restricted' => true,
                'restriction_reason' => $listEntry->restriction_reason,
                'premium' => false,
            ];
        }

        if ($listEntry->list_type === 'premium') {
            // Domain is premium
            return [
                'status' => 'available',
                'premium' => true,
                'premium_price' => $listEntry->premium_price,
                'restricted' => false,
            ];
        }
    }

    // Domain is available
    return [
        'status' => 'available',
        'premium' => false,
        'restricted' => false,
    ];
}

/**
 * Get domain suggestions
 */
function unregistry_presale_GetDomainSuggestions($params)
{
    $results = new ResultsList();
    $sld = $params['sld'];

    // Get all enabled custom TLDs
    $tlds = Capsule::table('mod_unregistry_presale_tlds')
        ->where('enabled', 1)
        ->orderBy('display_order')
        ->get();

    foreach ($tlds as $tldInfo) {
        $domain = $sld . $tldInfo->tld;

        // Check against lists
        $listEntry = unregistry_presale_checkDomainList($domain, $tldInfo->id);

        if ($listEntry && $listEntry->list_type === 'reserved') {
            continue; // Skip reserved domains
        }

        $searchResult = new SearchResult($sld, ltrim($tldInfo->tld, '.'));

        if ($listEntry && $listEntry->list_type === 'premium') {
            $searchResult->setStatus(SearchResult::STATUS_NOT_REGISTERED);
            $searchResult->setPremiumDomain(true);
            $searchResult->setPremiumCostPricing([
                'register' => $listEntry->premium_price,
                'renew' => $listEntry->premium_price,
                'CurrencyCode' => 'USD',
            ]);
        } else {
            $searchResult->setStatus(SearchResult::STATUS_NOT_REGISTERED);
        }

        $results->append($searchResult);
    }

    return $results;
}

/**
 * Register domain
 * In pre-sale mode, this queues the order instead of registering
 */
function unregistry_presale_RegisterDomain($params)
{
    $tld = $params['tld'];
    $domain = $params['sld'] . '.' . $tld;

    unregistry_presale_log('RegisterDomain called', ['domain' => $domain], $params);

    if (!unregistry_presale_isCustomTld($tld)) {
        return ['error' => 'TLD not supported'];
    }

    // Get TLD info
    $tldInfo = unregistry_presale_getTldInfo($tld);
    if (!$tldInfo) {
        return ['error' => 'TLD not configured'];
    }

    // Check if domain is reserved
    $listEntry = unregistry_presale_checkDomainList($domain, $tldInfo->id);
    if ($listEntry && $listEntry->list_type === 'reserved') {
        return ['error' => 'This domain is reserved and cannot be registered'];
    }

    // In pre-sale mode, queue the order
    if (!empty($params['PreSaleMode'])) {
        $result = unregistry_presale_queueOrder($params, 'register');

        if ($result['success']) {
            return [
                'success' => true,
                'message' => $params['QueueStatusMessage'] ?? 'Your pre-order has been queued.',
            ];
        }

        return ['error' => 'Failed to queue order'];
    }

    // If not in pre-sale mode, would integrate with Unregistry here
    // For now, return error as registry integration is not ready
    return ['error' => 'Registry integration not available. Pre-sale mode required.'];
}

/**
 * Transfer domain
 */
function unregistry_presale_TransferDomain($params)
{
    $tld = $params['tld'];
    $domain = $params['sld'] . '.' . $tld;

    unregistry_presale_log('TransferDomain called', ['domain' => $domain], $params);

    if (!unregistry_presale_isCustomTld($tld)) {
        return ['error' => 'TLD not supported'];
    }

    // In pre-sale mode, queue the transfer
    if (!empty($params['PreSaleMode'])) {
        $result = unregistry_presale_queueOrder($params, 'transfer');

        if ($result['success']) {
            return [
                'success' => true,
                'message' => 'Your transfer request has been queued.',
            ];
        }

        return ['error' => 'Failed to queue transfer'];
    }

    return ['error' => 'Registry integration not available. Pre-sale mode required.'];
}

/**
 * Renew domain
 */
function unregistry_presale_RenewDomain($params)
{
    $tld = $params['tld'];
    $domain = $params['sld'] . '.' . $tld;

    unregistry_presale_log('RenewDomain called', ['domain' => $domain], $params);

    if (!unregistry_presale_isCustomTld($tld)) {
        return ['error' => 'TLD not supported'];
    }

    // In pre-sale mode, queue the renewal
    if (!empty($params['PreSaleMode'])) {
        $result = unregistry_presale_queueOrder($params, 'renew');

        if ($result['success']) {
            return [
                'success' => true,
                'message' => 'Your renewal has been queued.',
            ];
        }

        return ['error' => 'Failed to queue renewal'];
    }

    return ['error' => 'Registry integration not available. Pre-sale mode required.'];
}

/**
 * Get domain information
 */
function unregistry_presale_GetDomainInformation($params)
{
    $tld = $params['tld'];
    $domain = $params['sld'] . '.' . $tld;

    // Check if in queue
    $queueEntry = Capsule::table('mod_unregistry_order_queue')
        ->where('domain', $domain)
        ->whereIn('status', ['queued', 'processing'])
        ->orderBy('id', 'desc')
        ->first();

    $status = 'Active';
    $expiryDate = date('Y-m-d', strtotime('+1 year'));

    if ($queueEntry) {
        // Show as pending if in queue
        $status = 'Pending (Pre-Order)';
    }

    return [
        'status' => $status,
        'expirydate' => $expiryDate,
        'paiduntil' => $expiryDate,
        'addons' => [
            'dnsmanagement' => true,
            'emailforwarding' => true,
            'idprotection' => true,
        ],
    ];
}

/**
 * Get nameservers
 */
function unregistry_presale_GetNameservers($params)
{
    // Return placeholder nameservers during pre-sale
    return [
        'ns1' => 'ns1.undomains.com',
        'ns2' => 'ns2.undomains.com',
    ];
}

/**
 * Save nameservers
 */
function unregistry_presale_SaveNameservers($params)
{
    // In pre-sale mode, just acknowledge - we'll configure later
    return ['success' => true];
}

/**
 * Get contact details
 */
function unregistry_presale_GetContactDetails($params)
{
    // Return placeholder - real data stored in WHMCS
    return [
        'Registrant' => [
            'FirstName' => $params['original']['registrant']['FirstName'] ?? '',
            'LastName' => $params['original']['registrant']['LastName'] ?? '',
            'CompanyName' => $params['original']['registrant']['CompanyName'] ?? '',
            'Address1' => $params['original']['registrant']['Address1'] ?? '',
            'Address2' => $params['original']['registrant']['Address2'] ?? '',
            'City' => $params['original']['registrant']['City'] ?? '',
            'State' => $params['original']['registrant']['State'] ?? '',
            'Postcode' => $params['original']['registrant']['Postcode'] ?? '',
            'Country' => $params['original']['registrant']['Country'] ?? '',
            'EmailAddress' => $params['original']['registrant']['EmailAddress'] ?? '',
            'Phone' => $params['original']['registrant']['Phone'] ?? '',
        ],
    ];
}

/**
 * Save contact details
 */
function unregistry_presale_SaveContactDetails($params)
{
    // In pre-sale mode, just acknowledge - data is in WHMCS
    return ['success' => true];
}

/**
 * Get registrar lock status
 */
function unregistry_presale_GetRegistrarLock($params)
{
    // Return locked during pre-sale
    return 'locked';
}

/**
 * Save registrar lock
 */
function unregistry_presale_SaveRegistrarLock($params)
{
    // Acknowledge during pre-sale
    return ['success' => true];
}

/**
 * Get DNS management
 */
function unregistry_presale_GetDNS($params)
{
    // Return empty during pre-sale
    return [];
}

/**
 * Save DNS management
 */
function unregistry_presale_SaveDNS($params)
{
    // Acknowledge during pre-sale
    return ['success' => true];
}

/**
 * Get email forwarding
 */
function unregistry_presale_GetEmailForwarding($params)
{
    return [];
}

/**
 * Save email forwarding
 */
function unregistry_presale_SaveEmailForwarding($params)
{
    return ['success' => true];
}

/**
 * Get ID protection status
 */
function unregistry_presale_GetIDProtect($params)
{
    return false;
}

/**
 * Set ID protection
 */
function unregistry_presale_SetIDProtect($params)
{
    return ['success' => true];
}

/**
 * Sync domain status
 */
function unregistry_presale_Sync($params)
{
    // In pre-sale, no sync needed
    return [
        'expirydate' => $params['expirydate'] ?? date('Y-m-d', strtotime('+1 year')),
        'active' => true,
        'expired' => false,
    ];
}

/**
 * Sync transfer status
 */
function unregistry_presale_TransferSync($params)
{
    // In pre-sale, transfers are always "pending"
    return [
        'completed' => false,
        'failed' => false,
    ];
}

/**
 * Request EPP code
 */
function unregistry_presale_GetEPPCode($params)
{
    // Generate a placeholder EPP code for pre-sale
    return [
        'eppcode' => strtoupper(substr(md5($params['sld'] . $params['tld'] . time()), 0, 12)),
    ];
}

/**
 * Release domain
 */
function unregistry_presale_ReleaseDomain($params)
{
    return ['error' => 'Domain release not available during pre-sale'];
}

/**
 * Delete domain
 */
function unregistry_presale_RequestDelete($params)
{
    // Mark as to be cancelled in queue
    return ['success' => true];
}

/**
 * Register nameserver
 */
function unregistry_presale_RegisterNameserver($params)
{
    return ['success' => true];
}

/**
 * Modify nameserver
 */
function unregistry_presale_ModifyNameserver($params)
{
    return ['success' => true];
}

/**
 * Delete nameserver
 */
function unregistry_presale_DeleteNameserver($params)
{
    return ['success' => true];
}
