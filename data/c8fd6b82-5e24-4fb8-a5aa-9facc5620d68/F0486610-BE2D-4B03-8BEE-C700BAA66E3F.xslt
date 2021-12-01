<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:Stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	exclude-result-prefixes="msxml umbraco.library">


<xsl:output method="xml" omit-xml-declaration="yes" />

<xsl:param name="currentPage"/>

<xsl:variable name="level" select="2"/>

<xsl:template match="/">

<xsl:if test="count($currentPage/ancestor-or-self::node [@level=$level]/node [string(data [@alias='umbracoNaviHide']) != '1']) &gt; 0">
<ul id="secondLevelNavigation">
<xsl:for-each select="$currentPage/ancestor-or-self::node [@level=$level]/node [string(data [@alias='umbracoNaviHide']) != '1']">
	<li>
		<a href="{umbraco.library:NiceUrl(@id)}" title="Go to {@nodeName}">
			<xsl:if test="$currentPage/ancestor-or-self::node/@id = current()/@id">
				<!-- we're under the item - you can do your own styling here -->
				<xsl:attribute name="class">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="@nodeName"/>
		</a>
	</li>
</xsl:for-each>
</ul>
</xsl:if>
</xsl:template>

</xsl:stylesheet>