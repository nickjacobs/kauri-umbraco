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

    <xsl:variable name="propertyAlias" select="/macro/propertyAlias" />
    <xsl:variable name="altText" select="/macro/altText" />

    <xsl:param name="currentPage"/>

    <xsl:template match="/">

        <xsl:variable name="altTextValue">
            <xsl:choose>
                <xsl:when test="$altText != ''">
                    <xsl:value-of select="$altText"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$currentPage/@nodeName"/>                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    

        <xsl:if test="$currentPage/data [@alias = $propertyAlias] != ''">
            <img src="{$currentPage/data [@alias = $propertyAlias]}" alt="{$altTextValue}"/>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>