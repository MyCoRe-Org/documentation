<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                exclude-result-prefixes="i18n">

    <xsl:import href="../../../common/xslt/html/site-to-xhtml.xsl" />

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    main template
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="site">

        <xsl:variable name="page_name">
            <xsl:choose>
                <xsl:when test="$path = 'index.html'"><xsl:value-of select="'home'" /></xsl:when>
                <xsl:otherwise><xsl:value-of select="$path" /></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

<html>
    <head>
        <link href='http://fonts.googleapis.com/css?family=Source+Code+Pro' rel='stylesheet' type='text/css' />
        <link href='http://fonts.googleapis.com/css?family=Sintony' rel='stylesheet' type='text/css' />
        <xsl:call-template name="html-meta" />
        <xsl:call-template name="meta-data" />
        <xsl:call-template name="meta-title" />
        <xsl:call-template name="meta-icon" />
        <xsl:call-template name="meta-css" />
        <xsl:call-template name="meta-script" />
    </head>

    <body>

        <xsl:if test="$page_name = 'home'">
            <xsl:attribute name="id">
                <xsl:value-of select="'mycore_home'"/>
            </xsl:attribute>
        </xsl:if>

        <xsl:if test="$path = 'index.html'">
            <xsl:attribute name="id">
                <xsl:value-of select="'mycore_home'"/>
            </xsl:attribute>
        </xsl:if>
        <div class="container">

            <div class="row">
                <div id="header" class="span12">
                    <xsl:call-template name="site-logo" />
                    <xsl:call-template name="search" />
                </div>
            </div>

            <div class="row"  id="topnavrow">
                <div id="topnav" class="span12">
                    <div id="nav_block">
                        <xsl:apply-templates select="ul[@id='tabs']"/>
                    </div>
                </div>
            </div>

            <div class="row">
                <div id="main" class="span12">

                        <!-- use 3 columns for menu, if there is one -->
                        <xsl:choose>
                            <xsl:when test="div[@id='menu']/ul/li">
                                <div class="row">
                                    <div id="subnav" class="span3">
                                        <xsl:call-template name="menu"/>
                                        <script type="text/javascript"
                                                language="javascript">
                                                $(function() {
                                                    $("ul li div").click(function() {
                                                        $(this).parent().children("ul").slideToggle();
                                                    });
                                                });
                                        </script>
                                    </div>
                                    <div id="sub_content" class="span9">
                                        <xsl:apply-templates select="div[@id='content']"/>
                                    </div>
                                </div>
                            </xsl:when>
                            <xsl:when test="$page_name = 'home'">
                                <xsl:apply-templates select="div[@id='content']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <div class="row">
                                    <div id="big_content" class="span12">
                                        <xsl:apply-templates select="div[@id='content']"/>
                                    </div>
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>

                </div>
            </div>

            <div class="row">
                <div id="footer" class="span12">
                    <xsl:call-template name="feedback" />
                    <xsl:call-template name="footer_menu"/>
                </div>
            </div>

        </div>

<script type="text/javascript" language="javascript">
<![CDATA[
$(document).ready(function() {

    var domscripts = {

        init: function init () {
            var self = this;
            self.installStickyMenu();
        },

        installStickyMenu: function installStickyMenu () {

            var header      = $('div#header'),
                nav         = $('div#topnavrow'),
                stickyClass = 'fix';

                $(document).bind('scroll',function(){
                    var hOffset = header.offset().top+header.height();
                    var top = $(document).scrollTop();

                    // make it sticky ...
                        if (hOffset < top) {
                            if (nav.data(stickyClass) !== true) {
                                nav.addClass(stickyClass).data(stickyClass,true);
                                $('div#content').css('margin-top', nav.height());
                            }
                        } else {
                            if (nav.data(stickyClass) !== false) {
                                nav.removeClass(stickyClass).data(stickyClass,false);
                                $('div#content').css('margin-top', 0);
                            }
                        }
                });

                // initial check for scroll-status ...
                $(document).trigger('scroll');
        }
    }
    domscripts.init();
});
]]>
</script>

    </body>
</html>

    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta-title
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="meta-title">
        <title>
            <xsl:value-of select="div[@id='content']/h1"/>
            <xsl:if test="$config/motd">
                <xsl:for-each select="$config/motd/motd-option">
                    <xsl:choose>
                        <xsl:when test="@starts-with='true'">
                            <xsl:if test="starts-with($path, @pattern)">
                                <xsl:if test="normalize-space(motd-title) != ''">
                                    <xsl:text> (</xsl:text>
                                    <xsl:value-of select="motd-title"/>
                                    <xsl:text>)</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="contains($path, @pattern)">
                                <xsl:if test="normalize-space(motd-title) != ''">
                                    <xsl:text> (</xsl:text>
                                    <xsl:value-of select="motd-title"/>
                                    <xsl:text>)</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="string-length(div[@id='content']/h1) > 0">
              <xsl:text> | </xsl:text>
            </xsl:if>
            <xsl:text>MyCoRe</xsl:text>
        </title>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta-icon
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="meta-icon">
        <xsl:if test="//skinconfig/favicon-url"><link rel="shortcut icon">
          <xsl:attribute name="href">
            <xsl:value-of select="concat($root,//skinconfig/favicon-url)"/>
          </xsl:attribute></link>
        </xsl:if>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta-css
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="meta-css">
        <link href = "{$root}skin/central.css"
              type = "text/css"
              rel  = "stylesheet" />
        <xsl:if test="$path = 'applications/map.html'">
          <link rel="stylesheet" href="{$root}skin/mycore-standorte.css" type="text/css" />
        </xsl:if>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta-script
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="meta-script">
        <script type="text/javascript"
                language="javascript"
                src="{$root}skin/jquery-1.7.1.min.js"></script>
        <xsl:if test="$path = 'applications/map.html'">
          <script type="text/javascript" src="http://dev.openlayers.org/releases/OpenLayers-2.12/OpenLayers.js"></script>
          <script type="text/javascript">
