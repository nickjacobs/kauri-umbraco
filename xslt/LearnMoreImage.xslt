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
        <xsl:if test="$currentPage/data[@alias='mapImage']!=''">
            <xsl:choose>
                <xsl:when test="$currentPage/data[@alias='mapLink'] !='' and $currentPage/data[@alias='mapImage'] !=''">
                    <a href="{umbraco.library:NiceUrl($currentPage/data[@alias='mapLink'])}" class="btnLearnMore">                      
                        <img src="/handlers/imageStream.ashx?side=1&amp;maxSide=218&amp;path={umbraco.library:GetMedia($currentPage/data[@alias='mapImage'], 'false')/data [@alias='umbracoFile']}" />
                        <span>
                            <xsl:text> </xsl:text>
                        </span>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$currentPage/data[@alias='mapImage'] !=''">
                        <a href="#" class="noLink">                           
                            <img src="/handlers/imageStream.ashx?side=1&amp;maxSide=218&amp;path={umbraco.library:GetMedia($currentPage/data[@alias='mapImage'], 'false')/data [@alias='umbracoFile']}" />
                            <span>
                                <xsl:text> </xsl:text>
                            </span>
                        </a>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>            
         </xsl:if>
    </xsl:template>
</xsl:stylesheet>