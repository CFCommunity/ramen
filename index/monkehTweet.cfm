<cfset ramen.namespace("monkehtweet") />
<cfset userLocation = ramen.getParams().location />

<div class="msg info">

	<cfoutput>
		<p><strong>Install location:</strong> #userLocation#</p>
	</cfoutput>

	<cfset ramen.download("https://github.com/coldfumonkeh/monkehTweets/zipball/master", "monkehTweet_latest.zip") />
	<cfset ramen.unzip("monkehTweet_latest.zip", userLocation) />

</div>

<!--- since github gives the BER folder downloads a funky name, weve got to figure out what it was so we can rename it --->
<cfdirectory action="list" directory="#userLocation#" name="dirs" type="dir" />
<cfloop query="#dirs#">
	<cfif left( dirs.name, 26) eq "coldfumonkeh-monkehtweets-">
		<cfset srcDir = dirs.name />
		<cfdirectory action="rename" directory="#ramen.getDownloadsPath()#/#srcDir#" newDirectory="#userLocation#/monkehtweet" />
		<cfbreak />
	</cfif>
</cfloop>

<cfset ramen.cleanup() />

<div class="msg success">
	<cfoutput>
	<p>monkehTweet has been downloaded and unzipped.</p>
	<p>To complete the process and get your Twitter application up and running, you will need to register an application with Twitter and obtain the consumer secret and consumer key values. <a href="https://dev.twitter.com/apps" target="_blank">https://dev.twitter.com/apps</a> (will open in a new window)</p>
	<p>Once you have these, you will need to include them in the #userLocation#/Application.cfc file.<p>
	<p>You can also read the installation documentation provided with this download: #userLocation#/installation/monkehTweets_readMe.pdf file.<p>
	</cfoutput>
</div>
