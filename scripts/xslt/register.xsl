<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">

<xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" indent="yes" omit-xml-declaration="yes"/>

<xsl:variable name="termlabels" select="document('../../data/register/termlabels-persnames.xml')"/>
<xsl:variable name="termlabelsPlaces" select="document('../../data/register/termlabels-placenames.xml')"/>
<xsl:variable name="termlabels1" select="document('../../data/register/termlabels1.xml')"/>

<xsl:template match="/">
		<xsl:for-each select="document('../../data/register/abacus-index_persnames.xml')//tei:TEI">
			<div id="rg-pers" class="hidden">
				<xsl:for-each-group select=".//tei:person" group-by="@role">
						<h5 class="cursor-pointer inline" title="Personenkategorie ausklappen/einklappen"><span class="text-red-600">&#8595; </span>
							<xsl:variable name="persTypeLabel" select="$termlabels1//terms[@key='persType']/term[@key=current-grouping-key()]"/>
							<xsl:choose>
								<xsl:when test="$persTypeLabel != ''">
									<xsl:value-of select="$persTypeLabel"/>
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="current-grouping-key()"/></xsl:otherwise>
							</xsl:choose>
						</h5><span id="persType" data-str="{current-grouping-key()}" class="cursor-pointer inline-block text-red-600" title="Nach Personenkategorie '{current-grouping-key()}' suchen">&#160;&#10143;</span><br/>
							<ul class="hidden">
								<xsl:for-each select="current-group()">
									<xsl:sort select="if ($termlabels//term[@key=current()/.//tei:persName[@type='main']/@key]) then $termlabels//term[@key=current()/.//tei:persName[@type='main']/@key] else current()/.//tei:persName[@type='main']" data-type="text" order="ascending"/>
									<xsl:variable name="personKey" select=".//tei:persName[@type='main']/@key"/>
									<xsl:variable name="termLabel" select="$termlabels//term[@key=$personKey]"/>
									<li data-link="wk-{position()}" data-str="{.//tei:persName/@key}" class="text-red-500 cursor-pointer whitespace-pre">
										<xsl:choose>
											<xsl:when test="$termLabel != ''">
												<xsl:value-of select="$termLabel"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select=".//tei:persName[@type='main']"/>
											</xsl:otherwise>
										</xsl:choose>
									</li>
								</xsl:for-each>
							</ul>
				</xsl:for-each-group>
			</div>
		</xsl:for-each>
		<xsl:for-each select="document('../../data/register/abacus-index_placenames.xml')//tei:TEI">
			<div id="rg-place" class="hidden">
				<xsl:for-each-group select=".//tei:place" group-by="@type">
					<xsl:sort select="
						if (current-grouping-key()='city') then 'Städte'
						else if (current-grouping-key()='cont') then 'Kontinente'
						else if (current-grouping-key()='coun') then 'Länder'
						else if (current-grouping-key()='dist') then 'Regionen'
						else if (current-grouping-key()='lake') then 'Seen'
						else if (current-grouping-key()='moun') then 'Berge'
						else if (current-grouping-key()='rive') then 'Flüsse'
						else if (current-grouping-key()='sea') then 'Meere'
						else if (current-grouping-key()='sett') then 'Siedlungen'
						else if (current-grouping-key()='stre') then 'Straßen und Plätze in Wien'
						else if (current-grouping-key()='subu') then 'Stadtteile'
						else if (current-grouping-key()='vill') then 'Dörfer'
						else current-grouping-key()"
						data-type="text" order="ascending"/>
					<h5 class="cursor-pointer inline" title="Ortskategorie ausklappen/einklappen"><span class="text-red-600">&#8595; </span>
						<xsl:variable name="placeTypeLabel" select="$termlabels1//terms[@key='placeType']/term[@key=current-grouping-key()]"/>
						<xsl:choose>
							<xsl:when test="$placeTypeLabel != ''">
								<xsl:value-of select="$placeTypeLabel"/>
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="current-grouping-key()"/></xsl:otherwise>
						</xsl:choose>
						<!--(<xsl:value-of select="current-grouping-key()"/>)-->
					</h5><span id="placeType" data-str="{current-grouping-key()}" class="cursor-pointer inline-block text-red-600" title="Nach Ortskategorie '{current-grouping-key()}' suchen">&#160;&#10143;</span><br/>
						<ul class="hidden">
							<xsl:for-each select="current-group()">
								<xsl:sort select="if ($termlabelsPlaces//term[@key=current()/.//tei:placeName[@type='main']/@key]) then $termlabelsPlaces//term[@key=current()/.//tei:placeName[@type='main']/@key] else current()/.//tei:placeName[@type='main']" data-type="text" order="ascending"/>
								<xsl:variable name="placeKey" select=".//tei:placeName[@type='main']/@key"/>
								<xsl:variable name="termLabel" select="$termlabelsPlaces//term[@key=$placeKey]"/>
								<li data-link="wk-{position()}" data-str="{.//tei:placeName/@key}" class="text-red-500 cursor-pointer whitespace-pre">
									<xsl:choose>
										<xsl:when test="$termLabel != ''">
											<xsl:value-of select="$termLabel"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select=".//tei:placeName[@type='main']"/>
										</xsl:otherwise>
									</xsl:choose>
								</li>
							</xsl:for-each>
						</ul>
				</xsl:for-each-group>
			</div>
	</xsl:for-each>
	<div id="abacus-overview" class="py-4">
		<img src="/Buecher.jpg" alt="Bücher" title="Bücher" />
		<xsl:for-each select="collection('../../data/editions')//tei:TEI">
			<xsl:sort select="
				if (contains(.//tei:titleStmt/tei:title[1], 'Augustini Feuriges Hertz')) then 4
				else if (contains(.//tei:titleStmt/tei:title[1], 'Lösch Wienn')) then 2
				else if (contains(.//tei:titleStmt/tei:title[1], 'Mercks Wienn')) then 1
				else if (contains(.//tei:titleStmt/tei:title[1], 'Grosse Todten Bruderschaft')) then 3
				else if (contains(.//tei:titleStmt/tei:title[1], 'Todten-Capelle')) then 5
				else 999"
				data-type="number" order="ascending"/>
			<h4 class="mt-4"><xsl:value-of select="replace(.//tei:titleStmt/tei:title[1], ', digitale Ausgabe', '')"/></h4>
			<hr class="border-b border-b-gray-300"/>
			<ul class="register-menu">
				<li data-link="wk-{position()}" class="text-red-500 p-2 cursor-pointer inline" data-content="{.//tei:body/tei:pb[1]/@xml:id}">
					Werk
				</li>
				<li data-link="rg-{position()}" class="text-red-500 p-2 cursor-pointer inline">Inhalt</li>
				<!--<li data-link="md-{position()}" class="text-red-500 p-2 cursor-pointer inline">Metadaten</li>-->
			</ul>
			<div id="info-{position()}" class="hidden text-xs py-4">
				<xsl:variable name="filename" select="replace(tokenize(document-uri(/), '/')[last()], '\.xml$', '.jpg')"/>
				<img src="/{$filename}" alt="{.//tei:titleStmt/tei:title[1]}" title="{.//tei:titleStmt/tei:title[1]}" class="float-left mr-4 mb-2 cursor-pointer" data-content="{.//tei:titlePage[1]/preceding-sibling::tei:pb[1]/@xml:id}" />
				<xsl:choose>
					<xsl:when test="contains(.//tei:titleStmt/tei:title[1], 'Augustini Feuriges Hertz')">
						<p class="py-1">Abraham â Sancta Clara: AUGUSTINI Feuriges Hertz Tragt Ein Hertzliches Mitleyden mit den armen im Feeg=Feuer Leydenden Seelen [...] Gedruckt zu Saltzburg bey Melchior Haan [...] Anno 1693.</p>
						<p class="py-1">Österreichische Nationalbibliothek, Sammlung von Handschriften und alten Drucken (Signatur 484.862-A Alt)</p>
						<p class="py-1">Zitation: Abraham â Sancta Clara: Augustini Feuriges Hertz. Salzburg, 1693. (Digitale Ausgabe) . In: ABaC:us – Austrian Baroque Corpus. Hrsg. von Claudia Resch und Ulrike Czeitschner. &lt;<a href="https://abacus.acdh-ch-dev.oeaw.ac.at/edition/AFH_n0003" class="text-red-500">hhttps://abacus.acdh.oeaw.ac.at/edition/AFH_n0003</a>&gt; abgerufen am <span class="today"></span>.</p>
					</xsl:when>
					<xsl:when test="contains(.//tei:titleStmt/tei:title[1], 'Lösch Wienn')">
						<p class="py-1">Abraham â Sancta Clara: Lösch Wienn / Das ist Ein Bewögliche Anmahnung zu der Kays. Residentz=Statt Wienn in Oesterreich [...] Gedruckt zu Wien / bey Peter Paul Vivian / 1680.</p>
						<p class="py-1">Universitätsbibliothek Graz, Rara Sammlung (Signatur I 25.896 Rara II)</p>
						<p class="py-1">Zitation: Abraham â Sancta Clara: Lösch Wienn. Wien, 1680. (Digitale Ausgabe) . In: ABaC:us – Austrian Baroque Corpus. Hrsg. von Claudia Resch und Ulrike Czeitschner. &lt;<a href="https://abacus.acdh-ch-dev.oeaw.ac.at/edition/LW_a0007" class="text-red-500">https://abacus.acdh.oeaw.ac.at/edition/LW_a0007</a>&gt; abgerufen am <span class="today"></span>.</p>
					</xsl:when>
					<xsl:when test="contains(.//tei:titleStmt/tei:title[1], 'Mercks Wienn')">
						<p class="py-1">Abraham â Sancta Clara: Mercks Wienn / Das ist Deß wütenden Todts ein vmbständige Beschreibung Jn Der berühmten Haubt vnd Kayserl. Residentz Statt in Oesterreich [...] . Gedruckt zu Wienn / bey Peter Paul Vivian / der löbl: Universitet Buchdrucker 1680.</p>
						<p class="py-1">Stiftsbibliothek Melk (Signatur 48.022)</p>
						<p class="py-1">Zitation: Abraham â Sancta Clara: Mercks Wienn. Wien, 1680. (Digitale Ausgabe) . In: ABaC:us – Austrian Baroque Corpus. Hrsg. von Claudia Resch und Ulrike Czeitschner. &lt;<a href="https://abacus.acdh-ch-dev.oeaw.ac.at/edition/MW_a0005" class="text-red-500">https://abacus.acdh.oeaw.ac.at/edition/MW_a0005</a>&gt; abgerufen am <span class="today"></span>.</p>
					</xsl:when>
					<xsl:when test="contains(.//tei:titleStmt/tei:title[1], 'Grosse Todten Bruderschaft')">
						<p class="py-1">[Abraham â Sancta Clara]: Grosse Todten Bruderschaft / Das ist Ein kurtzer Entwurff Deß Sterblichen Lebens [...] Gedruckt im Jahr 1681.</p>
						<p class="py-1">Österreichische Nationalbibliothek, Sammlung von Handschriften und alten Drucken (Signatur 298.002-A)</p>
						<p class="py-1">Zitation: Abraham â Sancta Clara: Grosse Todten Bruderschaft. Wien, 1681. (Digitale Ausgabe) . In: ABaC:us – Austrian Baroque Corpus. Hrsg. von Claudia Resch und Ulrike Czeitschner. &lt;<a href="https://abacus.acdh-ch-dev.oeaw.ac.at/edition/TB_i0009" class="text-red-500">https://abacus.acdh.oeaw.ac.at/edition/TB_i0009</a>&gt; abgerufen am <span class="today"></span>.</p>
					</xsl:when>
					<xsl:when test="contains(.//tei:titleStmt/tei:title[1], 'Todten-Capelle')">
						<p class="py-1">[Abraham â Sancta Clara]: Besonders meublirt- und gezierte Todten=Capelle / Oder Allgemeiner Todten=Spiegel / [...] Nürnberg / Bey Christoph Weigel [...] Würtzburg / Druckts Marrtin Frantz Hertz. An. 1710.</p>
						<p class="py-1">University Library Illinois, Emblem Collection of the University of Illinois, Urbana-Champaign (Signatur 832Ab8)</p>
						<p class="py-1">Zitation: Abraham â Sancta Clara: Todten-Capelle. Würzburg, 1710. (Digitale Ausgabe) . In: ABaC:us – Austrian Baroque Corpus. Hrsg. von Claudia Resch und Ulrike Czeitschner. &lt;<a href="https://abacus.acdh-ch-dev.oeaw.ac.at/edition/TC_i0008" class="text-red-500">https://abacus.acdh.oeaw.ac.at/edition/TC_i0008</a>&gt; abgerufen am <span class="today"></span>.</p>
					</xsl:when>
					<xsl:otherwise>
						<p></p>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div id="rg-{position()}" class="hidden">
				<xsl:apply-templates select=".//tei:front|.//tei:body|.//tei:back"/>
			</div>
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template match="tei:front">
	<div>
		<h5 class="text-sm">Titelei</h5>
		<ul>
		<xsl:for-each select=".//tei:pb">
			<li data-link="{@xml:id}" class="text-sm text-red-500 inline cursor-pointer">
				<xsl:value-of select="@n"/>
			</li>
			<xsl:if test="position() != last()"><li class="inline text-sm">/</li></xsl:if>
		</xsl:for-each>
		</ul>
	</div>
</xsl:template>
<xsl:template match="tei:back">
	<div>
		<h5 class="text-sm">Anhang</h5>
		<ul>
		<xsl:for-each select=".//tei:pb">
			<li data-link="{@xml:id}" class="text-sm text-red-500 inline cursor-pointer">
				<xsl:value-of select="@n"/>
			</li>
			<xsl:if test="position() != last()"><li class="inline text-sm">/</li></xsl:if>
		</xsl:for-each>
		</ul>
	</div>
</xsl:template>
<xsl:template match="tei:body">
	<div>
		<xsl:for-each select=".//tei:div[@type='chapter']">
			<h5 class="text-sm">
				<xsl:value-of select="@n"/>
			</h5>
			<ul>
				<li data-link="{preceding-sibling::tei:pb[1]/@xml:id}" class="text-sm text-red-500 inline cursor-pointer">
					<xsl:value-of select="replace(preceding-sibling::tei:pb[1]/@n, 'S. ', '')"/>
				</li>
				<li class="inline text-sm">/</li>
				<xsl:for-each select=".//tei:pb">
					<li data-link="{@xml:id}" class="text-sm text-red-500 inline cursor-pointer">
						<xsl:value-of select="replace(@n, 'S. ', '')"/>
					</li>
					<xsl:if test="position() != last()"><li class="inline text-sm">/</li></xsl:if>
				</xsl:for-each>
			</ul>
		</xsl:for-each>
	</div>
</xsl:template>
</xsl:stylesheet>
