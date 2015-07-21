<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="lm://transform.skin.common.html.tab-to-menu"/>


    <xsl:template match="tabs">
        <ul id="tabs">
            <xsl:call-template name="base-tabs"/>
        </ul>
    </xsl:template>

    <xsl:template name="selected">
        <li class="active"><xsl:call-template name="base-selected"/></li>
    </xsl:template>

    <xsl:template name="not-selected">
        <li><xsl:call-template name="base-not-selected"/></li>
    </xsl:template>


    <xsl:template name="pre-separator"></xsl:template>
    <xsl:template name="post-separator"></xsl:template>
    <xsl:template name="separator"></xsl:template>
    <xsl:template name="level2-separator"></xsl:template>
    <xsl:template name="level2-not-selected"></xsl:template>
    <xsl:template name="level2-selected"></xsl:template>

</xsl:stylesheet>
