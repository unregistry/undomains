<div class="dropdown notify-container">
    <a href="#" class="iconews" data-toggle="dropdown">
        <i class="ico-bell f-18 w-icon"></i>{if count($clientAlerts) > 0}<div class="dotted-animation"><span class="animate-circle"></span><span class="main-circle"></span></div>{/if}
    </a>
    <div class="dropdown-menu dropdown-menu-right notification">
        <div class="notify-header">
            <h6 class="d-inline-block m-b-0">{$LANG.notifications}</h6>
            <span class="notify-number bg-colorstyle mergecolor">{if count($clientAlerts) > 0} {count($clientAlerts)} {else}0{/if}</span>
        </div>
        <div class="notify-content bg-seccolorstyle border-bottom-12">
            {if count($clientAlerts) > 0}
            <ul class="client-alerts">
                {foreach $clientAlerts as $alert}
                <li class="bg-colorstyle"><a href="{$alert->getLink()}">
                    <i class="ico-{if $alert->getSeverity() == 'danger'}help-circle{elseif $alert->getSeverity() == 'warning'}alert-circle{elseif $alert->getSeverity() == 'info'}info{else}check-circle{/if}"></i>
                    <div class="message">{$alert->getMessage()}</div>
                </a></li>
                {/foreach}
            </ul>
            {else}
            <span class="alert alert-warning notify-alert"> {$LANG.notificationsnone} <i class="ico-alert-circle"></i></span>
            {/if}
        </div>
    </div>
</div>
