<?php
/**
 * TLD Manager
 */

namespace UnregistryManager;

use WHMCS\Database\Capsule;

class TldManager
{
    /**
     * Get all TLDs with pricing
     */
    public static function getTldsWithPricing()
    {
        return Capsule::table('mod_unregistry_presale_tlds as t')
            ->leftJoin('mod_unregistry_presale_pricing as p', 't.id', '=', 'p.tld_id')
            ->orderBy('t.display_order', 'asc')
            ->get();
    }

    /**
     * Get TLD by ID with pricing
     */
    public static function getTldWithPricing($id)
    {
        return Capsule::table('mod_unregistry_presale_tlds as t')
            ->leftJoin('mod_unregistry_presale_pricing as p', 't.id', '=', 'p.tld_id')
            ->where('t.id', $id)
            ->first();
    }

    /**
     * Create or update TLD
     */
    public static function saveTld($data)
    {
        $id = $data['id'] ?? null;

        if ($id) {
            // Update existing
            return Capsule::table('mod_unregistry_presale_tlds')
                ->where('id', $id)
                ->update([
                    'tld' => $data['tld'],
                    'extension' => $data['extension'],
                    'enabled' => $data['enabled'] ?? 1,
                    'presale_mode' => $data['presale_mode'] ?? 1,
                    'display_order' => $data['display_order'] ?? 0,
                ]);
        } else {
            // Create new
            $id = Capsule::table('mod_unregistry_presale_tlds')
                ->insertGetId([
                    'tld' => $data['tld'],
                    'extension' => $data['extension'],
                    'enabled' => $data['enabled'] ?? 1,
                    'presale_mode' => $data['presale_mode'] ?? 1,
                    'display_order' => $data['display_order'] ?? 0,
                ]);

            // Create pricing
            if (isset($data['register_price'])) {
                Capsule::table('mod_unregistry_presale_pricing')
                    ->insert([
                        'tld_id' => $id,
                        'currency' => $data['currency'] ?? 'USD',
                        'register_price' => $data['register_price'],
                        'transfer_price' => $data['transfer_price'] ?? $data['register_price'],
                        'renew_price' => $data['renew_price'] ?? $data['register_price'],
                    ]);
            }
        }

        return $id;
    }

    /**
     * Delete TLD
     */
    public static function deleteTld($id)
    {
        // Delete pricing first
        Capsule::table('mod_unregistry_presale_pricing')
            ->where('tld_id', $id)
            ->delete();

        // Delete TLD
        Capsule::table('mod_unregistry_presale_tlds')
            ->where('id', $id)
            ->delete();
    }

}
