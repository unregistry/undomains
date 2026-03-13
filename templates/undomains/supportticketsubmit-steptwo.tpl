{if $errormessage}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
{/if}

<section class="p-80 bg-seccolorstyle bg-white noshadow br-12 mt-50">
    <div class="open-ticket"> 
        <form method="post" action="{$smarty.server.PHP_SELF}?step=3" enctype="multipart/form-data" role="form">

            <div class="row">
                <div class="form-group col-md-6">
                    <label class="mergecolor" for="inputName">{$LANG.supportticketsclientname}</label>
                    <input type="text" name="name" id="inputName" value="{$name}" class="form-control{if $loggedin} disabled{/if}"{if $loggedin} disabled="disabled"{/if} />
                </div>
                <div class="form-group col-md-6">
                    <label class="mergecolor" for="inputEmail">{$LANG.supportticketsclientemail}</label>
                    <input type="email" name="email" id="inputEmail" value="{$email}" class="form-control{if $loggedin} disabled{/if}"{if $loggedin} disabled="disabled"{/if} />
                </div>
            </div>


            <div class="row">
                <div class="form-group col-md-12">
                    <label class="mergecolor" for="inputSubject">{$LANG.supportticketsticketsubject}</label>
                    <input type="text" name="subject" id="inputSubject" value="{$subject}" class="form-control" />
                </div>
            </div>


            <div class="row">
                <div class="form-group col-md-4">
                    <label class="mergecolor" for="inputDepartment">{$LANG.supportticketsdepartment}</label>
                    <select name="deptid" id="inputDepartment" class="form-control" onchange="refreshCustomFields(this)">
                        {foreach from=$departments item=department}
                            <option value="{$department.id}"{if $department.id eq $deptid} selected="selected"{/if}>
                                {$department.name}
                            </option>
                        {/foreach}
                    </select>
                </div>
                {if $relatedservices}
                    <div class="form-group col-md-4">
                        <label class="mergecolor" for="inputRelatedService">{$LANG.relatedservice}</label>
                        <select name="relatedservice" id="inputRelatedService" class="form-control">
                            <option value="">{$LANG.none}</option>
                            {foreach from=$relatedservices item=relatedservice}
                                <option value="{$relatedservice.id}">
                                    <option value="{$relatedservice.id}"{if $relatedservice.id eq $selectedservice} selected="selected"{/if}>
                                    {$relatedservice.name} ({$relatedservice.status})
                                </option>
                            {/foreach}
                        </select>
                    </div>
                {/if}
                <div class="form-group col-md-4">
                    <label class="mergecolor" for="inputPriority">{$LANG.supportticketspriority}</label>
                    <select name="urgency" id="inputPriority" class="form-control">
                        <option value="High"{if $urgency eq "High"} selected="selected"{/if}>
                            {$LANG.supportticketsticketurgencyhigh}
                        </option>
                        <option value="Medium"{if $urgency eq "Medium" || !$urgency} selected="selected"{/if}>
                            {$LANG.supportticketsticketurgencymedium}
                        </option>
                        <option value="Low"{if $urgency eq "Low"} selected="selected"{/if}>
                            {$LANG.supportticketsticketurgencylow}
                        </option>
                    </select>
                </div>
            </div>


            <div class="form-group">
                <label class="mergecolor" for="inputMessage">{$LANG.contactmessage}</label>
                <textarea name="message" id="inputMessage" rows="12" class="form-control markdown-editor" data-auto-save-name="client_ticket_open">{$message}</textarea>
            </div>

            <div class="row form-group">
                <div class="col-sm-12">
                    <label class="mergecolor" for="inputAttachments">{$LANG.supportticketsticketattachments}</label>
                </div>
                <div class="col-sm-9">
                    <input type="file" name="attachments[]" id="inputAttachments" class="form-control" />
                    <div id="fileUploadsContainer"></div>
                </div>
                <div class="col-sm-3">
                    <button type="button" class="btn btn-md btn-default btn-block" onclick="extraTicketAttachment()">
                        <i class="fas fa-plus"></i> {$LANG.addmore}
                    </button>
                </div>
                <div class="col-xs-12 ticket-attachments-message text-muted">
                    {$LANG.supportticketsallowedextensions}: {$allowedfiletypes} ({lang key="maxFileSize" fileSize="$uploadMaxFileSize"})
                </div>
            </div>

            <div id="customFieldsContainer">
                {include file="$template/supportticketsubmit-customfields.tpl"}
            </div>

            <div id="autoAnswerSuggestions" class="hidden mt-50 mergecolor"></div>

            <div class="text-center margin-bottom">
                {include file="$template/includes/captcha.tpl"}
            </div>

            <p class="text-center">
                <input type="submit" id="openTicketSubmit" value="{$LANG.supportticketsticketsubmit}" class="btn btn-primary disable-on-click{$captcha->getButtonClass($captchaForm)}" />
                <a href="supporttickets.php" class="btn btn-default">{$LANG.cancel}</a>
            </p>
        </form>
    </div>
</section>

{if $kbsuggestions}
    <script>
        jQuery(document).ready(function() {
            getTicketSuggestions();
        });
    </script>
{/if}
