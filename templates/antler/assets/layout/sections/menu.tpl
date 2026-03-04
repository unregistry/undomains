<!-- ***** HEADER NEWS ***** -->
<div class="sec-bg3 infonews">
  <div class="container-fluid">
    <div class="row">
      <div class="col-xs-6 col-md-6 news">
      {if $loggedin}
        <div>
            <span class="badge bg-purple me-2">welcome</span> 
            <span> Check all about your Account Details. </span>
            <span class="secnav">{include file="$template/assets/layout/secnavbar.tpl" navbar=$secondaryNavbar}</span>
        </div>
        {else}
        <div>
            <span class="badge bg-purple me-2">news</span> 
            <span> SSD Storage with increased flexibility. </span>
            <span class="secnav"> <a class="c-yellow" href="{$WEB_ROOT}/cart.php?gid=2">Cloud Overview <i class="fas fa-arrow-circle-right"></i></a></span>
        </div>
        {/if}
      </div>
      <div class="col-xs-6 col-md-6 link">
        <div class="infonews-nav float-right">
          {if $languagechangeenabled && count($locales) > 1}
            {include file="$template/assets/layout/language.tpl"}<!-- language selector -->
          {/if}
          {include file="$template/assets/layout/notifications.tpl"} <!-- notifications -->
          <a href="{$WEB_ROOT}/cart.php?a=view" class="iconews"><i class="ico-shopping-cart f-18 w-icon"></i></a> <!-- shoping cart -->
          {if $adminMasqueradingAsClient || $adminLoggedIn}
          {include file="$template/assets/layout/adminlogin.tpl"} <!-- Admin login Access -->
          {/if} 
          {include file="$template/assets/layout/login.tpl"} <!-- login -->
          <a href="tel:1300-656-1046" class="iconews tabphone">+ (123) 1300-656-1046</a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ***** HEADER NAV ***** -->
