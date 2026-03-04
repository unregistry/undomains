<div class="container">
	
	<div class="row text-center">
		<h2 class="section-heading mergecolor text-center w-100">{$title}{if $desc}</h2>
		<p class="section-subheading mergecolor">{$desc}</p>{/if}
	</div>

	{if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}
	<div class="dropnav-header-lined">
		<button id="dropside-content" type="button" class="drop-down-btn dropside-content" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<i class="fa-solid fa-ellipsis-vertical"></i>
		</button>
		<div class="dropdown-menu bg-seccolorstyle" aria-labelledby="dropside-content">
			{include file="$template/includes/sidebar.tpl" sidebar=$primarySidebar}
			{include file="$template/includes/sidebar.tpl" sidebar=$secondarySidebar}
		</div>
	</div>
	{/if}

</div>