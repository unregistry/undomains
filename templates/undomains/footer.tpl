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
  
  <!-- Newsletter Subscription -->
  <div class="subcribe news">
    <div class="container">
      <div class="row">
        <form action="/subscribe.php" method="POST" class="w-100" id="subscribeForm">
          <div class="col-md-6 col-md-offset-3">
            <div class="subscribe-pill-wrapper">
              <input type="email" name="email" placeholder="Enter your email address" class="pill-input">
              <button type="submit" class="pill-button">Subscribe</button>
            </div>
          </div>
          <div class="col-md-6 col-md-offset-3 text-center pt-4">
            <p>Subscribe to our newsletter to receive news and updates</p>
          </div>
        </form>
      </div>
    </div>
  </div>
  
  <!-- Footer Content - All Centered -->
  <div class="container">
    <div class="footer-content" style="text-align: center; padding: 40px 0;">
      
      <!-- Support Menu Row -->
      <div class="footer-support" style="margin-bottom: 30px;">
        <ul class="footer-menu classic" style="list-style: none; padding: 0; margin: 0; display: inline-flex; flex-wrap: wrap; justify-content: center; gap: 0;">
          <li class="menu-item"><a href="{$WEB_ROOT}/login">Login</a></li>
          <li style="margin: 0 10px;">|</li>
          <li class="menu-item"><a href="{$WEB_ROOT}/knowledgebase">Knowledgebase</a></li>
          <li style="margin: 0 10px;">|</li>
          <li class="menu-item"><a href="{$WEB_ROOT}/contact">Contact</a></li>
        </ul>
      </div>
      
      <!-- Social & Logo Row -->
      <div class="footer-brand" style="margin-bottom: 30px;">
        <div class="soc-icons" style="margin-bottom: 15px; display: inline-flex; gap: 10px;">
          <a href="https://x.com/undomainsx" target="_blank" rel="noopener" style="display: inline-flex; align-items: center; justify-content: center; width: 36px; height: 36px; border: 1px solid currentColor; border-radius: 0; background: transparent;"><i class="fab fa-x-twitter"></i></a>
          <a href="https://www.linkedin.com/company/unregistrar/" target="_blank" rel="noopener" style="display: inline-flex; align-items: center; justify-content: center; width: 36px; height: 36px; border: 1px solid currentColor; border-radius: 0; background: transparent;"><i class="fab fa-linkedin-in"></i></a>
          <a href="https://www.facebook.com/unregistrar" target="_blank" rel="noopener" style="display: inline-flex; align-items: center; justify-content: center; width: 36px; height: 36px; border: 1px solid currentColor; border-radius: 0; background: transparent;"><i class="fab fa-facebook-f"></i></a>
        </div>
        <a style="display: block; margin-bottom: 10px;">
          <img class="logo-footer logo-dark img-fluid d-block" src="{$WEB_ROOT}/templates/{$template}/assets/img/undomains-logo-dark.png" alt="undomains" style="height: 35px; width: auto; display: inline-block; margin: 0 auto;">
          <img class="logo-footer logo-light img-fluid d-none" src="{$WEB_ROOT}/templates/{$template}/assets/img/undomains-logo-light.png" alt="undomains" style="height: 35px; width: auto; display: inline-block; margin: 0 auto;">
        </a>
        <div class="footer-powered" style="margin-bottom: 10px;">
          <ul class="footer-menu" style="list-style: none; padding: 0; margin: 0;">
            <li class="menu-item by" style="display: inline;">Powered by <a href="https://u.onl" target="_blank">U.</a> | Part of <a href="https://un4.com" target="_blank">UN4</a></li>
          </ul>
        </div>
        <div class="copyright" style="padding-bottom: 0;">{lang key="copyrightFooterNotice" year=$date_year company=$companyname}</div>
      </div>
      
      <!-- Payments Row -->
      <div class="footer-payments">
        <ul class="payment-list" style="list-style: none; padding: 0; margin: 0; display: inline-flex; flex-wrap: wrap; justify-content: center; gap: 15px;">
          <li><i class="fab fa-cc-paypal"></i></li>
          <li><i class="fab fa-cc-visa"></i></li>
          <li><i class="fab fa-cc-mastercard"></i></li>
          <li><i class="fab fa-cc-apple-pay"></i></li>
          <li><i class="fab fa-cc-discover"></i></li>
          <li><i class="fab fa-cc-amazon-pay"></i></li>
          <li><i class="fab fa-bitcoin"></i></li>
        </ul>
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

