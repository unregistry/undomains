<section class="services sec-normal sec-bg4">
    <div class="container">
      <div class="service-wrap">
        <div class="row" style="gap: 20px;">
          <div class="col-sm-12 text-center" style="width: 100%;">
            <h2 class="section-heading" style="color: #cc9933 !important;">Get Started</h2>
            <p class="section-subheading">{$LANG.homebegin}</p>
          </div>
          <div class="col-sm-12 col-md-4" data-aos="fade-up" data-aos-duration="1000">
            {if $registerdomainenabled || $transferdomainenabled}
            <div class="service-section bg-colorstyle noshadow" style="border-radius: 0;">
              <img class="svg" src="templates/{$template}/assets/fonts/svg/domains.svg" alt="">
              <div class="title mergecolor">{$LANG.buyadomain}</div>
              <p class="subtitle seccolor">
                {$LANG.homebegin}.
              </p>
              <a id="btnBuyADomain" href="/domain-registration" class="btn btn-default-yellow-fill">{$LANG.buyadomain}</a>
            </div>
            {/if}
          </div>
          <div class="col-sm-12 col-md-4" data-aos="fade-up" data-aos-duration="1000">
            <div class="service-section bg-colorstyle noshadow" style="border-radius: 0;">
              <img class="svg" src="templates/{$template}/assets/fonts/svg/move.svg" alt="">
              <div class="title mergecolor">{$LANG.transferdomain}</div>
              <p class="subtitle seccolor">
                {$LANG.homebegin}.
              </p>
              <a id="btnTransferDomain" href="/domain-transfer" class="btn btn-default-yellow-fill">{$LANG.transferdomain}</a>
            </div>
          </div>
          <div class="col-sm-12 col-md-4" data-aos="fade-up" data-aos-duration="1000">
            <div class="service-section bg-colorstyle noshadow" style="border-radius: 0;">
              <img class="svg" src="templates/{$template}/assets/fonts/svg/support.svg" alt="">
              <div class="title mergecolor">{$LANG.getsupport}</div>
              <p class="subtitle seccolor">
                {$LANG.homebegin}.
              </p>
              <a id="btnGetSupport" href="/support" class="btn btn-default-yellow-fill">{$LANG.getsupport}</a>
            </div>
          </div>
        </div>
      </div>
    </div>
</section>
