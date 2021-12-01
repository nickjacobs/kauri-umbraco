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
    <xsl:variable name="resultsPerPage" select="2"/>
    <xsl:variable name="pageNumber">
        1
    </xsl:variable>
    <xsl:template match="/">
        <xsl:call-template name="renderArticles">
            <xsl:with-param name="nodeSet" select="BlogList:GetBlogList($currentPage//node [@nodeTypeAlias = 'BlogPost'], $resultsPerPage, $pageNumber, 'dd MMMM yyyy')" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="renderArticles">
        <xsl:param name="nodeSet"></xsl:param>
        <xsl:variable name="blogOptions" select="$currentPage/ancestor-or-self::node [@level = 2]"></xsl:variable>
        <xsl:variable name="enableComments" select="string($blogOptions/data[@alias='commentsEnabled'])"/>
        <h4>Events</h4>
        <xsl:for-each select="$nodeSet/articles/article">
            <xsl:if test="position() &lt; 3">
                <a class="linkItem" href="{./url}">
                    <span>
                        <xsl:value-of select="./title" disable-output-escaping="yes" />
                    </span>
                    <xsl:value-of select="umbraco.library:StripHtml(substring(./introText, 0, 98))" />
                </a>
            </xsl:if>
            </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>