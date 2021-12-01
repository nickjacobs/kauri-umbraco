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
  <xsl:param name="parentId" select="/macro/parentId" />
  <xsl:param name="maxResults" select="/macro/maxResults" />
  <xsl:param name="currentPage"/>

  <xsl:template match="/">


    
    <xsl:variable name="parent" select="umbraco.library:GetXmlNodeById($parentId)" />
    <xsl:if test="umbraco.library:IsProtected(number($parent/@id), $parent/@path) = 0 or (umbraco.library:IsProtected(number($parent/@id), $parent/@path) = 1 and umbraco.library:IsLoggedOn() = 1)">      

        <xsl:call-template name="listItems">
          <xsl:with-param
           name="parent"
           select="$parent"
          />
        </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="listItems" >
    <xsl:param name="parent"/>

    <xsl:for-each select="$parent/node [string(data [@alias='umbracoNaviHide']) != '1']">
      <xsl:if test="position() &lt;= $maxResults" >
          <a href="{umbraco.library:NiceUrl(@id)}">
            <xsl:value-of select="@nodeName"/>
          </a><br/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>