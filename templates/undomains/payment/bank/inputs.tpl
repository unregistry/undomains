<div class="form-group bank-details{if !$addingNew} hidden{/if}">
    
    <div class="col-md-6">
        <label for="inputBankAcctType" class="control-label">{lang key='paymentMethodsManage.accountType'}</label>
        <label class="radio-inline icheck-label">
            <input type="radio" class="icheck-button" name="account_type" id="inputBankAcctType" value="Checking"{if !$accountType || $accountType == 'Checking'} checked{/if}>
            {lang key='paymentMethodsManage.checking'}
        </label>
        <label class="radio-inline icheck-label">
            <input type="radio" class="icheck-button" name="account_type" value="Savings"{if $accountType == 'Savings'} checked{/if}>
            {lang key='paymentMethodsManage.savings'}
        </label>
    </div>

    <div class="bank-details{if !$addingNew} hidden{/if}">
        <div class="col-md-6">
            <label for="inputBankAcctHolderName" class="control-label">{lang key='paymentMethodsManage.accountHolderName'}</label>
            <input type="tel" class="form-control" id="inputBankAcctHolderName" name="account_holder_name" autocomplete="off" value="{$accountHolderName}">
            <span class="field-error-msg">{lang key='paymentMethods.fieldRequired'}</span>
        </div>
    </div>

    <div class="bank-details{if !$addingNew} hidden{/if}">
        <div class="col-sm-7">
            <label for="inputBankName" class="control-label">{lang key='paymentMethodsManage.bankName'}</label>
            <input type="tel" class="form-control" id="inputBankName" name="bank_name" autocomplete="off" value="{$bankName}">
            <span class="field-error-msg">{lang key='paymentMethods.fieldRequired'}</span>
        </div>
    </div>

    <div class="bank-details{if !$addingNew} hidden{/if}">
        <div class="col-md-6">
            <label for="inputBankRoutingNum" class="control-label">{lang key='paymentMethodsManage.sortCodeRoutingNumber'}</label>
            <input type="tel" class="form-control" id="inputBankRoutingNum" name="routing_number" autocomplete="off" value="{$routingNumber}">
            <span class="field-error-msg">
                {lang key='paymentMethodsManage.routingNumberNotValid'}
            </span>
        </div>
    </div>

    <div class="bank-details{if !$addingNew} hidden{/if}">
        
        <div class="col-md-6">
            <label for="inputBankAcctNum" class="control-label">{lang key='paymentMethodsManage.accountNumber'}</label>
            <input type="tel" class="form-control" id="inputBankAcctNum" name="account_number" autocomplete="off" value="{$accountNumber}">
            <span class="field-error-msg">
                {lang key='paymentMethodsManage.accountNumberNotValid'}
            </span>
        </div>
    </div>
</div>

<div id="inputDescriptionContainer" class="form-group bank-details{if !$addingNew} hidden{/if}">
    <div class="col-sm-6">
        <label for="inputDescription" class="control-label">{lang key='paymentMethods.description'}</label>
        <input type="text"
               class="form-control"
               id="inputDescription"
               name="description"
               autocomplete="off"
               value="{$description}"
               placeholder="{lang key='paymentMethodsManage.optional'}"
        >
    </div>
</div>
{include file="$template/payment/billing-address.tpl"}
