<cfset ramen.namespace("underscore") />
<cfset userLocation = ramen.getParams().location />

<div class="msg info">
  <cfoutput>
    <strong>Install location:</strong> #userLocation#<br/>
  </cfoutput>

  <cfset ramen.download("https://github.com/downloads/russplaysguitar/UnderscoreCF/Underscore.cfc.2.2.zip", "Underscore.cfc.2.2.zip") />
  <cfset ramen.unzip("Underscore.cfc.2.2.zip", userLocation) />
  <cfset ramen.cleanup() />
</div>

<div class="msg success">
  <p>Underscore.cfc install complete.</p>
</div>
