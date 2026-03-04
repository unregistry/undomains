<!-- Slider Section -->
<div class="main-container slider">
    <div class="silder-container">
        <div class="carousel header-main-slider">
            <!-- 1 Slider -->
            <div class="carousel-cell overlay">
                <div class="slider-content">
                    <div class="container">
                        <img class="svg custom-element-right" src="{$WEB_ROOT}/templates/{$template}/assets/patterns/domainmanage.svg" alt="Domains">

                        <div class="col-sm-12 col-md-6 px-0">
                                <h1 data-aos="fade-up" data-aos-duration="800">{$LANG.findyourdomain}</h1>
                                <p data-aos="fade-up" data-aos-duration="1200">{$LANG.domainintrotext}</p>
                                <form class="domains-search" method="post" action="domainchecker.php" id="frmDomainHomepage">
                                    {if $showAdvancedSearchOptions}
                                        <textarea name="message"
                                                  id="message"
                                                  title="{lang key='domainSearch.domainOrAiPrompt'}"
                                                  data-placement="left"
                                                  data-trigger="manual"
                                                  placeholder="{lang key='domainSearch.domainOrAiInstruction'}"></textarea>
                                    {else}
                                        <input type="text" class="inputdomainsearch special-input form-control" name="domain" placeholder="{$LANG.exampledomain}" autocapitalize="none" data-toggle="tooltip" data-placement="left" data-trigger="manual" title="{lang key='orderForm.required'}" />
                                    {/if}

                                    <span class="ds-content">
                                        <input type="submit" class="btn btn-default-yellow-fill border-end-0 search initial-transform" value="Search">
                                        <button data-toggle="tooltip" data-placement="bottom" title="{$LANG.domainstransfer}" type="submit" name="transfer" class="btn btn-default-fill border-start-0 initial-transform ml-4" value="{$LANG.domainstransfer}"><i class="fa-solid fa-repeat"></i></button>
                                    </span>

                                    {if $showAdvancedSearchOptions}
                                        <span class="input-group input-group-lg{if $showAdvancedSearchOptions} advanced-input{/if}">
                                            <select name="tlds[]" class="multiselect multiselect-filter" multiple="multiple" data-placeholder="{lang key='domainSearch.tlds'}" data-min-selection="1">
                                                {foreach $tlds as $tld}
                                                    <option{if in_array($tld, $selectedTlds)} selected {if count($selectedTlds) <= 1}disabled="disabled"{/if}{/if} value="{$tld}">{$tld}</option>
                                                {/foreach}
                                            </select>
                                            <select name="maxLength" class="multiselect" data-placeholder="{lang key='domainSearch.maxLength'}">
                                                {foreach $searchLengths as $len}
                                                    <option value="{$len}" {if $maxLength === $len}selected{/if}>{$len}</option>
                                                {/foreach}
                                            </select>
                                            <label>
                                                <input type="checkbox" class="no-icheck" name="filter" {if $safeSearchSelected}checked{/if}> {lang key="domainSearch.safeSearch"}
                                            </label>
                                        </span>
                                    {/if}

                                </form>
                            <div class="special-note"><span class="text">Search a domain of your choise from <b>$6.00/yr</b></span></div>
                        </div>

                    </div>
                </div>
                <div class="silder-video">
                    <div class="cover-wrapper">
                        <video class="cover-video" autoplay loop muted>
                            <source src="{$WEB_ROOT}/templates/{$template}/assets/videos/planet.mp4" type="video/mp4">
                        </video>
                    </div>
                </div>
            </div>
            <!-- 2 Slider -->
            <div class="carousel-cell overlay">
                <div class="slider-content">
                    <div class="container ">
                        <img class="svg custom-element-right" src="{$WEB_ROOT}/templates/{$template}/assets/patterns/api.svg" alt="Dedicated Server">
                        <div class="col-sm-12 col-md-6 px-0">
                            <h1 data-aos="fade-up" data-aos-duration="800">Dedicated <br>Server with <br> <span id="typed1"></span></h1>
                            <p class="text-break" data-aos="fade-up" data-aos-duration="1200">{$LANG.cartnameserversdesc}</p>
                            <a href="{$WEB_ROOT}/store/dedicated-server" class="btn btn-default-yellow-fill me-2">{$LANG.ordernowbutton} <i class="fas fa-cart-plus ps-1 f-15"></i></a>
                            <a href="{$WEB_ROOT}/store/dedicated-server" class="btn btn-default-pink-fill">{$LANG.learnmore}</a>
                        </div>
                    </div>
                </div>
                <div class="carousel full-slider">
                    <img src="{$WEB_ROOT}/templates/{$template}/assets/img/topbanner01.jpg" alt="Web Hosting"/>
                </div>
            </div>
            
            <!-- 3 Slider -->
            <div class="carousel-cell sec-bg6 bg-colorstyle">
                <div class="slider-content">
                    <div class="container ">
                        <img class="svg custom-element-right" src="{$WEB_ROOT}/templates/{$template}/assets/patterns/rack.svg" alt="Hosting Package">
                        <div class="col-sm-12 col-md-6 px-0">
                            <h1 class="mergecolor" data-aos="fade-up" data-aos-duration="800">Hosting <br>Package</h1>
                            <p class="text-break seccolor" data-aos="fade-up" data-aos-duration="1200">{$LANG.cloudSlider.feature01DescriptionTwo}</p>
                            <a href="{$WEB_ROOT}/store/shared-hosting" class="btn btn-default-yellow-fill me-2">{$LANG.ordernowbutton} <i class="fas fa-cart-plus ps-1 f-15"></i></a>
                            <a href="{$WEB_ROOT}/store/shared-hosting" class="btn btn-default-pink-fill">{$LANG.learnmore}</a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 4 Slider -->
            <div class="carousel-cell sec-bg6 bg-colorstyle">
                <div class="slider-content">
                    <div class="container ">
                        <img class="svg custom-element-right" src="{$WEB_ROOT}/templates/{$template}/assets/patterns/monitoring.svg" alt="Support Requests">
                        <div class="col-sm-12 col-md-6 px-0">
                            <h1 class="mergecolor" data-aos="fade-up" data-aos-duration="800">{$LANG.homepage.supportRequests}</h1>
                            <p class="text-break seccolor" data-aos="fade-up" data-aos-duration="1200">{$LANG.cloudSlider.feature02DescriptionTwo}</p>
                            <a href="contact.php" class="btn btn-default-yellow-fill me-2">{$LANG.domainContactUs} <i class="fa-solid fa-headset"></i></a>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
