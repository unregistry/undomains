<!-- Styling -->

<!-- Mandatory Styling -->
{\WHMCS\View\Asset::fontCssInclude('open-sans-family.css')}
{\WHMCS\View\Asset::fontCssInclude('raleway-family.css')}
<link href="{assetPath file='all.min.css'}?v={$versionHash}" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/flickity.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/aos.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/assets/css/style.min.css" rel="stylesheet">
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
{assetExists file="custom.css"}
<link href="{$__assetPath__}" rel="stylesheet">
{/assetExists}
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