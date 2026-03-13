<?php
/**
 * SendGrid Newsletter Subscribe Handler
 * Adds email to SendGrid contact list
 */

// Load WHMCS configuration for secure credentials
require_once __DIR__ . '/configuration.php';

// CORS headers
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);

    if (!$email) {
        echo json_encode(['success' => false, 'message' => 'Invalid email address']);
        exit;
    }

    // Add to SendGrid contact list
    $result = addContactToSendGrid($email, $sendgrid_api_key, $sendgrid_list_id);

    if ($result) {
        echo json_encode(['success' => true, 'message' => 'Thank you for subscribing!']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Subscription failed. Please try again.']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request']);
}

/**
 * Add contact to SendGrid marketing list
 */
function addContactToSendGrid($email, $api_key, $list_id) {
    $url = 'https://api.sendgrid.com/v3/marketing/contacts';

    // Check if contact already exists
    $check_url = 'https://api.sendgrid.com/v3/marketing/contacts/search?email=' . urlencode($email);
    $check_result = sendgridRequest($check_url, $api_key, 'GET');

    $contact_id = null;
    if ($check_result && isset($check_result['result']) && count($check_result['result']) > 0) {
        $contact_id = $check_result['result'][0]['id'];
    }

    // Prepare contact data
    $contact_data = [
        'list_ids' => [$list_id],
        'contacts' => [
            [
                'email' => $email,
            ]
        ]
    ];

    // Add or update contact
    if ($contact_id) {
        // Update existing contact
        $url = 'https://api.sendgrid.com/v3/marketing/contacts/' . $contact_id;
        $result = sendgridRequest($url, $api_key, 'PUT', json_encode($contact_data));
    } else {
        // Create new contact
        $result = sendgridRequest($url, $api_key, 'PUT', json_encode($contact_data));
    }

    return $result !== false;
}

/**
 * Make request to SendGrid API
 */
function sendgridRequest($url, $api_key, $method = 'GET', $body = null) {
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Authorization: Bearer ' . $api_key,
        'Content-Type: application/json'
    ]);

    if ($body) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
    }

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);

    curl_close($ch);

    if ($error) {
        error_log('SendGrid API Error: ' . $error);
        return false;
    }

    if ($http_code >= 200 && $http_code < 300) {
        return json_decode($response, true);
    }

    error_log('SendGrid API HTTP Error: ' . $http_code . ' - ' . $response);
    return false;
}
?>
