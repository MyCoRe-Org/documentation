<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
	<xsl:output method="xml" indent="yes" />
	<xsl:variable name="mycoreclass2rdf_version">
		v0.1_20140707
	</xsl:variable>
	<xsl:template match="/mycoreclass">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
			<rdfs:Class>
				<xsl:choose>
				<xsl:when test="./label[@xml:lang='x-uri']">
					<xsl:attribute name="rdf:about"><xsl:value-of select="./label[@xml:lang='x-uri']/@text" /></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="rdf:ID"><xsl:value-of select="./@ID" /></xsl:attribute>
				</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="./label" />
			</rdfs:Class>
			<xsl:apply-templates select="./categories//category" />
		</rdf:RDF>
	</xsl:template>
	<xsl:template match="category">
		<rdfs:Class>
			<xsl:choose>
				<xsl:when test="./label[@xml:lang='x-uri']">
					<xsl:attribute name="rdf:about"><xsl:value-of select="./label[@xml:lang='x-uri']/@text" /></xsl:attribute>
				</xsl:when>
				<xsl:when test="/mycoreclass/label[@xml:lang='x-uri']">
					<xsl:attribute name="rdf:about"><xsl:value-of select="/mycoreclass/label[@xml:lang='x-uri']/@text" />#<xsl:value-of select="./@ID" /></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="rdf:ID"><xsl:value-of select="./@ID" /></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="parent::categories">
					<xsl:choose>
						<xsl:when test="./../../label[@xml:lang='x-uri']">
							<rdfs:subClassOf>
								<xsl:attribute name="rdf:resource"><xsl:value-of select="./../../label[@xml:lang='x-uri']/@text" /></xsl:attribute>
							</rdfs:subClassOf>
						</xsl:when>
						<xsl:otherwise>
							<rdfs:subClassOf>
								<xsl:attribute name="rdf:resource"><xsl:value-of select="/mycoreclass/label[@xml:lang='x-uri']/@text" />#<xsl:value-of select="./../../@ID" /></xsl:attribute>
							</rdfs:subClassOf>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="./../label[@xml:lang='x-uri']">
							<rdfs:subClassOf>
								<xsl:attribute name="rdf:resource"><xsl:value-of select="./../label[@xml:lang='x-uri']/@text" /></xsl:attribute>
							</rdfs:subClassOf>
						</xsl:when>
						<xsl:otherwise>
							<rdfs:subClassOf>
								<xsl:attribute name="rdf:resource"><xsl:value-of select="/mycoreclass/label[@xml:lang='x-uri']/@text" />#<xsl:value-of select="./../@ID" /></xsl:attribute>
							</rdfs:subClassOf>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="./label" />
		</rdfs:Class>

	</xsl:template>

	<xsl:template match="label">
		<rdfs:label>
			<xsl:attribute name="xml:lang"><xsl:value-of select="./@xml:lang" /></xsl:attribute>
			<xsl:value-of select="./@text" />
		</rdfs:label>
		<xsl:if test="./@description">
			<rdfs:comment>
				<xsl:attribute name="xml:lang"><xsl:value-of select="./@xml:lang" /></xsl:attribute>
				<xsl:value-of select="./@description" />
			</rdfs:comment>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet> 