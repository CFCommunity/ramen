<cfset ramen.namespace("ramen") />

<cfset zipUrl = "https://github.com/CFCommunity/ramen/zipball/master" />
<cfset zipName = "ramen.0.1.zip" />
<cfset ramenPath = expandPath('/CFIDE/Administrator/ramen') />
<cfset unzipPath = ramen.getTmpPath() & "/ramen" />

<cfoutput>
	<p>Downloading Ramen 0.1...</p>
	<cfflush />
	<cfset ramen.download( zipUrl, zipName ) />

	<p>Unzipping...</p>
	<cfflush />
	<cfset ramen.unzip( zipName, unzipPath ) />

	<p>Installing...</p>
	<cfflush />
	<cfdirectory action="list" directory="#unzipPath#" name="dirs" type="dir" />
	<cfloop query="#dirs#">
		<cfif left( dirs.name, 18) eq "CFCommunity-ramen-">
			<cfset srcDir = dirs.name />
			<cfdirectory action="rename" directory="#unzipPath#/#srcDir#/cfadmin" newDirectory="#ramenPath#/cfadmin" />
			<cfbreak />
		</cfif>
	</cfloop>

	<p>Cleaning up...</p>
	<cfflush />
	<cfset ramen.cleanup() />

</cfoutput>
