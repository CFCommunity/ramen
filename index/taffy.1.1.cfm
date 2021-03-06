<cfset ramen.namespace("taffy") />
<cfset userLocation = ramen.getParams().location />

<div class="msg info">
	<cfoutput>
		<strong>Install location:</strong> #userLocation#<br/>
	</cfoutput>

	<cfset ramen.download("https://github.com/downloads/atuttle/Taffy/taffy-v1.1.1.zip", "taffy-1.1.1.zip") />
	<cfset ramen.unzip("taffy-1.1.1.zip", userLocation) />
	<cfset ramen.cleanup() />
</div>

<div class="msg success">
	<p>Taffy install complete.</p>
</div>