<div class="menu-wrap">
  <div class="nav-menu">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-md-2">
          <a href="/antler/template/">
            <img class="svg logo-menu d-block" src="{$WEB_ROOT}/templates/{$template}/assets/img/logo.svg" alt="{$companyname}">
            <img class="svg logo-menu d-none" src="{$WEB_ROOT}/templates/{$template}/assets/img/logo-light.svg" alt="{$companyname}">
          </a>
        </div>
        <nav id="menu" class="col-md-10">
          <div class="navigation float-right">
            <button class="menu-toggle">
            <span class="icon"></span>
            <span class="icon"></span>
            <span class="icon"></span>
            </button>
            <ul class="main-menu nav navbar-nav navbar-right">
              <li class="menu-item menu-item-has-children">
                <a class="v-stroke m-0" href="">Home</a>
                <div class="badge bg-pink ms-2 me-5 wow animated shake delay-1s visible">NEW</div>
                <ul class="sub-menu dropdown bg-colorstyle">
                  <li class="menu-item"><a class="mergecolor" href="/antler/template"> Home Default</a></li>
                  <li class="menu-item"><a class="mergecolor" href="/antler/template/homeimage">Home Image</a></li>
                  <li class="menu-item"><a class="mergecolor" href="/antler/template/homevideo">Home Video</a></li>
                  <li class="menu-item"><a class="mergecolor" href="/antler/template/homegaming">Home Gaming</a> <div class="menu badge feat bg-purple">NEW</div></li>
                  <li class="menu-item"><a class="mergecolor" href="/antler/template/home3d"> Home3D</a> <div class="menu badge feat bg-purple">NEW</div></li>
                  <li class="menu-item"><a class="mergecolor" href="?language=arabic">WHMCS (RTL)</a> <div class="menu badge feat bg-pink">HOT</div></li>
                </ul>
              </li>
              <li class="menu-item menu-item-has-children me-2">
                <a class="v-stroke m-0" href="#">Hosting</a>
                <div class="badge bg-pink ms-2 me-5">PRO</div>
                <div class="sub-menu menu-large bg-colorstyle">
                  <div class="service-list">
                    <div class="service">
                      <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/cloudfiber.svg" alt="Shared Hosting">
                      <div class="media-body">
                        <a class="menu-item mergecolor" href="/antler/template/hosting">Shared Hosting</a>
                        <p class="seccolor">Storage SSD, Cloud Linux, cPabel or Plesk</p>
                      </div>
                    </div>
                    <div class="service">
                      <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/reseller.svg" alt="Cloud Reseller">
                      <div class="media-body">
                        <a class="menu-item mergecolor" href="/antler/template/reseller">Cloud Reseller</a>
                        <p class="seccolor">Best for agencies or multi-site hosting </p>
                      </div>
                    </div>
                    <div class="service">
                      <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/dedicated.svg" alt="Dedicated Server">
                      <div class="media-body">
                        <a class="menu-item mergecolor" href="/antler/template/dedicated">Dedicated Server</a>
                        <div class="menu badge feat bg-pink">FILTER</div>
                        <p class="seccolor">Last gereration hardaware, remote reboot</p>
                      </div>
                    </div>
                    <div class="service">
                      <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/vps.svg" alt="Cloud VPS">
                      <div class="media-body">
                        <a class="menu-item mergecolor" href="/antler/template/vps">Cloud VPS</a>
                        <div class="menu badge feat bg-grey">SSD</div>
                        <p class="seccolor">Dedicated features and high performance</p>
                      </div>
                    </div>
                    <div class="service">
                      <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/wordpress.svg" alt="WordPress Hosting">
                      <div class="media-body">
                        <a class="menu-item mergecolor" href="/antler/template/wordpress">WordPress Hosting</a>
                        <p class="seccolor">High performance plans optimized for WP</p>
                      </div>
                    </div>
                    <div class="service">
                      <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/domains.svg" alt="Domains">
                      <div class="media-body">
                        <a class="menu-item mergecolor" href="/antler/template/domains">Domains Names</a>
                        <p class="seccolor">More than 900 extensions available</p>
                      </div>
                    </div>
                    <div class="service">
                      <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/code.svg" alt="Developer Hosting">
                      <div class="media-body">
                        <a class="menu-item mergecolor" href="/antler/template/developer">Developer Hosting</a>
                        <p class="seccolor">Remove the hosting hassle, Dev. solution</p>
                      </div>
                    </div>
                  </div>
                </div>
              </li>
              <li class="menu-item menu-item-has-children">
                <a class="v-stroke" href="#">Pages</a>
                <div class="sub-menu megamenu-list">
                  <div class="container">
                    <div class="row d-flex">
                      <div class="service-list col-md-9 bg-colorstyle">
                        <div class="row">
                          <div class="col-md-4 service">
                            <div class="media-body">
                              <div class="top-head">
                                <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/favorite.svg" alt="Services">
                                <div class="menu-item c-grey mergecolor">Services</div> 
                              </div><hr>
                              <ul>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/ddos">DDos Protections</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/ssl">SSL Certificates</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/email">Enterprise Emails</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/magento">Magento Pro</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/gsuite">G Suite - Google</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/iptv">IPTV Services</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/gaming">Gaming Server</a> <div class="badge inside bg-pink">NEW</div></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/radiostream">Radio Stream</a> <div class="badge inside bg-pink">NEW</div></li>
                              </ul>     
                            </div>
                          </div>
                          <div class="col-md-4 service">
                            <div class="media-body">
                              <div class="top-head">
                                <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/infrastructure.svg" alt="Infrastructure">
                                <div class="menu-item c-grey mergecolor">Infrastructure</div>
                              </div><hr>
                              <ul>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/ddos">DDos Protections</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/datacenter">Datacenter</a> <div class="badge inside bg-grey">TOP</div></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/about">About Us</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/database">Database-as-a-Service</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/elements">Elements</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/voip">Virtual Numbers</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/voice">Voice Server</a> <div class="badge inside bg-pink">NEW</div></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/seo">Managed SEO Service</a> <div class="badge inside bg-pink">NEW</div></li>
                              </ul> 
                            </div>
                          </div>
                          <div class="col-md-4 service">
                            <div class="media-body">
                              <div class="top-head">
                                <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/global.svg" alt="Global">
                                <div class="menu-item c-grey mergecolor">Others</div>
                              </div><hr>
                              <ul>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/payments">Payment Methods</a> <div class="badge inside bg-pink">NEW</div></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/configurator">Configurator</a> <div class="badge inside bg-grey">HOT</div></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/cart">Cart</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/blog-grid">Blog Grid</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/checkout">Checkout</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/soon">Comming Soon</a></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/promos">Special</a> <i class="fas fa-tags c-pink ms-2"></i></li>
                                <li class="menu-item"><a class="mergecolor" href="/antler/template/blackfriday">Blackfriday</a> <div class="badge inside bg-pink">HOT</div></li>
                              </ul>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="start-offer col-md-3">
                        <div class="inner">
                          <h4 class="title my-3">Cloud VPS SSD <br>Get 50% Discount</h4>
                          <div class="inner-content mb-4">Enjoy increased flexibility and get the performance you need - SSD Storage.</div>
                          <span class="m-0">Before <del class="c-pink">$20.00 /mo</del></span><br>
                          <h4 class="m-0"><b>Now</b> <b class="c-pink">$9.99 /mo</b></h4>
                          <a href="/antler/template/vps" class="btn btn-default-pink-fill mt-4">See Plans</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </li>

              <!-- ***** Restricted Primary Navbar According "Security Hook" Into the WHMCS Root ***** -->
              {if $loggedin}
              <div id="primaryNavbar" class="desk nav navbar-nav ml-auto">
                  {include file="$template/includes/navbar.tpl" navbar=$primaryNavbar}
              </div>
              {/if}

              {if $loggedin}
              <li class="menu-item menu-item-has-children me-2" data-username="store">
                <a class="v-stroke" href="#">{$LANG.navbilling} <div class="dotted-static"><span class="main-circle"></span></div></a>
                <div class="sub-menu megamenu-list">
                  <div class="container">
                    <div class="row d-flex">
                      <div class="service-list col-md-9 bg-colorstyle">
                        <div class="row">
                          <div class="col-md-4 service">
                            <div class="media-body">
                              <div class="top-head">
                                <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/card.svg" alt="Billing">
                                <div class="menu-item c-grey mergecolor">{$LANG.billingdetails}</div> 
                              </div><hr>
                              <ul>
                                <li class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/clientarea.php?action=invoices">{$LANG.invoices}</a></li>
                                <li class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/clientarea.php?action=quotes">{$LANG.quotestitle}</a></li>
                                <li class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/clientarea.php?action=masspay&all=true">{$LANG.masspaytitle}</a></li>
                                <li class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/account/paymentmethods">{$LANG.paymentMethods.title}</a></li>
                                <li class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/clientarea.php?action=services">{$LANG.clientareanavservices}</a></li>
                              </ul>     
                            </div>
                          </div>
                          <div class="col-md-4 service">
                            <div class="media-body">
                              <div class="top-head">
                                <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/domainserver.svg" alt="Domains">
                                <div class="menu-item c-grey mergecolor">{$LANG.cartproductdomain}</div>
                              </div><hr>
                              <ul>
                                <li class="menu-item"><a class="menu-item mergecolor"  href="{$WEB_ROOT}/clientarea.php?action=domains">{$LANG.clientareanavdomains}</a></li>
                                <li class="menu-item"><a class="menu-item mergecolor"  href="{$WEB_ROOT}/cart.php?gid=renewals">{$LANG.domainrenewals}</a></li>
                                <li class="menu-item"><a class="menu-item mergecolor"  href="{$WEB_ROOT}/cart.php?a=add&domain=register">{$LANG.navregisterdomain}</a></li>
                                <li class="menu-item"><a class="menu-item mergecolor"  href="{$WEB_ROOT}/cart.php?a=add&domain=transfer">{$LANG.transferinadomain}</a></li>
                                <li class="menu-item"><a class="menu-item mergecolor"  href="{$WEB_ROOT}/cart.php?a=add&domain=register">{$LANG.navdomainsearch}</a></li>
                              </ul> 
                            </div>
                          </div>
                          <div class="col-md-4 service">
                            <div class="media-body">
                              <div class="top-head">
                                <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/docbox.svg" alt="Global">
                                <div class="menu-item c-grey mergecolor">{$LANG.shortcuts}</div>
                              </div><hr>
                              <ul>
                                <li class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/cart.php?gid=addons">{$LANG.clientareaviewaddons}</a></li>
                                <li class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/account/paymentmethods">{$LANG.paymentMethods.title}</a></li>                                
                                <li data-username="Downloads" class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/download">{$LANG.quotedownload}</a></li>
                                <li data-username="Network" class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/serverstatus.php">{$LANG.networkstatustitle}</a></li>
                                <li data-username="Home" class="menu-item"><a class="menu-item mergecolor" href="{$WEB_ROOT}/affiliates.php">{$LANG.affiliatestitle}</a></li>
                              </ul>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="start-offer col-md-3">
                        <div class="inner bg-pratalight">
                          <h4 class="title my-3">{$clientsdetails.firstname} {$clientsdetails.lastname}</h4>
                          <div class="inner-content">{$clientsdetails.address1}, {$clientsdetails.city} <b>{$clientsdetails.country}</b></div>
                          <a href="{$WEB_ROOT}/clientarea.php?action=details" class="btn btn-default-yellow-fill mt-4">{$LANG.clientareanavdetails}</a>
                          <a href="{$WEB_ROOT}/supporttickets.php" class="btn btn-md btn-default-fill mt-4">{$LANG.navtickets}</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </li>
              {/if}

              <li class="menu-item menu-item-has-children menu-last">
                <a class="v-stroke" href="#">Support</a>
                <div class="sub-menu megamenu">
                  <div class="container">
                    <div class="row d-flex">
                      <div class="service-list col-md-9 bg-colorstyle">
                        <div class="row">
                          <div class="col-md-4 service">
                            <div class="media-left">
                              <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/bookmark.svg" alt="Knowledgebase">
                            </div>
                            <div class="media-body">
                              <a class="menu-item mergecolor" href="{$WEB_ROOT}/knowledgebase">Knowlegebase</a>
                              <p class="seccolor">Find the Most Popular Knowledgebase Articles</p>
                            </div>
                          </div>
                          <div class="col-md-4 service">
                            <div class="media-left">
                              <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/book.svg" alt="Announcements">
                            </div>
                            <div class="media-body">
                              <a class="menu-item mergecolor" href="{$WEB_ROOT}/announcements">Announcements</a>
                              <p class="seccolor">Check all the latest Announcements</p>
                            </div>
                          </div>
                          <div class="col-md-4 service">
                            <div class="media-left">
                              <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/emailopen.svg" alt="Contact Us">
                            </div>
                            <div class="media-body">
                              <a class="menu-item mergecolor" href="{$WEB_ROOT}/contact.php">Contact Us</a>
                              <div class="badge inside bg-pink ms-1">NOW</div>
                              <p class="seccolor">We're ready and waiting for your questions</p>
                            </div>
                          </div>

                          <div class="col-md-4 service">
                            <div class="media-left">
                              <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/compare.svg" alt="Legal">
                            </div>
                            <div class="media-body">
                              <a class="menu-item mergecolor" href="http://inebur.com/antler/template/legal">Legal</a>
                              <div class="badge inside bg-grey ms-1">NEW</div>
                              <p class="seccolor">Antler uses and secures the information provided</p>
                            </div>
                          </div>

                          <div class="col-md-4 service">
                            <div class="media-left">
                              <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/blog.svg" alt="Blog Details">
                            </div>
                            <div class="media-body">
                              <div>
                                <a class="menu-item mergecolor" href="/antler/template/blog-details">Blog Details</a>
                              </div>
                              <p class="seccolor">The latest news about our Hosting Services</p>
                            </div>
                          </div>

                          {if $loggedin}
                          <div class="col-md-4 service">
                            <div class="media-left">
                              <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/ticket.svg" alt="Open Ticket">
                            </div>
                            <div class="media-body">
                              <div>
                                <a class="menu-item mergecolor" href="{$WEB_ROOT}/submitticket.php">{$LANG.navopenticket}</a>
                              </div>
                              <p class="seccolor">{$LANG.clientareanavsupporttickets}. {$LANG.ticketsyourhistory}</p>
                            </div>
                          </div>
                          {/if}

                        </div>
                      </div>
                      <div class="start-offer col-md-3">
                        <div class="inner">
                          <h4 class="title my-3">Support Premium</h4>
                          <div class="inner-content">
                            <span>Call us:</span> <b>+ (123) 1300-656-1046</b> HeadQuarters - No.01 - 399-0 Lorem Street City Melbourne
                          </div>
                          <a href="{$WEB_ROOT}/contact.php" class="btn btn-default-yellow-fill mt-4">Contact Us</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </li>

              <div class="tech-box">
                <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/img/menu.svg" alt="Sidebar">
              </div>

              {if $loggedin}
              <a class="pe-0 me-0" href="{$WEB_ROOT}/logout.php"> 
                <div class="btn btn-default-yellow-fill question">
                  <span class"uppercase">{$LANG.clientareanavlogout}</span> 
                  <i class="fas fa-lock ps-1"></i> 
                </div>
              </a>
              {else}
              <a class="pe-0 me-0" href="{$WEB_ROOT}/clientarea.php"> 
                <div class="btn btn-default-yellow-fill question">
                  <span class"uppercase">{$LANG.clientlogin}</span> 
                  <i class="fas fa-lock ps-1"></i> 
                </div>
              </a>
              {/if}
              
            </ul>
          </div>
        </nav>
      </div>
    </div>
  </div>
