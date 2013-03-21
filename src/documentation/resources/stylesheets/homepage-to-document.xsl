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
                        <div id="standorte" class="">
                            <span id="nummer">20+</span>
                            <span id="label">Standorte</span>
                        </div>
                        <div id="mitglieder" class="">
                            <a href="#"><img src = "images/gray_1x1.png"
                                 class="img-rounded"
                                 title="Link zum Standort"
                                 id  = ""
                                 alt = "" /></a>
                            <a href="#"><img src = "images/gray_1x1.png"
                                 class="img-rounded"
                                 title="Link zum Standort"
                                 id  = ""
                                 alt = "" /></a>
                            <a href="#"><img src = "images/gray_1x1.png"
                                 class="img-rounded"
                                 title="Link zum Standort"
                                 id  = ""
                                 alt = "" /></a>
                            <a href="#"><img src = "images/gray_1x1.png"
                                 class="img-rounded"
                                 title="Link zum Standort"
                                 id  = ""
                                 alt = "" /></a>
                            <a href="#"><img src = "images/gray_1x1.png"
                                 class="img-rounded"
                                 title="Link zum Standort"
                                 alt = "last"
                                 id=""/></a>
                        </div>
                        <div id="karte" class="">
                            <span id="label">Karte</span>
                            <a href="#"><img src = "images/gray_1x1.png"
                                 class="img-rounded"
                                 title="Link zur Karte"
                                 id  = ""
                                 alt = "" /></a>
                        </div>
                    </div>

                </div>
                <div id="news_down"><ul><xsl:apply-templates select="news/newsentry" /></ul></div>
            </div>
        </div>
    </div>
  </xsl:template>

  <xsl:template match="image">
    <div class="span4 text-center">
      <a href="{link}"><img src = "images/{path}"
                            class="img-circle"
                             id  = "xxx"
                             alt = "xxx" /></a>
      <h3><xsl:value-of select="title" /></h3>
      <p><xsl:value-of select="description" /></p>
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
    <li id="entry_{position()}">
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