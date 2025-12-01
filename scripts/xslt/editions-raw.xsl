<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">

<xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" indent="no" omit-xml-declaration="yes"/>

<xsl:import href="./partials/shared.xsl"/>
<xsl:import href="./partials/aot-options.xsl"/>

<xsl:variable name="prev">
		<xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '')"/>
</xsl:variable>
<xsl:variable name="next">
		<xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '')"/>
</xsl:variable>
<xsl:variable name="teiSource">
		<xsl:value-of select="data(tei:TEI/@xml:id)"/>
</xsl:variable>
<xsl:variable name="link">
		<xsl:value-of select="replace($teiSource, '.xml', '')"/>
</xsl:variable>
<xsl:variable name="doc_title">
		<xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
</xsl:variable>
<xsl:variable name="book_title">
		<xsl:value-of select=".//tei:sourceDesc/tei:bibl[@type='short']"/>
</xsl:variable>

<xsl:template match="/">
<div class="pl-4 text-left border-b border-b-gray-300" id="edition-content" data-prev="{$prev}" data-next="{$next}">
	<h1 class="text-lg text-red-500">
		<xsl:value-of select="$doc_title"/><xsl:text> </xsl:text><xsl:value-of select="//tei:pb[1]/@n"/>
	</h1>
	<!-- <a href="edition/{$link}">
		<span class="text-gray-300 text-md">Detailansicht öffnen</span>
	</a> -->
</div>
<div class="flex flex-row transcript active lg:flex-col md:flex-col sm:flex-col">
	<div class="basis-7/12 text yes-index">
		<div class="pl-4 flex flex-col section font-cambria text-lg">
			<xsl:for-each select=".//tei:front|.//tei:body|.//tei:back">
				<xsl:apply-templates/>
			</xsl:for-each>
		</div>
	</div>
	<div class="basis-5/12 facsimiles">
		<div id="viewer-1" class="sticky top-24">
			<div id="container_facs_1">
			</div>
		</div>
	</div>
</div>
<div id="citation-info" class="border-x-gray-500 p-2 text-sm">
	<xsl:text>Zitation: </xsl:text><xsl:value-of select="$book_title"/><xsl:text> (Digitale Ausgabe) </xsl:text>
	<xsl:value-of select="//tei:pb[1]/@n"/><xsl:text>. In: ABaC:us – Austrian Baroque Corpus. Hrsg. von Claudia Resch und
	Ulrike Czeitschner. &lt;</xsl:text><a href="suche?seite={$link}" class="text-red-600 cursor-pointer" id="citurl"><xsl:text>suche?seite=</xsl:text><xsl:value-of select="$link"/></a><xsl:text>&gt; abgerufen am </xsl:text><span id="cittoday"></span><xsl:text>.</xsl:text>
</div>
</xsl:template>

<!-- Hide all <supplied> content -->
<xsl:template match="tei:supplied"/>

<xsl:template match="tei:titlePage">
	<div class="title-page" id="#top_page">
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="tei:docTitle">
	<div>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="tei:titlePart">
	<h4 class="yes-index text-center py-2">
		<xsl:apply-templates/>
	</h4>
</xsl:template>

<xsl:template match="tei:byline">
	<div>
		<p class="yes-index text-center py-2">
			<xsl:apply-templates/>
		</p>
	</div>
</xsl:template>

<xsl:template match="tei:docImprint">
	<div>
		<p class="yes-index text-center py-2">
			<xsl:apply-templates/>
		</p>
	</div>
</xsl:template>

<xsl:template match="tei:head">
	<h5 class="yes-index text-center font-semibold">
		<xsl:apply-templates/>
	</h5>
</xsl:template>