</div>

{if $showAdvancedSearchOptions}
    <script>
        $(document).ready(function() {
            jQuery('#frmDomainHomepage .multiselect').each(function () {
                const enableFiltering = $(this).hasClass('multiselect-filter');
                const minSelection = jQuery(this).data('min-selection');
                $(this).multiselect({
                    onChange: function (element) {
                        const closestSelect = element.closest('select');
                        const selectedOptions = closestSelect.find('option:selected');
                        if (minSelection === undefined) {
                            return;
                        }
                        const atMinOptions = selectedOptions.length <= minSelection;
                        const targetOptions = atMinOptions ? selectedOptions : closestSelect.find('option');
                        targetOptions.each(function () {
                            const inputElement = jQuery('input[value="' + jQuery(this).val() + '"]');
                            inputElement.prop('disabled', atMinOptions ? 'disabled' : false);
                        });
                    },
                    buttonText: function(options, select) {
                        return select.data('placeholder');
                    },
                    maxHeight: 200,
                    includeFilterClearBtn: false,
                    enableCaseInsensitiveFiltering: enableFiltering,
                });
            })
        });
    </script>
{/if}

<script>
var typed1 = new Typed('#typed1', {
  strings: ["performance", "flexibility", "scalability."],
  typeSpeed: 50,
  backSpeed: 20,
  smartBackspace: true,
  loop: true
});
</script>