{include file="$template/includes/flashmessage.tpl"}

<div class="bg-seccolorstyle bg-white br-12 border-0 mergecolor p-50 p-relative noshadow mt-50">
    <form class="form-horizontal using-password-strength" method="post" action="{routePath('user-password')}" role="form">
        
        <div class="form-group">
            <div class="col-md-4">
                <input type="hidden" name="submit" value="true" />
                <label for="inputExistingPassword" class="control-label">{$LANG.existingpassword}</label>
                <input type="password" class="form-control" name="existingpw" id="inputExistingPassword" autocomplete="off" />
            </div>

            <div class="col-md-4">
                <div id="newPassword1" class="has-feedback">
                    <label for="inputNewPassword1" class="control-label">{$LANG.newpassword}</label>
                    <input type="password" class="form-control" name="newpw" id="inputNewPassword1" autocomplete="off" />
                </div>
            </div>

            <div class="col-md-4">
                <div id="newPassword2" class="has-feedback">
                    <label for="inputNewPassword2" class="control-label">{$LANG.confirmnewpassword}</label>
                    <input type="password" class="form-control" name="confirmpw" id="inputNewPassword2" autocomplete="off" />
                    <span class="form-control-feedback glyphicon"></span>
                    <div id="inputNewPassword2Msg"></div>
                </div>
            </div>

            <div class="col-md-12">
                <span class="form-control-feedback glyphicon"></span>
                {include file="$template/includes/pwstrength.tpl" maximumPasswordLength=$maximumPasswordLength}
                <button type="button" class="btn btn-default generate-password" data-targetfields="inputNewPassword1,inputNewPassword2">
                    {$LANG.generatePassword.btnLabel}
                </button>
            </div>

            <div class="col-md-12">
                <div class="text-center">
                    <input class="btn btn-primary" type="submit" value="{$LANG.clientareasavechanges}" />
                    <input class="btn btn-default" type="reset" value="{$LANG.cancel}" />
                </div>
            </div>
        </div>
    </form>
</div>
