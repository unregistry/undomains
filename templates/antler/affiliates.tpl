{if $inactive}
{include file="$template/includes/alert.tpl" type="danger" msg=$LANG.affiliatesdisabled textcenter=true}
{else}
{include file="$template/includes/flashmessage.tpl"}
<section class="services overview-services sec-normal pt-0 pb-5">
    <div class="service-wrap">
        <div class="row">
            <div class="col-sm-4">
                <div class="service-section bg-seccolorstyle bg-white noshadow text-center">
                    <img class="svg" src="templates/{$template}/assets/fonts/svg/domains.svg" alt="Domains">
                    <div class="title mergecolor"> {$visitors} <small>{$LANG.affiliatesclicks}</small> </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="service-section bg-seccolorstyle bg-white noshadow text-center">
                    <img class="svg" src="templates/{$template}/assets/fonts/svg/man.svg" alt="User">
                    <div class="title mergecolor"> {$signups} <small>{$LANG.affiliatessignups}</small> </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="service-section bg-seccolorstyle bg-white noshadow text-center">
                    <img class="svg" src="templates/{$template}/assets/fonts/svg/chart.svg" alt="Chart">
                    <div class="title mergecolor"> {$conversionrate}% <small>{$LANG.affiliatesconversionrate}</small> </div>
                </div>
            </div>
        </div>
    </div>
</section>
<div class="affiliate-referral-link">
    <p class="mergecolor">{$LANG.affiliatesreferallink}</p>
    <h2 class="mergecolor">{$referrallink}</h2>
</div>
<div class="row">
    <div class="col-md-12 table-responsive">
        <table class="table table-list">
            <tr class="mergecolor">
                <td>{$LANG.affiliatescommissionspending}:</td>
                <td><strong>{$pendingcommissions}</strong></td>
            </tr>
            <tr class="mergecolor">
                <td>{$LANG.affiliatescommissionsavailable}:</td>
                <td><strong>{$balance}</strong></td>
            </tr>
            <tr class="mergecolor">
                <td>{$LANG.affiliateswithdrawn}:</td>
                <td><strong>{$withdrawn}</strong></td>
            </tr>
        </table>
    </div>
</div>
{if $withdrawrequestsent}
<div class="alert alert-success">
    <p class="mergecolor">{$LANG.affiliateswithdrawalrequestsuccessful}</p>
</div>
{else}
<div>
    <form method="POST" action="{$smarty.server.PHP_SELF}">
        <input type="hidden" name="action" value="withdrawrequest" />
        <button type="submit" class="btn btn-lg btn-danger{if !$withdrawlevel} disabled" disabled="disabled{/if}">
            <i class="fas fa-university"></i> {$LANG.affiliatesrequestwithdrawal}
        </button>
    </form>
</div>
{if !$withdrawlevel}
<p class="text-muted mb-50">{lang key="affiliateWithdrawalSummary" amountForWithdrawal=$affiliatePayoutMinimum}</p>
{/if}
{/if}
<h2 class="mergecolor mb-0"> {$LANG.affiliatesreferals}</h2>
{include file="$template/includes/tablelist.tpl" tableName="AffiliatesList"}
<script type="text/javascript">
jQuery(document).ready( function ()
{
var table = jQuery('#tableAffiliatesList').removeClass('hidden').DataTable();
{if $orderby == 'regdate'}
table.order(0, '{$sort}');
{elseif $orderby == 'product'}
table.order(1, '{$sort}');
{elseif $orderby == 'amount'}
table.order(2, '{$sort}');
{elseif $orderby == 'status'}
table.order(4, '{$sort}');
{/if}
table.draw();
jQuery('#tableLoading').addClass('hidden');
});
</script>
<div class="table-container clearfix">
    <table id="tableAffiliatesList" class="table table-list hidden ">
        <thead>
            <tr>
                <th>{$LANG.affiliatessignupdate}</th>
                <th>{$LANG.orderproduct}</th>
                <th>{$LANG.affiliatesamount}</th>
                <th>{$LANG.affiliatescommission}</th>
                <th>{$LANG.affiliatesstatus}</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$referrals item=referral}
            <tr class="text-center">
                <td><span class="hidden">{$referral.datets}</span>{$referral.date}</td>
                <td>{$referral.service}</td>
                <td data-order="{$referral.amountnum}">{$referral.amountdesc}</td>
                <td data-order="{$referral.commissionnum}">{$referral.commission}</td>
                <td><span class='label status status-{$referral.rawstatus|strtolower}'>{$referral.status}</span></td>
            </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fas fa-spinner fa-spin"></i> {$LANG.loading}</p>
    </div>
</div>
{if $affiliatelinkscode}
{include file="$template/includes/subheader.tpl" title=$LANG.affiliateslinktous}
<div class="margin-bottom text-center">
    {$affiliatelinkscode}
</div>
{/if}
{/if}