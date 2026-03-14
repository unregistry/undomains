<!-- ***** HEADER NEWS ***** -->
<div class="sec-bg3 infonews">
  <div class="container-fluid">
    <div class="row">
      <div class="col-xs-6 col-md-6 news">
      {if $loggedin}
        <div>
            <span class="badge bg-purple me-2">welcome</span>
            <span> Check all about your Account Details. </span>
            <span class="secnav">{include file="$template/assets/layout/secnavbar.tpl" navbar=$secondaryNavbar}</span>
        </div>
        {else}
        <div>
            <span class="badge bg-purple me-2">news</span>
            <span> 2026 gTLD Round Opens April 30th &rarr; </span>
            <span class="secnav"> <a class="c-yellow" href="https://www.onl" target="_blank">Get Your TLD <i class="fas fa-arrow-circle-right"></i></a></span>
        </div>
        {/if}
      </div>
      <div class="col-xs-6 col-md-6 link">
        <div class="infonews-nav float-right">
          <!-- Theme Toggle -->
          <button class="iconews theme-toggle-btn" id="theme-toggle" title="Toggle Dark/Light Mode">
              <i class="fas fa-sun theme-icon-light"></i>
              <i class="fas fa-moon theme-icon-dark"></i>
          </button>
          {include file="$template/assets/layout/notifications.tpl"}
          <a href="{$WEB_ROOT}/cart" class="iconews"><i class="ico-shopping-cart f-18 w-icon"></i></a>
          {if $adminMasqueradingAsClient || $adminLoggedIn}
          {include file="$template/assets/layout/adminlogin.tpl"}
          {/if}
          {include file="$template/assets/layout/login.tpl"}
          {* <a href="tel:1300-656-1046" class="iconews tabphone">+ (123) 1300-656-1046</a> *}
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ***** HEADER NAV ***** -->
<div class="menu-wrap">
  <div class="nav-menu">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-md-2">
          <a href="{$WEB_ROOT}/">
            <img class="logo-menu logo-dark img-fluid d-block" src="{$WEB_ROOT}/templates/{$template}/assets/img/undomains-logo-dark.png" alt="{$companyname}" style="height: 40px; width: auto;">
            <img class="logo-menu logo-light img-fluid d-none" src="{$WEB_ROOT}/templates/{$template}/assets/img/undomains-logo-light.png" alt="{$companyname}" style="height: 40px; width: auto;">
          </a>
        </div>
        <nav id="menu" class="col-md-10">
          <div class="navigation float-right">
            <button class="menu-toggle">
            <span class="icon"></span>
            <span class="icon"></span>
            <span class="icon"></span>
            </button>
            <ul class="main-menu nav navbar-nav navbar-right">
              <!-- ***** WHMCS Primary Navbar ***** -->
              {if $loggedin}
              <div id="primaryNavbar" class="desk nav navbar-nav ml-auto">
                  {include file="$template/includes/navbar.tpl" navbar=$primaryNavbar}
              </div>
              {/if}

              {if $loggedin}
              <a class="pe-0 me-0" href="{$WEB_ROOT}/logout.php">
                <div class="btn btn-default-yellow-fill question">
                  <span class"uppercase">{$LANG.clientareanavlogout}</span>
                  <i class="fas fa-lock ps-1"></i>
                </div>
              </a>
              {else}
              <a class="pe-0 me-0" href="{$WEB_ROOT}/clientarea.php">
                <div class="btn btn-default-yellow-fill question">
                  <span class"uppercase">{$LANG.clientlogin}</span>
                  <i class="fas fa-lock ps-1"></i>
                </div>
              </a>
              {/if}

            </ul>
          </div>
        </nav>
      </div>
    </div>
  </div>
</div>

<!-- ***** NAV MENU MOBILE ****** -->
<div id="menu-mobile" class="menu-wrap mobile">
  <div class="container">
    <div class="row align-items-center">
      <div class="col-xs-6 col-md-6">
        <a href="{$WEB_ROOT}/">
          <img class="logo-menu logo-dark img-fluid d-block" src="{$WEB_ROOT}/templates/{$template}/assets/img/undomains-logo-dark.png" alt="{$companyname}" style="height: 35px; width: auto;">
          <img class="logo-menu logo-light img-fluid d-none" src="{$WEB_ROOT}/templates/{$template}/assets/img/undomains-logo-light.png" alt="{$companyname}" style="height: 35px; width: auto;">
        </a>
      </div>
      <div class="col-xs-6 col-md-6">
        <nav class="nav-menu float-right">
          <button id="nav-toggle" class="menu-toggle">
            <span class="icon"></span>
            <span class="icon"></span>
            <span class="icon"></span>
          </button>
          <div class="main-menu nav navbar-nav bg-seccolorstyle">
            {if $loggedin}
            <div class="menu-item dropdown">
              <a href="#" class="mergecolor dropdown-toggle" data-toggle="dropdown">{$LANG.navbilling}</a>
              <div class="dropdown-menu">
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=invoices">{$LANG.invoices}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=quotes">{$LANG.quotestitle}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=masspay&all=true">{$LANG.masspaytitle}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/account/paymentmethods">{$LANG.paymentMethods.title}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=services">{$LANG.clientareanavservices}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=domains">{$LANG.clientareanavdomains}</a>
              </div>
            </div>
            {/if}
            <div class="menu-item dropdown menu-last">
              <a href="#" class="mergecolor dropdown-toggle" data-toggle="dropdown">Support</a>
              <div class="dropdown-menu">
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/knowledgebase">Knowledgebase</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/announcements">Announcements</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/contact">Contact Us</a>
                {if $loggedin}
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/support">{$LANG.navopenticket}</a>
                {/if}
              </div>
            </div>
            <div>
              <a href="{$WEB_ROOT}/login"><div class="btn btn-default-yellow-fill mt-3">CLIENT AREA</div></a>
            </div>
          </div>
        </nav>
      </div>
    </div>
  </div>
