<link href="{assetPath file='store.css'}" rel="stylesheet">

<div class="landing-page sitelockvpn">

    <div class="hero bg-seccolorstyle bg-white p-80">
        <div class="container">
            <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/header-img.png" class="hidden-md hidden-lg">
            <h1 class="mergecolor c-black">{lang key='store.sitelockvpn.subtitle1'} {lang key='store.sitelockvpn.subtitle2'}</h1>
            <h2 class="mergecolor c-black mb-5">{lang key='store.sitelockvpn.tagline1'} {lang key='store.sitelockvpn.tagline2'}</h2>
            <a href="#plans" class="btn btn-default-yellow-fill">{lang key='store.sitelockvpn.getStarted'}</a>
        </div>
    </div>

    <div class="feature">
        <div class="container">
            <div class="row">
                <div class="col-md-4 text-center">
                    <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/feature-icon-01.png">
                </div>
                <div class="col-sm-8 lh-lg">
                    <h3 class="mergecolor">{lang key='store.sitelockvpn.feature1.title'}</h3>
                    <p class="mergecolor">{lang key='store.sitelockvpn.feature1.subtitle'}</p>
                    <div class="row mergecolor">
                        <div class="col-md-6"
                            <ul class="highlights">
                                <li>{lang key='store.sitelockvpn.feature1.highlights.one'}</li>
                                <li>{lang key='store.sitelockvpn.feature1.highlights.two'}</li>
                                <li>{lang key='store.sitelockvpn.feature1.highlights.three'}</li>
                            </ul>
                        </div>
                        <div class="col-md-6"
                            <ul class="highlights">
                                <li>{lang key='store.sitelockvpn.feature1.highlights.four'}</li>
                                <li>{lang key='store.sitelockvpn.feature1.highlights.five'}</li>
                                <li>{lang key='store.sitelockvpn.feature1.highlights.six'}</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="feature">
        <div class="container">
            <div class="row">
                <div class="col-sm-4 text-center">
                    <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/feature-icon-02.png">
                </div>
                <div class="col-sm-8 lh-lg">
                    <h3 class="mergecolor">{lang key='store.sitelockvpn.feature2.title'}</h3>
                    <p class="mergecolor">{lang key='store.sitelockvpn.feature2.subtitle'}</p>

                    <div class="row mergecolor">
                        <div class="col-md-6"
                            <ul class="highlights">
                                <li>{lang key='store.sitelockvpn.feature2.highlights.one'}</li>
                                <li>{lang key='store.sitelockvpn.feature2.highlights.two'}</li>
                                <li>{lang key='store.sitelockvpn.feature2.highlights.three'}</li>
                            </ul>
                        </div>
                        <div class="col-md-6"
                            <ul class="highlights">
                                <li>{lang key='store.sitelockvpn.feature2.highlights.four'}</li>
                                <li>{lang key='store.sitelockvpn.feature2.highlights.five'}</li>
                                <li>{lang key='store.sitelockvpn.feature2.highlights.six'}</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="feature">
        <div class="container">
            <div class="row">
                <div class="col-sm-4 text-center">
                    <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/feature-icon-03.png">
                </div>
                <div class="col-sm-8">
                    <h3 class="mergecolor">{lang key='store.sitelockvpn.feature3.title'}</h3>
                    <p class="mergecolor">{lang key='store.sitelockvpn.feature3.subtitle'}</p>
                    <p class="mergecolor">{lang key='store.sitelockvpn.feature3.subtitle2'}</p>
                    <div class="row mergecolor">
                        <div class="col-md-3">
                            <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/logo-ios.png">
                        </div>
                        <div class="col-md-3">
                            <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/logo-apple.png">
                        </div>
                        <div class="col-md-3">
                            <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/logo-windows.png">
                        </div>
                        <div class="col-md-3">
                            <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/logo-android.png">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <a name="plans"></a>
    <div class="feature pricing sec-main bg-colorstyle bg-white noshadow mt-80 mb-80 p-50">
        <div class="col-md-12 text-center">
            <h2 class="section-heading c-black mergecolor">{lang key='store.sitelockvpn.pricing.oneSubscription'}</h2>
            <p class="section-subheading whitecolor mergecolor mt-0">{lang key='store.sitelockvpn.pricing.fiveDevices'}</p>
        </div>

        {if !$loggedin && $currencies}
            <div class="row">
                <div class="col-md-3 col-md-offset-9">
                    <form method="post" action="">
                        <select name="currency" class="form-control currency-selector" onchange="submit()">
                            <option>{lang key="changeCurrency"} ({$activeCurrency.prefix} {$activeCurrency.code})</option>
                            {foreach $currencies as $currency}
                                <option value="{$currency['id']}">{$currency['prefix']} {$currency['code']}</option>
                            {/foreach}
                        </select>
                    </form>
                </div>
            </div>
        {/if}
        <div class="row">
            {foreach $plans as $plan}
                {foreach $plan->pricing()->allAvailableCycles() as $pricing}
                    <div class="{if $pricing@total == 1}col-sm-4 col-sm-offset-4{elseif $pricing@total == 2}col-sm-6{elseif $pricing@total == 2}col-sm-6{elseif $pricing@total == 3}col-md-4 col-sm-4{elseif $pricing@total == 4}col-lg-3 col-sm-6{elseif $pricing@total == 5}col-md-4 col-sm-6{else}col-lg-3 col-sm-4{/if}">
                        <div class="pricing-box bg-seccolorstyle bg-pratalight mergecolor br-12 c-black">
                            <div class="cycle border-top-12">
                                {if $pricing->isYearly()}
                                    {$pricing->cycleInYears()}
                                {else}
                                    {$pricing->cycleInMonths()}
                                {/if}
                                {if $pricing->calculatePercentageDifference($highestMonthlyPrice) > 0}
                                    <span class="label label-info c-black">
                                        {lang key='store.save' saving=$pricing->calculatePercentageDifference($highestMonthlyPrice)}
                                    </span>
                                {/if}
                            </div>
                            <div class="price c-black mergecolor">
                                {$pricing->toPrefixedString()}
                            </div>
                            <ul class="px-5">
                                {foreach $plan->planFeatures as $langKey => $feature}
                                    <li>
                                        {lang key="store.sitelockvpn.pricing.features.$langKey"}
                                    </li>
                                {/foreach}
                            </ul>
                            <div class="signup p-5">
                                <form method="post" action="{routePath('cart-order')}">
                                    <input type="hidden" name="pid" value="{$plan->id}">
                                    <input type="hidden" name="billingcycle" value="{$pricing->cycle()}">
                                    <button type="submit" class="btn btn-default-yellow-fill br-50 btn-block btn-signup{if $pricing@iteration == ($pricing@total - 1)} highlight1{elseif $pricing@iteration == $pricing@total} highlight2{/if}">
                                        {lang key="signup"}
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                {/foreach}
            {/foreach}
        </div>
    </div>

    <div class="feature all-plans bg-seccolorstyle bg-white p-80 br-12 mergecolor">
        <div class="container">

            <div class="col-md-12 text-center">
                <h2 class="section-heading c-black mergecolor">{lang key='store.sitelockvpn.plans.features.allInclude'}</h2>
            </div>

            <div class="row">
                <div class="col-sm-6 col-md-4 text-left mt-50">
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png"> 
                        {lang key='store.sitelockvpn.plans.features.noRestrictions'}
                    </span>
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.highSpeed'}
                    </span>
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.unlimited'}
                    </span>
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.encryption'}
                    </span>
                    
                </div>
                <div class="col-sm-6 col-md-4 text-left mt-50">
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.protocol'}
                    </span>
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.simultaneous'}
                    </span>
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.apps'}
                    </span>
                </div>
                <div class="col-sm-6 col-md-4 text-left mt-50">
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.switching'}
                    </span>
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.countries'}
                    </span>
                </div>
                <div class="col-sm-6 col-md-4 text-left">
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.servers'}
                    </span>
                    <span>
                        <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/icon-ok.png">
                        {lang key='store.sitelockvpn.plans.features.support'}
                    </span>
                </div>
            </div>
        </div>
    </div>

    <div class="feature world">
        <div class="container">
            <div class="col-md-12 text-center mb-50">
                <h2 class="section-heading c-black mergecolor">{lang key='store.sitelockvpn.world.features.title'}</h2>
                <p class="section-subheading d-inline-flex mt-0 f-12">
                    <span class="mergecolor c-black mr-30">{lang key='store.sitelockvpn.world.features.servers'}: 1000+</span>
                    <span class="mergecolor c-black mr-30">{lang key='store.sitelockvpn.world.features.countries'}: 40+</span>
                    <span class="mergecolor c-black">{lang key='store.sitelockvpn.world.features.bandwidth'}: {lang key='store.sitelockvpn.world.features.unlimited'}</span>
                </p>
            </div>

            <div class="row">
                <div class="col-md-12 text-center">
                    <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/world-map.png">
                </div>
            </div>
        </div>
    </div>

    <div class="feature countries bg-seccolorstyle bg-white p-50 br-12">
        <div class="container text-center">
            <img src="{$WEB_ROOT}/assets/img/marketconnect/sitelockvpn/flags.png">
        </div>
    </div>

</div>
