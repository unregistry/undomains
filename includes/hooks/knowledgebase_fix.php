<?php
/**
 * Fix for knowledgebase numarticles showing 0
 * This hook recalculates the article counts from the database
 * Also adds subtitle to knowledgebase page
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

// Add subtitle to knowledgebase page
add_hook('ClientAreaPageKnowledgebase', 2, function($vars) {
    $vars['tagline'] = 'Enter a question here to search our knowledgebase for answers.';
    return $vars;
});

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

// Add subtitle to knowledgebase category page
add_hook('ClientAreaPageKnowledgebaseCat', 2, function($vars) {
    $vars['tagline'] = 'Enter a question here to search our knowledgebase for answers.';
    return $vars;
});

// Add subtitle to knowledgebase article page
add_hook('ClientAreaPageKnowledgebaseArticle', 2, function($vars) {
    $vars['tagline'] = 'Enter a question here to search our knowledgebase for answers.';
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
