<?php
/**
 * WHMCS Hook: Custom Maintenance Page
 * Displays a branded maintenance template matching the undomains theme
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

add_hook('ClientAreaPage', 1, function($vars) {
    // Check if maintenance mode is enabled
    if (isset($vars['maintenanceMode']) && $vars['maintenanceMode']) {
        // Get maintenance message from database or use default
        $maintenanceMessage = isset($vars['maintenanceModeMessage']) && !empty($vars['maintenanceModeMessage'])
            ? $vars['maintenanceModeMessage']
            : 'We are currently performing maintenance and will be back shortly.';

        // Return custom template with maintenance message
        return array(
            'templatefile' => 'maintenance',
            'maintenanceMessage' => $maintenanceMessage
        );
    }
});
