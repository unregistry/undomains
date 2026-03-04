<div class="kb-search-background pt-50">
    <form role="form" method="post" action="{routePath('knowledgebase-search')}">
        <div class="input-group input-group-lg kb-search overlay">
            <div class="col-md-8 col-md-offset-2 col-xs-10 col-xs-offset-1">
                <input type="text"  id="inputKnowledgebaseSearch" name="search" class="form-control" placeholder="{$LANG.clientHomeSearchKb}" value="{$searchterm}" />
                <span class="input-group-btn">
                    <input type="submit" id="btnKnowledgebaseSearch" class="btn btn-primary btn-input-padded-responsive" value="{$LANG.search}" />
                </span>
            </div>
        </div>
    </form>
</div>

<div class="bg-seccolorstyle bg-white br-12 p-5 mt-5 noshadow">
    <div class="row kbcategories">
        <div class="know-bgbox-container">
            {if $kbcats}
            {foreach from=$kbcats name=kbcats item=kbcat}
            <div class="col-sm-12">
                <a class="mergecolor" href="{routePath('knowledgebase-category-view', {$kbcat.id}, {$kbcat.urlfriendlyname})}">
                    <i class="ico-file"></i>
                    {$kbcat.name} <span>{$kbcat.numarticles} {$LANG.knowledgebasearticles}</Span>
                </a>
                <p class="mergecolor">{$kbcat.description}</p>
            </div>
            {/foreach}
            {/if}
        </div>
    </div>
</div>

<div class="know-bgbox-container">
    <div class="kbarticles bg-seccolorstyle bg-white noshadow mt-5">
    {if $kbarticles || !$kbcats}
        {foreach from=$kbarticles item=kbarticle}
        <a class="mergecolor br-12" href="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}">
            <span class="glyphicon glyphicon-file"></span>
            <div class="d-block">
                <h4 class="mergecolor"> {$kbarticle.title}</h4>
                <p class="mergecolor">{$kbarticle.article|truncate:100:"..."}</p>
            </div>
        </a>
        {foreachelse}
        {include file="$template/includes/alert.tpl" type="info" msg=$LANG.knowledgebasenoarticles textcenter=true}
        {/foreach}
    {/if}
    </div>
</div>