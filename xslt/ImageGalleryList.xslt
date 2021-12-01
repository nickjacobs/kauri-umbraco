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
    <xsl:template match="/">
        <h1>
            <xsl:value-of select="$currentPage/data[@alias='title']" disable-output-escaping="yes" />
        </h1>
        <div class="col w560 mr40">
            <h2>
                <xsl:value-of select="$currentPage/data[@alias='synopsis']" disable-output-escaping="yes" />
            </h2>
            <div id="galleria">
                <xsl:for-each select="$currentPage/node"> 
                        <a href="#">                                      
                           <img alt="{./data[@alias='title']}" src="/handlers/imageStream.ashx?side=1&amp;maxSide=560&amp;path={umbraco.library:GetMedia(./data[@alias='image'], 'false')/data [@alias='umbracoFile']}"/>
                       </a>
                </xsl:for-each>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>