<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:msxml="urn:schemas-microsoft-com:xslt"
        xmlns:randomTools="http://www.umbraco.org/randomTools"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
  exclude-result-prefixes="msxml randomTools umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:template match="/">

  <xsl:variable name="mediaFile" select="/macro/mediaFile/*"/>
  <xsl:variable name="fileURL" select="/macro/fileURL"/>
  <xsl:variable name="width" select="/macro/flashWidth"/>
  <xsl:variable name="height" select="/macro/flashHeight"/>
  <xsl:variable name="cssId" select="/macro/cssId"/>
  <xsl:variable name="urlParameters" select="/macro/urlParameters"/>

  <xsl:if test="$mediaFile != '' or $fileURL != ''">
    <xsl:variable name="trueFileURL">
      <xsl:choose>
      <xsl:when test="$mediaFile != ''"><xsl:value-of select="$mediaFile/data[@alias = 'umbracoFile'] | $mediaFile/umbracoFile"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$fileURL"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="finalFileURL">
      <xsl:choose>
      <xsl:when test="$urlParameters != ''"><xsl:value-of select="concat($trueFileURL, $urlParameters)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$trueFileURL"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="finalCssId">
      <xsl:choose>
      <xsl:when test="string($cssId) != ''"><xsl:value-of select="$cssId"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="concat( 'ts-', randomTools:GetRandom() )"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="insertFlash">
      <xsl:with-param name="finalFileURL" select="$finalFileURL"></xsl:with-param>
      <xsl:with-param name="width" select="$width"></xsl:with-param>
      <xsl:with-param name="height" select="$height"></xsl:with-param>
      <xsl:with-param name="finalCssId" select="$finalCssId"></xsl:with-param>
    </xsl:call-template>

  </xsl:if>

</xsl:template>

<xsl:template name="insertFlash">
  <xsl:param name="finalFileURL"/>
  <xsl:param name="width"/>
  <xsl:param name="height"/>
  <xsl:param name="finalCssId"/>

  <div id="{$finalCssId}">
    <xsl:text> </xsl:text>
  </div>

  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js">
    <xsl:text> </xsl:text>
  </script>

  <script type="text/javascript">
    <![CDATA[
    var flashvars = {};
	flashvars.clickTag = "http://www.kauridieback.co.nz"
    var params = {};
    var attributes = {};

    var path = "]]><xsl:value-of select="$finalFileURL" /><![CDATA[";
    var cssId = "]]><xsl:value-of select="$finalCssId" /><![CDATA[";
    var width = "]]><xsl:value-of select="$width" /><![CDATA[";
    var height = "]]><xsl:value-of select="$height" /><![CDATA[";

    swfobject.embedSWF( path, cssId, width, height, "9.0.0", false, flashvars, params, attributes);
    ]]>
  </script>

</xsl:template>

 <msxml:script language="c#" implements-prefix="randomTools">
    <msxml:assembly href="../bin/umbraco.dll"/>
    <![CDATA[
        //Basic idea from http://our.umbraco.org/wiki/reference/xslt/snippets/getting-a-series-of-unique-random-numbers

        /// <summary>
        /// Gets a random integer that falls between the specified limits
        /// </summary>
        /// <returns>A random integer within the specified range</returns>
        public static int GetRandom() {
            Random r = umbraco.library.GetRandom();
            int returnedNumber = 0;
            lock (r)
            {
                returnedNumber = r.Next();
            }
            return returnedNumber;
        }
    ]]>
  </msxml:script>

</xsl:stylesheet>