<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
  xmlns:BlogLibrary="urn:BlogLibrary"
  xmlns:BlogList="urn:BlogList"
  xmlns:BlogTags="urn:BlogTags"
	xmlns:tagsLib="urn:tagsLib"
	xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings"
	exclude-result-prefixes="msxml umbraco.library tagsLib Exslt.ExsltStrings BlogLibrary BlogList BlogTags">


    <xsl:output method="html" omit-xml-declaration="yes"/>

    <xsl:param name="currentPage"/>
    <xsl:variable name="resultsPerPage" select="10"/>

    <xsl:variable name="pageNumber">
        <xsl:choose>
            <xsl:when test="umbraco.library:RequestQueryString('page') &lt;= 0 or string(umbraco.library:RequestQueryString('page')) = '' or string(umbraco.library:RequestQueryString('page')) = 'NaN'">1</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="umbraco.library:RequestQueryString('page')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$currentPage/@nodeTypeAlias = 'DateFolder'">
                <xsl:variable name="parent" select="umbraco.library:GetXmlNodeById($currentPage/@parentID)"></xsl:variable>                
                <xsl:choose>
                    <xsl:when test="$parent/@nodeTypeAlias = 'DateFolder'">
                        <xsl:call-template name="renderArticles">
                            <xsl:with-param name="nodeSet" select="BlogList:GetBlogListMonth($currentPage//node [@nodeTypeAlias = 'BlogPost'], $resultsPerPage, $pageNumber, $currentPage/@nodeName, $parent/@nodeName, 'dd MMMM yyyy')"/>
                        </xsl:call-template>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="renderArticles">
                            <xsl:with-param name="nodeSet" select="BlogList:GetBlogListYear($currentPage//node [@nodeTypeAlias = 'BlogPost'], $resultsPerPage, $pageNumber, $currentPage/@nodeName, 'dd MMMM yyyy')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="umbraco.library:RequestQueryString('tag') != ''">
                <xsl:call-template name="renderArticles">
                    <xsl:with-param name="nodeSet" select="BlogList:GetBlogListTag($currentPage//node [@nodeTypeAlias = 'BlogPost'], $resultsPerPage, $pageNumber, umbraco.library:RequestQueryString('tag'), 'dd MMMM yyyy')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="umbraco.library:RequestQueryString('author') != ''">
                <xsl:call-template name="renderArticles">
                    <xsl:with-param name="nodeSet" select="BlogList:GetBlogListAuthor($currentPage//node [@nodeTypeAlias = 'BlogPost'], $resultsPerPage, $pageNumber, umbraco.library:RequestQueryString('author'), 'dd MMMM yyyy')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="renderArticles">
                    <xsl:with-param name="nodeSet" select="BlogList:GetBlogList($currentPage//node [@nodeTypeAlias = 'BlogPost'], $resultsPerPage, $pageNumber, 'dd MMMM yyyy')" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="renderArticles">
        <xsl:param name="nodeSet"></xsl:param>
        <xsl:variable name="blogOptions" select="$currentPage/ancestor-or-self::node [@level = 2]"></xsl:variable>
        <xsl:variable name="enableComments" select="string($blogOptions/data[@alias='commentsEnabled'])"/>
        <xsl:for-each select="$nodeSet/articles/article">
            <div class="eventLink">
                <xsl:if test="./image!=''">
                    <img title="{./title}" alt="{./title}" src="/handlers/imageStream.ashx?side=2&amp;maxSide=128&amp;cropHeight=10&amp;path={./image}" />
                </xsl:if>                
                <a href="{./url}">
                    <h3>              
                            <xsl:value-of select="./title"/>               
                    </h3>
                </a>
                <h5>                      
                   <xsl:value-of select="./date"/>
                </h5>   
                <p><xsl:value-of select="./introText"/>...
                    <a href="{./url}">more</a>
                </p>   
            </div>        
        </xsl:for-each>
        <div class="pagingAltSurr">
            <xsl:value-of select="$nodeSet/articles/paging" disable-output-escaping="yes"/>
        </div>
    </xsl:template>
</xsl:stylesheet>