<p class="section-subheading text-center mergecolor">{$LANG.affiliatesignupinfo1}</p>
<div class="bg-seccolorstyle bg-white noshadow p-50 text-center br-12 mt-50">
    {if $affiliatesystemenabled}
        {include file="$template/includes/alert.tpl" type="info" title=$LANG.affiliatesignuptitle msg=$LANG.affiliatesignupintro|cat:'<br /><br />' textcenter=true}
        <div class="bg-colorstyle bg-white noshadow p-5 text-center br-12 mergecolor">
            <p>{$LANG.affiliatesignupinfo2} </p>
        </div>
        <br/>
        <form method="post" action="affiliates.php">
            <input type="hidden" name="activate" value="true" />
            <p align="center">
                <input id="activateAffiliate" type="submit" value="{$LANG.affiliatesactivate}" class="btn btn-success" />
            </p>
        </form>
    {else}
        {include file="$template/includes/alert.tpl" type="warning" msg=$LANG.affiliatesdisabled textcenter=true}
    {/if}
</div>
