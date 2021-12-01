<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:Stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
 version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:msxml="urn:schemas-microsoft-com:xslt" xmlns:umbraco.library="urn:umbraco.library" 
exclude-result-prefixes="msxml 
umbraco.library">

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:variable name="minLevel" select="0"/>

<xsl:template match="/">

<xsl:if test="$currentPage/@level &gt; $minLevel">
	<ul id="umbBreadcrum">
	<xsl:for-each select="$currentPage/ancestor::node [@level &gt; $minLevel and string(data [@alias='umbracoNaviHide']) != '1']">
		<li>
			<a href="{umbraco.library:NiceUrl(@id)}" title="@nodeName">
				<xsl:value-of select="@nodeName"/>
			</a>&nbsp; <xsl:text disable-output-escaping="yes">&amp;rsaquo;</xsl:text>
		</li>
	</xsl:for-each>
	<!-- print currentpage -->
	<li><xsl:value-of select="$currentPage/@nodeName"/></li>
	</ul>
</xsl:if>
</xsl:template>
</xsl:stylesheet>