<div class="text-center">
    <p class="section-subheading mergecolor">{$LANG.supportticketsticketcreateddesc}</p>
</div>

<div class="row">
    <div class="col-sm-12">
        <section class="p-80 bg-seccolorstyle bg-white noshadow br-12 mt-50">
            <div class="alert bg-success text-center">
                <strong>
                    {$LANG.supportticketsticketcreated}
                    <a id="ticket-number" href="viewticket.php?tid={$tid}&amp;c={$c}" class="alert-link c-black f-18">#{$tid}</a>
                </strong>
            </div>
            <p class="text-center">
                <a href="viewticket.php?tid={$tid}&amp;c={$c}" class="btn btn-default-yellow-fill">
                    {$LANG.continue} <i class="fas fa-arrow-circle-right"></i>
                </a>
            </p>
        </div>

    </div>
</div>
