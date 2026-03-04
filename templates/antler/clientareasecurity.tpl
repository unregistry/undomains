{if $linkableProviders }
    <h2>
        {lang key='remoteAuthn.titleLinkedAccounts'}
    </h2>

    {include file="$template/includes/linkedaccounts.tpl" linkContext="clientsecurity" }

    <br>

    {include file="$template/includes/linkedaccounts.tpl" linkContext="linktable" }

    <br>
{/if}

{if $showSsoSetting}

    <p class="section-subheading mergecolor text-center">{$LANG.sso.title}</p>
    {include file="$template/includes/alert.tpl" type="success" msg=$LANG.sso.summary}

    <div class="bg-seccolorstyle bg-white noshadow mt-50 p-50 br-12">
        <form id="frmSingleSignOn">
            <input type="hidden" name="token" value="{$token}" />
            <input type="hidden" name="action" value="security" />
            <input type="hidden" name="toggle_sso" value="1" />
            <div class="margin-10 mergecolor">
                <input type="checkbox" name="allow_sso" class="toggle-switch-success" id="inputAllowSso"{if $isSsoEnabled} checked{/if}>
                &nbsp;
                <span id="ssoStatusTextEnabled"{if !$isSsoEnabled} class="hidden mergecolor"{/if}>{$LANG.sso.enabled}</span>
                <span id="ssoStatusTextDisabled"{if $isSsoEnabled} class="hidden mergecolor"{/if}>{$LANG.sso.disabled}</span>
            </div>
        </form>

        <p class="mergecolor">{$LANG.sso.disablenotice}</p>
    </div>

    <br />
    <br />

{/if}
