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
        =====================================================
        We need to build up a URL to our email-a-friend page        
        =====================================================
        -->
        <xsl:variable name="currentPageID" select="$currentPage/@id" />
        <xsl:variable name="link" select="concat('/email-a-friend/', $currentPageID,'.aspx')"/>

        <a href="{$link}" class="rightArrow left">
            Email this page to a friend
        </a>

    </xsl:template>

</xsl:stylesheet>