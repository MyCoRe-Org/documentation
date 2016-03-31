<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:cmd="http://www.w3.org/1999/cmd"
  xmlns:dcterms="http://www.w3.org/1999/dcterms"
>

<xsl:output method="xml"
        indent="yes"
      xalan:indent-amount="4"
      encoding="UTF-8" />

  <xsl:variable name="language">
    <xsl:choose>
      <xsl:when test="//languages/language">
        <xsl:variable name="categid" select="//languages/language/@categid" />
        <xsl:variable name="myURI" select="concat('classification:metadata:0:children:',//languages/language/@classid, ':', $categid)" />
        <xsl:value-of select="substring-after(document($myURI)//category[@ID=$categid]/label[@xml:lang='de']/@description,'#')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'de'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <mycoreobject>
      <xsl:attribute name="ID">
        <xsl:value-of select="substring-before(mycoreobject/@ID,'_document_')"/>
        <xsl:value-of select="'_mods_'"/>
        <xsl:value-of select="substring-after(mycoreobject/@ID,'_document_')"/>
      </xsl:attribute>
      <xsl:attribute name="label">
        <xsl:value-of select="'migrated '"/>
        <xsl:value-of select="mycoreobject/@ID"/>
        <xsl:value-of select="' to '"/>
        <xsl:value-of select="substring-before(mycoreobject/@ID,'_document_')"/>
        <xsl:value-of select="'_mods_'"/>
        <xsl:value-of select="substring-after(mycoreobject/@ID,'_document_')"/>
      </xsl:attribute>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation">
        <xsl:value-of select="'datamodel-mods.xsd'"/>
      </xsl:attribute>
      <xsl:copy-of select="mycoreobject/@version"/>
      <structure>
        <xsl:copy-of select="mycoreobject/structure/parents"/>
      </structure>
      <metadata>
        <def.modsContainer class="MCRMetaXML" notinherit="true">
          <modsContainer>
            <mods:mods xmlns:mods="http://www.loc.gov/mods/v3">
              <xsl:apply-templates select="mycoreobject/metadata" />
              <xsl:call-template name="originInfo" />
              <mods:identifier type="local">
                <xsl:value-of select="mycoreobject/@ID" />
              </mods:identifier>
            </mods:mods>
          </modsContainer>
        </def.modsContainer>
      </metadata>
      <service>
        <xsl:apply-templates select="mycoreobject/service/servdates" />

        <xsl:copy-of select="mycoreobject/service/servflags" />
        <xsl:if test="not(mycoreobject/service/servflags/servflag/@type='createdby')">
          <servflags class="MCRMetaLangText">
            <servflag type="createdby" inherited="0" form="plain">administrator</servflag>
            <servflag type="modifiedby" inherited="0" form="plain">administrator</servflag>
          </servflags>
        </xsl:if>

        <xsl:copy-of select="mycoreobject/service/servstate" />
        <xsl:if test="not(mycoreobject/service/servstates/servstate)">
          <servstates class="MCRMetaClassification">
            <servstate inherited="0" classid="state" categid="published" />
          </servstates>
        </xsl:if>

        <!-- include acl if available -->
        <!-- xsl:variable name="acl" select="document(concat('access:action=all&amp;object=',mycoreobject/@ID))"/>
        <xsl:if test="$acl/*/*">
            <xsl:copy-of select="$acl"/>
        </xsl:if -->
      </service>
    </mycoreobject>
  </xsl:template>


  <xsl:template name="originInfo">
    <xsl:if test="//metadata/dates or //metadata/places"><!-- or //metadata/origins -->
      <mods:originInfo eventType="publication">
        <xsl:if test="//metadata/places">
          <mods:place>
            <mods:placeTerm>
              <xsl:value-of select="//metadata/places/place/text()" />
            </mods:placeTerm>
          </mods:place>
        </xsl:if>
        <xsl:if test="//metadata/dates">
          <xsl:choose>
            <xsl:when test="//metadata/dates/date[@type='create']">
              <mods:dateCreated encoding="w3cdtf">
                <xsl:value-of select="//metadata/dates/date/text()" />
              </mods:dateCreated>
            </xsl:when>
            <xsl:when test="//metadata/dates/date[@type='accept'or @type='submit' or @type='decide']">
              <xsl:for-each select="//metadata/dates/date[@type='accept'or @type='submit' or @type='decide']">
                <mods:dateOther encoding="w3cdtf">
                  <xsl:attribute name="type">
                    <xsl:choose>
                      <xsl:when test="@type='accept'">accepted</xsl:when><!-- Für das Datum der Verteidigung zur Dis./Habil.der Arbeit -->
                      <xsl:when test="@type='submit'">submitted</xsl:when><!-- Für das Datum der Einreichung zur Dis./Habil.der Arbeit -->
                      <xsl:when test="@type='decide'">decided</xsl:when><!-- "Für das Datum der Beschlussfassung zur Dis./Habil. der Arbeit" - wird derzeit von MIR nicht ausgewertet -->
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:value-of select="." />
                </mods:dateOther>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <mods:dateIssued encoding="w3cdtf">
                <xsl:value-of select="//metadata/dates/date/text()"></xsl:value-of>
              </mods:dateIssued>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </mods:originInfo>
    </xsl:if>
  </xsl:template>

  <xsl:template match="titles">
    <xsl:apply-templates select="title" />
  </xsl:template>

  <xsl:template match="title[not(@type='subtitle')]">
    <mods:titleInfo xml:lang="{@xml:lang}">
      <mods:title>
        <xsl:value-of select="." />
      </mods:title>
      <xsl:variable name="titleLang" select="@xml:lang" />
      <xsl:if test="../title[@type='subtitle' and @xml:lang=$titleLang]">
        <mods:subTitle>
          <xsl:value-of select="../title[@type='subtitle' and @xml:lang=$titleLang]" />
        </mods:subTitle>
      </xsl:if>
    </mods:titleInfo>
  </xsl:template>

  <xsl:template match="title[@type='alt']">
    <!-- mods:titleInfo type="alternative" xml:lang="{@xml:lang}" -->
    <mods:titleInfo type="translated" xml:lang="{@xml:lang}">
      <mods:title>
        <xsl:value-of select="." />
      </mods:title>
    </mods:titleInfo>
  </xsl:template>


  <xsl:template match="descriptions">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="description">
    <mods:abstract type="{@type}" xml:lang="{@xml:lang}">
      <xsl:value-of select="." />
    </mods:abstract>
  </xsl:template>

  <xsl:template match="sources">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="source">
    <mods:relatedItem type="original">
      <mods:titleInfo>
        <mods:title>
          <xsl:attribute name="xml:lang">
            <xsl:choose>
              <xsl:when test="@xml:lang"><xsl:value-of select="@xml:lang"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="." />
        </mods:title>
      </mods:titleInfo>
    </mods:relatedItem>
  </xsl:template>

  <xsl:template match="sourcelinks">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="sourcelink">
    <mods:relatedItem type="original">
      <mods:location>
          <xsl:value-of select="@xlink:href" />
      </mods:location>
    </mods:relatedItem>
  </xsl:template>

  <xsl:template match="creators">
    <xsl:apply-templates select="creator[@xml:lang=$language]"/>
  </xsl:template>

  <xsl:template match="creator">
    <mods:name type="personal" usage="primary">
      <mods:displayForm>
        <xsl:value-of select="." />
      </mods:displayForm>
      <mods:role>
        <mods:roleTerm authority="marcrelator" type="code">aut</mods:roleTerm>
      </mods:role>
    </mods:name>
  </xsl:template>

  <xsl:template match="creatorlinks">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="creatorlink">
    <xsl:variable name="person" select="document(concat('mcrobject:',@xlink:href))" />
    <mods:name type="personal" usage="primary">
      <mods:namePart type="given"><xsl:value-of select="$person//names/name/surname" /></mods:namePart>
      <mods:namePart type="family"><xsl:value-of select="$person//names/name/firstname" /></mods:namePart>
      <mods:role>
        <mods:roleTerm authority="marcrelator" type="code">aut</mods:roleTerm>
      </mods:role>
      <mods:nameIdentifier type="mcr_legalentity"><xsl:value-of select="@xlink:href"/></mods:nameIdentifier>
    </mods:name>
  </xsl:template>

  <xsl:template match="subjects">
    <xsl:apply-templates select="subject"/>
  </xsl:template>

  <xsl:template match="subject">
    <xsl:choose>
      <xsl:when test="@classid='DocPortal_class_00000009'"><!-- DDC Klassifikation -->
        <mods:classification authority="ddc" displayLabel="ddc">
          <xsl:value-of select="@categid" />
        </mods:classification>
      </xsl:when>
      <xsl:otherwise>
        <mods:classification>
          <xsl:value-of select="." /> <!--Passendes Attribute einfügen-->
        </mods:classification>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="origins">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="origin">
    <mods:name type="corporate" authorityURI="http://www.mycore.org/classifications/mir_institutes">
      <xsl:attribute name="valueURI">
        <xsl:value-of select="'http://www.mycore.org/classifications/mir_institutes#'" />
        <xsl:value-of select="@categid" />
      </xsl:attribute>
      <mods:role>
        <mods:roleTerm authority="marcrelator" type="code">his</mods:roleTerm>
      </mods:role>
    </mods:name>
  </xsl:template>

  <xsl:template match="descripturls">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="descripturl">
    <mods:abstract>
      <xsl:value-of select="@xlink:href" />  <!-- gegebenenfalls mit passendem Attribut tauschen -->
    </mods:abstract>
  </xsl:template>

  <xsl:template match="publishers">
    <xsl:apply-templates select="publisher[@xml:lang=$language]"/>
  </xsl:template>

  <xsl:template match="publisher">
    <mods:name type="corporate">
      <mods:displayForm>
        <xsl:value-of select="." />
      </mods:displayForm>
      <mods:role>
        <mods:roleTerm authority="marcrelator" type="code">pbl</mods:roleTerm>
      </mods:role>
    </mods:name>
  </xsl:template>

  <xsl:template match="publisherlinks">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="publisherlink">
    <mods:name type="corporate">
      <mods:displayForm>
        <xsl:value-of select="@xlink:href" /> <!-- TODO: Inhalt aus Personenobjekt auslesen und ID erhalten ... -->
      </mods:displayForm>
      <mods:role>
        <mods:roleTerm authority="marcrelator" type="code">pbl</mods:roleTerm>
      </mods:role>
    </mods:name>
  </xsl:template>


  <xsl:template match="contributors">
    <xsl:apply-templates select="contributor[@xml:lang=$language]"/>
  </xsl:template>

  <xsl:template match="contributor">
    <mods:name type="personal" usage="primary">
      <mods:displayForm>
        <xsl:value-of select="." />
      </mods:displayForm>
      <mods:role>
        <mods:roleTerm authority="marcrelator" type="code">ctb</mods:roleTerm>
      </mods:role>
    </mods:name>
  </xsl:template>

  <xsl:template match="contributorlinks">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="contributorlink">
    <mods:name type="personal" usage="primary">
      <mods:displayForm>
        <xsl:value-of select="@xlink:href" /> <!-- TODO: Inhalt aus Personenobjekt auslesen und ID erhalten ... -->
      </mods:displayForm>
      <mods:role>
        <mods:roleTerm authority="marcrelator" type="code">ctb</mods:roleTerm>
      </mods:role>
    </mods:name>
  </xsl:template>

  <xsl:template match="types">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="type">
    <mods:genre type="intern" authorityURI="http://www.mycore.org/classifications/mir_genres">
      <xsl:attribute name="valueURI">
        <xsl:value-of select="'http://www.mycore.org/classifications/mir_genres#'"/>
        <xsl:variable name="categid" select="@categid" />
        <xsl:variable name="myURI" select="concat('classification:metadata:0:children:',@classid, ':', $categid)" />
        <xsl:variable name="genre" select="document($myURI)//category[@ID=$categid]/label[@xml:lang='en']/@text" />
        <xsl:choose>
          <!-- TODO: add your genre mapping here -->
          <xsl:when test="contains($genre,'preprint, paper, report')"><xsl:value-of select="'report'"/></xsl:when>
          <xsl:when test="contains($genre,'Periodical, Series')"><xsl:value-of select="'journal'"/></xsl:when>
          <xsl:when test="contains($genre,'lecture')"><xsl:value-of select="'lecture_resource'"/></xsl:when>
          <xsl:when test="contains($genre,'diploma thesis')"><xsl:value-of select="'diploma_thesis'"/></xsl:when>
          <xsl:when test="contains($genre,'educational material')"><xsl:value-of select="'course_resources'"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$genre"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </mods:genre>
  </xsl:template>

  <xsl:template match="formats">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="format">
    <mods:typeOfResource>
      <xsl:variable name="categid" select="@categid" />
      <xsl:variable name="myURI" select="concat('classification:metadata:0:children:',@classid, ':', $categid)" />
      <xsl:variable name="format" select="document($myURI)//category[@ID=$categid]/label[@xml:lang='en']/@text" />
      <xsl:choose>
        <xsl:when test="contains($format,'text/document')">
          <xsl:value-of select="'text'"/>
        </xsl:when>
        <xsl:when test="contains($format,'image')">
          <xsl:value-of select="'still image'"/>
        </xsl:when>
        <xsl:when test="contains($format,'video')">
          <xsl:value-of select="'moving image'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$format"/>
        </xsl:otherwise>
      </xsl:choose>
    </mods:typeOfResource>
  </xsl:template>

  <xsl:template match="relations">
    <xsl:apply-templates select="relation[@xml:lang=$language]"/>
  </xsl:template>

  <xsl:template match="relation">
    <mods:relatedItem type="references">
      <mods:titleInfo>
      <mods:title>
          <xsl:value-of select="." /> <!-- Inhalt ergänzen falls kein frei Text-->
    </mods:title>
      </mods:titleInfo>
    </mods:relatedItem>
  </xsl:template>

  <xsl:template match="relationlinks">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="relationlink">
    <mods:relatedItem type="references">
      <mods:location>
        <xsl:value-of select="@xlink:href" />
      </mods:location>
    </mods:relatedItem>
  </xsl:template>

  <xsl:template match="relationisbns">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="relationisbn">
    <mods:relatedItem>
      <mods:identifier>
        <xsl:value-of select="." />
      </mods:identifier>
    </mods:relatedItem>
  </xsl:template>

  <xsl:template match="rights">
    <xsl:apply-templates select="right[@xml:lang=$language]"/>
  </xsl:template>

  <xsl:template match="right">
    <mods:accessCondition type="use and reproduction">
      rights_reserved
    </mods:accessCondition>
    <mods:accessCondition type="copyrightMD">
      <cmd:rights.holder>
        <cmd:name>
          <xsl:value-of select="." />
        </cmd:name>
      </cmd:rights.holder>
    </mods:accessCondition>
  </xsl:template>

  <xsl:template match="rightlinks">
  </xsl:template>

  <xsl:template match="isbns">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="isbn">
    <mods:identifier type="isbn">
      <xsl:value-of select="." />
    </mods:identifier>
  </xsl:template>

  <xsl:template match="nbns">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="nbn">
    <mods:identifier type="nbn">
      <xsl:value-of select="." />
    </mods:identifier>
  </xsl:template>

  <xsl:template match="urns">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="urn">
    <mods:identifier type="urn">
      <xsl:value-of select="." />
    </mods:identifier>
  </xsl:template>


  <xsl:template match="ddbContacts">
  </xsl:template>

  <xsl:template match="identifiers">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="identifier">
    <mods:identifier type="intern">
        <xsl:value-of select="." />
    </mods:identifier>
  </xsl:template>

  <xsl:template match="languages">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="language">
      <mods:language usage="primary">
        <mods:languageTerm authority="rfc4646" type="code">
      <xsl:choose>
        <xsl:when test="not(contains($language, 'xx'))">
              <xsl:value-of select="$language" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'und'" /><!-- undetermined (ISO code "und") -->
        </xsl:otherwise>
          </xsl:choose>
        </mods:languageTerm>
      </mods:language>
  </xsl:template>


  <xsl:template match="keywords">
    <xsl:apply-templates select="keyword[@xml:lang=$language]"/>
  </xsl:template>

  <xsl:template match="keyword">
    <mods:subject>
      <mods:topic>
        <xsl:value-of select="." />
      </mods:topic>
    </mods:subject>
  </xsl:template>

  <xsl:template match="coverages">
    <xsl:apply-templates select="coverage[@xml:lang=$language]"/>
  </xsl:template>

  <xsl:template match="coverage">
    <mods:subject>
      <mods:geographic>
        <xsl:value-of select="." />
      </mods:geographic>
    </mods:subject>
  </xsl:template>

  <xsl:template match="coveragelinks">
  </xsl:template>


  <xsl:template match="coveragedates">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="coveragedate">
    <mods:subject>
      <mods:temporal>
        <xsl:value-of select="." /> <!-- Das jeweilige Attribut einsetzen -->
      </mods:temporal>
    </mods:subject>
  </xsl:template>

  <xsl:template match="notes">
    <xsl:apply-templates select="note[@xml:lang=$language]"/>
  </xsl:template>

  <xsl:template match="note">
    <xsl:if test="not(@type='feet')">  <!-- Nur Kommentare in mods:note mappen -->
      <mods:note>
        <xsl:value-of select="." />
      </mods:note>
    </xsl:if>
  </xsl:template>

  <xsl:template match="citations">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="citation">
    <mods:extension>
      <dcterms:bibliographicCitation>
        <xsl:value-of select="." /> <!-- Das jeweilige Attribut einsetzen -->
      </dcterms:bibliographicCitation>
    </mods:extension>
  </xsl:template>


  <xsl:template match="sizes">
    <xsl:apply-templates select="size[@xml:lang=$language]"/>
  </xsl:template>

  <xsl:template match="size">
    <mods:physicalDescription>
      <mods:extent>
        <xsl:value-of select="." />
      </mods:extent>
    </mods:physicalDescription>
  </xsl:template>

  <xsl:template match="servdates">
    <servdates class="MCRMetaISO8601Date">
      <servdate type="createdate" inherited="0">
        <xsl:choose>
          <xsl:when test="not(contains(servdate[@type='createdate'], 'T'))">
            <xsl:value-of select="concat(servdate[@type='createdate'],'T00:00:00.000Z')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="servdate[@type='createdate']"/>
          </xsl:otherwise>
        </xsl:choose>
      </servdate>
      <servdate type="modifydate" inherited="0">
        <xsl:choose>
          <xsl:when test="not(contains(servdate[@type='modifydate'], 'T'))">
            <xsl:value-of select="concat(servdate[@type='modifydate'],'T00:00:00.000Z')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="servdate[@type='modifydate']" />
          </xsl:otherwise>
        </xsl:choose>
      </servdate>
    </servdates>
  </xsl:template>

  <xsl:template match="text()"> <!-- Nimmt alle Texte die nicht verarbeitet wurden, damit sie nicht in der Ausgabe erscheinen -->
  </xsl:template>

  <!-- standard copy template -->
  <!-- <xsl:template match="@*|node()"> <xsl:copy> <xsl:apply-templates select="@*"
    /> <xsl:apply-templates /> </xsl:copy> </xsl:template> -->
</xsl:stylesheet>