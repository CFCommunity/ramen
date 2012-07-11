<cfset ramen.namespace("mxunit") />
<cfset userLocation = ramen.getParams().location />

<div class="msg info">
	<cfoutput>
		<strong>Install location:</strong> #userLocation#<br/>
	</cfoutput>

	<cfset ramen.download("https://github.com/downloads/mxunit/mxunit/mxunit-2.1.1.zip", "mxunit-2.1.1.zip") />
	<cfset ramen.unzip("mxunit-2.1.1.zip", userLocation) />
	<cfset ramen.cleanup() />
</div>

<div class="msg success">
	<p>MXUnit install complete.</p>
</div>
