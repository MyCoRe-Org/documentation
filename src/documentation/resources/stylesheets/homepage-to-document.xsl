<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="homepage">
    <div class="row">
    <!--
        <div id="news" class="span3">
            <h3>Meldungen</h3>
            <ul><xsl:apply-templates select="news/newsentry" /></ul>
        </div>
        <div class="span9" >-->
        <div class="span12" >
            <div id="content_home">
                <h1 id="project_name"><xsl:value-of select="title" /></h1>
                <p id="short_description"><xsl:apply-templates select="text" /></p>
                <div id="short_features" class="row-fluid">
                    <xsl:apply-templates select="images/image" />
                </div>
                <div class="well">
                    <div id="verbreitung">
                        <xsl:apply-templates select="location" />
                        <div id="mitglieder" class="">
                            <ul>
                                <xsl:apply-templates select="members/member" />
                            </ul>
                         </div>
                        <div id="karte" class="">
                            <xsl:apply-templates select="map" />
                        </div>
                    </div>

                </div>
                <div id="news_down"><ul><xsl:apply-templates select="news/newsentry" /></ul></div>
            </div>
        </div>
    </div>
  </xsl:template>

  <xsl:template match="location">
    <div id="standorte" class="">
        <span id="nummer"><a href="site:list" title="{@title}"><xsl:value-of select="@number" /></a></span>
        <span id="label"><a href="site:list" title="{@title}"><xsl:value-of select="@label" /></a></span>
    </div>
  </xsl:template>

  <xsl:template match="member">
    <li title="{@title}">
        <a href="{@href}"><xsl:value-of select="@label" /></a>
    </li>
  </xsl:template>

  <xsl:template match="map">
    <span id="label"><a href="site:map" title="{@title}"><xsl:value-of select="@label" /></a></span>
    <a href="site:map" title="{@title}"><img src = "images/icon_karte.png"
         class=""
         id  = ""
         alt = "" /></a>
  </xsl:template>

  <xsl:template match="image">
    <div class="span4 text-center">
      <a href="{link}" class="sphereLink">
        <img src   = "images/{path}"
             class = "sphere"
             rel   = "{id}"
             alt   = "{alt}" />
        <h3><xsl:value-of select="title" /></h3>
        <p><xsl:value-of select="description" /></p>
      </a>
    </div>
  </xsl:template>

<!--
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
 -->

   <xsl:template match="newsentry">
    <li id="entry_{position()}" style="background-image: url(images/background_.png);">
            <a href="{url}" class="latestnews">
                <xsl:if test="contains(url, 'http://')">
                    <xsl:attribute name="class">
                        <xsl:value-of select="'external'"/>
                    </xsl:attribute>
                </xsl:if>
        <h4><xsl:value-of select="title" /></h4>
        <span class="message">
            <xsl:value-of select="message" />
        </span>
        <span class="date">
            vom <xsl:value-of select="date" />
        </span>
        <span class="author">
            durch <xsl:value-of select="author" />
        </span>


            </a>


    </li>
  </xsl:template>

  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>