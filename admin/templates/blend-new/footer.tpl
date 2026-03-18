</div>
<div class="clear"></div>
</div>

<a href="#" class="sidebar-opener-mobile{if $minsidebar} minimized{/if}" id="sidebarOpenerMobile">
    {$_ADMINLANG.openSidebar}
</a>
<div class="footerbar">
    <div class="links">
        <a href="https://www.whmcs.com/report-a-bug" target="_blank">Report a Bug</a>
        <span>&middot;</span>
        <a href="https://go.whmcs.com/1893/docs" target="_blank">Documentation</a>
        <span>&middot;</span>
        <a href="https://www.whmcs.com/contact" target="_blank">Contact Us</a>
    </div>
    <div class="copyright">
        <!-- Removal of the WHMCS copyright notice is strictly prohibited -->
        <!-- Branding removal entitlement does not permit this line to be removed -->
        &copy;<a href="https://www.whmcs.com/" target="_blank">WHMCS</a> {date('Y')}. All Rights Reserved.
    </div>
</div>

{include file="$template/intellisearch-results.tpl"}
{include file="$template/includes.tpl"}
{$footeroutput}

</body>
</html>
