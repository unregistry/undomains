{* TLD Management *}
<div class="unregistry-manager">
    <div class="page-header">
        <h1><i class="fas fa-globe"></i> TLD Management</h1>
        <a href="{$modulelink}" class="btn btn-default pull-right">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">Configured TLDs</h3>
        </div>
        <div class="panel-body">
            <table class="table table-striped table-hover" id="tldTable">
                <thead>
                    <tr>
                        <th>Order</th>
                        <th>TLD</th>
                        <th>Extension</th>
                        <th>Status</th>
                        <th>Mode</th>
                        <th>Register</th>
                        <th>Transfer</th>
                        <th>Renew</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $tlds as $tld}
                    <tr>
                        <td>{$tld.display_order}</td>
                        <td><strong>{$tld.tld}</strong></td>
                        <td><code>{$tld.extension}</code></td>
                        <td>
                            {if $tld.enabled}
                            <span class="label label-success">Enabled</span>
                            {else}
                            <span class="label label-default">Disabled</span>
                            {/if}
                        </td>
                        <td>
                            {if $tld.presale_mode}
                            <span class="label label-info">Pre-Sale</span>
                            {else}
                            <span class="label label-success">Live</span>
                            {/if}
                        </td>
                        <td>${$tld.register_price|default:'0.00'}</td>
                        <td>${$tld.transfer_price|default:'0.00'}</td>
                        <td>${$tld.renew_price|default:'0.00'}</td>
                        <td>
                            <a href="{$modulelink}&action=edit_tld&id={$tld.id}" class="btn btn-xs btn-primary">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                        </td>
                    </tr>
                    {foreachelse}
                    <tr>
                        <td colspan="9" class="text-center text-muted">No TLDs configured.</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>
