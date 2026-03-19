{* Unregistry Manager Dashboard *}
<div class="unregistry-manager">
    <div class="page-header">
        <h1><i class="fas fa-globe"></i> Unregistry TLD Manager</h1>
    </div>

    {* Statistics Boxes *}
    <div class="row">
        <div class="col-sm-6 col-md-3">
            <div class="panel panel-primary">
                <div class="panel-body text-center">
                    <h2 class="panel-title">{$stats.totalTlds}</h2>
                    <p class="text-muted">Active TLDs</p>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div class="panel panel-success">
                <div class="panel-body text-center">
                    <h2 class="panel-title">{$stats.queuedOrders}</h2>
                    <p class="text-muted">Queued Orders</p>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div class="panel panel-warning">
                <div class="panel-body text-center">
                    <h2 class="panel-title">{$stats.reservedDomains}</h2>
                    <p class="text-muted">Reserved Domains</p>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3">
            <div class="panel panel-info">
                <div class="panel-body text-center">
                    <h2 class="panel-title">{$stats.premiumDomains}</h2>
                    <p class="text-muted">Premium Domains</p>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            {* Recent Orders *}
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fas fa-clock"></i> Recent Pre-Orders</h3>
                </div>
                <div class="panel-body">
                    {if $recentOrders}
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Domain</th>
                                <th>TLD</th>
                                <th>Action</th>
                                <th>Queued</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $recentOrders as $order}
                            <tr>
                                <td><strong>{$order.domain}</strong></td>
                                <td>{$order.tld}</td>
                                <td>{$order.action}</td>
                                <td>{$order.queued_at}</td>
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
                            </tr>
                            {/foreach}
                        </tbody>
                    </table>
                    {else}
                    <p class="text-muted text-center">No pre-orders yet.</p>
                    {/if}
                </div>
            </div>

            {* Configured TLDs *}
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fas fa-globe"></i> Configured TLDs</h3>
                </div>
                <div class="panel-body">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>TLD</th>
                                <th>Status</th>
                                <th>Pre-Sale</th>
                                <th>Register Price</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $tlds as $tld}
                            <tr>
                                <td><strong>{$tld.tld}</strong></td>
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
                                <td>
                                    <a href="{$modulelink}&action=edit_tld&id={$tld.id}" class="btn btn-xs btn-default">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                </td>
                            </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            {* Quick Actions *}
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fas fa-bolt"></i> Quick Actions</h3>
                </div>
                <div class="list-group">
                    <a href="{$modulelink}&action=tlds" class="list-group-item">
                        <i class="fas fa-globe"></i> Manage TLDs
                    </a>
                    <a href="{$modulelink}&action=domain_lists" class="list-group-item">
                        <i class="fas fa-list"></i> Domain Lists
                    </a>
                    <a href="{$modulelink}&action=order_queue" class="list-group-item">
                        <i class="fas fa-tasks"></i> Order Queue
                    </a>
                    <a href="{$modulelink}&action=settings" class="list-group-item">
                        <i class="fas fa-cog"></i> Settings
                    </a>
                </div>
            </div>

            {* Domain List Summary *}
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fas fa-shield-alt"></i> Domain Protection</h3>
                </div>
                <ul class="list-group">
                    <li class="list-group-item">
                        <span class="badge">{$stats.reservedDomains}</span>
                        Reserved Domains
                    </li>
                    <li class="list-group-item">
                        <span class="badge">{$stats.restrictedDomains}</span>
                        Restricted Domains
                    </li>
                    <li class="list-group-item">
                        <span class="badge">{$stats.premiumDomains}</span>
                        Premium Domains
                    </li>
                </ul>
            </div>

            {* Queue Summary *}
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fas fa-shopping-cart"></i> Order Queue</h3>
                </div>
                <ul class="list-group">
                    <li class="list-group-item">
                        <span class="badge badge-info">{$stats.queuedOrders}</span>
                        Queued
                    </li>
                    <li class="list-group-item">
                        <span class="badge badge-warning">{$stats.processingOrders}</span>
                        Processing
                    </li>
                    <li class="list-group-item">
                        <span class="badge badge-success">{$stats.completedOrders}</span>
                        Completed
                    </li>
                    <li class="list-group-item">
                        <span class="badge badge-danger">{$stats.failedOrders}</span>
                        Failed
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
