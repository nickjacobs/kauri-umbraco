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

    <xsl:template match="/">

        <ul id="navi">

            <xsl:variable name="rootNode" select="$currentPage/ancestor-or-self::node [@level=1]" />
            
            <li>
                <!--
                    Add the class selected if the root node ID matches our 
                    current node ID in the for each loop
                    -->
                <xsl:if test="$rootNode/@id = $currentPage/@id">
                    <xsl:attribute name="class">
                        <xsl:text>
                            selected
                        </xsl:text>
                    </xsl:attribute>
                </xsl:if>
                
                <a href="{umbraco.library:NiceUrl($rootNode/@id)}">
                    <xsl:value-of select="$rootNode/@nodeName" />
                </a>
            </li>
            
            <xsl:for-each select="$currentPage/ancestor-or-self::node/node [@level = 2 and string(data[@alias='umbracoNaviHide']) != '1']">
                <li>
                    <!--
                    Add the class selected if the currentpage or parent nodes (up the tree to the root) 
                    ID matches our current node ID in the for each loop
                    -->
                    <xsl:if test="$currentPage/ancestor-or-self::node/@id = current()/@id">
                        <xsl:attribute name="class">
                            <xsl:text>
                                selected
                            </xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <a href="{umbraco.library:NiceUrl(@id)}">
                        <xsl:value-of select="@nodeName" />
                    </a>
                </li>
            </xsl:for-each>
        </ul>

    </xsl:template>

</xsl:stylesheet>