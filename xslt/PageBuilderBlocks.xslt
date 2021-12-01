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
        <xsl:for-each select="$currentPage/node[@nodeTypeAlias='PageBlock']">          
                <xsl:call-template name="listItems">
                    <xsl:with-param name="parent" select="." />
                </xsl:call-template>          
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="listItems">
        <xsl:param name="parent"/>
        <xsl:if test="./data[@alias='title']">
           <h3 id="{./@id}">
               <xsl:value-of select="./data[@alias='title']" disable-output-escaping="yes"/>
           </h3>
            <xsl:value-of select="./data[@alias='bodyText']" disable-output-escaping="yes"/>   
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>