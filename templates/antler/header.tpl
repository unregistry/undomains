<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="{$charset}" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" href="{$WEB_ROOT}/templates/{$template}/assets/img/favicon.ico">
    <title>{if $kbarticle.title}{$kbarticle.title} - {/if}{$pagetitle} - {$companyname}</title>
    {include file="$template/includes/head.tpl"} 
	{$headoutput}
    </head>
    <body data-phone-cc-input="{$phoneNumberInputStyle}">
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
                    <div class="spinner-txt">Antler...</div>
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
                <!-- BANNER -->
                <div class="top-header item17 overlay">
                    <div class="container">
                      <div class="row">
                        <div class="col-sm-12 col-md-12">
                          <div class="wrapper">
                            <h1 class="heading">Antler WHMCS Template</h1>
                            <h3 class="subheading">Best Hosting Provider with Support Premium 24/7/365.</h3>
                          </div>
                        </div>
                      </div>
                    </div>
                </div>
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