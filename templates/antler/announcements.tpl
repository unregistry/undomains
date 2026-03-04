{if $announcementsFbRecommend}
    <script>
        (function(d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) {
                return;
            }
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/{$LANG.locale}/all.js#xfbml=1";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    </script>
{/if}


<section class="services overview-services sec-normal p-0">
    <div class="service-wrap">
        <div class="row">
        {foreach from=$announcements item=announcement}
            <div class="col-md-12 col-lg-4" data-aos="fade-up" data-aos-duration="1000">
                <div class="service-section bg-seccolorstyle bg-white noshadow">
                    <span class="badge feat bg-pink">{$carbon->createFromTimestamp($announcement.timestamp)->format('jS M Y')} </span>
                    <div class="title mergecolor">{$announcement.title}</div>
                    {if $announcement.text|strip_tags|strlen < 350}
                        <p class="subtitle seccolor">{$announcement.text}</p>
                    {else}
                        <p class="subtitle seccolor">{$announcement.summary}</p>
                    {/if}
                    {if $announcementsFbRecommend}
                        <div class="fb-like hidden-sm hidden-xs" data-layout="standard" data-href="{fqdnRoutePath('announcement-view', $announcement.id, $announcement.urlfriendlytitle)}" data-send="true" data-width="450" data-show-faces="true" data-action="recommend"></div>
                        <div class="fb-like hidden-lg hidden-md" data-layout="button_count" data-href="{fqdnRoutePath('announcement-view', $announcement.id, $announcement.urlfriendlytitle)}" data-send="true" data-width="450" data-show-faces="true" data-action="recommend"></div>
                    {/if}
                    <a href="{routePath('announcement-view', $announcement.id, $announcement.urlfriendlytitle)}" class="btn btn-default-yellow-fill">{$LANG.news}</a>
                </div>
            </div>
        {foreachelse}
    </div>
</section>

{include file="$template/includes/alert.tpl" type="info" msg="{$LANG.noannouncements}" textcenter=true}
{/foreach}

{if $prevpage || $nextpage}
    <div class="col-xs-12 margin-bottom">
        <form class="form-inline" role="form">
            <div class="form-group">
                <div class="input-group">
                    <span class="btn-group">
                        {foreach $pagination as $item}
                            <a href="{$item.link}" class="btn btn-default{if $item.active} active{/if}"{if $item.disabled} disabled="disabled"{/if}>{$item.text}</a>
                        {/foreach}
                    </span>
                </div>
            </div>
        </form>
    </div>
    <div class="clearfix"></div>
{/if}
