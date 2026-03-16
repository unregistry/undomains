<?php
/**
 * Newsletter Subscribe Handler
 * Stores subscriber emails in local database
 */

// Load WHMCS configuration for database credentials
require_once __DIR__ . '/configuration.php';

// CORS headers
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);

    if (!$email) {
        echo json_encode(['success' => false, 'message' => 'Please enter a valid email address']);
        exit;
    }

    // Connect to database
    $mysqli = new mysqli($db_host, $db_username, $db_password, $db_name);
    
    if ($mysqli->connect_error) {
        error_log('Database connection error: ' . $mysqli->connect_error);
        echo json_encode(['success' => false, 'message' => 'Subscription failed. Please try again.']);
        exit;
    }

    // Get client IP address
    $ip_address = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? '';
    if (strpos($ip_address, ',') !== false) {
        $ip_address = trim(explode(',', $ip_address)[0]);
    }

    // Check if email already exists
    $stmt = $mysqli->prepare("SELECT id, status FROM mod_newsletter_subscribers WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        if ($row['status'] === 'active') {
            echo json_encode(['success' => false, 'message' => 'This email is already subscribed!']);
        } else {
            // Resubscribe
            $stmt = $mysqli->prepare("UPDATE mod_newsletter_subscribers SET status = 'active', unsubscribed_at = NULL WHERE email = ?");
            $stmt->bind_param("s", $email);
            if ($stmt->execute()) {
                echo json_encode(['success' => true, 'message' => 'Welcome back! You have been resubscribed.']);
            } else {
                echo json_encode(['success' => false, 'message' => 'Subscription failed. Please try again.']);
            }
        }
    } else {
        // Insert new subscriber
        $stmt = $mysqli->prepare("INSERT INTO mod_newsletter_subscribers (email, ip_address) VALUES (?, ?)");
        $stmt->bind_param("ss", $email, $ip_address);
        
        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Thank you for subscribing!']);
        } else {
            error_log('Database insert error: ' . $stmt->error);
            echo json_encode(['success' => false, 'message' => 'Subscription failed. Please try again.']);
        }
    }

    $stmt->close();
    $mysqli->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
?>