<xsl:template match="tei:lb[not(@break)]">
	<xsl:choose>
		<!-- Don't render lb[@rend='line'] that follows a header - it's handled by the header template -->
		<xsl:when test="@rend='line' and preceding-sibling::*[1][self::tei:fw[@type='header']]">
			<!-- Suppress this lb element -->
		</xsl:when>
		<xsl:otherwise>
			<br class="linebreak"/>
			<xsl:if test="parent::tei:titlePage and @rend">
				<hr class="border-black" />
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:figure">
	<div>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="tei:lb[@break]">
	<span class="linebreak">
		<xsl:variable name="preceding-text" select="preceding-sibling::text()[1]"/>
		<xsl:variable name="last-char" select="substring($preceding-text, string-length($preceding-text))"/>
		<xsl:choose>
			<!-- If break="no" without type attribute, don't add any character -->
			<xsl:when test="@break = 'no' and not(@type)">
				<!-- No character added for break="no" without type -->
			</xsl:when>
			<!-- Type "s" = single hyphen -->
			<xsl:when test="@type = 's'">
				<xsl:if test="not($last-char = '-')">
					<xsl:text>-</xsl:text>
				</xsl:if>
			</xsl:when>
			<!-- Type "d" = double hyphen (equals sign) -->
			<xsl:when test="@type = 'd'">
				<xsl:if test="not($last-char = '=' or $last-char = '-')">
					<xsl:text>=</xsl:text>
				</xsl:if>
			</xsl:when>
			<!-- Default behavior - use equals sign -->
			<xsl:otherwise>
				<xsl:if test="not($last-char = '=' or $last-char = '-')">
					<xsl:text>=</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<br />
	</span>
</xsl:template>

<xsl:template match="tei:div">
	<div>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<!--

<xsl:template match="tei:lb[parent::tei:list]"/> -->

<!-- <xsl:template match="//text()[parent::tei:w[ancestor::tei:body]]">
	<xsl:choose>
		<xsl:when test="parent::tei:w/following-sibling::tei:*[1]/@break='no'">
			<xsl:value-of select="replace(., '\s+$', '')"/>
		</xsl:when>
		<xsl:when test="parent::tei:w/preceding-sibling::tei:*[1]/@break='no'">
			<xsl:value-of select="replace(., '^\s', '')"/>
		</xsl:when>
		<xsl:when test="matches(., '=$', 'm')">
			<xsl:value-of select="replace(., '\s+$', '')"/>
		</xsl:when>
		<xsl:when test="matches(., '-$', 'm')">
				<xsl:value-of select="replace(., '\s+$', '')"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template> -->

<xsl:template match="tei:w[parent::tei:rs]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[parent::tei:foreign]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:docDate]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:date and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(ancestor::tei:choice) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:choice and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[parent::tei:seg[not(@type='whitespace')] and not(ancestor::tei:docDate)]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:persName and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(ancestor::tei:date) and not(ancestor::tei:choice) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:placeName and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(ancestor::tei:date) and not(ancestor::tei:choice) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:name and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(ancestor::tei:date) and not(ancestor::tei:choice) and not(ancestor::tei:persName) and not(ancestor::tei:placeName) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[parent::tei:item]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:w[not(parent::tei:item or parent::tei:rs or parent::tei:foreign or parent::tei:seg[not(@type='whitespace')] or ancestor::tei:docDate or ancestor::tei:date or ancestor::tei:choice or ancestor::tei:persName or ancestor::tei:placeName or ancestor::tei:name)]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:seg[not(@type='whitespace' or @type='ornament')]">
	<xsl:variable name="rend" select="if(@rend = 'bold') then('font-bold')
																		else if(@rend = 'antiqua') then('font-antiqua')
																		else if(@rend = 'spaced') then('tracking-[.3em]')
																		else if(@rend = 'italicised') then('italic')
																		else if(@rend = 'smallCaps') then('font-variant')
																		else('')"/>
	<xsl:choose>
		<xsl:when test="@rend = 'initialCapital'">
			<!-- Process content with special handling for first character -->
			<xsl:apply-templates mode="initialCapital"/>
		</xsl:when>
		<xsl:otherwise>
			<span class="{$rend}">
				<xsl:apply-templates/>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Templates for initialCapital mode -->
