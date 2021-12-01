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
        <div class="publicationLinks">
            <xsl:for-each select="$currentPage/node">
                <h3>
                    <xsl:value-of select="./data[@alias='title']" disable-output-escaping="yes" />
                </h3>               
                <xsl:call-template name="listItems">
                    <xsl:with-param name="parent" select="."  />
                </xsl:call-template>
            </xsl:for-each>
        </div>
    </xsl:template>    
        
    <xsl:template name="listItems" >
        <xsl:param name="parent"/>
        <xsl:for-each select="$parent/node">
            <xsl:if test="./data[@alias='publication']!=''"> 
                            <xsl:choose>
                                <xsl:when test="./data[@alias='isSecure'] = '1'">
                                    <a class="secure"  href="#" onclick="return false;" title="{umbraco.library:GetMedia(./data[@alias='publication'], 'false')/data [@alias='umbracoFile']}">
                                        <xsl:value-of select="./data[@alias='title']" disable-output-escaping="yes" />
                                    </a>
                                </xsl:when>
                            <xsl:otherwise>
                                <a target="_blank" class="nonSecure" href="{umbraco.library:GetMedia(./data[@alias='publication'], 'false')/data [@alias='umbracoFile']}" title="{umbraco.library:GetMedia(./data[@alias='publication'], 'false')/data [@alias='umbracoFile']}">
                                    <xsl:value-of select="./data[@alias='title']" disable-output-escaping="yes" />
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
