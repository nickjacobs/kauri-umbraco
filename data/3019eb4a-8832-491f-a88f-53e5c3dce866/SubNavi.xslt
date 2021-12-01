<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	exclude-result-prefixes="msxml umbraco.library">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

    <xsl:variable name="rootTextpageNode" select="$currentPage/ancestor-or-self::node [@level = 2 and @nodeTypeAlias = 'CWS_Textpage']" />

    <div class="secondaryNav">
        <h3>
            <xsl:value-of select="$rootTextpageNode/@nodeName"/>
        </h3>
        
        <ul>
            <xsl:for-each select="$rootTextpageNode/node">
                <li>
                    <xsl:if test="$currentPage/ancestor-or-self::node/@id = current()/@id">
                        <xsl:attribute name="class">
                            <xsl:text>selected</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <a href="{umbraco.library:NiceUrl(current()/@id)}">
                        <span>
                            <xsl:value-of select="current()/@nodeName"/>
                        </span>
                    </a>
                </li>
            </xsl:for-each>       
        </ul>
    </div>

</xsl:template>

</xsl:stylesheet>