<xsl:template match="node()[1][self::text()]" mode="initialCapital" priority="2">
	<!-- First text node - make first character large -->
	<span class="text-3xl">
		<xsl:value-of select="substring(., 1, 1)"/>
	</span>
	<xsl:value-of select="substring(., 2)"/>
</xsl:template>

<xsl:template match="tei:w[1]" mode="initialCapital" priority="2">
	<!-- First word in initialCapital segment -->
	<span class="text-3xl">
		<xsl:value-of select="substring(., 1, 1)"/>
	</span>
	<xsl:value-of select="substring(., 2)"/>
</xsl:template>

<xsl:template match="tei:w" mode="initialCapital">
	<!-- Other words - render normally -->
	<xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="tei:lb" mode="initialCapital">
	<!-- Render line breaks normally in initialCapital mode -->
	<xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="tei:pc" mode="initialCapital">
	<!-- Render punctuation normally in initialCapital mode -->
	<xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="*" mode="initialCapital">
	<!-- For other elements (like rs, seg, etc.), apply templates to their children in initialCapital mode -->
	<xsl:apply-templates mode="initialCapital"/>
</xsl:template>

<xsl:template match="text()" mode="initialCapital">
	<!-- Regular text nodes - just output as is -->
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="tei:seg[@type='ornament']">
	<span class="ornament">
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="tei:pc">
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="tei:g">
	<xsl:choose>
		<xsl:when test="@ref = '#bracketsMW'">
			<xsl:text>):( . . .</xsl:text>
		</xsl:when>
		<xsl:when test="@ref = '#bracketsTC'">
			<xsl:text>)(</xsl:text>
		</xsl:when>
		<xsl:when test="@ref = '#footerDots'">
			<xsl:text>. . .</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:milestone[@type='separator']">
	<div class="text-center yes-index">
		<xsl:text>⌫⌦</xsl:text>
	</div>
</xsl:template>

<xsl:template match="tei:fw[@type='footer']">
	<div class="grid grid-cols-3 items-center yes-index">
		<xsl:apply-templates/>
		<!-- Check if there's a catch word immediately following this footer -->
		<xsl:if test="following-sibling::*[1][self::tei:fw[@type='catch']]">
			<xsl:variable name="catch" select="following-sibling::*[1][self::tei:fw[@type='catch']]"/>
			<span>
				<xsl:choose>
					<xsl:when test="$catch/@place='bot_left'">
						<xsl:attribute name="class">yes-index text-left px-2 col-start-1</xsl:attribute>
					</xsl:when>
					<xsl:when test="$catch/@place='bot_center'">
						<xsl:attribute name="class">yes-index text-center px-2 col-start-2</xsl:attribute>
					</xsl:when>
					<xsl:when test="$catch/@place='bot_right'">
						<xsl:attribute name="class">yes-index text-right px-2 col-start-3</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">yes-index text-right px-2 col-start-3</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="$catch/node()"/>
			</span>
		</xsl:if>
	</div>
</xsl:template>

<xsl:template match="tei:fw[@type='header']">
	<div>
		<xsl:choose>
			<!-- If followed by lb[@rend='line'], add border-bottom to this header div -->
			<xsl:when test="following-sibling::*[1][self::tei:lb[@rend='line']]">
				<xsl:attribute name="class">grid grid-cols-3 items-center yes-index border-b border-black pb-1</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">grid grid-cols-3 items-center yes-index</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="tei:fw[@type='pageNum']">
	<span class="font-antiqua yes-index px-2">
		<xsl:choose>
			<xsl:when test="@place='top_left' or @place='bot_left'">
				<xsl:attribute name="class">font-antiqua yes-index px-2 text-left col-start-1</xsl:attribute>
			</xsl:when>
			<xsl:when test="@place='top_center' or @place='bot_center'">
				<xsl:attribute name="class">font-antiqua yes-index px-2 text-center col-start-2</xsl:attribute>
			</xsl:when>
			<xsl:when test="@place='top_right' or @place='bot_right'">
				<xsl:attribute name="class">font-antiqua yes-index px-2 text-right col-start-3</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">font-antiqua yes-index px-2 text-center col-start-2</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="tei:fw[@type='catch']">
	<!-- Suppress if immediately after footer (it's already rendered by the footer template) -->
	<xsl:if test="not(preceding-sibling::*[1][self::tei:fw[@type='footer']])">
		<div class="block yes-index text-right px-2">
			<xsl:apply-templates/>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:fw[@place and not(@type='pageNum' or @type='catch')]">
	<span>
		<xsl:choose>
			<xsl:when test="@place='top_center' or @place='bot_center'">
				<xsl:attribute name="class">yes-index text-center col-start-2</xsl:attribute>
			</xsl:when>
			<xsl:when test="@place='top_left' or @place='bot_left'">
				<xsl:attribute name="class">yes-index text-left col-start-1</xsl:attribute>
			</xsl:when>
			<xsl:when test="@place='top_right' or @place='bot_right'">
				<xsl:attribute name="class">yes-index text-right col-start-3</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">yes-index col-start-2</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="tei:persName[ancestor::tei:body or ancestor::tei:front]">
	<span class="person">
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="tei:placeName[ancestor::tei:body or ancestor::tei:front]">
	<span class="place">
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="tei:ab">
	<xsl:choose>
		<xsl:when test="@type='catch-word'">
			<div class="grid-item w-[100%] text-end">
				<h5 class="yes-index catch-word">
						<xsl:apply-templates/>
				</h5>
			</div>
		</xsl:when>
		<xsl:when test="@type='imprint' and not(contains(@facs, 'facs_1_'))">
			<div>
				<h5 class="italic yes-index text-center">
						<xsl:apply-templates/>
				</h5>
			</div>
		</xsl:when>
		<xsl:when test="@type='count-date' and not(contains(@facs, 'facs_1_'))">
			<div>
				<h4 class="yes-index text-center">
						<xsl:apply-templates/>
				</h4>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<div>
			<h5 class="yes-index">
					<xsl:apply-templates/>
			</h5>
			</div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:p">
	<xsl:variable name="indent" select="if(@rend = 'indent') then('indent-8') else('')"/>
	<p class="yes-index text-justify py-1 {$indent}">
		<xsl:apply-templates/>
		<!--<xsl:if test="following-sibling::tei:p[@prev]">
				<xsl:if test="following-sibling::*[1]/name() = 'pb'">
						<xsl:for-each select="following-sibling::*[1]">
								<span class="anchor-pb"></span>
								<span class="pb lightgrey" source="{@facs}">[<xsl:value-of select="./@n"/>]</span>
						</xsl:for-each>
				</xsl:if>
				<xsl:for-each select="following-sibling::tei:p[@prev]">
						<xsl:apply-templates/>
				</xsl:for-each>
		</xsl:if>-->
	</p>
</xsl:template>

<xsl:template match="tei:list">
	<ul class="p-4">
		<xsl:apply-templates/>
	</ul>
</xsl:template>

<xsl:template match="tei:item">
	<li class="yes-index {if(preceding-sibling::*[1]/@break = 'no') then 'ml-4' else ''}">
		<xsl:apply-templates/>
	</li>
</xsl:template>

<!--<xsl:template match="tei:p[@prev]"/>-->

<!--<xsl:template match="tei:pb[following-sibling::tei:p[@prev]]"/>-->

<!--    <xsl:template match="tei:div">
		<!-\-<div id="{local:makeId(.)}">
				<xsl:apply-templates/>
		</div>-\->
		<xsl:apply-templates/>
</xsl:template>  -->

</xsl:stylesheet>
