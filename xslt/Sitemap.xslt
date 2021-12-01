<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	exclude-result-prefixes="msxml umbraco.library">
	
    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:param name="currentPage"/>


    <!--
    ====================================================
    This XSLT creates an XML sitemap used for search
    engines. Following these guidelines
    http://www.sitemaps.org
    ====================================================
    -->

    <!--
    ====================================================
    We setup two parameters.
    
    maxLevelForSitemap allows you to configure how deep 
    the sitemap should go.
    
    url is the root url - eg: http://localhost
    ====================================================
    -->
    <xsl:variable name="maxLevelForSitemap" select="6"/>
    <xsl:variable name="url" select="concat('http://',umbraco.library:RequestServerVariables('HTTP_HOST'))" />


    <xsl:template match="/">
      <div class="pageSummaryCompCol">
        <xsl:call-template name="drawNodes">
          <xsl:with-param name="parent" select="$currentPage/ancestor-or-self::node [@level=1]"/>
          <xsl:with-param name="level" select="0"/>
        </xsl:call-template>
      </div>
    </xsl:template>


    <xsl:template name="drawNodes">
        <xsl:param name="parent"/>
        <xsl:param name="level"/>

        <!--
        ====================================================
        If the parent variable is NOT protected
        ====================================================
        -->
        <xsl:if test="umbraco.library:IsProtected($parent/@id, $parent/@path) = 0">

          <!--
          ====================================================
          For each CHILD node of the parent variable node
          WHERE umbracoNaviHide is NOT true AND the node's
          level is less than and equal to the 
          maxLevelForSitemap variable.
          ====================================================
          -->
          <ul class="siteMap{$level}">
            <xsl:for-each select="$parent/node [string(./data [@alias='umbracoNaviHide']) != '1' and @level &lt;= $maxLevelForSitemap]">
              <li>
                <a href="{umbraco.library:NiceUrl(@id)}">
                  <xsl:value-of select="@nodeName"/>
                </a>
              

                <!--
                ====================================================
                IF the number of child nodes from the current node
                in the for-each loop WHERE umbracoNaviHide is NOT true 
                AND the node's levels are less than and equal to the 
                maxLevelForSitemap variable is GREATER than 0.
                ====================================================
                -->
                <xsl:if test="count(current()/node [string(./data [@alias='umbracoNaviHide']) != '1' and @level &lt;= $maxLevelForSitemap and @nodeTypeAlias != 'FAQ' and @nodeTypeAlias != 'Gallery Image']) &gt; 0">

                  <!--
                    ====================================================
                    As we have further child nodes recall the same
                    template we are in with the parent variable set to
                    as the current node in the for-each loop.
                    ====================================================
                    -->
                  <xsl:call-template name="drawNodes">
                    <xsl:with-param name="parent" select="current()"/>
                    <xsl:with-param name="level" select="$level+1"/>
                  </xsl:call-template>
                </xsl:if>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
