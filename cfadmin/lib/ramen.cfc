<cfcomponent>
	<cfscript>

		//always run init
		init();

		function init(){
			variables.$ = {
				location = expandPath("/tmp")
			}; //for input params from user to developer

			variables._ns = "";

			switch (listFirst(server.coldfusion.productversion)){
				case "10":
				case "9":
					variables.parentPath = "ram:///ramen";
					variables.downloadsPath = "ram:///ramen/downloads/";
					variables.tmpPath = "ram:///ramen/tmp/";

					break;
				case "8":
					variables.parentPath = getTempDirectory() & "ramen";
					variables.downloadsPath = getTempDirectory() & "ramen/downloads/";
					variables.tmpPath = getTempDirectory() & "ramen/tmp/";

					break;
			}

			makePathExist(variables.parentPath);
			makePathExist(variables.downloadsPath);
			makePathExist(variables.tmpPath);
		}

		function makePathExist(p){
			if (!directoryExists(p)) directoryCreate(p);
		}

		function namespace(ns){
			variables._ns = ns;
			variables.downloadsPath = variables.downloadsPath & ns & "/";
			variables.tmpPath = variables.tmpPath & ns & "/";
			makePathExist(variables.downloadsPath);
			makePathExist(variables.tmpPath);
		}

		//---------------------------

		function getDownloadsPath(){
			return variables.downloadsPath;
		}

		function getTmpPath(){
			return variables.tmpPath;
		}

		function setParam(k, v){
			variables.$[k] = v;
		}
		function getParams(){
			return variables.$;
		}
		function defaultParam(varname, defaultVal){
			if (structKeyExists(variables.$, varname)){
				return;
			}
			variables.$[varname] = defaultVal;
		}

	</cfscript>

	<cffunction name="download">
		<cfargument name="urlpath" required="true" />
		<cfargument name="filename" required="true" />
		<cfif variables._ns eq "">
			<cfset namespace(hash(now())) />
		</cfif>
		<cfhttp method="get" url="#urlpath#" path="#getDownloadsPath()#" file="#filename#" />
		<cfreturn getDownloadsPath() & "/" & filename />
	</cffunction>

	<cffunction name="unzip">
		<cfargument name="zipName" required="true" hint="just the file name. path will be the downloads path. (use ramen.download())" />
		<cfargument name="destFolder" required="true" />
		<cfargument name="overwrite" default="false" />
		<cftry>
			<cfzip action="unzip" file="#getDownloadsPath()##zipName#" destination="#destFolder#" overwrite="#arguments.overwrite#" />
			<cfcatch>
				<cfif findNoCase("already exists", cfcatch.detail)>
					<cfset writeOutput("Destination directory exists, install aborted. Overwrite not permitted.") />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="cleanup">
		<cfdirectory action="delete" directory="#variables.tmpPath#" recurse="true" />
		<cfdirectory action="delete" directory="#variables.downloadsPath#" recurse="true" />
	</cffunction>

</cfcomponent>
