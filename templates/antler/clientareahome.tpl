{include file="$template/includes/flashmessage.tpl"}
<div class="container-clientarea">
    <span class="container-clientarea-bg"></span>
    <div class="clientarea-new-header">
        <div class="row">
            <div class="col-md-8 col-sm-8">
                <div class="aitems-center">
                    <div class="col profile-photo">
                        <img class="gravatar br-50" src="{$WEB_ROOT}/templates/{$template}/assets/img/gravatar.jpg" alt="Avatar" title="Avatar for {$loggedinuser.firstname}"/>
                        <a target="_blank" href="https://gravatar.com/">{$LANG.orderForm.edit}</a>
                    </div>
                    <h5 class="header-accout-details">
                    <span class="username mergecolor">{$clientsdetails.firstname} {$clientsdetails.lastname} !</span>
                    <span class="adress mergecolor">{$clientsdetails.address1}, {$clientsdetails.city} <b class="mergecolor">{$clientsdetails.country}</b></span></h5>
                </div>
            </div>
            <div class="col-md-4 col-sm-4">
                <div class="header-features-icons">
                    <a href="clientarea.php?action=addfunds" class="badge feat bg-success" data-toggle="tooltip" data-placement="top" title="" data-original-title="{$clientsstats.creditbalance}"><i class="ico-dollar-sign"></i> </a>
                    <a href="clientarea.php?action=details" class="badge feat bg-warning" data-toggle="tooltip" data-placement="top" title="" data-original-title="{$LANG.orderForm.update}"><i class="ico-edit-3"></i> </a>
                    <a href="clientarea.php?action=addcontact" class="badge feat bg-default" data-toggle="tooltip" data-placement="top" title="" data-original-title="{$LANG.clientareanavaddcontact}"><i class="ico-user-plus"></i></a>
                    <a href="clientarea.php?action=quotes" class="badge feat bg-prata" data-toggle="tooltip" data-placement="top" title="" data-original-title="{$LANG.quotes} {$clientsstats.numquotes}"><i class="ico-twitch"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>

<section class="services overview-services sec-normal pt-0">
    <div class="service-wrap">
        <div class="row">
            <div class="col-md-12 col-lg-3" data-aos="fade-up" data-aos-duration="1000">
              <div class="service-section bg-seccolorstyle bg-white noshadow">
                <div class="plans badge feat bg-pink">{$LANG.yourservices}</div>
                <img class="svg" src="templates/{$template}/assets/fonts/svg/settings.svg" alt="Services">
                <div class="title mergecolor">{$clientsstats.productsnumactive} {$LANG.navservices}</div>
                <p class="subtitle seccolor">{$LANG.clientareaproducts} </p>
                <a href="clientarea.php?action=services" class="btn btn-default-yellow-fill">Read more</a>
              </div>
            </div>
            <div class="col-md-12 col-lg-3" data-aos="fade-up" data-aos-duration="500">
              <div class="service-section bg-seccolorstyle bg-white noshadow">
                <div class="plans badge feat bg-pink">{$LANG.yourdomains}</div>
                <img class="svg" src="templates/{$template}/assets/fonts/svg/domains.svg" alt="Domains">
                {if $clientsstats.numdomains || $registerdomainenabled || $transferdomainenabled}
                    <div class="title mergecolor">{$clientsstats.numactivedomains} {$LANG.navdomains}</div>
                    <p class="subtitle seccolor">{$LANG.domainRenewal.renewingDomains}</p>
                    <a href="clientarea.php?action=domains" class="btn btn-default-yellow-fill">Read more</a>
                {elseif $condlinks.affiliates && $clientsstats.isAffiliate}
                    <div class="title mergecolor">{$clientsstats.numaffiliatesignups} {$LANG.affiliatessignups}</div>
                    <p class="subtitle seccolor">{$LANG.affiliatesreferals}</p>
                    <a href="affiliates.php" class="btn btn-default-yellow-fill">Read more</a>
                {/if}
              </div>
            </div>
            <div class="col-md-12 col-lg-3" data-aos="fade-up" data-aos-duration="800">
              <div class="service-section bg-seccolorstyle bg-white noshadow">
                <img class="svg" src="templates/{$template}/assets/fonts/svg/ticket.svg" alt="Tickets">
                <div class="title mergecolor">{$clientsstats.numactivetickets} {$LANG.navtickets}</div>
                <p class="subtitle seccolor">{$LANG.ticketsyourhistory}</p>
                <a href="supporttickets.php" class="btn btn-default-yellow-fill">Read more</a>
              </div>
            </div>
            <div class="col-md-12 col-lg-3" data-aos="fade-up" data-aos-duration="1000">
              <div class="service-section bg-seccolorstyle bg-white noshadow">
                <img class="svg" src="templates/{$template}/assets/fonts/svg/document.svg" alt="Tickets">
                <div class="title mergecolor">{$clientsstats.numunpaidinvoices} {$LANG.navinvoices}</div>
                <p class="subtitle seccolor">{$LANG.subaccountpermsinvoices}</p>
                <a href="clientarea.php?action=invoices" class="btn btn-default-yellow-fill">Read more</a>
              </div>
            </div>
        </div>
    </div>
