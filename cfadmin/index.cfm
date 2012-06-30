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

<cfoutput>
	<cfloop from="1" to="#arrayLen(json.categories)#" index="cat">
		<h1>#json.categories[cat].name#</h1>

		<cfloop from="1" to="#arrayLen(json.categories[cat].apps)#" index="app">
			<h2>#json.categories[cat].apps[app].name#</h2>
			<p>#json.categories[cat].apps[app].desc#</p>

			<ul>
			<cfloop from="1" to="#arrayLen(json.categories[cat].apps[app].versions)#" index="ver">
				<li>
					<a href="">Install</a> <strong>#json.categories[cat].apps[app].versions[ver].name#</strong> - #json.categories[cat].apps[app].versions[ver].desc#
					<div class="hidden">
						form for:
						#json.categories[cat].apps[app].versions[ver].install#
					</div>
				</li>
			</cfloop>
			</ul>

		</cfloop>

	</cfloop>
</cfoutput>