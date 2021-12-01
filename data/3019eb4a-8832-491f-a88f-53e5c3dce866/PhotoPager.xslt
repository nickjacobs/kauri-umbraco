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

    <!--
    =========================================================================
    Changed ouput from XML to html. As if we are only have 1 photo in 
    gallery, there would be no pagination and create bad markup 
    which breaks the design.
    
    eg:
    <div class="pager clearfix"/>
    =========================================================================
    -->
    <xsl:output method="html" omit-xml-declaration="yes"/>

    <xsl:param name="currentPage"/>

    <xsl:template match="/">

        <xsl:variable name="Previous" select="$currentPage/preceding-sibling::node[1]/@id"/>
        <xsl:variable name="Next" select="$currentPage/following-sibling::node/@id"/>

        <div class="pager clearfix">
            <xsl:if test="count($currentPage/preceding-sibling::node) > 0">
                <a href="{umbraco.library:NiceUrl($Previous)}" class="left prev">
                    Previous
                </a>
            </xsl:if>
            
            <xsl:if test="count($currentPage/following-sibling::node) > 0">
                <a href="{umbraco.library:NiceUrl($Next)}" class="right next">
                    Next
                </a>
            </xsl:if>
        </div>

    </xsl:template>

</xsl:stylesheet>