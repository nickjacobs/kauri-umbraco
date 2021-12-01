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

    <!-- Grab our values from the macro parameters -->
    <xsl:param name="dateFormat" select="/macro/dateFormat" />
    <xsl:param name="propertyAlias" select="/macro/propertyAlias" />

    <xsl:template match="/">

        <!--
        =============================================================
        Output the value of the date using the .NET XSLT extension
        umbraco.library to help us format it to the 
        date format we want, from the variable we passed in from the
        macro thats on the Masterpage.                
        =============================================================
        -->

        <xsl:choose>
            <xsl:when test="$currentPage/data [@alias = $propertyAlias] != ''">
                <xsl:value-of select="umbraco.library:FormatDateTime($currentPage/data [@alias = $propertyAlias], $dateFormat)"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="umbraco.library:FormatDateTime($currentPage/@createDate, $dateFormat)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>