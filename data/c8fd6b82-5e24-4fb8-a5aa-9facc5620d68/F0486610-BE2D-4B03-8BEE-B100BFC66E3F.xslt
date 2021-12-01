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
<xsl:variable name="numberOfItems" select="/macro/numberOfItems"/>

<xsl:template match="/">

<!-- The fun starts here -->
<xsl:for-each select="$currentPage/ancestor-or-self::node[@level=1]/descendant::node [@nodeTypeAlias = 'wwNews']/node">
<xsl:sort select="@createDate" order="descending"/>
<xsl:if test="position() &lt;= $numberOfItems">
<p class="newsDate"><xsl:value-of select="umbraco.library:LongDate(@createDate)"/>:</p>
		<h2><a title="Read news item: {@nodeName}" href="{umbraco.library:NiceUrl(@id)}"><xsl:value-of select="@nodeName"/></a></h2>
<p class="newsResume">
<xsl:value-of select="./data [@alias = 'teaser']" disable-output-escaping="yes"/>
</p>
</xsl:if>
</xsl:for-each>


</xsl:template>

</xsl:stylesheet>