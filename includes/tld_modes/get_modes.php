<?php
if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

function get_unregistry_tld_modes() {
    $tlds = Capsule::table('mod_unregistry_presale_tlds')
        ->where('enabled', 1)
        ->get();
    
    $result = [
        'disabled' => [],
        'modes' => []
    ];
    
    foreach ($tlds as $tld) {
        $mode = $tld->tld_mode ?: 'live';
        $name = ltrim($tld->tld, '.');
        
        $result['modes'][$name] = $mode;
        if ($mode === 'disabled') {
            $result['disabled'][] = $name;
        }
    }
    
    return $result;
}