<![CDATA[
      var map, select;
      $(document).ready(function() {
        map = new OpenLayers.Map('map_div',{
          projection: new OpenLayers.Projection("EPSG:900913"),
              displayProjection: new OpenLayers.Projection("EPSG: 4326"),
        });
        var mapquestLayer = new OpenLayers.Layer.XYZ(
            "MapQuest",
                [
                  "http://otile1.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png",
                  "http://otile2.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png",
                  "http://otile3.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png",
                  "http://otile4.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png"
                ],
                {
                  transitionEffect: "resize"
                }
        );
        map.addLayer(mapquestLayer);

        var clusterStrategy = new OpenLayers.Strategy.Cluster( { distance: 25, threshold: 1 } );

        var style = new OpenLayers.Style( {
          pointRadius: "${pointRadius}",
          fillColor: "red",
          fillOpacity: 1,
          strokeColor: "black",
          strokeOpacity: 1,
          graphicZIndex: 2,
          strokeWidth: 2,
          label: "${label}",
          title: "Klicken, um Anwendungen anzuzeigen"
        } , {
          context: 
          {
            pointRadius: function(feature) { return 7 + feature.cluster.length.toString().length * 3; },
            label: function(feature) { return feature.cluster ? feature.cluster.length : "1";  }
          }
        } );
        var styleMap = new OpenLayers.StyleMap( { "default": style, "select": { fillColor : "orange" } } );

        var kml =  new OpenLayers.Layer.Vector("MyCoRe Standorte", {
                     projection: new OpenLayers.Projection("EPSG:4326"),
                     strategies: [ new OpenLayers.Strategy.Fixed(), clusterStrategy ],
                     styleMap : styleMap,
                     protocol: new OpenLayers.Protocol.HTTP({
                       url: "map/mycore-standorte.kml",
                       format: new OpenLayers.Format.KML({
                         extractStyles: true,
                         extractAttributes: true
                       })
                     })
                   });
        map.addLayer(kml);

        select = new OpenLayers.Control.SelectFeature(kml);
        kml.events.on({
                    "featureselected": onFeatureSelect,
                    "featureunselected": onFeatureUnselect,
        });

        map.addControl(select);
        select.activate();

        map.setCenter(new OpenLayers.LonLat(10.25,51.5) // Center of the map
              .transform(
                new OpenLayers.Projection("EPSG:4326"), // transform from WGS 1984
                new OpenLayers.Projection("EPSG:900913") // to Spherical Mercator Projection
              ), 6); // Zoom level
      }); //END ready

      function onPopupClose(evt) {
              select.unselectAll();
          }

          function onFeatureSelect(event) {
              var feature = event.feature;
              // Since KML is user-generated, do naive protection against
              // Javascript.

              var content = "";
              if( feature.cluster ) {
                for(var i = 0; i < feature.cluster.length; i++ ) content += "<h2>" + feature.cluster[i].attributes.name + "</h2>" + feature.cluster[i].attributes.description;
              } else {
                content = "<h2>" + feature.attributes.name + "</h2>" + feature.attributes.description;
              };

              if (content.search("<script") != -1) {
                  content = "Content contained Javascript! Escaped content below.<br>" + content.replace(/</g, "&lt;");
              }
              var pos = feature.geometry.getBounds().getCenterLonLat();
              var popup = new OpenLayers.Popup.FramedCloud("mycoreapps",
                  pos,
                      null,
                      content,
                      null, true, onPopupClose);
              popup.autoSize=true;
              popup.maxSize =  new OpenLayers.Size(330,800);
              feature.popup = popup;
              map.addPopup(popup);
          }

          function onFeatureUnselect(event) {
              var feature = event.feature;
              if(feature.popup) {
                  map.removePopup(feature.popup);
                  feature.popup.destroy();
                  delete feature.popup;
              }
          }
]]>
          </script>
        </xsl:if>
        <xsl:if test="$path = 'index.html'">
          <script type="text/javascript">
