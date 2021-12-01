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
        <h4>Quick links</h4>

        
        <xsl:for-each select="umbraco.library:Split($currentPage/data[@alias='quickLinks'], ',')/value">
        <xsl:variable name="LinkNode" select="umbraco.library:GetXmlNodeById(.)"/>   
            <a href="{umbraco.library:NiceUrl($LinkNode/@id)}">
                <xsl:value-of select="$LinkNode/data[@alias='title']" disable-output-escaping="yes" />
            </a>
        </xsl:for-each>
    </xsl:template>     
</xsl:stylesheet>




