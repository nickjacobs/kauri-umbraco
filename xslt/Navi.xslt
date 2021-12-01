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
  <xsl:output method="xml" omit-xml-declaration="yes" />
  <xsl:param name="currentPage"/>
  <xsl:variable name="homeNode" select="umbraco.library:GetXmlNodeById(1244)"/>
    <!-- Input the documenttype you want here -->
  <xsl:variable name="level" select="1"/>
  <xsl:variable name="currentId" select="$currentPage/@id"/>
  <xsl:template match="/">
      <a href="/">Home</a>
      <xsl:for-each select="$homeNode/ancestor-or-self::node [@level=$level]/node [string(data [@alias='umbracoNaviHide']) != '1']">       
        <xsl:choose>
          <xsl:when test="$currentPage/ancestor-or-self::node/@id = current()/@id">
            <a href="{umbraco.library:NiceUrl(@id)}" class="active">
              <xsl:value-of select="@nodeName"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{umbraco.library:NiceUrl(@id)}">
              <xsl:value-of select="@nodeName"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>