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

        <xsl:variable name="parentNode" select="$currentPage/.."/>

        <a class="leftArrow backLink" href="{umbraco.library:NiceUrl($parentNode/@id)}">
            <xsl:value-of select="$parentNode/@nodeName"/>
        </a>

    </xsl:template>

</xsl:stylesheet>