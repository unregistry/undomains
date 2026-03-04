<div class="text-center">
    <p class="section-subheading whitecolor mergecolor">{$LANG.pwresetemailneeded}</p>
</div>

<div class="mt-50">
    <form method="post" action="{routePath('password-reset-validate-email')}" role="form">
        <input type="hidden" name="action" value="reset" />

        <div class="row">
            <div class="col-md-10">
                <div class="form-group">
                    <input type="email" name="email" class="form-control" id="inputEmail" placeholder="{$LANG.enteremail}" autofocus>
                </div>
            </div>

            <div class="col-md-2">
                <div class="form-group">
                    <button type="submit" class="btn btn-default-yellow-fill {$captcha->getButtonClass($captchaForm)}">
                        {$LANG.pwresetsubmit}
                    </button>
                </div>
            </div>

            {if $captcha && $captcha->isEnabled() && $showCaptchaAfterLimit}
                <div class="text-center margin-bottom">
                    {include file="$template/includes/captcha.tpl"}
                </div>
            {/if}

            <div class="form-group text-center">
                <button type="submit" class="btn btn-primary{$captcha->getButtonClass($captchaForm)}">
                <button type="submit" id="resetPasswordButton" {if $showCaptchaAfterLimit}data-captcha-required="true"{/if} class="btn btn-primary{$captcha->getButtonClass($captchaForm)}">
                    {$LANG.pwresetsubmit}
                </button>
            </div>

        </div>
    </form>
</div>


