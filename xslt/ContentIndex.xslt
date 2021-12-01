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

  <!-- update this variable on how deep your menu should be -->
  <xsl:variable name="maxLevelForMenu" select="4"/>

  <xsl:template match="/">
    
      <xsl:call-template name="drawNodes">
        <xsl:with-param
         name="parent"
         select="$currentPage/ancestor-or-self::node [@level=2]"
      />
      </xsl:call-template>
  </xsl:template>

  <xsl:template name="drawNodes">
    <xsl:param name="parent"/>

    <xsl:if test="umbraco.library:IsProtected($parent/@id, $parent/@path) = 0 or (umbraco.library:IsProtected($parent/@id, $parent/@path) = 1 and umbraco.library:IsLoggedOn() = 1)">
      <div class="pageSummaryCompCol">
        <xsl:call-template name="listItems">
        <xsl:with-param
         name="parent"
         select="$parent"
          />
        <xsl:with-param
         name="remainder"
         select="1"
          />
      </xsl:call-template>
      </div>
      <div class="pageSummaryCompCol">
        <xsl:call-template name="listItems">
          <xsl:with-param
           name="parent"
           select="$parent"
          />
          <xsl:with-param
           name="remainder"
           select="0"
          />
        </xsl:call-template>
        &nbsp;
      </div>
      <xsl:text disable-output-escaping="yes"><![CDATA[<div class="clearer"></div>]]></xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="listItems" >
    <xsl:param name="parent"/>
    <xsl:param name="remainder"/>
    
    <xsl:for-each select="$parent/node [string(./data [@alias='umbracoNaviHide']) != '1' and @level &lt;= $maxLevelForMenu]">
      <xsl:if test="position() mod 2 = $remainder">
        <div class="pageSummaryComp">
          <a href="{umbraco.library:NiceUrl(@id)}">
            <xsl:value-of select="@nodeName"/>
          </a>
          <p>
            <!-- Draw more.. -->
            <xsl:value-of select="data [@alias = 'synopsis']"/>
            
            <xsl:if test="string(data [@alias='displayChildren']) = '1'">
              <br/>
              <xsl:call-template name="listChildren">
                <xsl:with-param name="parent" select="."/>
              </xsl:call-template>
            </xsl:if>

          </p>
        </div>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="listChildren" >
    <xsl:param name="parent"/>
    <xsl:for-each select="$parent/node [string(./data [@alias='umbracoNaviHide']) != '1' and @level &lt;= $maxLevelForMenu]">      
        <a href="{umbraco.library:NiceUrl(@id)}">
          <xsl:value-of select="@nodeName"/>
        </a><xsl:if test="position() &lt; count($parent/node [string(./data [@alias='umbracoNaviHide']) != '1' and @level &lt;= $maxLevelForMenu])">,</xsl:if>
    </xsl:for-each>
  </xsl:template>



</xsl:stylesheet>