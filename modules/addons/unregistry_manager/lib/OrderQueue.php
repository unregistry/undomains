<?php
/**
 * Order Queue Manager
 */

namespace UnregistryManager;

use WHMCS\Database\Capsule;

class OrderQueue
{
    /**
     * Get queued orders count
     */
    public static function getQueuedCount()
    {
        return Capsule::table('mod_unregistry_order_queue')
            ->where('status', 'queued')
            ->count();
    }

    /**
     * Get orders by status
     */
    public static function getOrdersByStatus($status)
    {
        return Capsule::table('mod_unregistry_order_queue')
            ->where('status', $status)
            ->orderBy('queued_at', 'desc')
            ->get();
    }

    /**
     * Get all orders
     */
    public static function getAllOrders($limit = 50, $offset = 0)
    {
        $query = Capsule::table('mod_unregistry_order_queue')
            ->orderBy('queued_at', 'desc');

        if ($limit) {
            $query->take($limit);
        }

        if ($offset) {
            $query->skip($offset);
        }

        return $query->get();
    }

    /**
     * Get order details
     */
    public static function getOrder($id)
    {
        return Capsule::table('mod_unregistry_order_queue')
            ->where('id', $id)
            ->first();
    }

    /**
     * Add order to queue
     */
    public static function queueOrder($data)
    {
        return Capsule::table('mod_unregistry_order_queue')->insert($data);
    }

    /**
     * Update order status
     */
    public static function updateStatus($id, $status, $error = null)
    {
        $update = ['status' => $status];

        if ($error !== null) {
            $update['last_error'] = $error;
        }

        if ($status === 'completed') {
            $update['processed_at'] = date('Y-m-d H:i:s');
        }

        if ($status === 'processing') {
            $update['retry_count'] = Capsule::raw('retry_count + 1');
        }

        return Capsule::table('mod_unregistry_order_queue')
            ->where('id', $id)
            ->update($update) > 0;
    }

    /**
     * Delete order from queue
     */
    public static function deleteOrder($id)
    {
        return Capsule::table('mod_unregistry_order_queue')
            ->where('id', $id)
            ->delete();
    }

    /**
     * Get queue statistics
     */
    public static function getStats()
    {
        $stats = [
            'total' => Capsule::table('mod_unregistry_order_queue')->count(),
            'queued' => self::getQueuedCount(),
            'processing' => Capsule::table('mod_unregistry_order_queue')->where('status', 'processing')->count(),
            'completed' => Capsule::table('mod_unregistry_order_queue')->where('status', 'completed')->count(),
            'failed' => Capsule::table('mod_unregistry_order_queue')->where('status', 'failed')->count(),
            'by_tld' => [],
        ];

        // Get counts by TLD
        $tldCounts = Capsule::table('mod_unregistry_order_queue')
            ->select('tld', Capsule::raw('COUNT(*) as count'))
            ->groupBy('tld')
            ->get();

        foreach ($tldCounts as $row) {
            $stats['by_tld'][$row->tld] = $row->count;
        }

        return $stats;
    }

    /**
     * Get recent orders
     */
    public static function getRecentOrders($limit = 5)
    {
        return Capsule::table('mod_unregistry_order_queue')
            ->orderBy('queued_at', 'desc')
            ->take($limit)
            ->get();
    }
}
