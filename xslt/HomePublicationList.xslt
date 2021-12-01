<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
  xmlns:customfunctionlib="urn:customfunctionlib"
  xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:c4u="urn:c4u" xmlns:tagsLib="urn:tagsLib" xmlns:BlogLibrary="urn:BlogLibrary" xmlns:BlogList="urn:BlogList"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets c4u tagsLib BlogLibrary BlogList customfunctionlib">
    <xsl:output method="html" omit-xml-declaration="yes"/>
    <xsl:param name="currentPage"/>
    
    <xsl:template match="/"> 
        <xsl:if test="$currentPage/data[@alias='recentPublications']!=''">
        <h4>Latest publications</h4>
        <xsl:for-each select="umbraco.library:Split($currentPage/data[@alias='recentPublications'], ',')/value">  
              <xsl:variable name="selectedNode" select="umbraco.library:GetXmlNodeById(.)"/>
            <a class="linkItem" target="_Blank" href="{umbraco.library:GetMedia($selectedNode/data[@alias='publication'], 'false')/data [@alias='umbracoFile']}">
                    <span>
                      <xsl:value-of select="$selectedNode/data[@alias='title']" disable-output-escaping="yes" />
                    </span>
                    <xsl:value-of select="umbraco.library:StripHtml(substring($selectedNode/data[@alias='synopsis'], 0, 80))" />
                </a>                
        </xsl:for-each>
        </xsl:if>        
    </xsl:template> 
</xsl:stylesheet>