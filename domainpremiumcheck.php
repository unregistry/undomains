<?php
/**
 * Premium Domain Price Check Endpoint
 *
 * Bootstraps WHMCS to access NameSilo API credentials and premium markup tables.
 * Calls NameSilo API for premium domain pricing, applies WHMCS markup, returns JSON.
 *
 * Usage: /domainpremiumcheck.php?domain=example.com
 */

// Bootstrap WHMCS
chdir(__DIR__);
$_GET['nocache'] = 1;
require_once 'init.php';

use WHMCS\Database\Capsule;

header('Content-Type: application/json');

// Validate domain parameter
if (empty($_GET['domain'])) {
    echo json_encode(['error' => 'Missing domain parameter']);
    exit;
}

$domain = trim(preg_replace('/[^a-zA-Z0-9.-]/', '', $_GET['domain']));

if (strlen($domain) < 4 || strpos($domain, '.') === false) {
    echo json_encode(['error' => 'Invalid domain format']);
    exit;
}

// Check session cache
$cacheKey = 'premium_check_' . strtolower($domain);
if (isset($_SESSION[$cacheKey]) && !empty($_SESSION[$cacheKey])) {
    echo $_SESSION[$cacheKey];
    exit;
}

// Get NameSilo API key from WHMCS registrar config
try {
    $encryptedKey = Capsule::table('tblregistrars')
        ->where('registrar', 'namesilo')
        ->where('setting', 'Live_API_Key')
        ->value('value');

    $encryptedTestMode = Capsule::table('tblregistrars')
        ->where('registrar', 'namesilo')
        ->where('setting', 'Test_Mode')
        ->value('value');

    $encryptedSandboxKey = Capsule::table('tblregistrars')
        ->where('registrar', 'namesilo')
        ->where('setting', 'Sandbox_API_Key')
        ->value('value');

    if (!$encryptedKey) {
        echo json_encode(['error' => 'Registrar not configured']);
        exit;
    }

    $testMode = decrypt($encryptedTestMode);
    $apiKey = ($testMode === 'on' && $encryptedSandboxKey)
        ? decrypt($encryptedSandboxKey)
        : decrypt($encryptedKey);

    if (!$apiKey) {
        echo json_encode(['error' => 'API key not available']);
        exit;
    }

} catch (Exception $e) {
    echo json_encode(['error' => 'Database error']);
    exit;
}

// Determine API server
$apiServer = ($testMode === 'on') ? 'https://sandbox.namesilo.com' : 'https://www.namesilo.com';

// Call NameSilo API
$url = $apiServer . '/api/checkRegisterAvailability?version=1&type=xml&key=' . urlencode($apiKey) . '&domains=' . urlencode($domain);

$ch = curl_init($url);
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HEADER         => false,
    CURLOPT_USERAGENT      => 'WHMCS Premium Check/1.0',
    CURLOPT_SSL_VERIFYPEER => true,
    CURLOPT_TIMEOUT        => 15,
    CURLOPT_CONNECTTIMEOUT => 10,
]);

