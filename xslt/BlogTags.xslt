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
  xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:BlogLibrary="urn:BlogLibrary" xmlns:BlogList="urn:BlogList" xmlns:BlogTags="urn:BlogTags"
	exclude-result-prefixes="msxml umbraco.library customfunctionlib Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets BlogLibrary BlogList BlogTags ">


  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:param name="currentPage"/>

  <xsl:template match="/">    
      <a href="{umbraco.library:NiceUrl(customfunctionlib:AppSettings('Blog.RootId'))}">
        <xsl:if test="umbraco.library:RequestQueryString('tag') &lt;= 0 or string(umbraco.library:RequestQueryString('tag')) = '' or string(umbraco.library:RequestQueryString('tag')) = 'NaN'">
          <xsl:attribute name="class">active</xsl:attribute>
        </xsl:if>
        Latest Articles
      </a>      
      <xsl:variable name="currentTag">
        <xsl:choose>
          <xsl:when test="umbraco.library:RequestQueryString('tag') &lt;= 0 or string(umbraco.library:RequestQueryString('tag')) = '' or string(umbraco.library:RequestQueryString('tag')) = 'NaN'">
            <xsl:value-of select="' '"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="umbraco.library:RequestQueryString('tag')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="umbraco.library:GetXmlNodeById(customfunctionlib:AppSettings('Blog.RootId'))/node[@nodeTypeAlias='BlogTagContainer']/node[@nodeTypeAlias='BlogTag']">
        <xsl:if test="BlogTags:BlogsContainTag(@id)">          
                <a href="{umbraco.library:NiceUrl(customfunctionlib:AppSettings('Blog.RootId'))}?tag={@id}">
                    <xsl:if test="$currentTag=@id">
                        <xsl:attribute name="class">active</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="@nodeName"/>
                </a>           
        </xsl:if>
      </xsl:for-each>

      <xsl:value-of select="' '"/>
    

  </xsl:template>
  <msxml:script implements-prefix="customfunctionlib" language="C#">
    <msxml:assembly name="System.Web"/>
    <msxml:assembly name="System.Configuration"/>
    <msxml:assembly name="umbraco"/>
    <msxml:assembly name="cms"/>
    <msxml:assembly name="businesslogic"/>
    <msxml:using namespace="System.Web"/>
    <msxml:using namespace="umbraco.cms.businesslogic.web"/>
    <![CDATA[
    public static string AppSettings(string key){
        return System.Configuration.ConfigurationManager.AppSettings[key];
    }
    ]]>
  </msxml:script>
</xsl:stylesheet>