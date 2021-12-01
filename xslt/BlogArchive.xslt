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
  xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:BlogLibrary="urn:BlogLibrary" xmlns:BlogList="urn:BlogList" xmlns:BlogTags="urn:BlogTags" xmlns:BKA.UmbracoHelper.MenuHelper="urn:BKA.UmbracoHelper.MenuHelper"
	exclude-result-prefixes="msxml umbraco.library customfunctionlib Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets BlogLibrary BlogList BlogTags BKA.UmbracoHelper.MenuHelper ">


  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:param name="currentPage"/>

  <xsl:template match="/">
    <a href="#"><span>ARCHIVE</span></a>    

      <xsl:variable name="rootBlogNode" select="$currentPage/ancestor-or-self::node[@level = 2]"></xsl:variable>
      <xsl:for-each select="$rootBlogNode/node">
          <xsl:variable name="curYear" select="@nodeName"></xsl:variable>
        <xsl:if test="@nodeTypeAlias='DateFolder'">
          <a href="#" class="mediaLeftLink" onclick="showSubNav('leftSubNav-{$curYear}');">
            <xsl:if test="$currentPage/ancestor-or-self::node/@id = current()/@id">
              <xsl:attribute name="class">
                <xsl:text>active mediaLeftLink</xsl:text>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$curYear"/>
          </a>
          <div id="leftSubNav-{$curYear}" style="display:none;" class="leftSubNav">
              <div class="leftSubSubNav">
            <xsl:for-each select="./node">
              <xsl:if test="count(.//node [@nodeTypeAlias = 'BlogPost']) > 0">
                <a href="{umbraco.library:NiceUrl(./@id)}">
                  <xsl:if test="$currentPage/ancestor-or-self::node/@id = current()/@id">
                    <xsl:attribute name="class">
                      <xsl:text>active</xsl:text>
                    </xsl:attribute>
                  </xsl:if>
                    <span>
                  <xsl:call-template name="monthName">
                    <xsl:with-param name="month" select="@nodeName" />
                  </xsl:call-template>
                    </span>
                </a>
              </xsl:if>
            </xsl:for-each>
            
                  <xsl:value-of select="' '"/>
              </div>
          </div>
        </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="' '"/>

  </xsl:template>

  <xsl:template name="monthName" >
    <xsl:param name="month"/>
    <xsl:choose>
      <xsl:when test="$month='1'">January</xsl:when>
      <xsl:when test="$month='2'">February</xsl:when>
      <xsl:when test="$month='3'">March</xsl:when>
      <xsl:when test="$month='4'">April</xsl:when>
      <xsl:when test="$month='5'">May</xsl:when>
      <xsl:when test="$month='6'">June</xsl:when>
      <xsl:when test="$month='7'">July</xsl:when>
      <xsl:when test="$month='8'">August</xsl:when>
      <xsl:when test="$month='9'">September</xsl:when>
      <xsl:when test="$month='10'">October</xsl:when>
      <xsl:when test="$month='11'">November</xsl:when>
      <xsl:when test="$month='12'">December</xsl:when>
    </xsl:choose>
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
    public static string AppSettings(string key)
    {
        return System.Configuration.ConfigurationManager.AppSettings[key];
    }
    ]]>
  </msxml:script>
</xsl:stylesheet>