</div>

<!-- ***** NAV MENU MOBILE ****** -->
<div id="menu-mobile" class="menu-wrap mobile">
  <div class="container">
    <div class="row align-items-center">
      <div class="col-xs-6 col-md-6">
        <a href="/antler/template/" class=" d-flex">
          <img class="svg logo-menu d-block" src="{$WEB_ROOT}/templates/{$template}/assets/img/logo.svg" alt="{$companyname}">
          <img class="svg logo-menu d-none" src="{$WEB_ROOT}/templates/{$template}/assets/img/logo-light.svg" alt="{$companyname}">
        </a>
      </div>
      <div class="col-xs-6 col-md-6">
        <nav class="nav-menu float-right">
          <button id="nav-toggle" class="menu-toggle">
            <span class="icon"></span>
            <span class="icon"></span>
            <span class="icon"></span>
          </button>
          <div class="tech-box float-right mt-2 pt-1">
            <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/img/menu.svg" alt="Sidebar">
          </div>
          <div class="main-menu nav navbar-nav bg-seccolorstyle">
            <div class="menu-item dropdown">
              <a href="#" class="mergecolor dropdown-toggle" data-toggle="dropdown" data-toggle="dropdown">Home <div class="badge bg-purple">New</div></a>
              <div class="dropdown-menu">
                <a class="dropdown-item menu-item" href="/antler/template/">Home Default</a>
                <a class="dropdown-item menu-item" href="/antler/template/homeimage">Home Image</a>
                <a class="dropdown-item menu-item" href="/antler/template/homevideo">Home Video</a>
                <a class="dropdown-item menu-item" href="/antler/template/homegaming">Home Gaming</a>
                <a class="dropdown-item menu-item" href="/antler/template/home3d">Home3D</a>
                <a class="dropdown-item menu-item" href="?language=arabic">WHMCS (RTL)</a>
              </div>
            </div>
            <div class="menu-item dropdown">
              <a href="#" class="mergecolor dropdown-toggle" data-toggle="dropdown"  data-toggle="dropdown">Hosting <div class="badge bg-purple">PRO</div></a>
              <div class="dropdown-menu">
                <a class="dropdown-item menu-item" href="/antler/template/hosting">Shared Hosting</a>
                <a class="dropdown-item menu-item" href="/antler/template/reseller">Cloud Reseller</a>
                <a class="dropdown-item menu-item" href="/antler/template/dedicated">Dedicated Server</a>
                <a class="dropdown-item menu-item" href="/antler/template/vps">Cloud VPS</a>
                <a class="dropdown-item menu-item" href="/antler/template/wordpress">WordPress Hosting</a>
                <a class="dropdown-item menu-item" href="/antler/template/domains">Domain Names</a>
                <a class="dropdown-item menu-item" href="/antler/template/developer">Developer Hosting</a>
              </div>
            </div>
            <div class="menu-item dropdown">
              <a href="#" class="mergecolor dropdown-toggle" data-toggle="dropdown">Pages</a>
              <div class="dropdown-menu">
                <a class="dropdown-item menu-item" href="/antler/template/emailsecurity">Email Security</a>
                <a class="dropdown-item menu-item" href="/antler/template/ssl">SSL Certificates</a>
                <a class="dropdown-item menu-item" href="/antler/template/email">Enterprise Email</a>
                <a class="dropdown-item menu-item" href="/antler/template/magento">Magento Pro</a>
                <a class="dropdown-item menu-item" href="/antler/template/gsuite">G Suite - Google</a>
                <a class="dropdown-item menu-item" href="/antler/template/iptv">IPTV System</a>
                <a class="dropdown-item menu-item" href="/antler/template/gaming">Gaming Server</a>
                <a class="dropdown-item menu-item" href="/antler/template/radiostream">Radio Stream <div class="badge inside bg-pink ms-2">NEW</div></a>
                <a class="dropdown-item menu-item" href="/antler/template/ddos">DDoS Protection</a>
                <a class="dropdown-item menu-item" href="/antler/template/datacenter">Datacenter <div class="badge inside bg-grey ms-2">TOP</div></a>
                <a class="dropdown-item menu-item" href="/antler/template/about">About Us</a>
                <a class="dropdown-item menu-item" href="/antler/template/database">Database-as-a-Service</a>
                <a class="dropdown-item menu-item" href="/antler/template/elements">Elements</a>
                <a class="dropdown-item menu-item" href="/antler/template/voip">Virtual Numbers</a>
                <a class="dropdown-item menu-item" href="/antler/template/voice">Voice Server <div class="badge inside bg-pink ms-2">NEW</div></a>
                <a class="dropdown-item menu-item" href="/antler/template/payments">Payment Methods <div class="badge inside bg-pink ms-2">NEW</div></a>
                <a class="dropdown-item menu-item" href="/antler/template/configuration">Configuration <div class="badge inside bg-grey ms-2">HOT</div></a>
                <a class="dropdown-item menu-item" href="/antler/template/cart">Cart</a>
                <a class="dropdown-item menu-item" href="/antler/template/checkout">Checkout</a>
                <a class="dropdown-item menu-item" href="/antler/template/soon">Comming Soon</a>
                <a class="dropdown-item menu-item" href="/antler/template/promos">Promotions</a>
                <a class="dropdown-item menu-item" href="/antler/template/blackfriday">Blackfriday <div class="badge inside bg-pink ms-2">HOT</div></a>
              </div>
            </div>
            {if $loggedin}
            <div class="menu-item dropdown menu-last">
              <a href="#" class="mergecolor dropdown-toggle" data-toggle="dropdown">{$LANG.navbilling} <div class="dotted-static"><span class="main-circle"></span></div></a>
              <div class="dropdown-menu">
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=invoices">{$LANG.invoices}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=quotes">{$LANG.quotestitle}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=masspay&all=true">{$LANG.masspaytitle}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/account/paymentmethods">{$LANG.paymentMethods.title}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=masspay&all=true">{$LANG.clientareanavservices}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/clientarea.php?action=domains">{$LANG.clientareanavdomains}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/cart.php?gid=renewals">{$LANG.domainrenewals}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/cart.php?a=add&domain=register">{$LANG.navregisterdomain}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/cart.php?a=add&domain=transfer">{$LANG.transferinadomain}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/cart.php?a=add&domain=register">{$LANG.navdomainsearch}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/cart.php?gid=addons">{$LANG.clientareaviewaddons}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/account/paymentmethods">{$LANG.paymentMethods.title}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/download">{$LANG.quotedownload}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/serverstatus.php">{$LANG.networkstatustitle}</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/affiliates.php">{$LANG.affiliatestitle}</a>
              </div>
            </div>
            {/if}
            <div class="menu-item dropdown menu-last">
              <a href="#" class="mergecolor dropdown-toggle" data-toggle="dropdown">Support</a>
              <div class="dropdown-menu">
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/knowledgebase">Knowlegebase</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/announcements">Announcements</a>
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/contact.php">Contact Us</a>
                <a class="dropdown-item menu-item" href="/antler/template/legal">Privacy policy</a>
                <a class="dropdown-item menu-item" href="/antler/template/blog-details">Blog Details</a>
                {if $loggedin}
                <a class="dropdown-item menu-item" href="{$WEB_ROOT}/submitticket.php">{$LANG.navopenticket}</a>
                {/if}
              </div>
            </div>
            <div class="float-left w-100 mt-3 f-18">
              <p class="c-grey-light seccolor"><small>Email: admin@antler.com</small> </p>
            </div>
            <div>
              <a href="login"><div class="btn btn-default-yellow-fill mt-3">CLIENT AREA</div></a>
            </div>
          </div>
        </nav>
      </div>
    </div>
  </div>
