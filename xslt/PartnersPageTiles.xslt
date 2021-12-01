﻿<?xml version="1.0" encoding="UTF-8"?>
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
    <xsl:variable name="managenentTeam" select="umbraco.library:GetXmlNodeById(1359)"/>

    <xsl:template match="/">
        <div class="partnerTiles">    
            <xsl:for-each select="$managenentTeam/node">                
                <xsl:call-template name="listItems">
                    <xsl:with-param name="parent" select="."  />
                </xsl:call-template>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template name="listItems" >
        <xsl:param name="parent"/>                  
                <xsl:choose>
                    <xsl:when test="$parent/data[@alias='linkUrl'] !='' and $parent/data[@alias='logo']!=''">
                        <a href="{$parent/data[@alias='linkUrl']}" target="_Blank">
                            <xsl:value-of select="$parent/data[@alias='title']" disable-output-escaping="yes" />
                            <img src="/handlers/imageStream.ashx?side=1&amp;maxSide=127&amp;path={umbraco.library:GetMedia($parent/data[@alias='logo'], 'false')/data [@alias='umbracoFile']}" />
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="$parent/data[@alias='logo']!=''">
                        <a href="#" class="noLink">
                            <xsl:value-of select="$parent/data[@alias='title']" disable-output-escaping="yes" />
                            <img src="/handlers/imageStream.ashx?side=1&amp;maxSide=127&amp;path={umbraco.library:GetMedia($parent/data[@alias='logo'], 'false')/data [@alias='umbracoFile']}" />
                        </a>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>    
    </xsl:template>
</xsl:stylesheet>
