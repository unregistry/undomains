{if in_array('state', $optionalFields)}
<script>
var statesTab = 10;
var stateNotRequired = true;
</script>
{/if}
<script type="text/javascript" src="{$BASE_PATH_JS}/StatesDropdown.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/PasswordStrength.js"></script>
<script>
window.langPasswordStrength = "{$LANG.pwstrength}";
window.langPasswordWeak = "{$LANG.pwstrengthweak}";
window.langPasswordModerate = "{$LANG.pwstrengthmoderate}";
window.langPasswordStrong = "{$LANG.pwstrengthstrong}";
jQuery(document).ready(function()
{
jQuery("#inputNewPassword1").keyup(registerFormPasswordStrengthFeedback);
});
</script>
<div class="loginpage sec-bg3 motpath fullrock-content bg-colorstyle">
    <div class="container">
        <div class="row login-page-header">
            <a class="navbar-brand" href="{$WEB_ROOT}/index.php">
                <img class="logo-menu img-fluid d-block" src="{$WEB_ROOT}/templates/{$template}/assets/img/undomains-logo.svg" alt="{$companyname}" style="height: 50px; width: auto;">
            </a>
            <a href="{$WEB_ROOT}/login.php"> <i class="ico-unlock" data-toggle="tooltip" data-placement="left" title="{$LANG.alreadyregistered}"></i> </a>
        </div>

        <div class="logincontent">
            <div class="login-wrapper">
                <div class="login-form-container sec-main sec-bg1 tabs bg-seccolorstyle noshadow">
                    {if $registrationDisabled}
                    {include file="$template/includes/alert.tpl" type="error" msg=$LANG.registerCreateAccount|cat:' <strong><a href="'|cat:"$WEB_ROOT"|cat:'/cart.php" class="alert-link">'|cat:$LANG.registerCreateAccountOrder|cat:'</a></strong>'}
                    {/if}
                    {if $errormessage}
                    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
                    {/if}
                    {if !$registrationDisabled}
                    
                    <div class="text-center">
                        <h2 class="section-heading whitecolor mergecolor">{$LANG.registerintro}</h2>
                        <p class="section-subheading whitecolor mergecolor">{$LANG.restrictedpage}</p>
                    </div>
                    
                    <div id="registration" class="mt-50">
                        <form method="post" class="using-password-strength" action="{$smarty.server.PHP_SELF}" role="form" name="orderfrm" id="frmCheckout">
                            
                            <input type="hidden" name="register" value="true"/>
                            <div id="containerNewUserSignup">
                                {include file="$template/includes/linkedaccounts.tpl" linkContext="registration"}
                                
                                <div class="divider mb-15">
                                    <span></span>
                                    <span>{$LANG.orderForm.personalInformation}</span>
                                    <span></span>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <input type="text" name="firstname" id="inputFirstName" class="field form-control" placeholder="{$LANG.orderForm.firstName}" value="{$clientfirstname}" {if !in_array('firstname', $optionalFields)}required{/if} autofocus>
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <input type="text" name="lastname" id="inputLastName" class="field form-control" placeholder="{$LANG.orderForm.lastName}" value="{$clientlastname}" {if !in_array('lastname', $optionalFields)}required{/if}>
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <input type="email" name="email" id="inputEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$clientemail}">
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <input type="tel" name="phonenumber" id="inputPhone" class="field" placeholder="{$LANG.orderForm.phoneNumber}" value="{$clientphonenumber}">
                                        </div>
                                    </div>
                                </div>

                                <div class="divider mb-15">
                                    <span></span>
                                    <span>{$LANG.orderForm.billingAddress}</span>
                                    <span></span>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <input type="text" name="companyname" id="inputCompanyName" class="field" placeholder="{$LANG.orderForm.companyName} ({$LANG.orderForm.optional})" value="{$clientcompanyname}">
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <input type="text" name="address1" id="inputAddress1" class="field form-control" placeholder="{$LANG.orderForm.streetAddress}" value="{$clientaddress1}"  {if !in_array('address1', $optionalFields)}required{/if}>
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <input type="text" name="address2" id="inputAddress2" class="field" placeholder="{$LANG.orderForm.streetAddress2}" value="{$clientaddress2}">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <input type="text" name="city" id="inputCity" class="field form-control" placeholder="{$LANG.orderForm.city}" value="{$clientcity}"  {if !in_array('city', $optionalFields)}required{/if}>
                                        </div>
                                    </div>
                                    <div class="col-sm-5">
                                        <div class="form-group">
                                            <input type="text" name="state" id="state" class="field form-control" placeholder="{$LANG.orderForm.state}" value="{$clientstate}"  {if !in_array('state', $optionalFields)}required{/if}>
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <input type="text" name="postcode" id="inputPostcode" class="field form-control" placeholder="{$LANG.orderForm.postcode}" value="{$clientpostcode}" {if !in_array('postcode', $optionalFields)}required{/if}>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <select name="country" id="inputCountry" class="field form-control">
                                                {foreach $clientcountries as $countryCode => $countryName}
                                                <option value="{$countryCode}"{if (!$clientcountry && $countryCode eq $defaultCountry) || ($countryCode eq $clientcountry)} selected="selected"{/if}>
                                                    {$countryName}
                                                </option>
                                                {/foreach}
                                            </select>
                                        </div>
                                    </div>
                                    {if $showTaxIdField}
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <input type="text" name="tax_id" id="inputTaxId" class="field" placeholder="{$taxLabel} ({$LANG.orderForm.optional})" value="{$clientTaxId}">
                                        </div>
                                    </div>
                                    {/if}
                                </div>
                            </div>
                            {if $customfields || $currencies}

                            <div class="divider mb-15">
                                <span></span>
                                <span>{$LANG.orderadditionalrequiredinfo}<br><i><small>{lang key='orderForm.requiredField'}</small></i></span>
                                <span></span>
                            </div>

                            <div class="row">
                                {if $customfields}
                                {foreach $customfields as $customfield}
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="customfield{$customfield.id}">{$customfield.name} {$customfield.required}</label>
                                        <div class="control">
                                            {$customfield.input}
                                            {if $customfield.description}
                                            <span class="field-help-text">{$customfield.description}</span>
                                            {/if}
                                        </div>
                                    </div>
                                </div>
                                {/foreach}
                                {/if}
                                {if $customfields && count($customfields)%2 > 0 }
                                <div class="clearfix"></div>
                                {/if}
                                {if $currencies}
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <select id="inputCurrency" name="currency" class="field form-control">
                                            {foreach from=$currencies item=curr}
                                            <option value="{$curr.id}"{if !$smarty.post.currency && $curr.default || $smarty.post.currency eq $curr.id } selected{/if}>{$curr.code}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                                {/if}
                            </div>
                            {/if}

                            {if isset($accountDetailsExtraFields) && !empty($accountDetailsExtraFields)}
                                <div class="sub-heading">
                                    <span>{lang key='orderForm.additionalInformation'}</span>
                                </div>
                                <div class="row">
                                    {foreach $accountDetailsExtraFields as $field}
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                {$field.input}
                                            </div>
                                        </div>
                                    {/foreach}
                                </div>
                            {/if}
            
                            <div id="containerNewUserSecurity" {if $remote_auth_prelinked && !$securityquestions } class="hidden"{/if}>

                                <div class="divider mb-15">
                                    <span></span>
                                    <span>{$LANG.orderForm.accountSecurity}</span>
                                    <span></span>
                                </div>

                                <div id="containerPassword" class="row{if $remote_auth_prelinked && $securityquestions} hidden{/if}">
                                    <div id="passwdFeedback" style="display: none;" class="alert alert-info text-center col-sm-12"></div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <input type="password" name="password" id="inputNewPassword1" data-error-threshold="{$pwStrengthErrorThreshold}" data-warning-threshold="{$pwStrengthWarningThreshold}" class="field" placeholder="{$LANG.clientareapassword}" autocomplete="off"{if $remote_auth_prelinked} value="{$password}"{/if}>
                                            <button data-toggle="tooltip" data-placement="left" title="" data-original-title="{$LANG.generatePassword.btnLabel}" type="button" class="generate-password" data-targetfields="inputNewPassword1,inputNewPassword2"><i class="icon-lock"></i></button>
                                            <div class="password-strength-meter">
                                                <div class="progress">
                                                    <div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" id="passwordStrengthMeterBar">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <input type="password" name="password2" id="inputNewPassword2" class="field" placeholder="{$LANG.clientareaconfirmpassword}" autocomplete="off"{if $remote_auth_prelinked} value="{$password}"{/if}>
                                        </div>
                                    </div>
                                    
                                </div>
                                {if $securityquestions}
                                <div class="row">
                                    <div class="form-group col-sm-12">
                                        <select name="securityqid" id="inputSecurityQId" class="field form-control">
                                            <option value="">{$LANG.clientareasecurityquestion}</option>
                                            {foreach $securityquestions as $question}
                                            <option value="{$question.id}"{if $question.id eq $securityqid} selected{/if}>
                                                {$question.question}
                                            </option>
                                            {/foreach}
                                        </select>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <input type="password" name="securityqans" id="inputSecurityQAns" class="field form-control" placeholder="{$LANG.clientareasecurityanswer}" autocomplete="off">
                                        </div>
                                    </div>
                                </div>
                                {/if}
                            </div>
                            {if $showMarketingEmailOptIn}
                            <div class="marketing-email-optin bg-colorstyle">
                                <h2 class="mergecolor">{lang key='emailMarketing.joinOurMailingList'}</h2>
                                <p class="mergecolor">{$marketingEmailOptInMessage}</p>
                                <input type="checkbox" name="marketingoptin" value="1"{if $marketingEmailOptIn} checked{/if} class="no-icheck toggle-switch-success" data-size="small" data-on-text="{lang key='yes'}" data-off-text="{lang key='no'}">
                            </div>
                            {/if}
                            {include file="$template/includes/captcha.tpl"}
                            <br/>
                            {if $accepttos}
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="panel panel-danger tospanel border-0">
                                        <div class="panel-heading bg-colorstyle">
                                            <h3 class="panel-title mergecolor"><span class="fas fa-exclamation-triangle tosicon"></span> &nbsp; {$LANG.ordertos}</h3>
                                        </div>
                                        <div class="panel-body">
                                            <div class="list d-inline custom-control custom-checkbox">
                                                <input type="checkbox" class="custom-control-input accepttos" name="accepttos" id="rememberme">
                                                <label class="custom-control-label" for="rememberme">{$LANG.ordertosagreement}</label>
                                                <a class="c-pink" href="{$tosurl}" target="_blank">{$LANG.ordertos}</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            {/if}
                            <input class="btn btn-default-yellow-fill {$captcha->getButtonClass($captchaForm)}" type="submit" value="{$LANG.clientregistertitle}"/>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {/if}