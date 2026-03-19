{* Order Queue Management *}
<div class="unregistry-manager">
    <div class="page-header">
        <h1><i class="fas fa-tasks"></i> Order Queue</h1>
        <a href="{$modulelink}" class="btn btn-default pull-right">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    {* Filter Tabs *}
    <ul class="nav nav-tabs">
        <li{if $filter == 'all' || !$filter} class="active"{/if}>
            <a href="{$modulelink}&action=order_queue&filter=all">All ({$counts.total})</a>
        </li>
        <li{if $filter == 'queued'} class="active"{/if}>
            <a href="{$modulelink}&action=order_queue&filter=queued">Queued ({$counts.queued})</a>
        </li>
        <li{if $filter == 'processing'} class="active"{/if}>
            <a href="{$modulelink}&action=order_queue&filter=processing">Processing ({$counts.processing})</a>
        </li>
        <li{if $filter == 'completed'} class="active"{/if}>
            <a href="{$modulelink}&action=order_queue&filter=completed">Completed ({$counts.completed})</a>
        </li>
        <li{if $filter == 'failed'} class="active"{/if}>
            <a href="{$modulelink}&action=order_queue&filter=failed">Failed ({$counts.failed})</a>
        </li>
    </ul>

    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">Pre-Order Queue</h3>
        </div>
        <div class="panel-body">
            <table class="table table-striped table-hover" id="queueTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Domain</th>
                        <th>TLD</th>
                        <th>Action</th>
                        <th>Years</th>
                        <th>Status</th>
                        <th>Queued</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $orders as $order}
                    <tr>
                        <td>{$order.id}</td>
                        <td><strong>{$order.domain}</strong></td>
                        <td>{$order.tld}</td>
                        <td>
                            {if $order.action == 'register'}
                            <span class="label label-primary">Register</span>
                            {elseif $order.action == 'transfer'}
                            <span class="label label-info">Transfer</span>
                            {else}
                            <span class="label label-default">Renew</span>
                            {/if}
                        </td>
                        <td>{$order.years}</td>
                        <td>
                            {if $order.status == 'queued'}
                            <span class="label label-info">Queued</span>
                            {elseif $order.status == 'processing'}
                            <span class="label label-warning">Processing</span>
                            {elseif $order.status == 'completed'}
                            <span class="label label-success">Completed</span>
                            {else}
                            <span class="label label-danger">Failed</span>
                            {/if}
                        </td>
                        <td>{$order.queued_at|date_format:"%Y-%m-%d %H:%M"}</td>
                        <td>
                            {if $order.status == 'queued'}
                            <form method="post" style="display:inline">
                                <input type="hidden" name="action" value="process_order">
                                <input type="hidden" name="order_id" value="{$order.id}">
                                <button type="submit" class="btn btn-xs btn-success" onclick="return confirm('Process this order?')">
                                    <i class="fas fa-play"></i> Process
                                </button>
                            </form>
                            {/if}
                            {if $order.status == 'failed'}
                            <form method="post" style="display:inline">
                                <input type="hidden" name="action" value="retry_order">
                                <input type="hidden" name="order_id" value="{$order.id}">
                                <button type="submit" class="btn btn-xs btn-warning">
                                    <i class="fas fa-redo"></i> Retry
                                </button>
                            </form>
                            {/if}
                            <a href="{$modulelink}&action=view_order&id={$order.id}" class="btn btn-xs btn-default">
                                <i class="fas fa-eye"></i> View
                            </a>
                        </td>
                    </tr>
                    {foreachelse}
                    <tr>
                        <td colspan="8" class="text-center text-muted">No orders in queue.</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>

    {if $pagination}
    <div class="text-center">
        {$pagination}
    </div>
    {/if}
</div>
