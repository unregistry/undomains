<?php
/**
 * Helper class for Unregistry Manager
 */

namespace UnregistryManager;

use WHMCS\Database\Capsule;

class Helper
{
    /**
     * Get module setting
     */
    public static function getSetting($key, $default = null)
    {
        $setting = Capsule::table('mod_unregistry_settings')
            ->where('setting_key', $key)
            ->first();

        return $setting ? $setting->setting_value : $default;
    }

    /**
     * Set module setting
     */
    public static function setSetting($key, $value)
    {
        return Capsule::table('mod_unregistry_settings')
            ->updateOrInsert(
                ['setting_key' => $key, 'setting_value' => $value],
                ['setting_key']
            );
    }

    /**
     * Get all TLDs
     */
    public static function getTlds($enabled = null)
    {
        $query = Capsule::table('mod_unregistry_presale_tlds')
            ->orderBy('display_order', 'asc');

        if ($enabled !== null) {
            $query->where('enabled', $enabled);
        }

        return $query->get();
    }

    /**
     * Get TLD by ID
     */
    public static function getTldById($id)
    {
        return Capsule::table('mod_unregistry_presale_tlds')
            ->where('id', $id)
            ->first();
    }

    /**
     * Get TLD by extension
     */
    public static function getTldByExtension($extension)
    {
        return Capsule::table('mod_unregistry_presale_tlds')
            ->where('extension', ltrim($extension, '.'))
            ->first();
    }

    /**
     * Get TLD pricing
     */
    public static function getTldPricing($tldId)
    {
        return Capsule::table('mod_unregistry_presale_pricing')
            ->where('tld_id', $tldId)
            ->get();
    }

    /**
     * Get domain list entries
     */
    public static function getDomainList($listType = null, $tldId = null, $limit = 100, $offset = 0)
    {
        $query = Capsule::table('mod_unregistry_domain_lists')
            ->orderBy('created_at', 'desc')
            ->limit($limit)
            ->offset($offset);

        if ($listType) {
            $query->where('list_type', $listType);
        }

        if ($tldId) {
            $query->where('tld_id', $tldId);
        }

        return $query->get();
    }

    /**
     * Count domain list entries
     */
    public static function countDomainList($listType = null, $tldId = null)
    {
        $query = Capsule::table('mod_unregistry_domain_lists');

        if ($listType) {
            $query->where('list_type', $listType);
        }

        if ($tldId) {
            $query->where('tld_id', $tldId);
        }

        return $query->count();
    }

    /**
     * Get order queue
     */
    public static function getOrderQueue($status = null, $limit = 100, $offset = 0)
    {
        $query = Capsule::table('mod_unregistry_order_queue')
            ->orderBy('queued_at', 'desc')
            ->limit($limit)
            ->offset($offset);

        if ($status) {
            $query->where('status', $status);
        }

        return $query->get();
    }

    /**
     * Count order queue
     */
    public static function countOrderQueue($status = null)
    {
        $query = Capsule::table('mod_unregistry_order_queue');

        if ($status) {
            $query->where('status', $status);
        }

        return $query->count();
    }

    /**
     * Get dashboard statistics
     */
    public static function getStats()
    {
        return [
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
    }

    /**
     * Add domain to list
     */
    public static function addDomainToList($data)
    {
        return Capsule::table('mod_unregistry_domain_lists')->insertGetId($data);
    }

    /**
     * Update domain list entry
     */
    public static function updateDomainListEntry($id, $data)
    {
        return Capsule::table('mod_unregistry_domain_lists')
            ->where('id', $id)
            ->update($data);
    }

    /**
     * Delete domain list entry
     */
    public static function deleteDomainListEntry($id)
    {
        return Capsule::table('mod_unregistry_domain_lists')
            ->where('id', $id)
            ->delete();
    }

    /**
     * Check if domain matches pattern
     */
    public static function matchDomainPattern($domain, $pattern)
    {
        $domain = strtolower($domain);
        $pattern = strtolower($pattern);

        // Convert wildcard pattern to regex
        $regex = str_replace('\*', '.*', preg_quote($pattern, '/'));
        return preg_match('/^' . $regex . '$/i', $domain);
    }

    /**
     * Format price
     */
    public static function formatPrice($price, $currency = 'USD')
    {
        $symbols = [
            'USD' => '$',
            'EUR' => '€',
            'GBP' => '£',
        ];

        $symbol = $symbols[$currency] ?? $currency . ' ';
        return $symbol . number_format($price, 2);
    }
}
