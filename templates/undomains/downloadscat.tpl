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
        <h2 class="section-heading mergecolor border-0">{$LANG.knowledgebasecategories} / {$LANG.downloadsfiles}</h2>
        <p class="section-subheading mergecolor">{$LANG.downloadsintrotext}</p>
    </div>


    {if $dlcats}
        <div class="row">
            {foreach $dlcats as $dlcat}
                <div class="col-sm-6">
                    <a href="{routePath('download-by-cat', $dlcat.id, $dlcat.urlfriendlyname)}">
                        <i class="far fa-folder-open"></i>
                        <strong>{$dlcat.name}</strong>
                    </a>
                    ({$dlcat.numarticles})
                    <br>
                    {$dlcat.description}
                </div>
            {foreachelse}
                <div class="col-sm-12">
                    <p class="text-center fontsize3">{$LANG.downloadsnone}</p>
                </div>
            {/foreach}
        </div>
    {/if}

    <div class="list-group">
        {foreach $downloads as $download}
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
