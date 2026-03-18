<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="{$charset}">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="referrer" content="same-origin">

    <title>Undomains - {$pagetitle}</title>

    <link rel="icon" type="image/png" href="templates/{$template}/images/favicon.png" />

    {\WHMCS\View\Asset::fontCssInclude('open-sans-family.css')}
    <link href="templates/{$template}/css/all.min.css?v={$versionHash}" rel="stylesheet" />
    <link href="templates/{$template}/css/theme.min.css?v={$versionHash}" rel="stylesheet" />
    <style>
        @media only screen and (max-width: 949px) {
            .sidebar-opener,
            .sidebar-opener.minimized {
                display: none !important;
            }
            .sidebar-opener-mobile,
            .sidebar-opener-mobile.minimized {
                display: block !important;
                position: fixed !important;
                bottom: 10px !important;
                left: 10px !important;
                z-index: 9999 !important;
                font-size: 0 !important;
                width: 40px !important;
                height: 40px !important;
                line-height: 40px !important;
                text-align: center !important;
                background: transparent !important;
                border: none !important;
                padding: 0 !important;
                margin: 0 !important;
            }
            .sidebar-opener-mobile::before {
                content: "⋮";
                font-size: 28px;
                color: #cc9933 !important;
            }
            .sidebar-opener-mobile:hover::before {
                color: #ffffff !important;
            }
        }
        @media only screen and (min-width: 950px) {
            .sidebar-opener-mobile {
                display: none !important;
            }
        }
    </style>
    <link href="templates/{$template}/css/undomains-theme.css?v={$versionHash}" rel="stylesheet" />
    <link href="templates/{$template}/css/theme-toggle.css?v={$versionHash}" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-solid.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-regular.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-light.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-brands.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-duotone.min.css" rel="stylesheet" />
    <script type="text/javascript" src="templates/{$template}/js/vendor.min.js?v={$versionHash}"></script>
    <script type="text/javascript" src="templates/{$template}/js/scripts.min.js?v={$versionHash}"></script>
    <script>
        // Initialize theme before page renders
        (function() {
            try {
                var theme = localStorage.getItem('undomains_admin_theme');
                if (theme === 'dark') {
                    document.documentElement.setAttribute('data-theme', 'dark');
                }
            } catch(e) {}
        })();
    </script>
    <script>
        var datepickerformat = "{$datepickerformat}",
            csrfToken="{$csrfToken}",
            adminBaseRoutePath = "{\WHMCS\Admin\AdminServiceProvider::getAdminRouteBase()}",
            whmcsBaseUrl = "{\WHMCS\Utility\Environment\WebHelper::getBaseUrl()}";

        {if $jquerycode}
            $(document).ready(function(){ldelim}
                {$jquerycode}
            {rdelim});
        {/if}
        {if $jscode}
            {$jscode}
        {/if}
    </script>

    {$headoutput}

</head>
<body class="{if empty($sidebar)}no-sidebar{/if}{if !empty($globalAdminWarningMsg)} has-warning-banner{/if}" data-phone-cc-input="{if !empty($phoneNumberInputStyle)}{$phoneNumberInputStyle}{/if}">

    {$headeroutput}

    <div class="alert alert-warning global-admin-warning">
        <i class="far fa-exclamation-triangle fa-fw"></i>
        {$globalAdminWarningMsg}
    </div>

    <div class="navigation">
        {include file="$template/nav.tpl"}
    </div>

    <div class="sidebar{if $minsidebar} minimized{/if}" id="sidebar">
        <a href="#" class="sidebar-close-mobile" id="sidebarClose" style="display: none;">
            <i class="fa fa-times"></i>
        </a>
        <div class="sidebar-collapse-expand" id="sidebarCollapseExpand">
            <i class="fas fa-chevron-down"></i>
        </div>
        <div class="sidebar-collapse">
            {include file="$template/sidebar.tpl"}
        </div>
    </div>
    <div class="sidebar-overlay" id="sidebarOverlay"></div>
    <a href="#" class="sidebar-opener{if $minsidebar} minimized{/if}" id="sidebarOpener">
        {$_ADMINLANG.openSidebar}
    </a>

    <div class="{$contentAreaClasses}" id="contentarea">
        <div style="width:100%;">
            {if !$isCustomHeader}
                <h1{if $pagetitle == $_ADMINLANG.global.hometitle} class="pull-left"{/if}>{$pagetitle}</h1>
            {/if}
