<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:Stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	exclude-result-prefixes="msxml umbraco.library">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">
<ul id="naviList">
<xsl:for-each select="$currentPage/ancestor-or-self::node [@level=1]/node">
<li>
<xsl:if test="$currentPage/ancestor-or-self::node/@id = current()/@id">
	<xsl:attribute name="class">selected</xsl:attribute>
</xsl:if>
<a href="{umbraco.library:NiceUrl(@id)}" title="Go to {@nodeName}"><xsl:value-of select="@nodeName"/></a>
</li>
</xsl:for-each>
</ul>
</xsl:template>

</xsl:stylesheet>