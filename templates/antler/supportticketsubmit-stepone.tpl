
<p class="text-center mergecolor">{$LANG.supportticketsheader}</p>

<section class="services overview-services sec-normal pt-50 pb-0">
    <div class="service-wrap">
        <div class="row">
            {foreach from=$departments key=num item=department}
            <div class="col-md-4" data-aos="fade-up" data-aos-duration="1000">
              <div class="service-section bg-seccolorstyle bg-white noshadow">
                <div class="plans badge feat bg-pink">{$LANG.getsupport}</div>
                <img class="svg" src="templates/{$template}/assets/fonts/svg/helpdesk.svg" alt="Support">
                <div class="title mergecolor" deptid={$department.id}>{$department.name}</div>
                {if $department.description}
                    <p class="subtitle seccolor">{$department.description}</p>
                {/if}
                <a href="{$smarty.server.PHP_SELF}?step=2&amp;deptid={$department.id}" class="btn btn-default-yellow-fill">{$department.name}</a>
              </div>
            </div>
            {foreachelse}
                {include file="$template/includes/alert.tpl" type="info" msg=$LANG.nosupportdepartments textcenter=true}
            {/foreach}
        </div>
    </div>
</section>


