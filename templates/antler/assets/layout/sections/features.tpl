<svg class="division-ontop bg-white d-none" viewBox="0 0 1440 150">
  <path fill="#fdd700" fill-opacity="1" d="M0,96L120,85.3C240,75,480,53,720,53.3C960,53,1200,75,1320,85.3L1440,96L1440,320L1320,320C1200,320,960,320,720,320C480,320,240,320,120,320L0,320Z">
  </path>
</svg>
    
<section class="services sec-normal sec-bg4">
    <div class="container">
      <div class="service-wrap">
        <div class="row">
          <div class="col-sm-12 text-center">
            <h2 class="section-heading">{$LANG.howcanwehelp}</h2>
            <p class="section-subheading">{$LANG.homebegin}</p>
          </div>
          <div class="col-sm-12 col-md-4" data-aos="fade-up" data-aos-duration="1000">
            {if $registerdomainenabled || $transferdomainenabled}
            <div class="service-section bg-colorstyle noshadow">
              <img class="svg" src="templates/{$template}/assets/fonts/svg/domains.svg" alt="">
              <div class="title mergecolor">{$LANG.buyadomain}</div>
              <p class="subtitle seccolor">
                {$LANG.homebegin}.
              </p>
              <a id="btnBuyADomain" href="domainchecker.php" class="btn btn-default-yellow-fill">{$LANG.buyadomain}</a>
            </div>
            {/if}
          </div>
          <div class="col-sm-12 col-md-4" data-aos="fade-up" data-aos-duration="500">
            <div class="service-section bg-colorstyle noshadow">
              <img class="svg" src="templates/{$template}/assets/fonts/svg/cloudfiber.svg" alt="">
              <div class="title mergecolor">{$LANG.orderhosting}</div>
              <p class="subtitle seccolor">
                {$LANG.orderForm.chooseFromRange}
              </p>
              <a id="btnOrderHosting" href="{$WEB_ROOT}/cart.php?gid=1" class="btn btn-default-yellow-fill">{$LANG.orderhosting}</a>
            </div>
          </div>
          <div class="col-sm-12 col-md-4" data-aos="fade-up" data-aos-duration="1000">
            <div class="service-section bg-colorstyle noshadow">
              <div class="plans badge feat bg-pink">Premium</div>
              <img class="svg" src="templates/{$template}/assets/fonts/svg/helpdesk.svg" alt="">
              <div class="title mergecolor">{$LANG.getsupport}</div>
              <p class="subtitle seccolor">
                {$LANG.supportticketsintro}
              </p>
              <a id="btnGetSupport" href="submitticket.php" class="btn btn-default-yellow-fill">{$LANG.getsupport}</a>
            </div>
          </div>
        </div>
      </div>
    </div>
</section>