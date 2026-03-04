{if $sent}
    {include file="$template/includes/alert.tpl" type="success" msg=$LANG.contactsent textcenter=true}
{/if}
{if $errormessage}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
{/if}

{if !$sent}
<div class="bg-seccolorstyle bg-white noshadow mt-50 p-50 br-12">
    <form method="post" action="contact.php" class="form-horizontal" role="form">
        <input type="hidden" name="action" value="send" />

            <div class="form-group">

                <div class="row mb-50 px-5">
                    <div class="col-md-6">
                        <label for="inputName" class="control-label mb-0 mergecolor">{$LANG.supportticketsclientname}</label>
                        <input type="text" name="name" value="{$name}" class="form-control" id="inputName" />
                    </div>
                    <div class="col-md-6">
                        <label for="inputEmail" class="control-label mb-0 mergecolor">{$LANG.supportticketsclientemail}</label>
                        <input type="email" name="email" value="{$email}" class="form-control" id="inputEmail" />
                    </div>
                    <div class="col-md-6">
                        <label for="inputSubject" class="control-label mb-0 mergecolor">{$LANG.supportticketsticketsubject}</label>
                        <input type="subject" name="subject" value="{$subject}" class="form-control" id="inputSubject" />
                    </div>
                    <div class="col-md-6">
                        <label for="inputMessage" class="control-label mb-0 mergecolor">{$LANG.contactmessage}</label>
                        <textarea name="message" rows="4" class="form-control br-12" id="inputMessage">{$message}</textarea>
                    </div>
                </div>

                {if $captcha}
                    <div class="text-center margin-bottom">
                        {include file="$template/includes/captcha.tpl"}
                    </div>
                {/if}

                <div class="form-group">
                    <div class="text-center">
                        <button type="submit" class="btn btn-primary{$captcha->getButtonClass($captchaForm)}">{$LANG.contactsend}</button>
                    </div>
                </div>
            </div>
    </form>
</div>
{/if}
