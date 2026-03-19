<?php
// Get Unregistry TLD modes from database
$tldModes = [];
$tldDisabled = [];

try {
    $pdo = new PDO(
        'mysql:host=localhost;dbname=undomains;charset=utf8mb4',
        'undomains_user',
        '',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_SILENT]
    );
    
    $stmt = $pdo->query("SELECT tld, tld_mode FROM mod_unregistry_presale_tlds WHERE enabled = 1");
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $mode = $row['tld_mode'] ?: 'live';
        $name = ltrim($row['tld'], '.');
        $tldModes[$name] = $mode;
        if ($mode === 'disabled') {
            $tldDisabled[] = $name;
        }
    }
} catch (Exception $e) {
    // Fallback to hardcoded values
    $tldModes = [
        'degen' => 'disabled', 'fio' => 'disabled',
        'com.store' => 'coming_soon', 'com.film' => 'coming_soon',
        'com.supply' => 'coming_soon', 'com.bond' => 'coming_soon',
        'com.barcelona' => 'coming_soon',
        'app.onl' => 'live', 'org.onl' => 'live', 'site.onl' => 'live'
    ];
    $tldDisabled = ['degen', 'fio'];
}

// Make available to Smarty
$GLOBALS['unregistryTldModes'] = $tldModes;
$GLOBALS['unregistryDisabledTlds'] = $tldDisabled;
