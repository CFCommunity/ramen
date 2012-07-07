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
				<cfset dirCopy(path & "/" & files.name, userLocation & "/" & files.name) />
				<cfdirectory action="delete" directory="#path#/#files.name#" recurse="true" />
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

<!---
 Copies a directory.
 v3 mod by Anthony Petruzzi

 @param source      Source directory. (Required)
 @param destination      Destination directory. (Required)
 @param ignore      List of folders, files to ignore. Defaults to nothing. (Optional)
 @param nameConflict      What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)
 @return Returns nothing.
 @author Joe Rinehart (joe.rinehart@gmail.com)
 @version 3, April 26, 2011
--->
<cffunction name="dirCopy" output="true">
	<cfargument name="source" required="true" type="string">
	<cfargument name="destination" required="true" type="string">
	<cfargument name="ignore" required="false" type="string" default="">
	<cfargument name="nameconflict" required="true" default="overwrite">

	<cfset var contents = "" />

	<cfif not(directoryExists(arguments.destination))>
		<cfdirectory action="create" directory="#arguments.destination#">
	</cfif>

	<cfdirectory action="list" directory="#arguments.source#" name="contents">

	<cfif len(arguments.ignore)>
		<cfquery dbtype="query" name="contents">
		select * from contents where name not in(#ListQualify(arguments.ignore, "'")#)
		</cfquery>
	</cfif>

	<cfloop query="contents">
		<cfif contents.type eq "file">
			<cffile action="copy" source="#arguments.source#/#name#" destination="#arguments.destination#/#name#" nameconflict="#arguments.nameConflict#">
		<cfelseif contents.type eq "dir">
			<cfset dirCopy(arguments.source & "/" & name, arguments.destination & "/" &  name, arguments.ignore, arguments.nameConflict) />
		</cfif>
	</cfloop>
</cffunction>
