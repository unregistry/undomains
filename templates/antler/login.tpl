<div class="loginpage sec-bg3 motpath fullrock-content bg-colorstyle">
    <div class="container">
        
        <div class="row login-page-header">
            <a class="navbar-brand" href="{$WEB_ROOT}/index.php">
              <img class="svg logo-menu d-block" src="{$WEB_ROOT}/templates/{$template}/assets/img/logo.svg" alt="{$companyname}">
              <img class="svg logo-menu d-none" src="{$WEB_ROOT}/templates/{$template}/assets/img/logo-light.svg" alt="{$companyname}">
            </a>
            <a href="{$WEB_ROOT}/register.php"> <i class="ico-user-plus" data-toggle="tooltip" data-placement="left" title="{$LANG.registerintro}"></i> </a>
        </div>

        <div class="logincontent">
            <div class="login-wrapper">
                <div class="login-form-container sec-main sec-bg1 tabs bg-seccolorstyle noshadow">
                    {include file="$template/includes/flashmessage.tpl"}
                    
                    <div class="text-center">
                        <h2 class="section-heading whitecolor mergecolor">{$LANG.clientareahomeloginbtn}</h2>
                        <p class="section-subheading whitecolor mergecolor">{$LANG.restrictedpage}</p>
                    </div>

                    <div class="mt-50">
                        <div class="{if !$linkableProviders}hidden{/if}">
                            {include file="$template/includes/linkedaccounts.tpl" linkContext="login" customFeedback=true}
                            <div class="divider">
                                <span></span>
                                <span>{$LANG.remoteAuthn.titleOr}</span>
                                <span></span>
                            </div>
                        </div>
                        <div class="providerLinkingFeedback mx-3"></div>
                        <form method="post" action="{routePath('login-validate')}" class="login-form" role="form">

                            <div class="col-md-6">
                                <div class="form-group">
                                    <input type="email" name="username" class="form-control" id="inputEmail" placeholder="{$LANG.pwresetemailrequired}" autofocus>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <input type="password" name="password" class="form-control" id="inputPassword" placeholder="{$LANG.twofaconfirmpw}" autocomplete="off" >
                                </div>
                            </div>

                            <div class="col-md-12 mt-5 position-relative aitems-center">
                                <button type="submit" id="login" value="login" class="btn btn-default-yellow-fill mt-0 me-5 {$captcha->getButtonClass($captchaForm)}"> 
                                    <span class="me-2">{$LANG.loginbutton}</span>
                                    <i class="fas fa-lock"></i>
                                </button>
                                <a class="golink me-5 position-relative forgotpw-txt" href="{routePath('password-reset-begin')}">{$LANG.forgotpw}</a>
                                <div class="list d-inline custom-control custom-checkbox">
                                    <input type="checkbox" class="custom-control-input" name="rememberme" id="rememberme">
                                    <label class="custom-control-label mb-0" for="rememberme">{$LANG.loginrememberme}</label>
                                </div>
                            </div>
                            {if $captcha->isEnabled()}
                            <div class="text-center margin-bottom">
                                {include file="$template/includes/captcha.tpl"}
                            </div>
                            {/if}
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>