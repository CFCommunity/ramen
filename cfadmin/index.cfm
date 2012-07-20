<cffunction name="get">
	<cfargument name="path" />
	<cfargument name="cacheDurationMinutes" default="3" />
	<cfif arguments.cacheDurationMinutes gt 0>
		<cfif structKeyExists(application, "indexCache")>
			<cfif dateDiff("n", application.indexCache.timestamp, now()) lte arguments.cacheDurationMinutes>
				<cfheader name="X-RAMEN-CACHE" value="hit" />
				<cfreturn application.indexCache.data />
			</cfif>
		</cfif>
	</cfif>
	<cfheader name="X-RAMEN-CACHE" value="miss" />
	<cfhttp url="#arguments.path#" method="get" result="r" />
	<cfset application.indexCache.data = r.filecontent />
	<cfset application.indexCache.timestamp = now() />
	<cfreturn application.indexCache.data />
</cffunction>

<cfset localRepo = expandPath( "/cfide/administrator/ramen/cfadmin/index.json" ) />
<cfset repoInUse = "github" />

<cfif fileExists( localRepo )>
	<cffile action="read" file="#localRepo#" variable="index" />
	<cfset repoInUse = "local" />
<cfelse>
	<cftry>
		<cfif structKeyExists(url, "reload") and url.reload eq "true">
			<cfset cacheLen = 0 />
		<cfelse>
			<cfset cacheLen = 3 />
		</cfif>
		<cfset index = get("https://raw.github.com/CFCommunity/ramen/master/index/index.json", cacheLen) />
		<cfcatch>
			<h1>Error</h1>
			<p>It looks like GitHub is down (or for some other reason, we can't get the index file). Please wait a while and try again.</p>
			<cfabort/>
		</cfcatch>
	</cftry>
</cfif>

<cftry>
	<cfset json = deserializeJSON( index ) />
	<cfcatch>
		<h1>Error</h1>
		<cfif repoInUse eq "github">
			<p>Index is invalid json. Sorry about that! Please email <a href="mailto:adam@fusiongrokker.com">adam@fusiongrokker.com</a> to have this addressed!</p>
		<cfelse>
			<p>Index is invalid json. Your index file is: <pre><cfoutput>#localRepo#</cfoutput></pre></p>
			<p>Try running it through <a target="_blank" href="http://jsonlint.com/">JSON Lint</a> to identify any invalid syntax. If JSON Lint reports that the syntax is valid, <a target="_blank" href="https://github.com/cfcommunity/ramen/issues">please report this as an issue</a>!</p>
		</cfif>
		<cfabort />
	</cfcatch>
</cftry>

<cfimport taglib="lib/tags" prefix="ramen" />

<ramen:layout>

	<div id="buttonbar"><button id="reload">Reload Cached Index</button></div>

	<cfoutput>
		<cfloop from="1" to="#arrayLen(json.categories)#" index="cat">
			<cfset currentCat = json.categories[cat] />
			<h1>#currentCat.name#</h1>

			<cfloop from="1" to="#arrayLen(currentCat.apps)#" index="app">
				<cfset currentApp = currentCat.apps[app] />
				<h2>#currentApp.name#</h2>
				<p>#currentApp.desc#</p>

				<ul id="apps">
				<cfloop from="1" to="#arrayLen(currentApp.versions)#" index="ver">
					<cfset currentVer = currentApp.versions[ver] />
					<li>
						<a href="##" class="showform"><img src="assets/brick.png" /></a> <strong>#currentVer.name#</strong> - #currentVer.desc#
						<div class="hidden installform" style="display:none !important;">
							<form action="runner.cfm" method="get">
								<input type="hidden" name="$script" value="#currentVer.install#" />

								<cfif arrayLen(currentVer.require) gt 0>
									<cfloop from="1" to="#arrayLen(currentVer.require)#" index="req">
										<cfset currentReq = currentVer.require[req] />

										<cfif currentReq.type eq "hidden">

											<input type="hidden" name="#currentReq.name#" value="#currentReq.value#" />

										<cfelseif currentReq.type eq "checkbox">

											<input type="checkbox"
												<cfif currentReq.default eq true>checked="checked"</cfif>
												value="<cfif structKeyExists(currentReq, 'value')>#currentReq.value#><cfelse>1</cfif>"
												name="#currentReq.name#"
												id="#currentReq.name#_#currentApp.name#_#currentVer.name#"
											/>
											<label for="#currentReq.name#_#currentApp.name#_#currentVer.name#">#currentReq.label#</label>
											<br/>
											
										<cfelse>

											<label for="#currentReq.name#_#currentApp.name#_#currentVer.name#">#currentReq.label#</label>
											<input type="text" size="30"
												value="#currentReq.default#"
												name="#currentReq.name#"
												id="#currentReq.name#_#currentApp.name#_#currentVer.name#"
											/><br/>

										</cfif>
									</cfloop>
								</cfif>

								<input type="submit" value="Install" />
							</form>
						</div>
					</li>
				</cfloop>
				</ul>

			</cfloop>

		</cfloop>
	</cfoutput>

	<script type="text/javascript" src="assets/jquery-1.7.2.min.js"></script>
	<script type="text/javascript">
		$(function(){
			$(".showform").click(function(e){
				$(this).parent().find(".hidden").toggle(150);
				e.preventDefault();
			});
			$("#reload").click(function(e){
				window.location.href = window.location.protocol + '//' + window.location.host + '/CFIDE/Administrator/ramen/cfadmin/index.cfm?reload=true';
				e.preventDefault();
			});
		});
	</script>

</ramen:layout>
