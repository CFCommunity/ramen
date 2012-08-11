<cfcomponent>
	<cfset this.name = "ramen" />
	<cfset this.mappings = {} />

	<cfswitch expression="#listFirst(server.coldfusion.productversion)#">
		<cfcase value="8">
			<cfset this.mappings["/ramen"] = getTempDirectory() & "ramen" />
		</cfcase>
		<cfdefaultcase>
			<cfset this.mappings["/ramen"] = "ram:///ramen" />
		</cfdefaultcase>
	</cfswitch>

	<cffunction name="onRequestStart">
		<cfsetting showdebugoutput="false" />
	</cffunction>

</cfcomponent>