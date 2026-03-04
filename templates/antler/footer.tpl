{if $loginpage eq 0 and $templatefile ne "clientregister"}<!-- login and register page without the default header and footer -->
                                        </div><!-- /.main-content -->
                                    <div class="clearfix"></div>
                                </div><!-- end row -->
                            </div><!-- end container -->
                        </section><!-- end main body section -->
                    </div><!-- end page wrapper -->
                </div><!-- end main body -->
            </div><!-- end inner content -->
        </div><!-- end content -->
    </div><!-- end wrapper -->
</div><!-- end main container -->

{if $loggedin}<span id="gravataremail" class="hidden">{$clientsdetails.email}</span><!-- gravatar email -->{/if}
<div id="fullpage-overlay" class="hidden">
    <div class="outer-wrapper">
        <div class="inner-wrapper">
            <img src="{$WEB_ROOT}/assets/img/overlay-spinner.svg">
            <br>
            <span class="msg"></span>
        </div>
    </div>
</div>

<!--
*******************
FOOTER
*******************
-->
<footer id="footer" class="footer">
  {include file="$template/includes/verifyemail.tpl"}
  <img class="logo-bg logo-footer" src="{$WEB_ROOT}/templates/{$template}/assets/img/symbol.svg" alt="symbol">
  <div class="container">
    <div class="footer-top">
      <div class="row">
        <div class="col-sm-6 col-md-3">
          <div class="heading">Hosting</div>
          <ul class="footer-menu classic">
            <li class="menu-item"><a href="http://inebur.com/antler/template/hosting">Shared Hosting</a></li>
            <li class="menu-item"><a href="http://inebur.com/antler/template/dedicated">Dedicated Server</a></li>
            <li class="menu-item"><a href="http://inebur.com/antler/template/vps">Cloud Virtual (VPS)</a></li>
            <li class="menu-item"><a href="http://inebur.com/antler/template/domains">Domain Names</a></li>
          </ul>
        </div>
        <div class="col-sm-6 col-md-3">
          <div class="heading">Support</div>
          <ul class="footer-menu classic">
            <li class="menu-item"><a href="{$WEB_ROOT}/login">myAntler</a></li>
            <li class="menu-item"><a href="{$WEB_ROOT}/knowledgebase">Knowledge Base</a></li>
            <li class="menu-item"><a href="{$WEB_ROOT}/contact.php">Contact Us</a></li>
            <li class="menu-item"><a href="http://inebur.com/antler/template/faq">FAQ</a></li>
          </ul>
        </div>
        <div class="col-sm-6 col-md-3">
          <div class="heading">Company</div>
          <ul class="footer-menu classic">
            <li class="menu-item"><a href="http://inebur.com/antler/template/about">About Us</a> </li>
            <li class="menu-item"><a href="http://inebur.com/antler/template/elements">Features</a></li>
            <li class="menu-item"><a href="http://inebur.com/antler/template/blog-details">Blog</a></li>
            <li class="menu-item"><a href="http://inebur.com/antler/template/legal">Legal</a></li>
          </ul>
        </div>
        <div class="col-sm-6 col-md-3">
          <a><img class="svg logo-footer d-block" src="{$WEB_ROOT}/templates/{$template}/assets/img/logo.svg" alt="logo Antler"></a>
          <a><img class="svg logo-footer d-none" src="{$WEB_ROOT}/templates/{$template}/assets/img/logo-light.svg" alt="logo Antler"></a>
          <div class="copyright">{lang key="copyrightFooterNotice" year=$date_year company=$companyname}</div>
          <div class="soc-icons">
            <a href=""><i class="fab fa-facebook-f"></i></a>
            <a href=""><i class="fab fa-google-plus-g"></i></a>
            <a href=""><i class="fab fa-twitter"></i></a>
            <a href=""><i class="fab fa-linkedin-in"></i></a>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="subcribe news">
    <div class="container">
      <div class="row">
        <form action="#" class="w-100">
          <div class="col-md-6 col-md-offset-3">
            <div class="general-input">
              <input type="email" name="email" placeholder="Enter your email address" class="fill-input">
              <input type="submit" value="SUBSCRIBE" class="btn btn-subscribe btn-default-yellow-fill initial-transform">
            </div>
          </div>
          <div class="col-md-6 col-md-offset-3 text-center pt-4">
            <p>Subscribe to our newsletter to receive news and updates</p>
          </div>
        </form>
      </div>
    </div>
  </div>
  <div class="footer-bottom">
    <div class="container">
      <div class="row">
        <div class="col-md-6 col-lg-6">          
          <ul class="footer-menu">
            <li class="menu-item by ml-0">Hybrid Design With <span class="c-pink">♥</span> by
              <a href="http://inebur.com/" target="_blank">Inebur</a>
            </li>
          </ul>
        </div>
        <div class="col-md-6 col-lg-6">
          <ul class="payment-list">
            <li><p>Payments We Accept</p></li>
            <li><i class="fab fa-cc-paypal"></i></li>
            <li><i class="fab fa-cc-visa"></i></li>
            <li><i class="fab fa-cc-mastercard"></i></li>
            <li><i class="fab fa-cc-apple-pay"></i></li>
            <li><i class="fab fa-cc-discover"></i></li>
            <li><i class="fab fa-cc-amazon-pay"></i></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</footer>

<div class="modal system-modal fade" id="modalAjax" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content panel panel-primary">
            <div class="modal-header panel-heading">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">&times;</span>
                    <span class="sr-only">Close</span>
                    <span class="sr-only">{$LANG.close}</span>
                </button>
                <h4 class="modal-title">Title</h4>
            </div>
            <div class="modal-body panel-body">
                Loading...
                {$LANG.loading}
            </div>
            <div class="modal-footer panel-footer">
                <div class="pull-left loader">
                    <i class="fas fa-circle-notch fa-spin"></i> Loading...
                </div>
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    Close
                    {$LANG.close}
                </button>
                <button type="button" class="btn btn-primary modal-submit">
                    Submit
                    {$LANG.submit}
                </button>
            </div>
        </div>
    </div>
</div>
{/if}

{include file="$template/includes/generate-password.tpl"}
{$footeroutput}

<script>
 if ($("p:contains('Powered by')").length) {
 $("p:contains('Powered by')").hide();
 }
</script>

</body>
</html>
