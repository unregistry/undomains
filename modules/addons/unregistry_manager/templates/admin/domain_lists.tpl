{* Domain Lists Management *}
<div class="unregistry-manager">
    <div class="page-header">
        <h1><i class="fas fa-list"></i> Domain Lists</h1>
        <a href="{$modulelink}" class="btn btn-default pull-right">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    {* Filter Tabs *}
    <ul class="nav nav-tabs">
        <li{if $listType == 'all' || !$listType} class="active"{/if}>
            <a href="{$modulelink}&action=domain_lists&list_type=all">All ({$counts.total})</a>
        </li>
        <li{if $listType == 'reserved'} class="active"{/if}>
            <a href="{$modulelink}&action=domain_lists&list_type=reserved">
                <span class="label label-danger">Reserved</span> ({$counts.reserved})
            </a>
        </li>
        <li{if $listType == 'restricted'} class="active"{/if}>
            <a href="{$modulelink}&action=domain_lists&list_type=restricted">
                <span class="label label-warning">Restricted</span> ({$counts.restricted})
            </a>
        </li>
        <li{if $listType == 'premium'} class="active"{/if}>
            <a href="{$modulelink}&action=domain_lists&list_type=premium">
                <span class="label label-info">Premium</span> ({$counts.premium})
            </a>
        </li>
    </ul>

    {* Add Domain Form *}
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title"><i class="fas fa-plus"></i> Add Domain to List</h3>
        </div>
        <div class="panel-body">
            <form method="post" class="form-horizontal">
                <input type="hidden" name="action" value="add_domain">
                <div class="form-group">
                    <label class="col-sm-2 control-label">Domain</label>
                    <div class="col-sm-6">
                        <input type="text" name="domain" class="form-control" placeholder="e.g., premium.degen or admin.*" required>
                        <span class="help-block">Use * as wildcard (e.g., admin.* matches admin.degen, admin.fio, etc.)</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">TLD (Optional)</label>
                    <div class="col-sm-4">
                        <select name="tld_id" class="form-control">
                            <option value="">All TLDs</option>
                            {foreach $tlds as $tld}
                            <option value="{$tld.id}">{$tld.tld}</option>
                            {/foreach}
                        </select>
                        <span class="help-block">Leave empty to apply to all TLDs</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">List Type</label>
                    <div class="col-sm-4">
                        <select name="list_type" class="form-control" id="listTypeSelect" required>
                            <option value="reserved">Reserved (Cannot be registered)</option>
                            <option value="restricted">Restricted (Requires verification)</option>
                            <option value="premium">Premium (Higher pricing)</option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="premiumPriceGroup" style="display:none">
                    <label class="col-sm-2 control-label">Premium Price</label>
                    <div class="col-sm-3">
                        <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input type="number" name="premium_price" class="form-control" step="0.01" placeholder="0.00">
                        </div>
                    </div>
                </div>
                <div class="form-group" id="restrictionReasonGroup" style="display:none">
                    <label class="col-sm-2 control-label">Restriction Reason</label>
                    <div class="col-sm-6">
                        <input type="text" name="restriction_reason" class="form-control" placeholder="e.g., Requires government documentation">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">Notes</label>
                    <div class="col-sm-6">
                        <textarea name="notes" class="form-control" rows="2" placeholder="Internal notes"></textarea>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add Domain
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    {* Domain List *}
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">Domain List</h3>
        </div>
        <div class="panel-body">
            <table class="table table-striped table-hover" id="domainListTable">
                <thead>
                    <tr>
                        <th>Domain</th>
                        <th>Type</th>
                        <th>TLD</th>
                        <th>Price/Reason</th>
                        <th>Notes</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $domains as $domain}
                    <tr>
                        <td><code>{$domain.domain}</code></td>
                        <td>
                            {if $domain.list_type == 'reserved'}
                            <span class="label label-danger">Reserved</span>
                            {elseif $domain.list_type == 'restricted'}
                            <span class="label label-warning">Restricted</span>
                            {else}
                            <span class="label label-info">Premium</span>
                            {/if}
                        </td>
                        <td>
                            {if $domain.tld_id}
                            {foreach $tlds as $tld}
                            {if $tld.id == $domain.tld_id}{$tld.tld}{/if}
                            {/foreach}
                            {else}
                            <span class="text-muted">All TLDs</span>
                            {/if}
                        </td>
                        <td>
                            {if $domain.list_type == 'premium' && $domain.premium_price}
                            <strong>${$domain.premium_price}</strong>
                            {elseif $domain.list_type == 'restricted' && $domain.restriction_reason}
                            <small>{$domain.restriction_reason|truncate:50}</small>
                            {else}
                            -
                            {/if}
                        </td>
                        <td><small>{$domain.notes|truncate:30|default:'-'}</small></td>
                        <td>{$domain.created_at|date_format:"%Y-%m-%d"}</td>
                        <td>
                            <form method="post" style="display:inline" onsubmit="return confirm('Delete this entry?')">
                                <input type="hidden" name="action" value="delete_domain">
                                <input type="hidden" name="id" value="{$domain.id}">
                                <button type="submit" class="btn btn-xs btn-danger">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                    {foreachelse}
                    <tr>
                        <td colspan="7" class="text-center text-muted">No domains in list.</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
{literal}
document.getElementById('listTypeSelect').addEventListener('change', function() {
    var premiumGroup = document.getElementById('premiumPriceGroup');
    var restrictionGroup = document.getElementById('restrictionReasonGroup');

    if (this.value === 'premium') {
        premiumGroup.style.display = 'block';
        restrictionGroup.style.display = 'none';
    } else if (this.value === 'restricted') {
        premiumGroup.style.display = 'none';
        restrictionGroup.style.display = 'block';
    } else {
        premiumGroup.style.display = 'none';
        restrictionGroup.style.display = 'none';
    }
});
{/literal}
</script>
