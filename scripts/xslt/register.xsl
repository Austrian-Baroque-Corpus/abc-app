<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">

<xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/">
<div>
	<!-- <ul>
		<xsl:for-each select="collection('../../data/register')//tei:TEI">
			<li><label>Personen</label>
				<ul>
					<xsl:for-each-group select="//tei:person" group-by="@type">
						<li>
							<a href="#{current-grouping-key()}">
								<ul>
									<xsl:for-each select="current-group()">
										<xsl:sort select=".//tei:persName/@lemma" data-type="text" order="ascending"/>
										<li data-link="{@xml:id}" data-key="{.//tei:persName/@key}" class="p-2 text-red-500 inline cursor-pointer whitespace-pre">
											<xsl:value-of select=".//tei:persName/@lemma"/>
										</li>
									</xsl:for-each>
								</ul>
							</a>
						</li>
					</xsl:for-each-group>
				</ul>
			</li>
			<li>Orte</li>
		</xsl:for-each>
	</ul> -->
	<xsl:for-each select="collection('../../data/editions')//tei:TEI">
		<h4 class="mt-4"><xsl:value-of select="replace(.//tei:titleStmt/tei:title[1], ', digitale Ausgabe', '')"/></h4>
		<hr class="border-b border-b-gray-300"/>
		<ul class="register-menu">
			<li data-link="wk-{position()}" class="text-red-500 p-2 cursor-pointer inline" data-content="{.//tei:body/tei:pb[1]/@xml:id}">
				Werk
			</li>
			<li data-link="rg-{position()}" class="text-red-500 p-2 cursor-pointer inline">Inhalt</li>
			<li data-link="md-{position()}" class="text-gray-500 p-2 cursor-pointer inline">Metadaten</li>
		</ul>
		<div id="rg-{position()}" class="hidden">
			<xsl:apply-templates select="//tei:front|//tei:body|//tei:back"/>
		</div>
	</xsl:for-each>
</div>
</xsl:template>

<xsl:template match="tei:front">
	<div>
		<h5>Titelei</h5>
		<ul>
		<xsl:for-each select=".//tei:pb">
			<li data-link="{@xml:id}" class="p-2 text-red-500 inline cursor-pointer whitespace-pre">
				<xsl:value-of select="@n"/>
			</li>
		</xsl:for-each>
		</ul>
	</div>
</xsl:template>
<xsl:template match="tei:back">
	<div>
		<h5>Anhang</h5>
		<ul>
		<xsl:for-each select=".//tei:pb">
			<li data-link="{@xml:id}" class="p-2 text-red-500 inline cursor-pointer whitespace-pre">
				<xsl:value-of select="@n"/>
			</li>
		</xsl:for-each>
		</ul>
	</div>
</xsl:template>
<xsl:template match="tei:body">
	<div>
		<xsl:for-each select=".//tei:div[@type='chapter']">
			<h5>
				<xsl:value-of select="@n"/>
			</h5>
			<ul>
				<li data-link="{preceding-sibling::tei:pb[1]/@xml:id}" class="whitespace-pre p-2 text-red-500 inline cursor-pointer">
					<xsl:value-of select="preceding-sibling::tei:pb[1]/@n"/>
				</li>
				<xsl:for-each select=".//tei:pb">
					<li data-link="{@xml:id}" class="p-2 text-red-500 inline cursor-pointer whitespace-pre">
						<xsl:value-of select="@n"/>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:for-each>
	</div>
</xsl:template>
</xsl:stylesheet>
