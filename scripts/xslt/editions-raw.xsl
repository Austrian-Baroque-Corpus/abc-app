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
<xsl:variable name="book_title">
		<xsl:value-of select=".//tei:sourceDesc/tei:bibl[@type='short']"/>
</xsl:variable>

<xsl:template match="/">
<div class="text-left border-b border-b-gray-300" id="edition-content" data-prev="{$prev}" data-next="{$next}">
	<h1 class="text-lg text-red-500">
		<xsl:value-of select="$doc_title"/><xsl:text> </xsl:text><xsl:value-of select="//tei:pb[1]/@n"/>
	</h1>
	<!-- <a href="edition/{$link}">
		<span class="text-gray-300 text-md">Detailansicht öffnen</span>
	</a> -->
</div>
<div class="flex flex-row transcript active lg:flex-col md:flex-col sm:flex-col">
	<div class="basis-7/12 text yes-index">
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
<div id="citation-info" class="border-x-gray-500 p-2 text-sm">
	<xsl:text>Zitation: </xsl:text><xsl:value-of select="$book_title"/><xsl:text> (Digitale Ausgabe) </xsl:text>
	<xsl:value-of select="//tei:pb[1]/@n"/><xsl:text>. In: ABaC:us – Austrian Baroque Corpus. Hrsg. von Claudia Resch und
	Ulrike Czeitschner. &lt;</xsl:text><a href="suche?seite={$link}" class="text-red-600 cursor-pointer" id="citurl"><xsl:text>suche?seite=</xsl:text><xsl:value-of select="$link"/></a><xsl:text>&gt; abgerufen am </xsl:text><span id="cittoday"></span><xsl:text>.</xsl:text>
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
			<!-- Check if inside antiqua segment OR immediately after antiqua segment (ignoring whitespace text) - use hyphen instead of equals -->
			<xsl:when test="ancestor::tei:seg[@rend='antiqua'] or (preceding-sibling::*[1][self::tei:seg[@rend='antiqua']] and not(normalize-space(preceding-sibling::text()[1])))">
				<!-- Only add hyphen if there's no hyphen already -->
				<xsl:if test="not($last-char = '-')">
					<xsl:text>-</xsl:text>
				</xsl:if>
			</xsl:when>
			<!-- Default behavior - use equals sign -->
			<xsl:otherwise>
				<!-- Check if there's already a hyphen or equals before the line break -->
				<xsl:if test="not($last-char = '=' or $last-char = '-')">
					<xsl:text>=</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<br />
	</span>
</xsl:template>

