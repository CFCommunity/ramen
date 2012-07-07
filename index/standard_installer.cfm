<cfset ramen.namespace("standard_installer") />

<!--- get params defined in config (if you need more than this, you'll need a custom installer) --->
<cfset userLocation = ramen.getParams().location/>
<cfset zipFile = ramen.getParams().zipFile />

<!---
	If your target zip contains lots of stuff and you want to create
	a new folder for it all to live in, set this to TRUE and specify a value for "createFolderName"
	(can be user-editable or hidden).

	On the other hand, if your zip already contains its self-containing folder, then set this to false
	and ignore the "createFolderName" setting.

	NOTE: The user is prompted for an install location, and if the folder they specify does not exist
	then it will be created automatically (as long as its direct parent exists). If you specify that
	a folder should be created, it will be created INSIDE the user-specified folder. So, if the user
	specifies {something}/mxunit and you also specify that an "mxunit" folder should be created, then
	the user will end up with something like: {something}/mxunit/mxunit...

	THEREFORE it is advisable that you set the default install folder to something resembling
	"{webroot}/mxunit" so that the user knows they need to include the "/mxunit" portion and you can
	safely ignore the create folder setting.
--->
<cfset ramen.defaultParam("createFolder", false) />
<cfset createFolder = ramen.getParams().createFolder />
<cfif createFolder neq "false">
	<cfset createFolderName = ramen.getParams().createFolder />
</cfif>

<cfif createFolder neq "false">
	<cfset userLocation = listAppend(userLocation, createFolderName, "/") />
</cfif>

<cfset ramen.defaultParam("escapeFolder", false) />
<cfset escapeFolder = ramen.getParams().escapeFolder />
<cfif escapeFolder neq "false">
	<cfset escapeFolderName = ramen.getParams().escapeFolder />
</cfif>

<div class="msg info">
	<cfoutput>
		<strong>Install location:</strong> #userLocation#<br/>
	</cfoutput>

	<!--- if the specified directory doesn't exist, creates it (only works if direct-parent exists) --->
	<cfif not directoryExists( userLocation )>
		<cfdirectory action="create" directory="#userLocation#" />
	</cfif>

	<cfset ramen.download( zipFile, "tmp.zip") />

	<cfif escapeFolder eq "false">
		<cfset ramen.unzip( "tmp.zip", userLocation ) />
	<cfelse>
		<cfset basepath = ramen.getTmpPath() />
		<cfset ramen.unzip( "tmp.zip", basepath ) />
		<cfset path = basepath & "/" & escapeFolderName />

		<cfdirectory action="list" directory="#path#" recurse="false" name="files" />
		<strong>Installing files:</strong>
		<ul>
		<cfloop query="#files#">
			<cfif files.type eq "Dir">
				<!--- move directories --->
				<cfdirectory action="rename" directory="#path#/#files.name#" newdirectory="#userLocation#/#files.name#" />
			<cfelseif files.type eq "File">
				<!--- move files --->
				<cffile action="move" source="#path#/#files.name#" destination="#userLocation#/#files.name#" />
			</cfif>
			<li>/#files.name#</li>
		</cfloop>
		</ul>
	</cfif>

	<cfset ramen.cleanup() />
</div>

<div class="msg success">
	<p>Install complete.</p>
</div>
