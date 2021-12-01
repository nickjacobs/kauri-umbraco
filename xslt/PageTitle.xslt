<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
 version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:msxml="urn:schemas-microsoft-com:xslt" xmlns:umbraco.library="urn:umbraco.library" 
exclude-result-prefixes="msxml 
umbraco.library">

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:variable name="minLevel" select="1"/>

<xsl:template match="/">

  <xsl:choose>
    <xsl:when test="string($currentPage/data [@alias='SEOTitle']) !='' ">
      <xsl:value-of select="string($currentPage/data [@alias='SEOTitle']) "/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$currentPage/ancestor-or-self::node [@level=1]/data [@alias='siteName']"/>
      <xsl:if test="$currentPage/@level &gt; $minLevel">
        <xsl:text> - </xsl:text>
        <xsl:value-of select="$currentPage/@nodeName"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  

</xsl:template>
</xsl:stylesheet>