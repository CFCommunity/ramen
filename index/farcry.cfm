<cfscript>
ramen.namespace("farcry");
userLocation = expandPath("/");
ramen.defaultParam("installCMSPlugin", false);
ramen.defaultParam("installFandangoSkeleton", false);
params = ramen.getParams();
installCMSPlugin = params["installCMSPlugin"];
installFandangoSkeleton = params["installFandangoSkeleton"];
if (!isBoolean(installCMSPlugin)) {
	installCMSPlugin = false;
}
if (!isBoolean(installFandangoSkeleton)) {
	installFandangoSkeleton = false;
}

// create installation directories
ramen.makePathExist(userLocation & "farcry");
ramen.makePathExist(userLocation & "farcry/projects");
if (installCMSPlugin) {
	ramen.makePathExist(userLocation & "farcry/plugins");
}
if (installFandangoSkeleton) {
	ramen.makePathExist(userLocation & "farcry/skeletons");	
}

// install core
ramen.download("https://github.com/seancoyne/farcry/zipball/milestone-6-2-0", "farcry-core-6.2.0.zip");
ramen.unzip("farcry-core-6.2.0.zip", userLocation & "farcry", true);
</cfscript>

<!--- rename dir --->
<cfdirectory name="qDirs" action="list" directory="#userLocation#farcry" type="dir" filter="seancoyne-farcry-*" />
<!--- backup old core --->
<cfif directoryExists(userLocation & "farcry/core")>
	<cfdirectory action="rename" directory="#userLocation#farcry/core" newdirectory="#userLocation#farcry/core_#dateFormat(now(),'yyyymmdd')##timeFormat(now(),'HHmmss')#" />
</cfif>
<cfdirectory action="rename" directory="#userLocation#farcry/#qDirs.name[1]#" newdirectory="#userLocation#farcry/core" />

<cfif installCMSPlugin>
	<cfscript>
	ramen.download("https://github.com/seancoyne/farcrycms/zipball/master", "farcry-farcrycms-master.zip");
	ramen.unzip("farcry-farcrycms-master.zip", userLocation & "farcry/plugins", true);
	</cfscript>
	<!--- rename dir --->
	<cfdirectory name="qDirs" action="list" directory="#userLocation#farcry/plugins" type="dir" filter="seancoyne-farcrycms-*" />
	<!--- backup old farcrycms plugin --->
	<cfif directoryExists(userLocation & "farcry/plugins/farcrycms")>
		<cfdirectory action="rename" directory="#userLocation#farcry/plugins/farcrycms" newdirectory="#userLocation#farcry/plugins/farcrycms_#dateFormat(now(),'yyyymmdd')##timeFormat(now(),'HHmmss')#" />
	</cfif>
	<cfdirectory action="rename" directory="#userLocation#farcry/plugins/#qDirs.name[1]#" newdirectory="#userLocation#farcry/plugins/farcrycms" />
</cfif>

<cfif installFandangoSkeleton>
	<cfscript>
	ramen.download("https://github.com/seancoyne/fandango-skeleton/zipball/master", "farcry-fandango-skeleton-master.zip");
	ramen.unzip("farcry-fandango-skeleton-master.zip", userLocation & "farcry/skeletons", true);
	</cfscript>
	<!--- rename dir --->
	<cfdirectory name="qDirs" action="list" directory="#userLocation#farcry/skeletons" type="dir" filter="seancoyne-fandango-skeleton-*" />
	<!--- backup old fandango skeleton --->
	<cfif directoryExists(userLocation & "farcry/skeletons/fandango")>
		<cfdirectory action="rename" directory="#userLocation#farcry/skeletons/fandango" newdirectory="#userLocation#farcry/skeletons/fandango_#dateFormat(now(),'yyyymmdd')##timeFormat(now(),'HHmmss')#" />
	</cfif>
	<cfdirectory action="rename" directory="#userLocation#farcry/skeletons/#qDirs.name[1]#" newdirectory="#userLocation#farcry/skeletons/fandango" />
</cfif>

<cfset ramen.cleanup() />

<cfoutput>
<div class="msg info">
	<p><strong>Install location:</strong> #userLocation#farcry</p>
	<p>Continue to the <a href="/farcry/core/webtop">FarCry Installer</a></p>
</div>
</cfoutput>