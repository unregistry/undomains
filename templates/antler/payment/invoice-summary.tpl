<div id="invoiceIdSummary" class="invoice-summary bg-seccolorstyle mergecolor border-0 p-5">
    <h2 class="text-center">
        <b>{$LANG.invoicenumber}{if $invoicenum}{$invoicenum}{else}{$invoiceid}{/if}</b>
    </h2>
    
    <div class="invoice-summary-table table-resposnsive">
        <table class="table table-list">
            <thead>
            <tr>
                <td class="text-left"><strong>{$LANG.invoicesdescription}</strong></td>
                <td width="150" class="text-center"><strong>{$LANG.invoicesamount}</strong></td>
            </tr>
            </thead>
            <tbody>
            {foreach $invoiceitems as $item}
                <tr>
                    <td>{$item.description}</td>
                    <td class="text-center">{$item.amount}</td>
                </tr>
            {/foreach}
            <tr>
                <td class="total-row text-right">{$LANG.invoicessubtotal}</td>
                <td class="total-row text-center">{$invoice.subtotal}</td>
            </tr>
            {if $invoice.taxrate}
                <tr>
                    <td class="total-row text-right">{$invoice.taxrate}% {$invoice.taxname}</td>
                    <td class="total-row text-center">{$invoice.tax}</td>
                </tr>
            {/if}
            {if $invoice.taxrate2}
                <tr>
                    <td class="total-row text-right">{$invoice.taxrate2}% {$invoice.taxname2}</td>
                    <td class="total-row text-center">{$invoice.tax2}</td>
                </tr>
            {/if}
            <tr>
                <td class="total-row text-right">{$LANG.invoicescredit}</td>
                <td class="total-row text-center">{$invoice.credit}</td>
            </tr>
            <tr>
                <td class="total-row text-right">{$LANG.invoicestotaldue}</td>
                <td class="total-row text-center">{$invoice.total}</td>
            </tr>
            </tbody>
        </table>
    </div>

    <p class="text-center">
        {$LANG.paymentstodate}: <strong>{$invoice.amountpaid}</strong><br /><br />
        {$LANG.balancedue}: <strong>{$balance}</strong>
    </p>
</div>
