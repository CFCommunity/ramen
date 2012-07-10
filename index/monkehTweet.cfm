<cfset ramen.namespace("monkehtweet") />
<cfset userLocation = ramen.getParams().location />

<div class="msg info">
	<cfoutput>
		<strong>Install location:</strong> #userLocation#<br/>
	</cfoutput>

	<cfset ramen.download("https://github.com/coldfumonkeh/monkehTweets/zipball/master", "monkehTweet_latest.zip") />
	<cfset ramen.unzip("monkehTweet_latest.zip", userLocation) />
	<cfset ramen.cleanup() />
</div>

<div class="msg success">
	<cfoutput>
	<p>monkehTweet has been downloaded and unzipped.</p>
	<p>To complete the process and get your Twitter application up and running, you will need to register an application with Twitter and obtain the consumer secret and consumer key values. <a href="https://dev.twitter.com/apps" target="_blank">https://dev.twitter.com/apps</a> (will open in a new window)</p>
	<p>Once you have these, you will need to include them in the #userLocation#Application.cfc file.<p>
	<p>You can also read the installation documentation provided with this download: #userLocation#installation/monkehTweets_readMe.pdf file.<p>
	</cfoutput>
</div>