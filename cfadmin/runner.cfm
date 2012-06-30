<cfimport taglib="lib/tags" prefix="ramen" />

<ramen:layout>

	<cfset ramen = createObject("component", "lib.ramen") />

	<cfset tmpPath = ramen.getTmpPath() />
	<cfset tmpName = hash(now()) & ".cfm" />

	<cffunction name="download">
		<cfargument name="urlpath" required="true" />
		<cfargument name="filename" required="true" />
		<cfhttp method="get" url="#urlpath#" path="#tmpPath#" file="#filename#" />
	</cffunction>

	<cffunction name="replaceTokens">
		<cfargument name="in" />
		<cfreturn replaceList(in, "{webroot}", "#expandPath('/')#") />
	</cffunction>

	<cfparam name="url.$script" default="" /><!--- the cfml script to run --->
	<cfset download(url.$script, tmpName) />

	<!--- inject params into core class --->
	<cfset urlVars = structKeyList(url) />
	<cfloop list="#urlVars#" index="k">
		<!--- params that start with a $ are for this script only --->
		<cfif left(k, 1) neq "$">
			<cfset v = url[k] />
			<cfset v = replaceTokens(v) />
			<cfset ramen.setParam(k, v) />
		</cfif>
	</cfloop>


	<div class="output">
		<cfinclude template="/ramen/tmp/#tmpName#" />
	</div>

	<h3>Done!</h3>
	<p><a href="index.cfm">Back to list</a></p>

</ramen:layout>
