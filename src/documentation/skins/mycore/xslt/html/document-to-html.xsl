<?xml version="1.0"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!--
This stylesheet contains templates for converting documentv11 to HTML.  See the
imported document-to-html.xsl for details.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="lm://transform.skin.common.html.document-to-html"/>
  <xsl:template match="document">
    <meta-data>
      <xsl:apply-templates select="header/meta"/>
      <xsl:apply-templates select="header/link"/>
    </meta-data>
    <div id="content">
      <xsl:if test="normalize-space(header/release)!=''">
        <div style="text-align:right">
          <xsl:for-each select="header/release">
            <span>&#160;</span>
            <span class="label label-info">
              <xsl:value-of select="text()"/>
            </span>
          </xsl:for-each>
        </div>
      </xsl:if>
      <xsl:apply-templates select="body" mode="carry-body-attribs"/>
      <div id="skinconf-printlink"/>
      <div id="skinconf-xmllink"/>
      <div id="skinconf-podlink"/>
      <div id="skinconf-txtlink"/>
      <div id="skinconf-pdflink"/>
      <div id="disable-font-script"/>
      <xsl:if test="normalize-space(header/title)!=''">
        <h1>
          <xsl:value-of select="header/title"/>
        </h1>
      </xsl:if>
      <xsl:if test="normalize-space(header/subtitle)!=''">
        <h2>
          <xsl:value-of select="header/subtitle"/>
        </h2>
      </xsl:if>
<!--
      <xsl:apply-templates select="header/type"/>
      <xsl:apply-templates select="header/notice"/>
      <xsl:apply-templates select="header/abstract"/>
      <xsl:apply-templates select="body"/>

      <div class="attribution">
        <xsl:apply-templates select="header/authors"/>
        <xsl:if test="header/authors and header/version">
          <xsl:text>; </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="header/version"/>
      </div>
    -->
      <div id="front-matter">
        <div id="motd-page"/>
        <xsl:if test="header/abstract">
          <div class="abstract">
            <xsl:value-of select="header/abstract"/>
          </div>
        </xsl:if>
        <div id="skinconf-toc-page"/>
      </div>
      <xsl:apply-templates select="body"/>
      <xsl:if test="header/authors or header/version">
        <p align="right">
          <font size="-2">
            <xsl:for-each select="header/authors/person">
              <xsl:choose>
                <xsl:when test="position()=1">&#160;</xsl:when>
                <xsl:otherwise>,&#160;</xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="@name"/>
            </xsl:for-each>
            <xsl:if test="header/version">
              <xsl:choose>
                <xsl:when test="header/authors/person">&#160;-&#160;</xsl:when>
                <xsl:otherwise><!-- do nothing --></xsl:otherwise>
              </xsl:choose>
              <xsl:apply-templates select="header/version"/>
            </xsl:if>
          </font>
        </p>
      </xsl:if>
    </div>
  </xsl:template>
  <xsl:template match="body">
    <xsl:apply-templates/>
    <!-- Piwik -->
    <script type="text/javascript">
      var _paq = _paq || [];
      _paq.push(["setDocumentTitle", document.domain + "/" + document.title]);
      _paq.push(["setCookieDomain", "*.mycore.de"]);
      _paq.push(["setDomains", ["*.mycore.de"]]);
      _paq.push(["setDoNotTrack", true]);
      _paq.push(['trackPageView']);
      _paq.push(['enableLinkTracking']);
      (function() {
        var u="//piwik.gbv.de/";
        _paq.push(['setTrackerUrl', u+'piwik.php']);
        _paq.push(['setSiteId', 20]);
        _paq.push(['setDownloadExtensions', "7z|aac|arc|arj|asf|asx|avi|bin|bz|bz2|csv|deb|dmg|doc|exe|flv|gif|gz|gzip|hqx|jar|jpg|jpeg|js|mp2|mp3|mp4|mpg|mpeg|mov|movie|msi|msp|odb|odf|odg|odp|ods|odt|ogg|ogv|pdf|phps|png|ppt|qt|qtm|ra|ram|rar|rpm|sea|sit|tar|tbz|tbz2|tgz|torrent|txt|wav|wma|wmv|wpd|z|zip"]);
        var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript';
        g.defer=true; g.async=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
      })();
    </script>
    <noscript><p><img src="//piwik.gbv.de/piwik.php?idsite=20" style="border:0;" alt="" /></p></noscript>
    <!-- End Piwik Code -->
  </xsl:template>
  <xsl:template match="@id">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="section"><a name="{generate-id()}"/>
    <xsl:apply-templates select="@id"/>
    <xsl:variable name = "level" select = "count(ancestor::section)+1" />
    <xsl:choose>
      <xsl:when test="$level=1">
        <div class="skinconf-heading-{$level}">
          <h1>
            <xsl:value-of select="title"/>
          </h1>
        </div>
        <div class="section">
          <xsl:apply-templates select="*[not(self::title)]"/>
        </div>
      </xsl:when>
      <xsl:when test="$level=2">
        <div class="skinconf-heading-{$level}">
          <h2>
            <xsl:value-of select="title"/>
          </h2>
        </div>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:when>
<!-- If a faq, answer sections will be level 3 (1=Q/A, 2=part) -->
      <xsl:when test="$level=3 and $notoc='true'">
        <h4 class="faq">
          <xsl:value-of select="title"/>
        </h4>
        <div align="right"><a href="#{@id}-menu">^</a>
        </div>
        <div style="margin-left: 15px">
          <xsl:apply-templates select="*[not(self::title)]"/>
        </div>
      </xsl:when>
      <xsl:when test="$level=3">
        <h4>
          <xsl:value-of select="title"/>
        </h4>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:when>
      <xsl:otherwise>
        <h5>
          <xsl:value-of select="title"/>
        </h5>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="abstract">
    <div class="abstract">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="figure">
    <xsl:apply-templates select="@id"/>
    <div style="text-align: center;" id="{@id}">
      <img src="{@src}" alt="{@alt}" class="figure"  id="{@id}">
        <xsl:if test="@height">
          <xsl:attribute name="height">
            <xsl:value-of select="@height"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@width">
          <xsl:attribute name="width">
            <xsl:value-of select="@width"/>
          </xsl:attribute>
        </xsl:if>
      </img>
    </div>
  </xsl:template>

  <xsl:template match="code">
    <xsl:apply-templates select="@id"/>
    <code>
      <xsl:copy-of select="@id"/>
      <xsl:value-of select="."/>
    </code>
  </xsl:template>
</xsl:stylesheet>
