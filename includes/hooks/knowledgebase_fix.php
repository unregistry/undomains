<?php
/**
 * Fix for knowledgebase numarticles showing 0
 * This hook recalculates the article counts from the database
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

add_hook('ClientAreaPageKnowledgebase', 1, function($vars) {
    if (!isset($vars['kbcats']) || !is_array($vars['kbcats'])) {
        return $vars;
    }
    
    // Get correct article counts from database
    try {
        $counts = Capsule::table('tblknowledgebase')
            ->select('parentid', Capsule::raw('COUNT(*) as count'))
            ->where(function ($query) {
                $query->where('private', '')
                      ->orWhere('private', '0');
            })
            ->groupBy('parentid')
            ->pluck('count', 'parentid')
            ->toArray();
        
        // Update each category's numarticles
        foreach ($vars['kbcats'] as $idx => $cat) {
            $catId = $cat['id'];
            if (isset($counts[$catId])) {
                $vars['kbcats'][$idx]['numarticles'] = $counts[$catId];
            }
        }
    } catch (Exception $e) {
        logActivity("Knowledgebase fix hook error: " . $e->getMessage());
    }
    
    return $vars;
});

// Also fix the category view page
add_hook('ClientAreaPageKnowledgebaseCat', 1, function($vars) {
    if (!isset($vars['kbcats']) || !is_array($vars['kbcats'])) {
        return $vars;
    }
    
    try {
        $counts = Capsule::table('tblknowledgebase')
            ->select('parentid', Capsule::raw('COUNT(*) as count'))
            ->where(function ($query) {
                $query->where('private', '')
                      ->orWhere('private', '0');
            })
            ->groupBy('parentid')
            ->pluck('count', 'parentid')
            ->toArray();
        
        foreach ($vars['kbcats'] as $idx => $cat) {
            $catId = $cat['id'];
            if (isset($counts[$catId])) {
                $vars['kbcats'][$idx]['numarticles'] = $counts[$catId];
            }
        }
    } catch (Exception $e) {
        logActivity("Knowledgebase cat fix hook error: " . $e->getMessage());
    }
    
    return $vars;
});
