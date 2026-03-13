<div class="dropdown lang-drop">
	<a href="#" class="iconews" data-toggle="dropdown" >
		<img src="{$WEB_ROOT}/templates/{$template}/assets/img/flags/{$language}.svg" class="br-50 img-19 f-18" alt="{$activeLocale.localisedName}">
	</a>
	<div class="dropdown-menu dropdown-menu-right notification lang-container">
		<div class="notify-header">
			<h6>{$LANG.chooselanguage}</h6>
			<a class="bg-colorstyle">{$activeLocale.localisedName}</a>
		</div>
		<ul class="bg-colorstyle">
			{foreach $locales as $locale}
			<li><a href="{$currentpagelinkback}language={$locale.language}">{$locale.localisedName}</a></li>
			{/foreach}
		</ul>
	</div>
</div>