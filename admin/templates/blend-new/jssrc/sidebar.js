var blendSidebar = {
    refs: {
        sidebar: '#sidebar',
        content: '#contentarea',
        opener: '#sidebarOpener',
        mobileOpener: '#sidebarOpenerMobile',
        closer: '#sidebarClose',
        collapse: '.sidebar-collapse',
        collapseExpand: '#sidebarCollapseExpand',
    },

    init: function() {
        var self = blendSidebar;

        // Handle desktop opener
        $(self.refs.opener).click(function(e) {
            e.preventDefault();
            self.openSidebar();
        });

        // Handle mobile opener
        $(self.refs.mobileOpener).click(function(e) {
            e.preventDefault();
            self.openSidebar();
        });

        $(self.refs.closer).click(function(e) {
            e.preventDefault();
            self.closeSidebar();
        });

        $(self.refs.collapseExpand).click(function(e) {
            e.preventDefault();
            $(this).toggleClass('expanded');
            $(self.refs.collapse).slideToggle();
        });
    },

    openSidebar: function() {
        var self = blendSidebar;
        $(self.refs.mobileOpener).fadeOut();
        $(self.refs.opener).fadeOut();
        $(self.refs.content).removeClass('sidebar-minimized');
        $(self.refs.sidebar).delay(400).fadeIn('fast');
        WHMCS.http.jqClient.post(whmcsBaseUrl + adminBaseRoutePath + "/search.php","a=maxsidebar");
    },

    closeSidebar: function() {
        var self = blendSidebar;
        $(self.refs.sidebar).fadeOut('fast',function(){
            $(self.refs.content).addClass('sidebar-minimized');
            $(self.refs.mobileOpener).fadeIn();
            $(self.refs.opener).fadeIn();
        });
        WHMCS.http.jqClient.post(whmcsBaseUrl + adminBaseRoutePath + "/search.php","a=minsidebar");
    }
};

$(document).ready(blendSidebar.init);
