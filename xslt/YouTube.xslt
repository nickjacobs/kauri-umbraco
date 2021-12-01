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
    xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" 
    xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" 
    xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" 
    xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" 
    xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" 
    xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
    xmlns:c4u="urn:c4u" 
    xmlns:tagsLib="urn:tagsLib" 
    xmlns:BlogLibrary="urn:BlogLibrary" 
    xmlns:BlogList="urn:BlogList"
    xmlns:KKSClasses.YouTube="urn:KKSClasses.YouTube"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets c4u tagsLib BlogLibrary BlogList customfunctionlib KKSClasses.YouTube">
    <xsl:output method="html" omit-xml-declaration="yes"/>
    <xsl:param name="currentPage"/>
    <xsl:template match="/">
        <xsl:if test="$currentPage/data[@alias='youTubeVideoURL'] != ''">
            <object style="margin-top:15px; margin-bottom:15px;" width="560" height="450">                
                <param name="movie" value="{KKSClasses.YouTube:GetYouTubeURL($currentPage/data [@alias='youTubeVideoURL'])}"></param>
                <param name="allowFullScreen" value="true"></param>
                <embed src="{KKSClasses.YouTube:GetYouTubeURL($currentPage/data [@alias='youTubeVideoURL'])}" type="application/x-shockwave-flash" allowfullscreen="true" width="560" height="450">                    
                </embed>
            </object>
        </xsl:if>   
    </xsl:template>
</xsl:stylesheet>