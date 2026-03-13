<!DOCTYPE html>
<html lang="en">
    <head>
    <style>
        /* Prevent flash of wrong theme - hide content until theme is set */
        html { visibility: hidden; }
        html[data-background] { visibility: visible; }
    </style>
    <script>
        // Apply saved theme immediately to prevent flash
        (function() {
            // Try cookie first, then localStorage, default to dark
            var bg = document.cookie.match(/(?:^|;)\s*background=([^;]*)/);
            if (!bg || !bg[1]) {
                // Fallback to localStorage if cookie not found
                try {
                    var stored = localStorage.getItem('undomains_theme');
                    if (stored) {
                        bg = [null, stored];
                    }
                } catch(e) {}
            }
            var theme = (bg && bg[1]) ? bg[1] : 'dark';
            document.documentElement.setAttribute('data-background', theme);
        })();
    </script>
    <meta charset="{$charset}" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" type="image/png" href="{$WEB_ROOT}/templates/{$template}/assets/img/favicon.png">
    <title>{if $kbarticle.title}{$kbarticle.title} - {/if}{$pagetitle} - {$companyname}</title>
    {include file="$template/includes/head.tpl"}
	{$headoutput}
    </head>
    <body data-phone-cc-input="{$phoneNumberInputStyle}">
    <script>
        // Also apply to body immediately
        (function() {
            var bg = document.cookie.match(/(?:^|;)\s*background=([^;]*)/);
            if (bg) {
                document.body.setAttribute('data-background', bg[1]);
            }
        })();
    </script>
        <div class="box-container limit-width">
            <div class="bg-colorstyle">
                {if $captcha}{$captcha->getMarkup()}{/if}
                {$headeroutput}
                {include file="$template/assets/layout/settings.tpl"}
                              
            	<!-- ***** LOADING PAGE ****** -->
                <div id="spinner-area">
                  <div class="spinner">
                    <div class="double-bounce1"></div>
                    <div class="double-bounce2"></div>
                    <div class="spinner-txt">Undomains...</div>
                  </div>
                </div>
                <!-- ***** FRAME MODE ****** -->
                <div class="body-borders" data-border="20">
                  <div class="top-border bg-white"></div>
                  <div class="right-border bg-white"></div>
                  <div class="bottom-border bg-white"></div>
                  <div class="left-border bg-white"></div>
                </div>
            	{if $loginpage eq 0 and $templatefile ne "clientregister"}<!-- login and register page without the default header and footer -->
                <header id="header" class="header navbar-expand-lg navbar-light">
                {include file="$template/assets/layout/sections/menu.tpl"}<!-- the main header -->
                </header>
            	{if $templatefile == 'homepage'}
                <!-- Section Slider -->
            	{include file="$template/assets/layout/sections/slider.tpl"}
                {if $templatefile == 'homepage'}
                <!-- Section Plans -->
                {include file="$template/assets/layout/sections/plans.tpl"}
                <!-- Section Features -->
                {include file="$template/assets/layout/sections/features.tpl"}
                {/if}
                {else}
                <!-- BANNER REMOVED -->
                {/if} <!-- Container for HOMEPAGE display content -->
                <div class="wrapper sec-normal">
                    <div class="content bg-colorstyle noshadow nopadding">
                        <div class="inner-content">
                            <div class="main-body">
                             <div class="page-wrapper">
                                {include file="$template/includes/validateuser.tpl"}			
                                <section id="{if $templatefile == 'homepage'} {else}main-body{/if}">
                                    <div class="container">
                                        <div class="main-content {if $skipMainBodyContainer}-fluid without-padding{/if}">
                                            <div class="row">
                                                {if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())} {if $primarySidebar->hasChildren() && !$skipMainBodyContainer}
                                                <div class="col-md-12">
                                                    {include file="$template/includes/pageheader.tpl" title=$displayTitle desc=$tagline showbreadcrumb=true}
                                                </div>
                                                {/if} 
            									{/if}<!-- Container for MAIN PAGE display content -->
                                                <div class="{if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}col-md-12 {else}col-xs-12{/if}">
                                                    {if !$primarySidebar->hasChildren() && !$showingLoginPage && !$inShoppingCart && $templatefile != 'homepage' && !$skipMainBodyContainer}
            										{include file="$template/includes/pageheader.tpl" title=$displayTitle desc=$tagline showbreadcrumb=false}
            										{/if} 
            										{/if}<!-- login and register page without the default header and footer -->