</section>

{if $captchaError}
    <div class="alert alert-danger">
        {$captchaError}
    </div>
{/if}

<section class="services overview-services p-80 bg-yellow br-12 clientarea-limited-chracters">
  <div class="container">
    <div class="service-wrap">
      <div class="row">
        <div class="col-md-12 text-center">
          <h2 class="section-heading">{$LANG.accountoverview}</h2>
          <p class="section-subheading">{$LANG.clientareaproductdetailsintro}</p>
        </div>
        {function name=outputHomePanels}
            <div class="col-md-12 col-md-12 rockbox">
              <div class="service-section bg-seccolorstyle noshadow">
                <div class="title mergecolor">
                    {$item->getLabel()}
                    {if $item->hasBadge()}&nbsp;<span class="badge">{$item->getBadge()}</span>{/if}
                </div>
                {if $item->hasBodyHtml()}
                    {$item->getBodyHtml()}
                {/if}
                {if $item->hasChildren()}
                <div class="list-group d-grid{if $item->getChildrenAttribute('class')} {$item->getChildrenAttribute('class')}{/if}">
                    {foreach $item->getChildren() as $childItem}
                    {if $childItem->getUri()}
                    <a menuItemName="{$childItem->getName()}" href="{$childItem->getUri()}" class="list-group-item bg-colorstyle{if $childItem->getClass()} {$childItem->getClass()}{/if} {if $childItem->isCurrent()} active{/if}"{if $childItem->getAttribute('dataToggleTab')} data-toggle="tab"{/if}{if $childItem->getAttribute('target')} target="{$childItem->getAttribute('target')}"{/if} id="{$childItem->getId()}">
                        {if $childItem->hasIcon()}<i class="{$childItem->getIcon()}"></i>&nbsp;{/if}
                        {$childItem->getLabel()}
                        {if $childItem->hasBadge()}&nbsp;<span class="badge">{$childItem->getBadge()}</span>{/if}
                    </a>
                    {else}
                    <div menuItemName="{$childItem->getName()}" class="list-group-item bg-colorstyle{if $childItem->getClass()} {$childItem->getClass()}{/if}" id="{$childItem->getId()}">
                        {if $childItem->hasIcon()}<i class="{$childItem->getIcon()}"></i>&nbsp;{/if}
                        {$childItem->getLabel()}
                        {if $childItem->hasBadge()}&nbsp;<span class="badge">{$childItem->getBadge()}</span>{/if}
                    </div>
                    {/if}
                    {/foreach}
                </div>
                {/if}
                {if $item->getExtra('btn-link') && $item->getExtra('btn-text')}
                <a href="{$item->getExtra('btn-link')}" class="btn btn-default-yellow-fill">Read more</a>
                {/if}
              </div>
            </div>
        {/function}

        {foreach $panels as $item}
            {if $item->getExtra('colspan')}
                {outputHomePanels}
                {assign "panels" $panels->removeChild($item->getName())}
            {/if}
        {/foreach}

        {foreach $panels as $item}
        {if $item@iteration is odd}
        {outputHomePanels}
        {/if}
        {/foreach}

        {foreach $panels as $item}
        {if $item@iteration is even}
        {outputHomePanels}
        {/if}
        {/foreach}

      </div>
    </div>
  </div>
</section>


{foreach from=$addons_html item=addon_html}
<div class="sec-normal pb-0">
    {$addon_html}
</div>
{/foreach}

