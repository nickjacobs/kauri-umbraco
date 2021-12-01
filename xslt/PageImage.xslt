<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:msxml="urn:schemas-microsoft-com:xslt" xmlns:umbraco.library="urn:umbraco.library"
exclude-result-prefixes="msxml 
umbraco.library">
    <xsl:output method="xml" omit-xml-declaration="yes"/>
    <xsl:param name="currentPage"/>
    <xsl:template match="/">
        <xsl:if test="$currentPage/data[@alias='image']!=''">
            <img src="/handlers/imageStream.ashx?side=1&amp;maxSide=540&amp;path={umbraco.library:GetMedia($currentPage/data[@alias='image'], 'false')/data [@alias='umbracoFile']}" class="imgInContent"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>