<form method="post" action="clientarea.php?action=masspay" class="form-horizontal">
    <input type="hidden" name="geninvoice" value="true" />



    <table class="table bg-seccolorstyle bg-white br-12 mt-5 noshadow">
        <thead>
            <tr>
                <th class="mergecolor">{$LANG.invoicesdescription}</th>
                <th class="mergecolor">{$LANG.invoicesamount}</th>
            </tr>
        </thead>
        <tbody class="border-0">
            {foreach from=$invoiceitems key=invid item=invoiceitem}
                <tr>
                    <td colspan="2" class="bg-colorstyle bg-white mergecolor">
                        <strong>{$LANG.invoicenumber} {if $invoiceitem.0.invoicenum}{$invoiceitem.0.invoicenum}{else}{$invid}{/if}</strong>
                        <input type="hidden" name="invoiceids[]" value="{$invid}" />
                    </td>
                </tr>
                {foreach from=$invoiceitem item=item}
                    <tr class="masspay-invoice-detail">
                        <td class="mergecolor">{$item.description}</td>
                        <td class="mergecolor">{$item.amount}</td>
                    </tr>
                {/foreach}
            {foreachelse}
                <tr>
                    <td colspan="6" align="center">{$LANG.norecordsfound}</td>
                </tr>
            {/foreach}
            <tr class="bg-colorstyle bg-white mergecolor">
                <td class="text-right">{$LANG.invoicessubtotal}:</td>
                <td>{$subtotal}</td>
            </tr>
            {if $tax}
                <tr class="bg-colorstyle bg-white mergecolor">
                    <td class="text-right">{$taxrate1}% {$taxname1}:</td>
                    <td>{$tax}</td>
                </tr>
            {/if}
            {if $tax2}
                <tr class="bg-colorstyle bg-white mergecolor">
                    <td class="text-right">{$taxrate2}% {$taxname2}:</td>
                    <td>{$tax2}</td>
                </tr>
            {/if}
            {if $credit}
                <tr class="bg-colorstyle bg-white mergecolor">
                    <td class="text-right">{$LANG.invoicescredit}:</td>
                    <td>{$credit}</td>
                </tr>
            {/if}
            {if $partialpayments}
                <tr class="bg-colorstyle bg-white mergecolor">
                    <td class="text-right">{$LANG.invoicespartialpayments}:</td>
                    <td>{$partialpayments}</td>
                </tr>
            {/if}
            <tr class="bg-colorstyle bg-white mergecolor">
                <td class="text-right">{$LANG.invoicestotaldue}:</td>
                <td>{$total}</td>
            </tr>
        </tbody>
    </table>

    <h3 class="panel-title mergecolor mt-50">{$LANG.masspaymentselectgateway}</h3>

    <div class="row mt-5">
        <div class="col-md-12">
            <div class="masspay-container bg-white mergecolor br-12">

                <label for="paymentmethod" class="control-label c-black">{$LANG.orderpaymentmethod}:</label><br/>
                <fieldset> 
                    <div class="row">
                        <div class="col-md-6 col-xs-12"> 
                            <select name="paymentmethod" id="paymentmethod" class="form-control">
                                {foreach from=$gateways item=gateway}
                                    <option value="{$gateway.sysname}">{$gateway.name}</option>
                                {/foreach}
                            </select>
                        </div>

                        <div class="col-md-6 col-xs-12">
                            <input type="submit" value="{$LANG.masspaymakepayment}" class="btn btn-primary btn-block" id="btnMassPayMakePayment" />
                        </div>
                    </div>
                </fieldset>

            </div>
        </div>
    </div>

</form>
