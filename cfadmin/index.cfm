<cffunction name="get">
	<cfargument name="path" />
	<cfhttp url="#arguments.path#" method="get" result="r" />
	<cfreturn r.filecontent />
</cffunction>

<cftry>
	<cfset index = get("https://raw.github.com/CFCommunity/ramen/master/index/index.json") />
	<cfcatch>
		<h1>Error</h1>
		<p>It looks like GitHub is down (or for some other reason, we can't get the index file). Please wait a while and try again.</p>
		<cfabort/>
	</cfcatch>
</cftry>

<cftry>
	<cfset json = deserializeJSON(index) />
	<cfcatch>
		<h1>Error</h1>
		<p>Index is invalid json. Sorry about that! Please email <a href="mailto:adam@fusiongrokker.com">adam@fusiongrokker.com</a> to have this addressed!</p>
		<cfabort />
	</cfcatch>
</cftry>

<cfimport taglib="lib/tags" prefix="ramen" />

<ramen:layout>

	<cfoutput>
		<cfloop from="1" to="#arrayLen(json.categories)#" index="cat">
			<h1>#json.categories[cat].name#</h1>

			<cfloop from="1" to="#arrayLen(json.categories[cat].apps)#" index="app">
				<h2>#json.categories[cat].apps[app].name#</h2>
				<p>#json.categories[cat].apps[app].desc#</p>

				<ul>
				<cfloop from="1" to="#arrayLen(json.categories[cat].apps[app].versions)#" index="ver">
					<li>
						<a href="##" class="showform">Install</a> <strong>#json.categories[cat].apps[app].versions[ver].name#</strong> - #json.categories[cat].apps[app].versions[ver].desc#
						<div class="hidden" style="display:none !important;">
							<form action="runner.cfm" method="get">
								<input type="hidden" name="$script" value="#json.categories[cat].apps[app].versions[ver].install#" />

								<cfif arrayLen(json.categories[cat].apps[app].versions[ver].require) gt 0>
									<cfloop from="1" to="#arrayLen(json.categories[cat].apps[app].versions[ver].require)#" index="req">
										<label for="#json.categories[cat].apps[app].versions[ver].require[req].name#_#json.categories[cat].apps[app].name#_#json.categories[cat].apps[app].versions[ver].name#">#json.categories[cat].apps[app].versions[ver].require[req].label#</label>
										<input type="text" size="30"
											value="#json.categories[cat].apps[app].versions[ver].require[req].default#"
											name="#json.categories[cat].apps[app].versions[ver].require[req].name#"
											id="#json.categories[cat].apps[app].versions[ver].require[req].name#_#json.categories[cat].apps[app].name#_#json.categories[cat].apps[app].versions[ver].name#"
										/><br/>
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
			$(".showform").click(function(){
				$(this).parent().find(".hidden").show();
			});
		});
	</script>

</ramen:layout>
