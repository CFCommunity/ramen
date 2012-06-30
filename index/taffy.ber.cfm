<cfset ramen.namespace("taffy") />
<cfset userLocation = ramen.getParams().location />

<cfoutput>
	<strong>Install location:</strong> #userLocation#<br/>
</cfoutput>

<cfset ramen.download("https://github.com/atuttle/Taffy/zipball/develop", "taffy-ber.zip") />
<cfset ramen.unzip("taffy-ber.zip", userLocation) />

<!--- since github gives the BER folder downloads a funky name, weve got to figure out what it was so we can rename it --->
<cfdirectory action="list" directory="#userLocation#" name="dirs" type="dir" />
<cfloop query="#dirs#">
	<cfif left( dirs.name, 14) eq "atuttle-Taffy-">
		<cfset srcDir = dirs.name />
		<cfdirectory action="rename" directory="#userLocation#/#srcDir#" newDirectory="#userLocation#/taffy" />
		<cfbreak />
	</cfif>
</cfloop>

<cfset ramen.cleanup() />