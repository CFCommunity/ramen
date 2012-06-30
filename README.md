## Integrated Installer for ColdFusion Servers

Ramen is inspired by many things. [Homebrew][1], [Ruby Gems][2], and of course the [Railo Extension Manager][3]. Hat tips all around!

It's an integrated installation system operated wholly _by and for the ColdFusion Community_. It aims to be compatible with ColdFusion 8 and above.

We'll get the party started by adding installation scripts for some of our favorite frameworks and apps, but it's up to the community to add installer scripts for your favorites. Don't be intimidated, it can be as easy as this!

```cfm
<cfset ramen.namespace("taffy") />
<cfset userLocation = ramen.getParams().location />

<cfoutput>
	<strong>Install location:</strong> #userLocation#<br/>
</cfoutput>

<cfset ramen.download("https://github.com/downloads/atuttle/Taffy/taffy-v1.1.zip", "taffy-1.1.zip") />
<cfset ramen.unzip("taffy-1.1.zip", userLocation) />
<cfset ramen.cleanup() />

<p>Taffy install complete.</p>
```

The above code sample is [the install script for Taffy 1.1][4]. See how easy it is? Oh, there's 1 more part. You've got to add some JSON to [the index][5]:

```json
{
	"name": "Taffy",
	"desc": "Taffy is a framework for creating REST API's with extremely terse, object-oriented code.",
	"icon": "",
	"versions": [
		{
			"name": "Bleeding Edge Release (BER)",
			"desc": "The BER is the absolute latest available code. Possibility of bugs, but latest features!",
			"install": "https://raw.github.com/CFCommunity/ramen/master/index/taffy.ber.cfm",
			"require": [
				{
					"name": "location",
					"label": "Install Location:",
					"type": "folder",
					"default": "{webroot}"
				}
			]
		},
		{
			"name": "1.1 Official Release",
			"desc": "This is the latest version of Taffy, now with Railo support and improved ColdSpring integration",
			"install": "https://raw.github.com/CFCommunity/ramen/master/index/taffy.1.1.cfm",
			"require": [
				{
					"name": "location",
					"label": "Install Location:",
					"type": "folder",
					"default": "{webroot}"
				}
			]
		}
	]
}
```

I think you can handle that.

Want your favorite Framework/App/Tool/whatever to be listed? **You're just a pull request away!**

## Installation into your CF Administrator

1. [Download Ramen][6] and extract the `ramen` folder to be inside `/CFIDE/administrator/`.
2. Edit /CFIDE/administrator/custommenu.xml to add this line:

```xml
    <menuitem href="ramen/cfadmin/index.cfm" target="content">Ramen</menuitem>
```

3. If you don't have a submenu block, then add that as well:

```xml
	<submenu label="Admin Tools">
		<menuitem href="ramen/cfadmin/index.cfm" target="content">Ramen</menuitem>
	</submenu>
```

4. Then log into your CF Administrator, and look for the Ramen link:

![where to find the Ramen link](https://img.skitch.com/20120630-g825ijiddkuaw39yaf6hdbqkbp.png)

## LICENSE

This project is free, open source software, available under the MIT License:

>The MIT License (MIT)
>
>Copyright (c) 2011 Adam Tuttle and Contributors
>
>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, >FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER >LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER >DEALINGS IN THE SOFTWARE.


[1]: http://mxcl.github.com/homebrew/
[2]: http://rubygems.org/
[3]: http://www.getrailo.com/index.cfm/products/railo-extensions/
[4]: https://github.com/CFCommunity/ramen/blob/master/index/taffy.1.1.cfm
[5]: https://github.com/CFCommunity/ramen/blob/master/index/index.json
