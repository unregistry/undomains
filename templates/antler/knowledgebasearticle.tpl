<div class="bg-seccolorstyle bg-white noshadow mt-50 br-12">
    <div class="article-content">
        <h2 class="mergecolor mb-5">{$kbarticle.title}</h2>
        {if $kbarticle.voted}
            {include file="$template/includes/alert.tpl" type="success alert-bordered-left" msg="{lang key="knowledgebaseArticleRatingThanks"}" textcenter=true}
        {/if}

        <div class="kb-article-content">
            <p class="mergecolor">{$kbarticle.text}</p>
        </div>

        {if $kbarticle.editLink}
            <a href="{$kbarticle.editLink}" class="btn btn-default btn-sm pull-right mergecolor">
                <i class="fas fa-pencil-alt fa-fw"></i>
                {$LANG.edit}
            </a>
        {/if}
    </div>
</div>

<ul class="kb-article-details">
    {if $kbarticle.tags }
        <li><i class="fas fa-tag"></i> {$kbarticle.tags}</li>
    {/if}
</ul>
<div class="clearfix"></div>
<div class="kb-rate-article hidden-print bg-seccolorstyle bg-white noshadow">
    <form action="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}" method="post" class="row">
        <div class="col-md-8">
            <input type="hidden" name="useful" value="vote">
            <h4 class="c-black mergecolor">{if $kbarticle.voted}{$LANG.knowledgebaserating}{else}{$LANG.knowledgebasehelpful}{/if} </h4>
            <span class="c-black mergecolor"><i class="ico-heart"></i> {$kbarticle.useful} {$LANG.knowledgebaseratingtext}</span>
    	</div>
        <div class="col-md-4 text-right">
            {if $kbarticle.voted}
                <span class="user-votted">{$kbarticle.useful} {$LANG.knowledgebaseratingtext} ({$kbarticle.votes} {$LANG.knowledgebasevotes})</span>
            {else}
                <button type="submit" name="vote" value="yes" class="btn btn-yes"><i class="ico-user-check"></i> {$LANG.knowledgebaseyes}</button>
                <button type="submit" name="vote" value="no" class="btn btn-no"><i class="ico-user-minus"></i> {$LANG.knowledgebaseno}</button>
            {/if}
    	</div>
    </form>
</div>

<div class="bg-seccolorstyle bg-white br-12 p-50 mt-5 noshadow">
    <div class="row kbcategories">
        <div class="know-bgbox-container">
            <h3 class="mergecolor">{$LANG.knowledgebaserelated}</h3>
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
            <div class="kbarticles bg-seccolorstyle bg-white noshadow mt-5 p-0">
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
            </div>
            {/if}
        </div>
    </div>
</div>
