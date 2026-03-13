{if empty($dlcats) }
    {include file="$template/includes/alert.tpl" type="info" msg=$LANG.downloadsnone textcenter=true}
{else}

    <form class="mt-50" role="form" method="post" action="{routePath('download-search')}">
        <div class="input-group input-group-lg kb-search overlay">
            <div class="col-md-8 col-md-offset-2 col-xs-10 col-xs-offset-1">
                <input type="text" id="inputDownloadsSearch" name="search" class="form-control" 
                placeholder="{$LANG.downloadssearch}" value="{$searchterm}" />
                <span class="input-group-btn">
                    <input type="submit" id="btnDownloadsSearch" class="btn btn-primary btn-input-padded-responsive initial-transform" value="{$LANG.search}" />
                </span>
            </div>
        </div>
    </form>

    <div class="bg-seccolorstyle bg-white p-50 br-12 mt-5 noshadow">
        <div class="text-center">
            <h2 class="section-heading mergecolor border-0">{$LANG.downloadscategories}</h2>
            <p class="section-subheading mergecolor">{$LANG.downloadsintrotext}</p>
        </div>
        <div class="row">
            {foreach $dlcats as $dlcat}
            <div class="col-sm-6 mergecolor">
                <div class="bg-colorstyle bg-pratalight p-5 br-12 mt-5 noshadow lh-sm">
                    <a class="downfiles" href="{routePath('download-by-cat', $dlcat.id, $dlcat.urlfriendlyname)}">
                        <i class="far fa-folder-open"></i>
                        <strong>{$dlcat.name}</strong>
                    </a>
                    ({$dlcat.numarticles})
                    <br>
                    {$dlcat.description}
                </div>
            </div>
            {foreachelse}
                <div class="bg-colorstyle bg-white p-5 br-12 mt-5 noshadow">
                    <div class="col-sm-12">
                        <p class="text-center fontsize3">{$LANG.downloadsnone}</p>
                    </div>
                </div>
            {/foreach}
        </div>
    </div>

    <div class="bg-seccolorstyle bg-white p-50 br-12 mt-5 noshadow">
        <div class="text-center">
            <h2 class="section-heading mergecolor border-0">{$LANG.downloadspopular}</h2>
        </div>
        <div class="list-group">
            {foreach $mostdownloads as $download}
                <a href="{$download.link}" class="list-group-item">
                    <strong>
                        <i class="fas fa-download"></i>
                        {$download.title}
                        {if $download.clientsonly}
                            <i class="fas fa-lock text-muted"></i>
                        {/if}
                    </strong>
                    <br>
                    {$download.description}
                    <br>
                    <small>{$LANG.downloadsfilesize}: {$download.filesize}</small>
                </a>
            {foreachelse}
                <span class="list-group-item text-center">
                    {$LANG.downloadsnone}
                </span>
            {/foreach}
        </div>
    </div>
{/if}
