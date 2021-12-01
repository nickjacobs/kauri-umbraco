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

  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:param name="currentPage"/>
  <xsl:template match="/">      
      <xsl:variable name="author">
          <xsl:choose>
              <xsl:when test="$currentPage/data[@alias='authorTextOverride'] != ''"><xsl:value-of select="$currentPage/data[@alias='authorTextOverride']"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="umbraco.library:GetXmlNodeById($currentPage/data[@alias='Author'])/@nodeName"/></xsl:otherwise>
          </xsl:choose>
      </xsl:variable>

      <h3>
          <xsl:value-of select="$currentPage/data[@alias='subTitle']"/>
      </h3>    
      <h5>
        <!--POSTED BY: <span><strong><xsl:value-of select="$author"/></strong></span>
        &nbsp;&nbsp;&nbsp;&nbsp;ON: <span><strong>-->
            <xsl:value-of select="customfunctionlib:GetDateTime($currentPage/data[@alias='Date'])"/>
      </h5>
      <p>
        <span class="introText">
          <xsl:value-of select="$currentPage/data[@alias='IntroText']"/>
        </span>
      </p>
      <xsl:value-of select="$currentPage/data[@alias='bodyText']" disable-output-escaping="yes"/>
  </xsl:template>
  <msxml:script implements-prefix="customfunctionlib" language="C#">
    <msxml:assembly name="System.Web"/>
    <msxml:assembly name="umbraco"/>
    <msxml:assembly name="cms"/>
    <msxml:assembly name="businesslogic"/>
    <msxml:using namespace="System.Web"/>
    <msxml:using namespace="umbraco.cms.businesslogic.web"/>
    <![CDATA[
    public static string GetDateTime(DateTime dt)
    {
        return dt.ToString("d MMMM yyyy");
    }
    public static string IncrementViewCount(int nodeID)
    {
        Document document = new Document(nodeID);
        int numViews = 0;
        int.TryParse(document.getProperty("NumViews").Value.ToString(), out numViews);
        numViews ++;
        document.getProperty("NumViews").Value = numViews.ToString();
        document.Save();
        
        //return numViews.ToString();
        return "";
    }
    ]]>
  </msxml:script>
</xsl:stylesheet>