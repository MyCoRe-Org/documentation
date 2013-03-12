<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="homepage">
    <div class="row">
        <div id="news" class="span3">
            <h3>Meldungen</h3>
            <ul><xsl:apply-templates select="news/newsentry" /></ul>
        </div>
        <div class="span9">
            <h3><xsl:value-of select="title" /></h3>
            <p><xsl:value-of select="text" /></p>
            <p style="text-align: center;"><xsl:apply-templates select="images" /></p>
        </div>
    </div>
  </xsl:template>

  <xsl:template match="newsentry">
    <li>
        <span class="message">
            <a href="{url}" class="latestnews">
                <xsl:if test="contains(url, 'http://')">
                    <xsl:attribute name="class">
                        <xsl:value-of select="'external'"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="message" />
            </a>
        </span>
        <span class="date">
            vom <xsl:value-of select="date" />
        </span>
        <span class="author">
            durch <xsl:value-of select="author" />
        </span>
    </li>
  </xsl:template>

  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>