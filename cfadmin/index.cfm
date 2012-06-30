<cfscript>
	index = get("https://raw.github.com/CFCommunity/ramen/master/index/index.json");
	json = deserializeJSON(index);

	writeDump(json);
</cfscript>

<cffunction name="get">
	<cfargument name="path" />
	<cfhttp url="#arguments.path#" method="get" result="r" />
	<cfreturn r.filecontent />
</cffunction>