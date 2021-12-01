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
    <xsl:variable name="level" select="1"/>
    <xsl:template match="/">
        <div class="sideNav">
        <xsl:for-each select="$currentPage/node[@nodeTypeAlias='PageBlock']">            
                <xsl:call-template name="listItems">
                    <xsl:with-param name="parent" select="." />
                </xsl:call-template>           
        </xsl:for-each>
            <xsl:text> </xsl:text>
        </div>
    </xsl:template>  
    <xsl:template name="listItems">
        <xsl:param name="parent"/>
        <xsl:if test="$parent/@id !=''">
            <a href="#{./@id}">
                <xsl:value-of select="./data[@alias='title']" disable-output-escaping="yes"/>
            </a>   
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>