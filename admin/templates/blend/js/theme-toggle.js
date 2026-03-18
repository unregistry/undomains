/**
 * Undomains Admin Theme - Dark/Light Mode Toggle
 * Handles theme switching and persistence
 */

(function() {
    'use strict';

    // Theme configuration
    const THEME_KEY = 'undomains_admin_theme';
    const THEMES = {
        LIGHT: 'light',
        DARK: 'dark'
    };

    /**
     * Get current theme from localStorage or default to light
     */
    function getCurrentTheme() {
        try {
            return localStorage.getItem(THEME_KEY) || THEMES.LIGHT;
        } catch (e) {
            return THEMES.LIGHT;
        }
    }

    /**
     * Set theme in localStorage and apply to document
     */
    function setTheme(theme) {
        try {
            localStorage.setItem(THEME_KEY, theme);
        } catch (e) {
            console.warn('Could not save theme preference:', e);
        }
        applyTheme(theme);
    }

    /**
     * Apply theme to document
     */
    function applyTheme(theme) {
        if (theme === THEMES.DARK) {
            document.documentElement.setAttribute('data-theme', 'dark');
        } else {
            document.documentElement.removeAttribute('data-theme');
        }
        updateToggleButton(theme);
    }

    /**
     * Toggle between light and dark themes
     */
    function toggleTheme() {
        const currentTheme = getCurrentTheme();
        const newTheme = currentTheme === THEMES.DARK ? THEMES.LIGHT : THEMES.DARK;
        setTheme(newTheme);
    }

    /**
     * Update the toggle button appearance
     */
    function updateToggleButton(theme) {
        // Update navbar theme icon (in left-nav)
        const navIcon = document.getElementById('nav-theme-icon');
        if (navIcon) {
            if (theme === THEMES.DARK) {
                navIcon.className = 'fas fa-sun';
                navIcon.parentElement.setAttribute('title', 'Switch to Light Mode');
            } else {
                navIcon.className = 'fas fa-moon';
                navIcon.parentElement.setAttribute('title', 'Switch to Dark Mode');
            }
        }
        
        // Update mobile toggle for custom pages (icon only, in left-nav)
        const mobileIcon = document.getElementById('mobile-theme-icon');
        if (mobileIcon) {
            if (theme === THEMES.DARK) {
                mobileIcon.className = 'fas fa-sun';
                mobileIcon.parentElement.setAttribute('title', 'Switch to Light Mode');
            } else {
                mobileIcon.className = 'fas fa-moon';
                mobileIcon.parentElement.setAttribute('title', 'Switch to Dark Mode');
            }
        }
    }

    /**
     * Initialize theme on page load
     */
    function init() {
        // Apply saved theme immediately
        const savedTheme = getCurrentTheme();
        applyTheme(savedTheme);

        // Update any existing toggle buttons to match current theme
        updateToggleButton(savedTheme);
    }

    // Initialize
    init();

    // Expose API for external use
    window.UndoTheme = {
        getTheme: getCurrentTheme,
        setTheme: setTheme,
        toggle: toggleTheme,
        THEMES: THEMES
    };
})();
