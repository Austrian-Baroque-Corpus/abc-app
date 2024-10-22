<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">

<xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" indent="yes" omit-xml-declaration="yes"/>

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

<xsl:template match="/">
<div class="p-2 text-left border-b border-b-gray-300">
	<h1 class="text-lg text-red-500">
		<xsl:value-of select="$doc_title"/><xsl:text> [</xsl:text><xsl:value-of select="//tei:pb[1]/@n"/><xsl:text>]</xsl:text>
	</h1>
	<a href="edition/{$link}">
		<span class="text-gray-300 text-md">Detailansicht öffnen</span>
	</a>
</div>
<div class="flex flex-row transcript active p-2 lg:flex-col md:flex-col sm:flex-col">
	<div class="basis-7/12 text px-4 yes-index sm:px-2 min-h-[800px]">
		<div class="flex flex-col section font-cambria text-xl">
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
</xsl:template>

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
	<br class="linebreak"/>
	<xsl:if test="parent::tei:titlePage and @rend">
		<hr class="border-black" />
	</xsl:if>
</xsl:template>

<xsl:template match="tei:figure">
	<div>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="tei:lb[@break]">
	<span class="linebreak"><xsl:text>=</xsl:text><br /></span>
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

<xsl:template match="tei:w[parent::tei:item]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:if test="following-sibling::*[1]/name() = 'pc'">
		<xsl:value-of select="following-sibling::*[1]"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:w[not(parent::tei:item)]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:if test="following-sibling::*[1]/name() = 'pc'">
		<xsl:value-of select="following-sibling::*[1]"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:seg[not(@type='whitespace')]">
	<xsl:variable name="rend" select="if(@rend = 'bold') then('font-bold')
																		else if(@rend = 'antiqua') then('font-antiqua')
																		else if(@rend = 'spaced') then('tracking-[.3em]')
																		else if(@rend = 'italicised') then('italic')
																		else if(@rend = 'smallCaps') then('font-variant')
																		else('')"/>
	<xsl:choose>
		<xsl:when test="@rend = 'initialCapital'">

				<xsl:choose>
					<xsl:when test="child::tei:w">
						<span class="text-3xl">
							<xsl:value-of select="substring(./tei:w/., 1, 1)"/>
						</span>
						<xsl:value-of select="substring(./tei:w/., 2)"/>
					</xsl:when>
					<xsl:otherwise>
						<span class="text-3xl">
							<xsl:value-of select="substring(., 1, 1)"/>
						</span>
						<xsl:value-of select="substring(., 2)"/>
					</xsl:otherwise>
				</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<span class="{$rend}">
				<xsl:apply-templates/>
			</span>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="following-sibling::*[1]/name() = 'pc'">
		<xsl:value-of select="following-sibling::*[1]"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:seg[@type='whitespace']">
	<xsl:apply-templates/>
	<xsl:if test="following-sibling::*[1]/name() = 'pc'">
		<xsl:value-of select="following-sibling::*[1]"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:pc"/>

<!-- <xsl:template match="tei:fw[@type='footer']">
	<span class="block mt-[200px]">
		<xsl:apply-templates/>
	</span>
</xsl:template> -->

<!-- <xsl:template match="tei:fw[@type='header']">
	<span class="block mt-[200px]">
		<xsl:apply-templates/>
	</span>
</xsl:template> -->

<xsl:template match="tei:fw[@type='pageNum']">
	<span>
		<xsl:choose>
			<xsl:when test="parent::tei:fw[@type='header']/following-sibling::tei:lb[@rend='line']">
				<xsl:attribute name="class">font-antiqua block yes-index text-center px-2 border-b border-black</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">font-antiqua block yes-index text-center px-2</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="tei:fw[@type='catch']">
	<span class="block yes-index text-right px-2">
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
