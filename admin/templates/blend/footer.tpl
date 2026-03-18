        </div>
        <div class="clear"></div>
    </div>

    <a href="#" class="sidebar-opener-mobile{if $minsidebar} minimized{/if}" id="sidebarOpenerMobile">
        {$_ADMINLANG.openSidebar}
    </a>
    <div class="footerbar">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-6 links">
                    <a href="https://undomains.com/" target="_blank" title="Visit Undomains"><i class="fas fa-globe"></i> Website</a>
                    <span class="divider">|</span>
                    <a href="#" onclick="UndoTheme.toggle(); return false;" title="Toggle Dark/Light Theme"><i class="fas fa-moon" id="footer-theme-icon"></i> Theme</a>
                </div>
                <div class="col-md-6 copyright text-right">
                    <!-- Removal of the WHMCS copyright notice is strictly prohibited -->
                    <!-- Branding removal entitlement does not permit this line to be removed -->
                    <i class="fas fa-copyright"></i> Copyright {date('Y')} 
                    <a href="https://undomains.com/" target="_blank">Undomains</a>.
                    Part of <a href="https://un4.com/" target="_blank">UN4</a>
                </div>
            </div>
        </div>
    </div>

    {include file="$template/intellisearch-results.tpl"}
    {include file="$template/includes.tpl"}
    {$footeroutput}

    <script type="text/javascript" src="templates/{$template}/js/theme-toggle.js?v={$versionHash}"></script>
</body>
</html>