<!-- Suppress whitespace-only text nodes between seg and lb elements -->
<xsl:template match="text()[preceding-sibling::*[1][self::tei:seg] and following-sibling::*[1][self::tei:lb] and not(normalize-space())]"/>

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
	<xsl:choose>
		<!-- First check if there's a PC directly after this word within the same rs -->
		<xsl:when test="following-sibling::*[1]/self::tei:pc">
			<xsl:value-of select="following-sibling::*[1]"/>
		</xsl:when>
		<!-- If this is the last word in the immediate parent rs, check for PC after it -->
		<xsl:when test="not(following-sibling::tei:w) and not(following-sibling::tei:rs) and not(following-sibling::*//tei:w)">
			<xsl:variable name="parent-rs" select="parent::tei:rs"/>
			<xsl:variable name="next-after-rs" select="$parent-rs/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
			<xsl:choose>
				<!-- Check if PC follows the parent rs (skipping whitespace), but only if no whitespace before it -->
				<xsl:when test="$next-after-rs/self::tei:pc and not($parent-rs/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
					<xsl:value-of select="$next-after-rs"/>
				</xsl:when>
				<!-- If there's whitespace before PC after parent rs, let whitespace template handle it -->
				<xsl:when test="$next-after-rs/self::tei:pc and $parent-rs/following-sibling::*[1]/self::tei:seg[@type='whitespace']">
					<!-- Whitespace template will render the PC -->
				</xsl:when>
				<!-- Check if rs is inside foreign and PC follows the foreign -->
				<!-- Only output PC if this rs is the last element with words in foreign -->
				<xsl:when test="$parent-rs/parent::tei:foreign">
					<xsl:variable name="foreign" select="$parent-rs/parent::tei:foreign"/>
					<xsl:variable name="next-after-foreign" select="$foreign/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
					<!-- Only output if there are no more words after this rs within foreign -->
					<xsl:if test="$next-after-foreign/name() = 'pc' and not($parent-rs/following-sibling::tei:w) and not($parent-rs/following-sibling::*//tei:w)">
						<xsl:value-of select="$next-after-foreign"/>
					</xsl:if>
				</xsl:when>
				<!-- Otherwise, if parent rs has no following siblings, bubble up through rs hierarchy -->
				<xsl:otherwise>
					<!-- If parent rs is the last element in its container, check parent's following siblings -->
					<xsl:if test="not($parent-rs/following-sibling::*)">
						<!-- Check if parent rs is inside another rs -->
						<xsl:choose>
							<xsl:when test="$parent-rs/parent::tei:rs">
								<xsl:variable name="grandparent-rs" select="$parent-rs/parent::tei:rs"/>
								<xsl:variable name="next-after-grandparent" select="$grandparent-rs/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
								<xsl:if test="$next-after-grandparent/name() = 'pc' and not($grandparent-rs/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
									<xsl:value-of select="$next-after-grandparent"/>
								</xsl:if>
							</xsl:when>
							<!-- Otherwise check if PC follows outermost rs -->
							<xsl:otherwise>
								<xsl:variable name="outermost-rs" select="ancestor::tei:rs[not(parent::tei:rs)][1]"/>
								<xsl:if test="$parent-rs is $outermost-rs and $outermost-rs/following-sibling::*[1]/name() = 'pc'">
									<xsl:value-of select="$outermost-rs/following-sibling::*[1]"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:w[parent::tei:foreign]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:choose>
		<!-- First check if there's a PC sibling directly after this word (inside foreign) -->
		<xsl:when test="following-sibling::*[1]/self::tei:pc">
			<xsl:value-of select="following-sibling::*[1]"/>
		</xsl:when>
		<!-- Otherwise, if this is the last word in foreign, check for PC after foreign -->
		<xsl:when test="not(following-sibling::tei:w) and not(following-sibling::*/descendant-or-self::tei:w)">
			<xsl:variable name="foreign" select="parent::tei:foreign"/>
			<xsl:variable name="next-after-foreign" select="$foreign/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
			<xsl:choose>
				<!-- Check if PC follows foreign directly -->
				<xsl:when test="$next-after-foreign/name() = 'pc' and not($foreign/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
					<xsl:value-of select="$next-after-foreign"/>
				</xsl:when>
				<!-- If foreign is inside an rs, check for PC after rs or after parent seg -->
				<xsl:when test="$foreign/parent::tei:rs">
					<xsl:variable name="rs" select="$foreign/parent::tei:rs"/>
					<xsl:choose>
						<!-- Check if rs is directly inside a seg -->
						<xsl:when test="$rs/parent::tei:seg[not(@type='whitespace')]">
							<xsl:variable name="parent-seg" select="$rs/parent::tei:seg"/>
							<xsl:variable name="next-after-rs" select="$rs/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
							<xsl:choose>
								<!-- First check if PC follows rs directly (within the seg) -->
								<xsl:when test="$next-after-rs/self::tei:pc">
									<xsl:value-of select="$next-after-rs"/>
								</xsl:when>
								<!-- Otherwise, if rs is the last element in the seg, check after seg -->
								<xsl:when test="not($rs/following-sibling::*[not(self::tei:seg[@type='whitespace'])])">
									<xsl:variable name="next-after-seg" select="$parent-seg/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
									<xsl:if test="$next-after-seg/name() = 'pc'">
										<xsl:value-of select="$next-after-seg"/>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<!-- If foreign is inside a bibl, check for PC after bibl or after parent seg -->
				<xsl:when test="$foreign/parent::tei:bibl">
					<xsl:variable name="bibl" select="$foreign/parent::tei:bibl"/>
					<xsl:choose>
						<!-- Check if bibl is directly inside a seg -->
						<xsl:when test="$bibl/parent::tei:seg[not(@type='whitespace')]">
							<xsl:variable name="parent-seg" select="$bibl/parent::tei:seg"/>
							<xsl:variable name="next-after-bibl" select="$bibl/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
							<xsl:choose>
								<!-- First check if PC follows bibl directly (within the seg) -->
								<xsl:when test="$next-after-bibl/self::tei:pc">
									<xsl:value-of select="$next-after-bibl"/>
								</xsl:when>
								<!-- Otherwise, if bibl is the last element in the seg, check after seg -->
								<xsl:when test="not($bibl/following-sibling::*[not(self::tei:seg[@type='whitespace'])])">
									<xsl:variable name="next-after-seg" select="$parent-seg/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
									<xsl:if test="$next-after-seg/name() = 'pc'">
										<xsl:value-of select="$next-after-seg"/>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<!-- If foreign is inside a seg and is the last element, check for PC after the seg -->
				<xsl:when test="$foreign/parent::tei:seg[not(@type='whitespace')] and not($foreign/following-sibling::*[not(self::tei:seg[@type='whitespace'])])">
					<xsl:variable name="parent-seg" select="$foreign/parent::tei:seg"/>
					<xsl:variable name="next-after-seg" select="$parent-seg/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
					<xsl:if test="$next-after-seg/name() = 'pc'">
						<xsl:value-of select="$next-after-seg"/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:docDate]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:variable name="docDate" select="ancestor::tei:docDate[1]"/>
	<xsl:if test="not(following-sibling::tei:w) and $docDate/following-sibling::*[1]/name() = 'pc'">
		<xsl:value-of select="$docDate/following-sibling::*[1]"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:date and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(ancestor::tei:choice) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:choose>
		<!-- First check if there's a PC sibling directly after this word -->
		<xsl:when test="following-sibling::*[1]/self::tei:pc">
			<xsl:value-of select="following-sibling::*[1]"/>
		</xsl:when>
		<!-- Otherwise, if this is the last word in date, check for PC after date -->
		<xsl:when test="not(following-sibling::tei:w)">
			<xsl:variable name="date" select="ancestor::tei:date[1]"/>
			<xsl:variable name="next-after-container" select="$date/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
			<!-- Only render PC if there's no whitespace before it (whitespace template handles that case) -->
			<xsl:if test="$next-after-container/name() = 'pc' and not($date/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
				<xsl:value-of select="$next-after-container"/>
			</xsl:if>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:choice and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:choose>
		<!-- First check if there's a PC sibling directly after this word -->
		<xsl:when test="following-sibling::*[1]/self::tei:pc">
			<xsl:value-of select="following-sibling::*[1]"/>
		</xsl:when>
		<!-- Otherwise, if this is the last word in choice, check for PC after choice -->
		<xsl:when test="not(following-sibling::tei:w)">
			<xsl:variable name="choice" select="ancestor::tei:choice[1]"/>
			<xsl:variable name="next-after-container" select="$choice/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
			<!-- Only render PC if there's no whitespace before it (whitespace template handles that case) -->
			<xsl:if test="$next-after-container/name() = 'pc' and not($choice/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
				<xsl:value-of select="$next-after-container"/>
			</xsl:if>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:w[parent::tei:seg[not(@type='whitespace')] and not(ancestor::tei:docDate)]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:choose>
		<!-- First check if there's a PC sibling directly after this word -->
		<xsl:when test="following-sibling::*[1][self::tei:pc or name() = 'pc']">
			<xsl:value-of select="string(following-sibling::*[1])"/>
		</xsl:when>
		<!-- Check if this is the last word and seg is inside placeName/persName/date/foreign/docAuthor, check their following PC -->
		<xsl:when test="not(following-sibling::tei:w) and not(following-sibling::*//tei:w) and parent::tei:seg[parent::tei:placeName or parent::tei:persName or parent::tei:date or parent::tei:foreign or parent::tei:docAuthor]">
			<xsl:variable name="container" select="parent::tei:seg/parent::*[self::tei:placeName or self::tei:persName or self::tei:date or self::tei:foreign or self::tei:docAuthor]"/>
			<xsl:variable name="next-after-seg" select="parent::tei:seg/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
			<xsl:variable name="next-after-container" select="$container/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
			<!-- Check if this is truly the last word in the entire container, not just in this seg -->
			<xsl:variable name="is-last-word-in-container" select="not(parent::tei:seg/following-sibling::*//tei:w)"/>
			<xsl:choose>
				<!-- First check if PC follows the seg (within the container) -->
				<xsl:when test="$next-after-seg/name() = 'pc'">
					<xsl:value-of select="$next-after-seg"/>
				</xsl:when>
				<!-- Otherwise check if PC follows the container directly, but only if this is the last word in container and no whitespace before PC -->
				<xsl:when test="$is-last-word-in-container and $next-after-container/name() = 'pc' and not($container/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
					<xsl:value-of select="$next-after-container"/>
				</xsl:when>
				<!-- Check if PC is a direct child of a seg after the container, but only if this is the last word in container -->
				<xsl:when test="$is-last-word-in-container and $next-after-container/self::tei:seg[not(@type='whitespace')]/child::tei:pc[not(preceding-sibling::*[not(self::tei:seg[@type='whitespace'])])]">
					<xsl:value-of select="$next-after-container/tei:pc[not(preceding-sibling::*[not(self::tei:seg[@type='whitespace'])])]"/>
				</xsl:when>
				<!-- If no PC after container, check if container is inside another container (date/persName/placeName/bibl/quote/cit) and look for PC after them -->
				<xsl:when test="not($next-after-container) and ($container/ancestor::*[self::tei:date or self::tei:persName or self::tei:placeName or self::tei:bibl or self::tei:cit])">
					<xsl:choose>
						<!-- Check for date/persName/placeName ancestors -->
						<xsl:when test="$container/ancestor::*[self::tei:date or self::tei:persName or self::tei:placeName]">
							<xsl:variable name="outer-container" select="$container/ancestor::*[self::tei:date or self::tei:persName or self::tei:placeName][1]"/>
							<xsl:variable name="next-after-outer" select="$outer-container/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
							<xsl:choose>
								<!-- Check if PC follows the outer container directly -->
								<xsl:when test="$next-after-outer/name() = 'pc' and not($outer-container/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
									<xsl:value-of select="$next-after-outer"/>
								</xsl:when>
								<!-- Check if PC is in a seg after the outer container -->
								<xsl:when test="$next-after-outer/self::tei:seg[not(@type='whitespace')]/child::tei:pc[not(preceding-sibling::*[not(self::tei:seg[@type='whitespace'])])]">
									<xsl:value-of select="$next-after-outer/tei:pc[not(preceding-sibling::*[not(self::tei:seg[@type='whitespace'])])]"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<!-- Check for bibl ancestor -->
						<xsl:when test="$container/parent::tei:bibl">
							<xsl:variable name="bibl" select="$container/parent::tei:bibl"/>
							<xsl:variable name="next-after-bibl" select="$bibl/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
							<xsl:if test="$next-after-bibl/name() = 'pc'">
								<xsl:value-of select="$next-after-bibl"/>
							</xsl:if>
						</xsl:when>
						<!-- Check for cit ancestor -->
						<xsl:when test="$container/ancestor::tei:cit">
							<xsl:variable name="cit" select="$container/ancestor::tei:cit[1]"/>
							<xsl:variable name="next-after-cit" select="$cit/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
							<xsl:if test="$next-after-cit/name() = 'pc'">
								<xsl:value-of select="$next-after-cit"/>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:when>
		<!-- Check if this word is inside a nested seg within persName/placeName/etc and should bubble up -->
		<xsl:when test="not(following-sibling::tei:w) and not(following-sibling::*//tei:w) and ancestor::*[self::tei:placeName or self::tei:persName or self::tei:date or self::tei:foreign or self::tei:name or self::tei:docAuthor]">
			<xsl:variable name="container" select="ancestor::*[self::tei:placeName or self::tei:persName or self::tei:date or self::tei:foreign or self::tei:name or self::tei:docAuthor][1]"/>
			<xsl:choose>
				<!-- If whitespace precedes, don't render PC (whitespace template handles it) -->
				<xsl:when test="$container/following-sibling::*[1]/self::tei:seg[@type='whitespace']">
					<!-- Whitespace template will handle the PC -->
				</xsl:when>
				<!-- Otherwise, check if PC follows the container directly -->
				<xsl:when test="$container/following-sibling::*[1]/self::tei:pc">
					<xsl:value-of select="$container/following-sibling::*[1]"/>
				</xsl:when>
				<!-- Check if PC is a direct child of a seg after the container (not nested in other elements) -->
				<xsl:when test="$container/following-sibling::*[1]/self::tei:seg[not(@type='whitespace')]/tei:pc[1][not(preceding-sibling::*[not(self::tei:seg[@type='whitespace'])])]">
					<xsl:value-of select="$container/following-sibling::*[1]/tei:pc[1]"/>
				</xsl:when>
				<!-- Otherwise: check for PC within the container or after parent seg -->
				<xsl:otherwise>
					<xsl:if test="parent::tei:seg/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]/self::tei:pc">
						<xsl:value-of select="parent::tei:seg/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
					</xsl:if>
					<xsl:if test="$container/parent::tei:seg[not(@type='whitespace')]">
						<xsl:variable name="parent-seg" select="$container/parent::tei:seg[not(@type='whitespace')]"/>
						<!-- Only output if no whitespace before PC -->
						<xsl:if test="not($parent-seg/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
							<xsl:variable name="next-after-seg" select="$parent-seg/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
							<xsl:if test="$next-after-seg/name() = 'pc'">
								<xsl:value-of select="$next-after-seg"/>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<!-- Otherwise, if this is the last word in the entire seg and there's a PC after the seg WITHOUT whitespace, render it -->
		<xsl:when test="not(following-sibling::tei:w) and not(following-sibling::*//tei:w)">
			<xsl:variable name="parent-seg" select="parent::tei:seg"/>
			<xsl:choose>
				<!-- Check if seg is inside rs and is the last element, bubble up to check after rs -->
				<xsl:when test="$parent-seg/parent::tei:rs and not($parent-seg/following-sibling::*)">
					<xsl:variable name="rs" select="$parent-seg/parent::tei:rs"/>
					<xsl:variable name="next-after-rs" select="$rs/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
					<xsl:choose>
						<!-- Check if PC follows rs directly -->
						<xsl:when test="$next-after-rs/self::tei:pc and not($rs/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
							<xsl:value-of select="$next-after-rs"/>
						</xsl:when>
						<!-- Check if PC is inside a seg after rs -->
						<xsl:when test="$next-after-rs/self::tei:seg[not(@type='whitespace')]/tei:pc[1][not(preceding-sibling::*)]">
							<xsl:value-of select="$next-after-rs/tei:pc[1]"/>
						</xsl:when>
						<!-- If rs has no following siblings and is inside another rs, bubble up -->
						<xsl:when test="not($rs/following-sibling::*) and $rs/parent::tei:rs">
							<xsl:variable name="outer-rs" select="$rs/parent::tei:rs"/>
							<xsl:variable name="next-after-outer-rs" select="$outer-rs/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
							<xsl:choose>
								<!-- Check if PC follows outer rs directly -->
								<xsl:when test="$next-after-outer-rs/self::tei:pc">
									<xsl:value-of select="$next-after-outer-rs"/>
								</xsl:when>
								<!-- Check if PC is inside a seg after outer rs -->
								<xsl:when test="$next-after-outer-rs/self::tei:seg[not(@type='whitespace')]/tei:pc[1][not(preceding-sibling::*)]">
									<xsl:value-of select="$next-after-outer-rs/tei:pc[1]"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<!-- Otherwise check if PC follows the seg directly -->
				<xsl:otherwise>
					<!-- Only output PC if NO whitespace seg comes between this seg and the PC -->
					<xsl:if test="not($parent-seg/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
						<!-- Check if there's a PC immediately after the seg (without whitespace) -->
						<xsl:if test="$parent-seg/following-sibling::*[1]/self::tei:pc">
							<xsl:value-of select="$parent-seg/following-sibling::*[1]"/>
						</xsl:if>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:persName and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(ancestor::tei:date) and not(ancestor::tei:choice) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:choose>
		<!-- First check if there's a PC sibling directly after this word -->
		<xsl:when test="following-sibling::*[1]/self::tei:pc">
			<xsl:value-of select="following-sibling::*[1]"/>
		</xsl:when>
		<!-- Otherwise, if this is the last word in persName, check for PC after persName -->
		<xsl:when test="not(following-sibling::tei:w)">
			<xsl:variable name="persName" select="ancestor::tei:persName[1]"/>
			<xsl:variable name="next-after-container" select="$persName/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
			<!-- Check if this is truly the last word in the entire persName -->
			<xsl:variable name="is-last-word-in-persName" select="not(following-sibling::*//tei:w)"/>
			<xsl:choose>
				<!-- Check if PC follows persName directly (without whitespace), but only if this is the last word in persName -->
				<xsl:when test="$is-last-word-in-persName and $next-after-container/name() = 'pc' and not($persName/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
					<xsl:value-of select="$next-after-container"/>
				</xsl:when>
				<!-- If persName has no following siblings and is inside rs elements, bubble up through rs chain -->
				<xsl:when test="not($persName/following-sibling::*) and $persName/ancestor::tei:rs">
					<xsl:variable name="outermost-rs" select="$persName/ancestor::tei:rs[not(parent::tei:rs)][1]"/>
					<xsl:variable name="next-after-rs" select="$outermost-rs/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
					<xsl:choose>
						<!-- Check if PC follows rs directly -->
						<xsl:when test="$next-after-rs/name() = 'pc' and not($outermost-rs/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
							<xsl:value-of select="$next-after-rs"/>
						</xsl:when>
						<!-- Check if PC is inside a seg after the rs -->
						<xsl:when test="$next-after-rs/self::tei:seg[not(@type='whitespace')]/tei:pc[1][not(preceding-sibling::*[not(self::tei:seg[@type='whitespace'])])]">
							<xsl:value-of select="$next-after-rs/tei:pc[1]"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:placeName and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(ancestor::tei:date) and not(ancestor::tei:choice) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:choose>
		<!-- First check if there's a PC sibling directly after this word -->
		<xsl:when test="following-sibling::*[1]/self::tei:pc">
			<xsl:value-of select="following-sibling::*[1]"/>
		</xsl:when>
		<!-- Otherwise, if this is the last word in placeName, check for PC after placeName -->
		<xsl:when test="not(following-sibling::tei:w)">
			<xsl:variable name="placeName" select="ancestor::tei:placeName[1]"/>
			<xsl:variable name="next-after-container" select="$placeName/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
			<!-- Only render PC if there's no whitespace before it (whitespace template handles that case) -->
			<xsl:if test="$next-after-container/name() = 'pc' and not($placeName/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
				<xsl:value-of select="$next-after-container"/>
			</xsl:if>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:w[ancestor::tei:name and not(parent::tei:rs) and not(parent::tei:foreign) and not(parent::tei:item) and not(ancestor::tei:docDate) and not(ancestor::tei:date) and not(ancestor::tei:choice) and not(ancestor::tei:persName) and not(ancestor::tei:placeName) and not(parent::tei:seg[not(@type='whitespace')])]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:choose>
		<!-- First check if there's a PC sibling directly after this word -->
		<xsl:when test="following-sibling::*[1]/self::tei:pc">
			<xsl:value-of select="following-sibling::*[1]"/>
		</xsl:when>
		<!-- Otherwise, if this is the last word in name, check for PC after name -->
		<xsl:when test="not(following-sibling::tei:w)">
			<xsl:variable name="name" select="ancestor::tei:name[1]"/>
			<xsl:variable name="next-after-container" select="$name/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
			<!-- Only render PC if there's no whitespace before it (whitespace template handles that case) -->
			<xsl:if test="$next-after-container/name() = 'pc' and not($name/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
				<xsl:value-of select="$next-after-container"/>
			</xsl:if>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:w[parent::tei:item]">
	<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word"><xsl:apply-templates/></span>
	<xsl:if test="following-sibling::*[1]/name() = 'pc'">
		<xsl:value-of select="following-sibling::*[1]"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:w[not(parent::tei:item or parent::tei:rs or parent::tei:foreign or parent::tei:seg[not(@type='whitespace')] or ancestor::tei:docDate or ancestor::tei:date or ancestor::tei:choice or ancestor::tei:persName or ancestor::tei:placeName or ancestor::tei:name)]">
	<!-- Skip if preceded by internal PC and word (already rendered by previous word) -->
	<xsl:if test="not(preceding-sibling::*[1][self::tei:pc[@type='internal']] and preceding-sibling::*[2][self::tei:w])">
		<span data-lemma="{@lemma}" data-type="{@type}" data-pb="{preceding::tei:pb[1]/@xml:id}" id="{@xml:id}" class="word">
			<xsl:apply-templates/>
			<!-- If followed by internal PC and then another word, include PC and next word in same span -->
			<xsl:if test="following-sibling::*[1][self::tei:pc[@type='internal']] and following-sibling::*[2][self::tei:w]">
				<xsl:value-of select="following-sibling::*[1]"/>
				<xsl:apply-templates select="following-sibling::*[2]/node()"/>
			</xsl:if>
		</span>
		<!-- Output PC only if not internal or not followed by word -->
		<xsl:if test="following-sibling::*[1]/name() = 'pc' and not(following-sibling::*[1][self::tei:pc[@type='internal']] and following-sibling::*[2][self::tei:w])">
			<xsl:value-of select="following-sibling::*[1]"/>
		</xsl:if>
		<!-- Check if PC is inside a following seg (like seg[@rend='antiqua']) -->
		<xsl:if test="following-sibling::*[1]/self::tei:seg[not(@type='whitespace')]/tei:pc[1][not(preceding-sibling::*)]">
			<xsl:value-of select="following-sibling::*[1]/tei:pc[1]"/>
		</xsl:if>
	</xsl:if>
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
				<!-- Check for PC elements inside the initialCapital seg -->
				<xsl:if test="child::tei:pc">
					<xsl:value-of select="tei:pc"/>
				</xsl:if>
				<!-- Check if PC follows this seg directly (without whitespace) -->
				<xsl:if test="following-sibling::*[1]/self::tei:pc">
					<xsl:value-of select="following-sibling::*[1]"/>
				</xsl:if>
				<!-- Check if seg is inside a container and if PC follows that container -->
				<xsl:if test="parent::tei:placeName or parent::tei:persName or parent::tei:date or parent::tei:foreign">
					<xsl:variable name="container" select="parent::*[self::tei:placeName or self::tei:persName or self::tei:date or self::tei:foreign]"/>
					<xsl:variable name="next-after-container" select="$container/following-sibling::*[not(self::tei:seg[@type='whitespace'])][1]"/>
					<!-- Only render PC if there's no whitespace before it (whitespace template handles that case) -->
					<xsl:if test="$next-after-container/name() = 'pc' and not($container/following-sibling::*[1]/self::tei:seg[@type='whitespace'])">
						<xsl:value-of select="$next-after-container"/>
					</xsl:if>
				</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<span class="{$rend}">
				<xsl:apply-templates/>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:seg[@type='whitespace']">
	<xsl:apply-templates/>
	<!-- Render following PC (word templates will skip PC if whitespace precedes it) -->
	<xsl:if test="following-sibling::*[1]/name() = 'pc'">
		<xsl:value-of select="following-sibling::*[1]"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:seg[@type='ornament']">
	<span class="ornament">
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="tei:pc">
</xsl:template>

<xsl:template match="tei:g">
	<xsl:choose>
		<xsl:when test="@ref = '#bracketsMW'">
			<xsl:text>):( . . .</xsl:text>
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
