<div class="dropdown">
    <a href="" class="iconews"  data-toggle="dropdown"><i class="ico-log-in f-18 w-icon"></i></a>
    <div class="dropdown-menu dropdown-menu-right notification">
        <div class="notify-header">
            <h6 class="d-inline-block m-b-0">WHMCS Admin Panel</h6>
        </div>
        <div class="notify-content">
            <p>
            {if $adminMasqueradingAsClient}{$LANG.adminmasqueradingasclient} {$LANG.logoutandreturntoadminarea}{else}{$LANG.adminloggedin} {$LANG.returntoadminarea}{/if}
            </p>
        </div>
        <div class="notify-footer">
            <a href="{$WEB_ROOT}/logout.php?returntoadmin=1" class="btn btn-sm btn-default-yellow-fill"> {$LANG.admin.returnToAdmin} <i class="ico-arrow-right w-icon"></i></a>
        </div>
    </div>
</div>
