<div class="row text-center">
    <p class="section-subheading mergecolor">{lang key="switchAccount.choose"}</p>
</div>
<section class="services help sa-container">
  <div class="container">
    <div class="service-wrap">
      <div class="row">

        {include file="$template/includes/flashmessage.tpl"}
        {if $accounts->count() == 0}
            <p>{lang key="switchAccount.noneFound"}</p>
            <p>{lang key="switchAccount.createInstructions"}</p>
            <p>
                <a href="{routePath('cart-index')}" class="btn btn-default">
                    {lang key="shopNow"}
                </a>
            </p>
            <br><br>
        {else}
        
        {foreach $accounts as $account}
        <div class="col-sm-12 col-md-6 col-lg-6">
          <div class="help-container bg-seccolorstyle bg-pratalight noshadow select-account">
            <a href="#" data-id="{$account->id}"{if $account->status == 'Closed'} class="disabled"{/if}>
                <div class="help-item ">
                  <div class="img">
                    <img class="svg ico" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/smile.svg" height="65" alt="Owner Account">
                  </div>
                  <div class="inform">
                    <div class="title mergecolor">
                        {$account->displayName}
                        {if $account->authedUserIsOwner()}
                            <span class="badge feat bg-pink">{lang key="clientOwner"}</span>
                        {/if}
                        {if $account->status == 'Closed'}
                            <span class="badge feat bg-default">{$account->status}</span>
                        {/if}
                    </div>
                    <div class="description seccolor">{lang key="clientareadescription"}</div>
                  </div>
                </div>
            </a>
          </div>
        </div>
        {/foreach}
        {/if}
      </div>
    </div>
  </div>
</section>

<form method="post" action="{routePath('user-accounts')}">
    <input type="hidden" name="id" value="" id="inputSwitchAcctId">
</form>

<script>
    $(document).ready(function() {
        $('.select-account a').click(function(e) {
            e.preventDefault();
            $('#inputSwitchAcctId').val($(this).data('id'))
                .parent('form').submit();
        });
    });
</script>