<![CDATA[
      $(document).ready(function() {

          $(".sphereLink").hover(

              function () {
                  var sphere = $(this).children('img.sphere');
                  sphere.attr("src", "images/abbildung_orange_110x110.jpg");
              },
              function () {
                  var sphere = $(this).children('img.sphere');
                  switch(sphere.attr("rel")){
                      case "sphere_manysided":
                          sphere.attr("src", "images/abbildung_vielseitig.jpg");
                          break;
                      case "sphere_adaptable":
                          sphere.attr("src", "images/abbildung_anpassbar.jpg");
                          break;
                      case "sphere_lasting":
                          sphere.attr("src", "images/abbildung_nachhaltig.jpg");
                          break;
                  }
              }
          );
      });
]]>
          </script>
        </xsl:if>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    site-logo
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="site-logo">
        <a href="{$root}"><img src = "{$root}images/logo_mycore.png"
             id  = "mycore_logo"
             alt = "MyCoRe Logo" /></a>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub menu block
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="menu">
        <div id="submenu">
            <xsl:for-each select = "div[@id='menu']/ul/li">
                <xsl:call-template name = "innermenuli" >
                    <xsl:with-param name="id" select="concat('1_', position())"/>
                    <xsl:with-param name="position" select="position()" />
                </xsl:call-template>
            </xsl:for-each>
        </div>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub menu
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template name="innermenuli">

        <xsl:param name="id"/>
        <xsl:param name="position" />

        <xsl:variable name="tagid">
            <xsl:choose>
                <xsl:when test="descendant-or-self::node()/li/div/@class='current'">
                    <xsl:value-of select="concat('menu_selected_',$id)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('menu_',concat(font,$id))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="whichGroup">
            <xsl:choose>
                <xsl:when test="descendant-or-self::node()/li/div/@class='current'">block_level_two_active</xsl:when>
                <xsl:otherwise>block_level_two</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

<!-- menu title -->
        <xsl:choose>
          <xsl:when test="$position = 1">
            <xsl:call-template name = "innermenulientry" >
              <xsl:with-param name="id"         select="$id"/>
              <xsl:with-param name="tagid"      select="$tagid"/>
              <xsl:with-param name="whichGroup" select="'block_level_one'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
              <li id="{$tagid}Title">
                  <xsl:choose>
                    <xsl:when test="$whichGroup = 'block_level_two_active'">
                        <xsl:attribute name="class">menu_entry_block_active</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="class">menu_entry_block</xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <div class="block_title"><xsl:value-of select="h1"/></div>
                  <xsl:call-template name = "innermenulientry" >
                    <xsl:with-param name="id"         select="$id"/>
                    <xsl:with-param name="tagid"      select="$tagid"/>
                    <xsl:with-param name="whichGroup" select="$whichGroup"/>
                  </xsl:call-template>
              </li>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="innermenulientry">
        <xsl:param name="id"/>
        <xsl:param name="tagid"/>
        <xsl:param name="whichGroup" />

<!-- menu entry -->
        <ul class="{$whichGroup}" id="{$tagid}">

            <xsl:for-each select= "ul/li">
                <xsl:choose>

    <!-- linked entry -->
                    <xsl:when test="a">
                        <li class="menu_entry">
                            <xsl:if test="contains(a/@href, 'http://')">
                                <xsl:attribute name="class">
                                    <xsl:value-of select="'menu_entry external'"/>
                                </xsl:attribute>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="a/@href"/>
                                </xsl:attribute>
                                <xsl:if test="a/@title!=''">
                                    <xsl:attribute name="title">
                                        <xsl:value-of select="a/@title"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="a"/>
                            </a>
                        </li>
                    </xsl:when>

    <!-- active entry -->
                    <xsl:when test="div/@class='current'">
                        <li class="menu_entry_active">
                            <div class="block_title">
                                <xsl:value-of select="div" />
                            </div>
                        </li>
                    </xsl:when>

    <!-- default entry -->
                    <xsl:otherwise>
                        <xsl:call-template name = "innermenuli">
                            <xsl:with-param name="id" select="concat($id, '_', position())"/>
                        </xsl:call-template>
                    </xsl:otherwise>

                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pdf link
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<!-- TODO: remove inline styles -->
    <xsl:template match="div[@id='skinconf-pdflink']">
        <xsl:if test="not($config/disable-pdf-link) or $disable-pdf-link = 'false'">
            <div class="pdflink" style="position: relative;float: right;" title="Portable Document Format">
                <a style="display: block;text-align: center;" href="{$filename-noext}.pdf" class="dida">
                    <img class="skin" style="display: block;" src="{$root}images/pdficon_large.png" alt="PDF -icon" />
                </a>
            </div>
        </xsl:if>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    search
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="search">
        <form method="get"
              action="http://www.google.com/search"
              class="navbar-search pull-right">
            <input type="hidden"
                   name="sitesearch"
                   value="{$config/search/@domain}"/>
            <input type="text"
                   id="query"
                   name="q"
                   size="25"
                   value = ""
                   placeholder="Seite mit Google durchsuchen" />
            <button type="submit"
                    class="btn">
                <i class="icon-search icon-white"></i>
            </button>
        </form>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    footer menu
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="footer_menu">
        <div id="footer_menu" class="pull-right">
            <a href="{$root}contact/index.html">Kontakt</a> |
            <a href="{$root}impressum/index.html">Impressum</a>
        </div>

    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


</xsl:stylesheet>
