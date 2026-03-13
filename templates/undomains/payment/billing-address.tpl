<div class="form-group" id="billingAddressChoice" {if !$addingNew}style="display: none"{/if}>
    
    <div class="col-md-12">
        <label class="control-label c-black mergecolor pl-0">{$LANG.billingAddress}</label>
        <label class="radio-inline icheck-label billing-contact-0">
            <input
                    type="radio"
                    class="icheck-button"
                    name="billingcontact"
                    value="0"
                    {if $billingContact == 0} checked{/if}
            >
            <strong class="name">{$client->fullName}</strong>
            <span class="address1">{$client->address1}</span>,
            {if $client->address2}<span class="address2">{$client->address2}</span>,{/if}
            <span class="city">{$client->city}</span>,
            <span class="state">{$client->state}</span>,
            <span class="postcode">{$client->postcode}</span>,
            <span class="country">{$client->country}</span>
        </label>
        <br>
        {foreach $client->contacts()->orderBy('firstname', 'asc')->orderBy('lastname', 'asc')->get() as $contact}
            <label class="radio-inline icheck-label billing-contact-{$contact->id}">
                <input
                        type="radio"
                        class="icheck-button"
                        name="billingcontact"
                        value="{$contact->id}"
                        {if $billingContact == $contact->id} checked{/if}
                >

                <strong class="name">{$contact->fullName}</strong>
                <span class="address1">{$contact->address1}</span>,
                {if $contact->address2}<span class="address2">{$contact->address2}</span>,{/if}
                <span class="city">{$contact->city}</span>,
                <span class="state">{$contact->state}</span>,
                <span class="postcode">{$contact->postcode}</span>,
                <span class="country">{$contact->country}</span>
            </label>
            <br>
        {/foreach}
        <label class="radio-inline icheck-label">
            <input
                    type="radio"
                    class="icheck-button"
                    name="billingcontact"
                    value="new"
                    {if $billingContact === 'new'} checked{/if}
            >
            {$LANG.paymentMethodsManage.addNewBillingAddress}
        </label>
    </div>
</div>

<div id="newBillingAddress" {if !$userDetailsValidationError && $billingcontact !== 'new'} style="display: none"{/if}>
    <div class="form-group cc-billing-address">
        
        <div class="col-md-6">
            <label for="inputFirstName" class="control-label c-black mergecolor">{$LANG.clientareafirstname}</label>
            <input type="text" name="firstname" id="inputFirstName" value="{$firstname}" class="form-control" />
        </div>

        <div class="cc-billing-address">
            <div class="col-md-6">
                <label for="inputLastName" class="control-label c-black mergecolor">{$LANG.clientarealastname}</label>
                <input type="text" name="lastname" id="inputLastName" value="{$lastname}" class="form-control" />
            </div>
        </div>
        <div class="cc-billing-address">
            <div class="col-md-6">
                <label for="inputAddress1" class="control-label c-black mergecolor">{$LANG.clientareaaddress1}</label>
                <input type="text" name="address1" id="inputAddress1" value="{$address1}" class="form-control" />
            </div>
        </div>
        <div class="cc-billing-address">
            <div class="col-md-6">
                <label for="inputAddress2" class="control-label c-black mergecolor">{$LANG.clientareaaddress2}</label>
                <input type="text" name="address2" id="inputAddress2" value="{$address2}" class="form-control" />
            </div>
        </div>
        <div class="cc-billing-address">
            <div class="col-md-6">
                <label for="inputCity" class="control-label c-black mergecolor">{$LANG.clientareacity}</label>
                <input type="text" name="city" id="inputCity" value="{$city}" class="form-control" />
            </div>
        </div>
        <div class="cc-billing-address">
            <div class="col-md-6">
                <label for="inputState" class="control-label c-black mergecolor">{$LANG.clientareastate}</label>
                <input type="text" name="state" id="inputState" value="{$state}" class="form-control" />
            </div>
        </div>
        <div class="cc-billing-address">
            <div class="col-sm-6">
                <label for="inputPostcode" class="control-label c-black mergecolor">{$LANG.clientareapostcode}</label>
                <input type="text" name="postcode" id="inputPostcode" value="{$postcode}" class="form-control" />
            </div>
        </div>
        <div class="cc-billing-address">
            <div class="col-sm-6">
                <label for="inputCountry" class="control-label c-black mergecolor">{$LANG.clientareacountry}</label>
                {$countriesdropdown}
            </div>
        </div>
        <div class="cc-billing-address">
            <div class="col-sm-6">
                <label for="inputPhone" class="control-label c-black mergecolor">{$LANG.clientareaphonenumber}</label>
                <input type="text" name="phonenumber" id="inputPhone" value="{$phonenumber}" class="form-control" />
            </div>
        </div>
    </div>
</div>