</div>

<!-- Theme Toggle Styles & Script -->
<style>
.theme-toggle-btn {
    background: transparent;
    border: none;
    cursor: pointer;
    padding: 0;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}
/* Icons inherit color from .iconews parent - same as other icons */
.theme-toggle-btn .theme-icon-light,
.theme-toggle-btn .theme-icon-dark {
    display: none;
    font-size: 18px;
    /* Color inherited from .iconews - handled by line 219-220 */
}

/* Default state - show sun icon (dark mode is default) */
.theme-toggle-btn .theme-icon-light {
    display: inline-block;
}

/* Light mode - show moon icon, hide sun icon */
.theme-toggle-btn[data-theme="light"] .theme-icon-light {
    display: none !important;
}
.theme-toggle-btn[data-theme="light"] .theme-icon-dark {
    display: inline-block !important;
}

/* Dark mode - show sun icon, hide moon icon */
.theme-toggle-btn[data-theme="dark"] .theme-icon-light {
    display: inline-block !important;
    color: #fff !important;
}
.theme-toggle-btn[data-theme="dark"] .theme-icon-dark {
    display: none !important;
}

/* Logo Switching - Same logic as footer */
/* Default (dark mode): show dark logo, hide light logo */
.logo-menu.logo-dark {
    display: block !important;
}
.logo-menu.logo-light {
    display: none !important;
}

/* Light mode: hide dark logo, show light logo */
[data-background="light"] .logo-menu.logo-dark {
    display: none !important;
}
[data-background="light"] .logo-menu.logo-light {
    display: block !important;
}

/* Light Theme Overrides - LIGHT backgrounds, BLACK icons */
[data-background="light"] .sec-bg3.infonews {
}
[data-background="light"] .infonews .badge {
    background-color: #D4AF37 !important;
}
[data-background="light"] .infonews span {
    color: #333 !important;
}
[data-background="light"] .infonews .c-yellow {
    color: #000 !important;
}
[data-background="light"] .iconews {
    color: #333 !important;
}
[data-background="light"] .iconews:hover {
    color: #D4AF37 !important;
}
[data-background="light"] .menu-wrap {
}
[data-background="light"] .nav-menu .main-menu a {
    color: #333 !important;
}
[data-background="light"] .menu-toggle span {
    background-color: #333 !important;
}
[data-background="light"] .btn-default-yellow-fill {
    background-color: #D4AF37 !important;
    color: #000 !important;
}
[data-background="light"] .main-menu.nav {
    background-color: #fff !important;
}
[data-background="light"] .dropdown-menu {
    background-color: #fff !important;
    border-color: #D4AF37 !important;
}
[data-background="light"] .dropdown-item {
    color: #333 !important;
}
[data-background="light"] .dropdown-item:hover {
    background-color: #D4AF37 !important;
    color: #000 !important;
}
[data-background="light"] .mergecolor {
    color: #333 !important;
}
[data-background="light"] .tech-box svg path {
    fill: #D4AF37 !important;
}

/* Remove horizontal padding from mobile menu container */
#menu-mobile .container {
    padding-left: 0;
    padding-right: 0;
}
</style>

<script>
(function() {
    // Get saved theme from localStorage or cookie, default to dark
    let currentTheme = localStorage.getItem('undomains_theme');
    if (!currentTheme) {
        // Try cookie fallback
        var bg = document.cookie.match(/(?:^|;)\s*background=([^;]*)/);
        currentTheme = (bg && bg[1]) ? bg[1] : 'dark';
    }

    function applyTheme(theme) {
        // Update HTML element (for CSS selectors)
        document.documentElement.setAttribute('data-background', theme);
        // Always apply to body (for backward compatibility with scripts.js)
        document.body.setAttribute('data-background', theme);
        // Also apply to box-container if it exists
        const boxContainer = document.querySelector('.box-container');
        if (boxContainer) {
            boxContainer.setAttribute('data-background', theme);
        }
        // Apply theme directly to toggle button for icon switching
        const themeToggle = document.getElementById('theme-toggle');
        if (themeToggle) {
            themeToggle.setAttribute('data-theme', theme);
        }
    }

    // Apply theme immediately
    applyTheme(currentTheme);

    // Set up toggle button listener (if button exists)
    const themeToggle = document.getElementById('theme-toggle');
    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            currentTheme = currentTheme === 'dark' ? 'light' : 'dark';
            applyTheme(currentTheme);
            localStorage.setItem('undomains_theme', currentTheme);
            // Also save to cookie for scripts.js and header.tpl compatibility
            document.cookie = 'background=' + currentTheme + ';path=/;max-age=' + (365 * 24 * 60 * 60);
        });
    }
})();
</script>
