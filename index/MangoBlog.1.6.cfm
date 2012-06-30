<cfset ramen.namespace("MangoBlog") />
<cfset folder = ramen.getParams().parentFolder />

<cfoutput>
	<p><strong>MangoBlog will be installed in:</strong> #folder#</p>
</cfoutput>

<cfif not directoryExists( folder )>
	<cfdirectory action="create" directory="#folder#" />
</cfif>

<cfset ramen.download("http://mangoblog.riaforge.org/index.cfm?event=action.download&doit=true", "mango-1.6.zip") />
<cfset ramen.unzip("mango-1.6.zip", folder) />
<cfset ramen.cleanup() />

<!--- if install was in webroot somewhere, we can figure out the path --->
<cfset webroot = expandPath('/') />
<cfif left(folder, len(webroot)) eq webroot>
	<cfset relPath = right(folder, len(folder)-len(webroot)) />
	<cfif left(relPath, 1) neq "/">
		<cfset relPath = "/" & relPath />
	</cfif>
	<cfif right(relPath, 1) neq "/">
		<cfset relPath = relPath & "/" />
	</cfif>
	<p>Mango has been downloaded and unzipped, but you must <a target="_blank" href="#relPath#">run the installer</a>. (opens in a new window/tab)</p>
<cfelse>
	<p>Mango has been downloaded and unzipped, but you must run the installer. It doesn't look like you installed to anywhere inside your webroot, so I couldn't guess the path to the installer. Just open up the root of where your blog should be and Mango will take it from there.</p>
</cfif>
