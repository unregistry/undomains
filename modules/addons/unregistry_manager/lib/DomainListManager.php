<?php
/**
 * Domain List Manager (Reserved/Restricted/Premium)
 */

namespace UnregistryManager;

use WHMCS\Database\Capsule;

class DomainListManager
{
    /**
     * Get domains by type
     */
    public static function getDomains($listType = null, $tldId = null, $limit = 100, $offset = 0)
    {
        $query = Capsule::table('mod_unregistry_domain_lists');

        if ($listType) {
            $query->where('list_type', $listType);
        }

        if ($tldId !== null) {
            $query->where('tld_id', $tldId);
        }

        return $query->orderBy('created_at', 'desc')
            ->skip($offset)
            ->take($limit)
            ->get();
    }

    /**
     * Get domain entry
     */
    public static function getDomain($id)
    {
        return Capsule::table('mod_unregistry_domain_lists')
            ->where('id', $id)
            ->first();
    }

    /**
     * Add domain to list
     */
    public static function addDomain($data)
    {
        return Capsule::table('mod_unregistry_domain_lists')->insertGetId($data);
    }

    /**
     * Update domain entry
     */
    public static function updateDomain($id, $data)
    {
        return Capsule::table('mod_unregistry_domain_lists')
            ->where('id', $id)
            ->update($data);
    }

    /**
     * Delete domain entry
     */
    public static function deleteDomain($id)
    {
        return Capsule::table('mod_unregistry_domain_lists')
            ->where('id', $id)
            ->delete();
    }

    /**
     * Check if domain is in any list
     */
    public static function checkDomain($domain, $tldId = null)
    {
        $query = Capsule::table('mod_unregistry_domain_lists')
            ->where('domain', strtolower($domain));

        if ($tldId !== null) {
            $query->where(function($q) use ($tldId) {
                $q->where('tld_id', $tldId)
                  ->orWhereNull('tld_id');
            });
        }

        return $query->first();
    }

    /**
     * Get counts by type
     */
    public static function getCounts()
    {
        $counts = [];
        $types = ['reserved', 'restricted', 'premium'];

        foreach ($types as $type) {
            $counts[$type] = Capsule::table('mod_unregistry_domain_lists')
                ->where('list_type', $type)
                ->count();
        }

        return $counts;
    }

    /**
     * Search domains
     */
    public static function searchDomains($search, $limit = 50)
    {
        return Capsule::table('mod_unregistry_domain_lists')
            ->where('domain', 'LIKE', '%' . $search . '%')
            ->orWhere('notes', 'LIKE', '%' . $search . '%')
            ->orderBy('created_at', 'desc')
            ->take($limit)
            ->get();
    }

    /**
     * Import domains from array
     */
    public static function importDomains($lines, $listType, $tldId = null)
    {
        $imported = 0;
        $skipped = 0;

        foreach ($lines as $line) {
            $domain = trim($line['domain'] ?? '');
            if (empty($domain)) {
                continue;
            }

            // Check if already exists
            $existing = self::checkDomain($domain, $tldId);
            if ($existing) {
                $skipped++;
                continue;
            }

            $data = [
                'tld_id' => $tldId,
                'domain' => strtolower($domain),
                'list_type' => $listType,
                'premium_price' => $line['premium_price'] ?? null,
                'restriction_reason' => $line['restriction_reason'] ?? null,
                'notes' => $line['notes'] ?? null,
                'created_at' => date('Y-m-d H:i:s'),
            ];

            self::addDomain($data);
            $imported++;
        }

        return [
            'imported' => $imported,
            'skipped' => $skipped,
        ];
    }
}