<style>
.footer,
[data-background=dark] .box-container .footer,
[data-background=dark] .footer {
    background-color: #101010 !important;
}

.footer .heading,
.footer .copyright,
.footer .footer-menu a,
.footer .soc-icons a {
    color: #fff;
}

.subscribe-pill-wrapper {
    display: flex;
    gap: 10px;
    background: #fff;
    border-radius: 50px;
    padding: 8px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    border: 1px solid #ddd;
}

.pill-input {
    flex: 1;
    border: none !important;
    padding: 12px 20px !important;
    font-size: 15px;
    outline: none !important;
    border-radius: 40px !important;
}

.pill-button {
    background: linear-gradient(135deg, #e6c87a 0%, #cc9933 100%);
    color: #000;
    border: none;
    padding: 12px 30px;
    border-radius: 40px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    white-space: nowrap;
}

.pill-button:hover {
    transform: scale(1.02);
    box-shadow: 0 5px 20px rgba(204, 153, 51, 0.4);
}

/* Footer powered by links - U. and UN4 */
.menu-item.by a {
    font-weight: bold !important;
    color: #cc9933 !important;
    transition: font-size 0.2s ease;
}

.menu-item.by a:hover {
    font-size: 1.1em;
}
</style>

<!-- Toast Notification -->
<div id="toast" class="toast-notification">
    <div class="toast-content">
        <i class="fas fa-check-circle toast-icon"></i>
        <span class="toast-message"></span>
    </div>
</div>

<style>
.toast-notification {
    position: fixed;
    bottom: 20px;
    left: 20px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 5px 30px rgba(0,0,0,0.2);
    padding: 16px 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    min-width: 300px;
    max-width: 400px;
    opacity: 0;
    transform: translateY(20px);
    transition: all 0.3s ease;
    z-index: 9999;
    pointer-events: none;
}

.toast-notification.show {
    opacity: 1;
    transform: translateY(0);
    pointer-events: auto;
}

.toast-notification.error {
    border-left: 4px solid #e26f6f;
}

.toast-notification.success {
    border-left: 4px solid #a2d398;
}

.toast-content {
    display: flex;
    align-items: center;
    gap: 12px;
}

.toast-icon {
    font-size: 20px;
}

.toast-notification.success .toast-icon {
    color: #a2d398;
}

.toast-notification.error .toast-icon {
    color: #e26f6f;
}

.toast-message {
    font-size: 14px;
    color: #212122;
    font-weight: 500;
}
</style>

<script>
 if ($("p:contains('Powered by')").length) {
 $("p:contains('Powered by')").hide();
 }

// Toast notification function
function showToast(message, type) {
    var $toast = $('#toast');
    var $icon = $toast.find('.toast-icon');
    var $message = $toast.find('.toast-message');

    // Set message and type
    $message.text(message);
    $toast.removeClass('success error').addClass(type);

    // Update icon
    if (type === 'success') {
        $icon.removeClass('fa-exclamation-circle').addClass('fa-check-circle');
    } else {
        $icon.removeClass('fa-check-circle').addClass('fa-exclamation-circle');
    }

    // Show toast
    $toast.addClass('show');

    // Hide after 3 seconds
    setTimeout(function() {
        $toast.removeClass('show');
    }, 3000);
}

// Newsletter subscription AJAX handler
$('#subscribeForm').on('submit', function(e) {
    e.preventDefault();

    var $form = $(this);
    var $button = $form.find('.pill-button');
    var originalText = $button.text();
    var email = $form.find('input[name="email"]').val();

    // Basic email validation
    if (!email || !email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
        showToast('Please enter a valid email address', 'error');
        return;
    }

    $button.text('Subscribing...').prop('disabled', true);

    $.ajax({
        url: $form.attr('action'),
        type: 'POST',
        data: $form.serialize(),
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                showToast(response.message, 'success');
                $form.find('input[name="email"]').val('');
            } else {
                showToast(response.message, 'error');
            }
        },
        error: function() {
            showToast('Subscription failed. Please try again.', 'error');
        },
        complete: function() {
            $button.text(originalText).prop('disabled', false);
        }
    });
});
</script>

</body>
</html>
