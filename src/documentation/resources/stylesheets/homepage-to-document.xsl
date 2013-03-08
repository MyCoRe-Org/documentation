<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="homepage">
    <div class="row-fluid">
        <div class="span9">
            <h3><xsl:value-of select="title" /></h3>
            <p><xsl:value-of select="text" /></p>
            <p style="text-align: center;"><xsl:apply-templates select="images" /></p>
        </div>
        <div class="span3">
            <h3>Aktuelles</h3>
            <ul><xsl:apply-templates select="news/newsentry" /></ul>
        </div>
    </div>
  </xsl:template>

  <xsl:template match="newsentry">
    <li>
      <a href="{url}" class="latestnews"><xsl:value-of select="message" /></a>
      <br />
      <span style="font-size:10px;">(<xsl:value-of select="date" />, <xsl:value-of select="author" />)</span>
    </li>
  </xsl:template>

  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>