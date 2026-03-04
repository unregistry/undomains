<div class="services">
	<div class="container">
		<div class="service-wrap">
			{if $twitterusername}
				<div class="row">
					<div class="col-sm-12 text-center">
			            <h2 class="section-heading mergecolor">{$LANG.twitterlatesttweets}</h2>
			            <p class="section-subheading mergecolor">{$LANG.announcementsdescription}</p>
					</div>
				</div>
			    <div id="twitterFeedOutput">
			        <p class="text-center"><img src="{$BASE_PATH_IMG}/loading.gif" /></p>
			    </div>
			    <script type="text/javascript" src="{assetPath file='twitter.js'}"></script>
			{elseif $announcements}
				<div class="row">
					<div class="col-sm-12 text-center">
			            <h2 class="section-heading mergecolor">{$LANG.latestannouncements}</h2>
			            <p class="section-subheading mergecolor">{$LANG.announcementsdescription}</p>
					</div>
				</div>			
				<div class="row">
				{foreach $announcements as $announcement}
				{if $announcement@index < 3}
					<div class="col-sm-12 col-md-4">
						<div class="service-section bg-pratalight bg-seccolorstyle noshadow">
							<div class="title mergecolor">{$announcement.title}</div>
							<p class="subtitle seccolor">{$announcement.summary}</p>
							<div class="news-content-footer">
								<div class="plans badge feat bg-pink">{$carbon->translatePassedToFormat($announcement.rawDate, 'M jS')}</div>		
								<a class="btn btn-default-yellow-fill" href="{routePath('announcement-view', $announcement.id, $announcement.urlfriendlytitle)}"> {$LANG.readmore} <i class="ico-eye f-14 w-icon"></i></a>
							</div>
						</div>
					</div>
				{/if}
				{/foreach}				
				</div>
			{/if}
		</div>
	</div>
</div>