$content = curl_exec($ch);
$curlErr = curl_errno($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($curlErr || !$content) {
    echo json_encode(['error' => 'API connection failed']);
    exit;
}

// Parse XML response
libxml_use_internal_errors(true);
$xml = @simplexml_load_string($content);
libxml_clear_errors();

if (!$xml) {
    echo json_encode(['error' => 'Invalid API response']);
    exit;
}

// Build result
$result = [
    'domain'    => $domain,
    'available' => false,
    'premium'   => false,
    'price'     => null,
    'status'    => 'unavailable'
];

// Extract domain result from XML
// NameSilo checkRegisterAvailability uses <available>/<domain> for available
// and <unavailable>/<domain> or no match for unavailable
$domainXml = null;
$foundAvailable = false;

// Check <available> list
if (isset($xml->reply->available->domain)) {
    foreach ($xml->reply->available->domain as $d) {
        if ((string)$d === $domain || (string)$d['name'] === $domain) {
            $domainXml = $d;
            $foundAvailable = true;
            break;
        }
    }
}

// Check <unavailable> list
if (!$domainXml && isset($xml->reply->unavailable->domain)) {
    foreach ($xml->reply->unavailable->domain as $d) {
        if ((string)$d === $domain || (string)$d['name'] === $domain) {
            $domainXml = $d;
            break;
        }
    }
}

// Fallback: check <domains> format (used by checkDomainAvailability)
if (!$domainXml && isset($xml->reply->domains->domain)) {
    foreach ($xml->reply->domains->domain as $d) {
        if ((string)$d['name'] === $domain) {
            $domainXml = $d;
            $foundAvailable = ((string)$d['status'] === 'available');
            break;
        }
    }
}

if ($domainXml) {
    $isPremium = ((string)$domainXml['premium'] === '1');
    $rawPrice = (string)$domainXml['price'];

    if ($foundAvailable) {
        $result['available'] = true;

        if ($isPremium && is_numeric($rawPrice) && floatval($rawPrice) > 0) {
            $result['premium'] = true;
            $result['status'] = 'premium';

            // Apply WHMCS premium markup from tbldomainpricing_premium
            $basePrice = floatval($rawPrice);
            $markupPercent = getPremiumMarkup($basePrice);
            $finalPrice = $basePrice * (1 + $markupPercent / 100);

            // Get currency prefix from WHMCS
            $currencyPrefix = getCurrencyPrefix();
            $result['price'] = $currencyPrefix . number_format($finalPrice, 2);
        } else {
            // Regular available domain - get standard TLD price
            $result['status'] = 'available';
            $result['price'] = getStandardPrice($domain);
        }
    } else {
        $result['status'] = 'unavailable';
    }
} else {
    // Domain not found in any list - likely unavailable
    // Check if code=300 means success but no available match
    $code = (string)$xml->reply->code;
    if ($code !== '300') {
        $result['error'] = (string)$xml->reply->detail;
    }
}

// Cache result in session
$_SESSION[$cacheKey] = json_encode($result);

echo json_encode($result);
exit;

/**
 * Get premium markup percentage for a given base price
 * Uses WHMCS's tbldomainpricing_premium tiers
 *
 * Tiers: base < $200 = 20%, < $500 = 25%, < $1000 = 30%, >= $1000 = 20%
 */
function getPremiumMarkup($basePrice) {
    try {
        $tiers = Capsule::table('tbldomainpricing_premium')
            ->orderBy('to_amount', 'asc')
            ->get();

        $markup = 20; // default fallback

        foreach ($tiers as $tier) {
            $toAmount = floatval($tier->to_amount);

            if ($toAmount < 0) {
                // Catch-all tier (to_amount = -1)
                $markup = floatval($tier->markup);
                continue;
            }

            if ($basePrice < $toAmount) {
                $markup = floatval($tier->markup);
                break;
            }
        }

        return $markup;

    } catch (Exception $e) {
        return 20; // default 20% on error
    }
}

/**
 * Get the default currency prefix from WHMCS
 */
function getCurrencyPrefix() {
    try {
        $currency = Capsule::table('tblcurrencies')
            ->where('default', 1)
            ->first();

        return $currency ? $currency->prefix : '$';
    } catch (Exception $e) {
        return '$';
    }
}

/**
 * Get standard TLD registration price from WHMCS pricing tables
 */
function getStandardPrice($domain) {
    try {
        $parts = explode('.', $domain, 2);
        if (count($parts) < 2) return null;

        $tld = '.' . $parts[1];
        $prefix = getCurrencyPrefix();

        $currency = Capsule::table('tblcurrencies')
            ->where('default', 1)
            ->first();
        if (!$currency) return null;

        $relid = Capsule::table('tbldomainpricing')
            ->where('extension', $tld)
            ->value('id');
        if (!$relid) return null;

        $msetupfee = Capsule::table('tblpricing')
            ->where('type', 'domainregister')
            ->where('currency', $currency->id)
            ->where('relid', $relid)
            ->value('msetupfee');

        if ($msetupfee !== null && floatval($msetupfee) > 0) {
            return $prefix . number_format(floatval($msetupfee), 2);
        }

        return null;
    } catch (Exception $e) {
        return null;
    }
}