</div>

<!-- ***** OFFCANVAS Sidebar ****** -->
<div class="offcanvas offcanvas-start offcanvas-box bg-colorstyle" tabindex="-1" id="offcanvasWithBackdrop" aria-labelledby="offcanvasWithBackdropLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title mergecolor f-22" id="offcanvasWithBackdropLabel">Special Deals</h5>
    <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body">
    <div class="row mb-4">
      <h6 class="mergecolor mb-4 f-16 ml-20">Free Trials</h6>
      <div class="col-md-6">
        <a href="/antler/template/hosting">
          <div class="card mb-4 br-12 upping cursor-p p-relative noshadow border-0 bg-white bg-seccolorstyle">
            <div class="plans badge feat bg-purple">free migration</div>
            <img src="{$WEB_ROOT}/templates/{$template}/assets/img/topbanner05.jpg" class="w-100" alt="Shared Hosting">
            <div class="card-body">
              <h6 class="card-title c-black mergecolor f-16">Shared Hosting</h6>
              <p class="card-text c-black seccolor f-16 mb-0"><small>Blazing fast & stable hosting infrastructure</small></p>
            </div>
          </div>
        </a>
      </div>
      <div class="col-md-6">
        <a href="/antler/template/emailsecurity">
          <div class="card mb-4 br-12 upping cursor-p p-relative noshadow border-0 bg-white bg-seccolorstyle">
            <div class="plans badge feat bg-purple">free test</div>
            <img src="{$WEB_ROOT}/templates/{$template}/assets/img/topbanner03.jpg" class="w-100" alt="Email Security">
            <div class="card-body">
              <h6 class="card-title c-black mergecolor f-16">Email Security</h6>
              <p class="card-text c-black seccolor f-16 mb-0"><small>Powerful protection for emails with intelligent cluster</small></p>
            </div>
          </div>
        </div>
      </a>
    </div>
    <div class="row mb-4">
      <h6 class="mergecolor mb-4 f-16 ml-20">Special Promotions</h6>
      <div class="col-md-6">
        <a href="/antler/template/hosting">
          <div class="card mb-4 br-12 upping cursor-p p-relative noshadow border-0 bg-white bg-seccolorstyle">
            <div class="plans badge feat bg-grey">30%</div>
            <div class="row g-0 d-flex">
              <div class="col-md-4">
                <img class="svg img-fluid rounded-start" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/cloudfiber.svg" alt="Shared Hosting">
              </div>
              <div class="col-md-8">
                <div class="card-body pl-0">
                  <h6 class="card-title c-black mergecolor f-16">Hosting</h6>
                  <p class="card-text c-black seccolor f-16 mb-0"><small>Storage SSD, CloudLinux, cPanel..</small></p>
                </div>
              </div>
            </div>
          </div>
        </a>
      </div>
      <div class="col-md-6">
        <a href="/antler/template/domains">
          <div class="card mb-4 br-12 upping cursor-p p-relative noshadow border-0 bg-white bg-seccolorstyle">
            <div class="plans badge feat bg-grey">$5.80</div>
            <div class="row g-0 d-flex">
              <div class="col-md-4">
                <img class="svg img-fluid rounded-start" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/domains.svg" alt="Email Security">
              </div>
              <div class="col-md-8">
                <div class="card-body pl-0">
                  <h6 class="card-title c-black mergecolor f-16">Domains</h6>
                  <p class="card-text c-black seccolor f-16 mb-0"><small>More than 900 domains extensions..</small></p>
                </div>
              </div>
            </div>
          </div>
        </a>
      </div>
      <div class="col-md-6">
        <a href="/antler/template/gsuite">
          <div class="card mb-4 br-12 upping cursor-p p-relative noshadow border-0 bg-white bg-seccolorstyle">
            <div class="plans badge feat bg-purple">20%</div>
            <div class="row g-0 d-flex">
              <div class="col-md-4">
                <img class="svg img-fluid rounded-start" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/docbox.svg" alt="G Suite Google">
              </div>
              <div class="col-md-8">
                <div class="card-body pl-0">
                  <h6 class="card-title c-black mergecolor f-16">G Suite</h6>
                  <p class="card-text c-black seccolor f-16 mb-0"><small>Email, Chat, Apps, Cloud Storage..</small></p>
                </div>
              </div>
            </div>
          </div>
        </a>
      </div>
      <div class="col-md-6">
        <a href="/antler/template/ssl">
          <div class="card mb-4 br-12 upping cursor-p p-relative noshadow border-0 bg-white bg-seccolorstyle">
            <div class="plans badge feat bg-purple">20%</div>
            <div class="row g-0 d-flex">
              <div class="col-md-4">
                <img class="svg img-fluid rounded-start" src="{$WEB_ROOT}/templates/{$template}/assets/fonts/svg/privacy.svg" alt="Wilcard SSL">
              </div>
              <div class="col-md-8">
                <div class="card-body pl-0">
                  <h6 class="card-title c-black mergecolor f-16">Wilcard</h6>
                  <p class="card-text c-black seccolor f-16 mb-0"><small>Security, credibility and trust visitors..</small></p>
                </div>
              </div>
            </div>
          </div>
        </a>
      </div>
    </div>
    <div class="row mb-4">
      <h6 class="mergecolor f-16 ml-20">Flexible Operating Systems</h6>
      <p class="seccolor ml-20"><small>Install over +300 scripts and apps instantly with our auto installer.</small></p>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/centos.svg" alt="Centos">
          <p class="mb-0 seccolor">Centos</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/debian.svg" alt="Centos">
          <p class="mb-0 seccolor">Debian</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/docker.svg" alt="Centos">
          <p class="mb-0 seccolor">Docker</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/drupal.svg" alt="Centos">
          <p class="mb-0 seccolor">Drupal</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/cpanel.svg" alt="Centos">
          <p class="mb-0 seccolor">cPanel</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/fedora.svg" alt="Centos">
          <p class="mb-0 seccolor">Fedora</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/gitlab.svg" alt="Centos">
          <p class="mb-0 seccolor">Gitlab</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/joomla.svg" alt="Centos">
          <p class="mb-0 seccolor">Joomla</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/joomla.svg" alt="Centos">
          <p class="mb-0 seccolor">Lamp</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/magento.svg" alt="Centos">
          <p class="mb-0 seccolor">Magento</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/openvpn.svg" alt="Centos">
          <p class="mb-0 seccolor">VPN</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/owncloud.svg" alt="Centos">
          <p class="mb-0 seccolor">OWN</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/prestashop.svg" alt="Centos">
          <p class="mb-0 seccolor">Presta</p>
        </a>
      </div>
      <div class="os br-12 upping cursor-p noshadow bg-seccolorstyle">
        <a href="#">
          <img class="svg" src="{$WEB_ROOT}/templates/{$template}/assets/apps/windows.svg" alt="Centos">
          <p class="mb-0 seccolor">Windows</p>
        </a>
      </div>
    </div>
  </div>
</div>
<div class="backdrop-start offcanvas-backdrop fade" data-bs-dismiss="offcanvas"></div>
