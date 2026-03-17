<?php
/**
 * Contact Form Handler Hook
 * Saves contact form submissions to database and sends copy to admin
 */

use WHMCS\Database\Capsule;

// Hook into contact form submission
add_hook('EmailPreSend', 1, function($vars) {
    // Check if this is a contact form email
    if ($vars['messagename'] == 'Support Ticket Auto Response' || 
        strpos($vars['messagename'], 'Contact') !== false ||
        (isset($vars['extra']['contactForm']) && $vars['extra']['contactForm'] == true)) {
        
        // Extract form data from the email
        $emailBody = $vars['message'] ?? '';
        $subject = $vars['subject'] ?? '';
        
        // Parse name and email from the message or use extra data
        $name = $vars['extra']['name'] ?? 'Unknown';
        $email = $vars['extra']['email'] ?? '';
        $messageText = $vars['extra']['message'] ?? '';
        
        // If extra data not available, try to extract from email body
        if (empty($name) || empty($email)) {
            // Try to parse from email body (WHMCS format)
            if (preg_match('/Name:\s*(.+?)(?:\r|\n)/i', $emailBody, $matches)) {
                $name = trim($matches[1]);
            }
            if (preg_match('/Email:\s*(.+?)(?:\r|\n)/i', $emailBody, $matches)) {
                $email = trim($matches[1]);
            }
            if (preg_match('/Message:\s*(.+?)(?:\r|\n|$)/is', $emailBody, $matches)) {
                $messageText = trim($matches[1]);
            }
        }
        
        // Get IP address
        $ip_address = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? '';
        if (strpos($ip_address, ',') !== false) {
            $ip_address = trim(explode(',', $ip_address)[0]);
        }
        
        // Save to database
        try {
            Capsule::table('mod_contact_form_submissions')->insert([
                'name' => $name,
                'email' => $email,
                'subject' => $subject,
                'message' => $messageText ?: $emailBody,
                'ip_address' => $ip_address,
                'submitted_at' => date('Y-m-d H:i:s'),
                'status' => 'new'
            ]);
        } catch (Exception $e) {
            logActivity('Contact Form DB Error: ' . $e->getMessage());
        }
        
        // Send copy to admin
        $admin_email = 'admin@undomains.com';
        $admin_subject = '[Contact Form Copy] ' . $subject;
        
        $admin_message = "A new contact form submission has been received.\n\n";
        $admin_message .= "Name: " . $name . "\n";
        $admin_message .= "Email: " . $email . "\n";
        $admin_message .= "Subject: " . $subject . "\n";
        $admin_message .= "IP Address: " . $ip_address . "\n";
        $admin_message .= "Date/Time: " . date('Y-m-d H:i:s') . " UTC\n\n";
        $admin_message .= "Message:\n";
        $admin_message .= "----------------------------------------\n";
        $admin_message .= ($messageText ?: $emailBody) . "\n";
        $admin_message .= "----------------------------------------\n\n";
        $admin_message .= "View all submissions: https://undomains.com/admin/subscribers/\n\n";
        $admin_message .= "This is a copy of the contact form submission sent to your support department.";
        
        $headers = 'From: Undomains Contact Form <noreply@undomains.com>' . "\r\n";
        $headers .= 'Reply-To: ' . $email . "\r\n";
        
        @mail($admin_email, $admin_subject, $admin_message, $headers);
    }
});

// Alternative hook for ClientAreaPageContact to capture data before email is sent
add_hook('ClientAreaPageContact', 1, function($vars) {
    if (isset($_POST['action']) && $_POST['action'] == 'send' && isset($_POST['name'])) {
        // Store in session for EmailPreSend hook to use
        $_SESSION['contact_form_data'] = [
            'name' => $_POST['name'] ?? '',
            'email' => $_POST['email'] ?? '',
            'subject' => $_POST['subject'] ?? '',
            'message' => $_POST['message'] ?? '',
            'contactForm' => true
        ];
    }
    return $vars;
});
