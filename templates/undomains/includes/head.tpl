<!-- Styling -->

<!-- Mandatory Styling -->
{\WHMCS\View\Asset::fontCssInclude('open-sans-family.css')}
{\WHMCS\View\Asset::fontCssInclude('raleway-family.css')}
<link href="{assetPath file='all.min.css'}?v={$versionHash}" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/flickity.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/aos.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/style.min.css?v=3" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/main.min.css" rel="stylesheet">

<!-- Icons Styling -->
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-solid.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-regular.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-light.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-brands.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-duotone.min.css" rel="stylesheet">

<!-- Icons Styling -->
<link href="{$WEB_ROOT}/templates/{$template}/assets/fonts/fontawesome/css/all.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/fonts/evafeat/evafeat.css" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/fonts/cloudicon/cloudicon.css" rel="stylesheet">

<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
  <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->

<script type="text/javascript">
    var csrfToken = '{$token}',
        markdownGuide = '{lang|addslashes key="markdown.title"}',
        locale = '{if !empty($mdeLocale)}{$mdeLocale}{else}en{/if}',
        saved = '{lang|addslashes key="markdown.saved"}',
        saving = '{lang|addslashes key="markdown.saving"}',
        whmcsBaseUrl = "{\WHMCS\Utility\Environment\WebHelper::getBaseUrl()}";
      {if $captcha}{$captcha->getPageJs()}{/if}
</script>

<!-- Multilingual Condition to RTL & LTR Language -->
{if $language eq 'arabic' || $language eq 'farsi' || $language eq 'hebrew'}<html dir="rtl">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/auto-rtl/bootstrap-rtl.min.css?v={$versionHash}" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/auto-rtl/rtl.css?v={$versionHash}" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/auto-rtl/custom-rtl.css" rel="stylesheet">
<html>
{else}
<html dir="ltr">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/main.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/css/custom.css?v={$versionHash}" rel="stylesheet">
<html>
{/if}

{if $templatefile == "viewticket" && !$loggedin}
  <meta name="robots" content="noindex" />
{/if}

<script src="{assetPath file='scripts.min.js'}?v={$versionHash}"></script>
<script src="{$WEB_ROOT}/templates/{$template}/assets/js/typed.js"></script>
<script defer src="{$WEB_ROOT}/templates/{$template}/assets/js/jquery.slimscroll.min.js"></script>
<script defer src="{$WEB_ROOT}/templates/{$template}/assets/js/flickity.pkgd.min.js"></script>
<script defer src="{$WEB_ROOT}/templates/{$template}/assets/js/flickity-fade.min.js"></script>
<script defer src="{$WEB_ROOT}/templates/{$template}/assets/js/aos.min.js"></script>
<script defer src="{$WEB_ROOT}/templates/{$template}/assets/js/md5.min.js"></script>

<script defer src="{$WEB_ROOT}/templates/{$template}/assets/js/main.min.js"></script>
<script defer src="{$WEB_ROOT}/templates/{$template}/assets/js/scripts.min.js"></script>
<script defer src="{$WEB_ROOT}/templates/{$template}/assets/js/settings-init.js"></script>

<!-- Three.js for Hero Animation -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>

<!-- Fix Domain Checker Background Color (overrides JS-applied styles) -->
<script>
(function() {
    var styleEl = document.createElement('style');
    styleEl.id = 'domain-checker-override';
    styleEl.textContent = `
        .domain-checker-container.domain-checker-advanced,
        .domain-checker-container.domain-checker-advanced .domain-checker-bg {
            background-color: transparent !important;
            background-image: none !important;
            padding-top: 0 !important;
            padding-bottom: 0 !important;
            margin-top: 0 !important;
            margin-bottom: 0 !important;
        }
        [data-background="light"] .domain-checker-container.domain-checker-advanced,
        [data-background="light"] .domain-checker-container.domain-checker-advanced .domain-checker-bg {
            background-color: transparent !important;
            background-image: none !important;
            padding-top: 0 !important;
            padding-bottom: 0 !important;
            margin-top: 0 !important;
            margin-bottom: 0 !important;
        }
        .domain-checker-container.domain-checker-advanced .input-group.input-group-box {
            margin-left: 0 !important;
            background-color: transparent !important;
            background-image: none !important;
        }
        .domain-checker-container.domain-checker-advanced [class*="col-"] {
            padding-left: 0 !important;
            padding-right: 0 !important;
        }
        /* Remove backgrounds from domain pricing and cards */
        #order-standard_cart .domain-pricing,
        #order-standard_cart .domain-pricing .bg-white,
        #order-standard_cart .bg-white {
            background-color: transparent !important;
            background-image: none !important;
        }
    `;

    function insertStyle() {
        var existing = document.getElementById('domain-checker-override');
        if (existing) existing.remove();
        document.head.appendChild(styleEl);
    }

    // Run on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', insertStyle);
    } else {
        insertStyle();
    }

    // Run after page loads
    window.addEventListener('load', insertStyle);

    // Run periodically for first 3 seconds (no MutationObserver to avoid infinite loop)
    var count = 0;
    var interval = setInterval(function() {
        insertStyle();
        if (++count >= 30) clearInterval(interval);
    }, 100);
})();
</script>