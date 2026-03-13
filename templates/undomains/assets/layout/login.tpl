<div class="dropdown user-login {if !$loggedin}not-login{/if}">
	<a href="#" class="iconews" data-toggle="dropdown">
		<i class="ico-lock f-18 w-icon"></i>
	</a>
	<div class="dropdown-menu dropdown-menu-right profile-notification bg-seccolorstyle {if $loggedin} logined-user-drop-down{/if}">
		{if $loggedin}
		<div class="login-header on">
			<span class="user-info-avatar">
				<img src="{$WEB_ROOT}/templates/{$template}/assets/img/gravatar.jpg" class="br-50 gravatar" alt="User-Profile-Image">
				<a target="_blank" href="https://gravatar.com/">{$LANG.orderForm.edit}</a>
			</span>
			<h6>{$LANG.welcomeback}, {$clientsdetails.firstname}<br>
			 {$LANG.affiliatesbalance}, <span class="c-white fw-bold">{$clientsstats.creditbalance}</span></h6>
		 	<a class="logout-btn" data-toggle="tooltip" data-placement="left" title="{$LANG.logouttitle}" href="logout.php" > <i class="fa-solid fa-power-off"></i></a>
		</div>
		<div class="user-info-content">
			<a href="{$WEB_ROOT}/clientarea.php?action=services" class="user-info bg-greylight bg-colorstyle">
			<i class="ico-settings"></i> <div class="number-services">{$clientsstats.productsnumactive} <span>{$LANG.navservices}</span></div></a>
			<a href="{$WEB_ROOT}/clientarea.php?action=domains" class="user-info bg-greylight bg-colorstyle">
			<i class="ico-globe"></i> <div class="number-services">{$clientsstats.numactivedomains} <span>{$LANG.navdomains}</span></div></a>
			<a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="user-info bg-greylight bg-colorstyle">
			<i class="ico-credit-card"></i> <div class="number-services">{$clientsstats.numunpaidinvoices} <span>{$LANG.navinvoices}</span></div></a>
		</div>
		<ul class="user-quicklinks bg-colorstyle">
			<li><a href="{$WEB_ROOT}/clientarea.php?action=details"><i class="ico-user-check"></i> {$LANG.accountinfo} 
			<span>{$LANG.clientareadescription}</span></a></li>
			<li><a href="{$WEB_ROOT}/supporttickets.php"><i class="ico-mail"></i> {$LANG.supportticketspagetitle} 
			<span>{$LANG.subaccountpermstickets}</span></a></li>
			<li><a href="{$WEB_ROOT}/clientarea.php?action=changepw"><i class="ico-unlock"></i> {$LANG.generatePassword.title} 
			<span>{$LANG.generatePassword.generateNew}</span></a></li>
		</ul>
		{else}
		<div class="login-header"><h6><b class="f-13">{$LANG.login}</b> - {$LANG.restrictedpage}<h6></div>
		<div class="login-content bg-colorstyle bg-pratalight">
			<div class="col-md-12 col-xs-12 mb-15 forgot-pass">
				<a href="{$systemurl}pwreset.php" class="">{$LANG.forgotpw}</a> {$LANG.or} <a href="{$systemurl}register.php" class="">{$LANG.register}</a>
			</div>
			<form method="post" action="{$systemurl}dologin.php" class="login-form">
				<div class="form-group">
					<i class="ico-user"></i>
					<input type="email" name="username" class="form-control" id="inputEmail" placeholder="{$LANG.enteremail}" autofocus>
				</div>
				<div class="form-group">
					<i class="ico-lock"></i>
					<input type="password" name="password" class="form-control" id="inputPassword" placeholder="{$LANG.clientareapassword}" autocomplete="off" >
				</div>
				<div class="row mr-bt-20">
					<div class="col-md-6 col-sm-6 col-xs-7">
						<div class="custom-control custom-checkbox p-t-5">
							<input type="checkbox" class="custom-control-input" name="rememberme" id="rememberme">
							<label class="custom-control-label" for="rememberme">{$LANG.loginrememberme}</label>
						</div>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-5 float-right">
						<input id="login" type="submit" class="btn btn-block btn-sm btn-default-yellow-fill" value="{$LANG.loginbutton}" />
					</div>
				</div>
			</form>
		</div>
		{/if}
	</div>
</div>