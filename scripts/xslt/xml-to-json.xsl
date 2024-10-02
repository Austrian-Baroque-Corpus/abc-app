<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.w3.org/2005/xpath-functions"
    version="3.0" exclude-result-prefixes="#all">

	<xsl:output encoding="UTF-8" method="text" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="/">
		<xsl:variable name="files" select="collection('../../data/editions/tmp')"/>
		<xsl:variable name="xml">
			<map>
				<xsl:for-each select="$files//tei:TEI">
					<map key="{@xml:id}">
						<string key="title">
							<xsl:value-of select="//tei:titleStmt/tei:title[1]"/>
						</string>
						<string key="source">
							<xsl:value-of select="//tei:sourceDesc/tei:bibl[@type='short']"/>
						</string>
					</map>
				</xsl:for-each>
			</map>
		</xsl:variable>
		<!-- OUTPUT -->
		<xsl:value-of select="xml-to-json($xml)"/>
	</xsl:template>

</xsl:stylesheet>
