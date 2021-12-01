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

<xsl:variable name="level" select="1"/>

<xsl:template match="/">
<script type="text/javascript">

<xsl:text disable-output-escaping="yes">&lt;!--//--&gt;&lt;![CDATA[//&gt;&lt;!--

startList = function() {
	if (document.all&amp;&amp;document.getElementById) {
		navRoot = document.getElementById(&quot;nav&quot;)
		for (i=0; i&lt;navRoot.childNodes.length; i++) {
			node = navRoot.childNodes[i];
			if (node.nodeName==&quot;LI&quot;) {
				node.onmouseover=function() {
					this.className+=&quot; over&quot;;
				}
				node.onmouseout=function() {
					this.className=this.className.replace(&quot; over&quot;, &quot;&quot;);
				}
			}
		}
	}
}
window.onload=startList;

//--&gt;&lt;!]]&gt;</xsl:text>
</script>
	<xsl:call-template name="printListe">
		<xsl:with-param name="node" select="$currentPage/ancestor-or-self::node [@level = 1]"/>	
		<xsl:with-param name="id" select="string('nav')"/>	
	</xsl:call-template>
</xsl:template>

<xsl:template name="printListe">
	<xsl:param name="node"/>
	<xsl:param name="id"/>
<ul>
<xsl:if test="$id != ''">
<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
</xsl:if>
<xsl:for-each select="$node/node [@nodeTypeAlias != 'wwNewsItem']">
<li>
	<xsl:if test="$currentPage/ancestor-or-self::node/@id = current()/@id">
		<xsl:attribute name="class">current</xsl:attribute>
	</xsl:if>
	<div>
	<a href="{umbraco.library:NiceUrl(@id)}"><xsl:value-of select="@nodeName"/></a>
	</div>
	<xsl:if test="count(./node) &gt; 0">
		<xsl:call-template name="printListe">
			<xsl:with-param name="node" select="."/>
		</xsl:call-template>
	</xsl:if>
</li>
</xsl:for-each>
</ul>
</xsl:template>
</xsl:stylesheet>