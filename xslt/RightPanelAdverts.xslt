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
    <xsl:variable name="advertNode" select="umbraco.library:GetXmlNodeById(1319)"/> 
    <xsl:template match="/">
        <div class="tipContainer">
            <h3>
                <xsl:value-of select="$advertNode/data[@alias='title']" disable-output-escaping="yes"/>
            </h3>        
                <xsl:for-each select="$advertNode/node">
                    <xsl:call-template name="listItems">
                        <xsl:with-param name="parent" select="." />
                    </xsl:call-template>
                </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template name="listItems">
        <xsl:param name="parent"/>
        <xsl:if test="./data[@alias='image']"> 
            <img title="{./data[@alias='title']}" alt="{./data[@alias='title']}" src="/handlers/imageStream.ashx?side=1&amp;maxSide=284&amp;path={umbraco.library:GetMedia(./data[@alias='image'], 'false')/data [@alias='umbracoFile']}" width="284" />
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>