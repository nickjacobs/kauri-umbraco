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

        <!--
        ============================================================
        If the current node property PhotoText is NOT empty then
        we display a span with the PhotoText property in.
        ============================================================
        -->
        <xsl:if test="$currentPage/data [@alias ='photoText'] != ''">
            <span>
                <xsl:value-of select="$currentPage/data [@alias ='photoText']"/>
            </span>
        </xsl:if>


    </xsl:template>

</xsl:stylesheet>