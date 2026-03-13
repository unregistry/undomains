
<h3 class="mergecolor">{$LANG.kbsuggestions}</h3>
<p class="mergecolor">{$LANG.kbsuggestionsexplanation}</p>


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
        {if $kbarticles || !$kbcats}
        <div class="kbarticles bg-seccolorstyle bg-pratalight noshadow">
            {foreach from=$kbarticles item=kbarticle}
            <a class="mergecolor" href="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}">
                <span class="glyphicon glyphicon-file"></span>
                <div class="d-block">
                    <h4 class="mergecolor"> {$kbarticle.title}</h4>
                    <p class="mergecolor">{$kbarticle.article|truncate:100:"..."}</p>
                </div>
            </a>
            {foreachelse}
            {include file="$template/includes/alert.tpl" type="info" msg=$LANG.knowledgebasenoarticles textcenter=true}
            {/foreach}
        </div>
        {/if}
    </div>
</div>
