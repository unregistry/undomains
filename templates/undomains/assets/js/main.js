/* *****************************************************
Project: Undomains - Hosting Provider & U Template
Description: Undomains Responsive Premium Template Designed for all web hosting providers
Author: inebur (Rúben Rodrigues)
Author URI: http://inebur.com/
Author Envato: https://themeforest.net/user/inebur
Copyright: 2026 inebur
Version: 4.2

[Main Javascript]
***************************************************** */
document.addEventListener('DOMContentLoaded', function() {
    "use strict";
    loader();
    gravatar();
    dropmenudesk();
});

/*-- OffCanvas --*/
(function offcanvas() {
  "use strict";
  const offcanvasToggle = document.querySelectorAll('[data-bs-toggle="offcanvas"], [data-bs-dismiss="offcanvas"]');
  const offcanvasCollapse = document.querySelector('.offcanvas');
  const offcanvasFade = document.querySelector('.offcanvas-backdrop');
  offcanvasToggle.forEach(el => {
    el.addEventListener("click", function() {
      offcanvasCollapse.classList.toggle("show");
      offcanvasFade.classList.toggle("show");
    });
  });
})();


$(".tech-box").on('click', function(){
    $(".offcanvas-start").addClass("show");
});

$(".tech-box").on('click', function(){
    $(".backdrop-start").addClass("show");
});

$('.backdrop-start').on('click', function() {
    $(".backdrop-start.show").removeClass("show");
    $(".offcanvas-start.show").removeClass("show");
    $(".offcanvas-backdrop.show").removeClass("show");
    $(".offcanvas.show").removeClass("show");
});

$('.btn-close').on('click', function() {
    $(".backdrop-start.show").removeClass("show");
    $(".offcanvas-start.show").removeClass("show");
    $(".offcanvas-backdrop.show").removeClass("show");
    $(".offcanvas.show").removeClass("show");
});

/*-- Loader --*/
function loader() {
    $(window).on('load', function() {
        $("#spinner-area").fadeOut("slow");
    })
}
/* Gravatar Email */
function gravatar() {
    $(document).ready(function(){
        if ($('#gravataremail').length) {
        var email = document.getElementById('gravataremail').innerText;
        if(email != ''){
            var imgUrl = 'https://gravatar.com/avatar/'+MD5(email)+'';
            $.ajax({
                url:imgUrl,
                type:"HEAD",
                crossDomain:true,
                success:function(){
                    $(".gravatar").attr("src",imgUrl);
                }
            });
        }
        }
    });
}

/*-- Menu Toggle Mobile --*/
$("#nav-toggle").click(function(){
$(".menu-wrap.mobile, .menu-toggle").toggleClass("active");
$(".menu-wrap.mobile").toggleClass("active");
});

/*-- Dropdown Desk & Mobile --*/
function dropmenudesk() {
    $('.desk.nav .dropdown').hover(function(){
        $(this).addClass('open');
    },
    function() {
        $(this).removeClass('open');
    });
}

(function($){
  $('.mobile.nav .dropdown').on('click', function(e){
    $(this).parent().toggleClass('open').siblings().removeClass('open');
  });

  $(document).on('mobile.nav .dropdown', function(e){
    if (!$(e.target).hasClass('dropdown-toggle')) {
      $('.dropdown-menu').parent().removeClass('open');
    }
  });
})(jQuery);


/*-- Styleswitch Color Style --*/
(function($) {
    $(document).ready(function() {
        $(".styleswitch").click(function() {
            switchStylestyle(this.getAttribute("data-rel"));
            return false
        });
    });
    function switchStylestyle(styleName) {
        $("link[rel*=style][title]").each(function(i) {
            this.disabled = true;
            if (this.getAttribute("title") == styleName) this.disabled = false
        })
    }
})(jQuery);

/*-- Active Menu --*/
jQuery(function($) {
    var path = window.location.href;
    $('.navbar ul li a')
    .each(function() {
        if (this.href === path) {
            $(this)
            .addClass('active');
            $(this)
            .parent()
            .parent()
            .closest("li")
            .addClass('active2');
            $('.active2 a:first')
            .addClass('active');
        }
    });
});

/*-- Flickity Slider --*/
$('.header-main-slider').flickity({
  fullscreen: true,
  draggable: true,
  prevNextButtons: false,
  pageDots: true,
  autoPlay: 6000,
  fade: true
});
$('.header-main-nav').flickity({
  asNavFor: '.header-main-slider',
  prevNextButtons: false,
  pageDots: false,
  contain: true
  
});
$('.banner-slider').flickity({
  prevNextButtons: false,
  pageDots: true,
});

(function($) {
    $('.carousel').flickity({
        cellSelector: '.carousel-cell',
    });
})(jQuery);

/* AOS Scroll Effect */
AOS.init();