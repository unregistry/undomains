{if $errorMessageHtml}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errorMessageHtml}
{/if}

<script>
var stateNotRequired = true;
jQuery(document).ready(function() {
    WHMCS.form.register();
});
</script>
<script src="{$BASE_PATH_JS}/StatesDropdown.js"></script>

<div class="bg-seccolorstyle bg-white noshadow mt-50 p-50 br-12">

    <div class="alert alert-block bg-colorstyle bg-pratalight p-5 br-12">
        <form class="form-horizontal" role="form" method="post" action="{routePath('account-contacts')}">
            <label for="inputContactId" class="col-sm-3 w-100 control-label c-black mergecolor m-0">{$LANG.clientareachoosecontact}</label>
            <div class="row">
                <div class="col-md-6">
                    <select name="contactid" id="inputContactId" onchange="submit()" class="form-control">
                        {foreach $contacts as $contact}
                            <option value="{$contact.id}">{$contact.name} - {$contact.email}</option>
                        {/foreach}
                        <option value="new" selected="selected">{$LANG.clientareanavaddcontact}</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <button type="submit" class="btn btn-default btn-block">{$LANG.go}</button>
                </div>
            </div>
        </form>
    </div>

    <form role="form" method="post" action="{routePath('account-contacts-new')}">

        <div class="row">
            <div class="col-sm-6">

                <div class="form-group">
                    <label for="inputFirstName" class="control-label c-black mergecolor">{$LANG.clientareafirstname}</label>
                    <input type="text" name="firstname" id="inputFirstName" value="{$formdata.firstname}" class="form-control" />
                </div>

                <div class="form-group">
                    <label for="inputLastName" class="control-label c-black mergecolor">{$LANG.clientarealastname}</label>
                    <input type="text" name="lastname" id="inputLastName" value="{$formdata.lastname}" class="form-control" />
                </div>

                <div class="form-group">
                    <label for="inputCompanyName" class="control-label c-black mergecolor">{$LANG.clientareacompanyname}</label>
                    <input type="text" name="companyname" id="inputCompanyName" value="{$formdata.companyname}" class="form-control" />
                </div>

                <div class="form-group">
                    <label for="inputEmail" class="control-label c-black mergecolor">{$LANG.clientareaemail}</label>
                    <input type="email" name="email" id="inputEmail" value="{$formdata.email}" class="form-control" />
                </div>

                <div class="form-group">
                    <label for="inputPhone" class="control-label c-black mergecolor">{$LANG.clientareaphonenumber}</label>
                    <input type="tel" name="phonenumber" id="inputPhone" value="{$formdata.phonenumber}" class="form-control" />
                </div>

                {if $showTaxIdField}
                    <div class="form-group">
                        <label for="inputTaxId" class="control-label c-black mergecolor">{lang key=$taxIdLabel}</label>
                        <input type="text" name="tax_id" id="inputTaxId" class="form-control" value="{$formdata.tax_id}" />
                    </div>
                {/if}

            </div>
            <div class="col-sm-6 col-xs-12 pull-right">

                <div class="form-group">
                    <label for="inputAddress1" class="control-label c-black mergecolor">{$LANG.clientareaaddress1}</label>
                    <input type="text" name="address1" id="inputAddress1" value="{$formdata.address1}" class="form-control" />
                </div>

                <div class="form-group">
                    <label for="inputAddress2" class="control-label c-black mergecolor">{$LANG.clientareaaddress2}</label>
                    <input type="text" name="address2" id="inputAddress2" value="{$formdata.address2}" class="form-control" />
                </div>

                <div class="form-group">
                    <label for="inputCity" class="control-label c-black mergecolor">{$LANG.clientareacity}</label>
                    <input type="text" name="city" id="inputCity" value="{$formdata.city}" class="form-control" />
                </div>

                <div class="form-group">
                    <label for="inputState" class="control-label c-black mergecolor">{$LANG.clientareastate}</label>
                    <input type="text" name="state" id="inputState" value="{$formdata.state}" class="form-control" />
                </div>

                <div class="form-group">
                    <label for="inputPostcode" class="control-label c-black mergecolor">{$LANG.clientareapostcode}</label>
                    <input type="text" name="postcode" id="inputPostcode" value="{$formdata.postcode}" class="form-control" />
                </div>

                <div class="form-group">
                    <label class="control-label c-black mergecolor" for="country">{$LANG.clientareacountry}</label>
                    {$countriesdropdown}
                </div>

            </div>
        </div>

        <div class="form-group bg-colorstyle bg-pratalight p-50 br-12 mt-5">
            <h3 class="mergecolor mb-5">{$LANG.clientareacontactsemails}</h3>
            <div class="controls checkbox">
                {foreach $formdata.emailPreferences as $emailType => $value}
                    <label class="mergecolor">
                    <input class="p-relative mb-0 mr-20" type="hidden" name="email_preferences[{$emailType}]" value="0">
                    <input class="p-relative mb-0 mr-20" type="checkbox" name="email_preferences[{$emailType}]" id="{$emailType}emails" value="1"{if $value} checked="checked"{/if} />
                    {lang key="clientareacontactsemails"|cat:$emailType}
                    </label>{if !($emailType@last)}<br />{/if}
                {/foreach}
            </div>
        </div>

        <div class="form-group">
            <input class="btn btn-primary mr-5" type="submit" name="save" value="{$LANG.clientareasavechanges}" />
            <input class="btn btn-default" type="reset" value="{$LANG.cancel}" />
        </div>

    </form>

</div>
