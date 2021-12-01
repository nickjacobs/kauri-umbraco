<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:umbraco.library="urn:umbraco.library"
xmlns:customfunctionlib="urn:customfunctionlib"
xmlns:rssdatehelper="urn:rssdatehelper"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:content="http://purl.org/rss/1.0/modules/content/"
exclude-result-prefixes="msxml umbraco.library customfunctionlib">


  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:param name="currentPage"/>

  <!-- Update these variables to modify the feed -->
  <xsl:variable name="RSSNoItems" select="string('10')"/>
  <xsl:variable name="RSSTitle" select="'COMPANY NAME Blog Updates'"/>
  <xsl:variable name="SiteURL" select="string('http://www.companyname.co.nz')"/>
  <xsl:variable name="RSSDescription" select="' '"/>

  <xsl:variable name="rootBlogNode" select="umbraco.library:GetXmlNodeById(customfunctionlib:AppSettings('Blog.RootId'))"></xsl:variable>
  <!-- This gets all news and events and orders by updateDate to use for the pubDate in RSS feed -->
  <xsl:variable name="pubDate">
    <xsl:for-each select="$rootBlogNode//node[@alias='BlogPost']">
      <xsl:sort select="data[@alias='Date']" order="descending" />
      <xsl:if test="position() = 1">
        <xsl:value-of select="updateDate" />
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:template match="/">
    <!-- change the mimetype for the current page to xml -->
    <xsl:value-of select="umbraco.library:ChangeContentType('text/xml')"/>

    <xsl:text disable-output-escaping="yes">&lt;?xml version="1.0" encoding="UTF-8"?&gt;</xsl:text>
    <rss version="2.0"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:wfw="http://wellformedweb.org/CommentAPI/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
>

      <channel>
        <title>
          <xsl:value-of select="$RSSTitle"/>
        </title>
        <link>
          <xsl:value-of select="$SiteURL"/>
        </link>
        <pubDate>
          <xsl:value-of select="$pubDate"/>
        </pubDate>
        <generator>umbraco</generator>
        <description>
          <xsl:value-of select="$RSSDescription"/>
        </description>
        <language>en</language>

        <xsl:apply-templates select="$rootBlogNode//node [@nodeTypeAlias = 'BlogPost']">
          <xsl:sort select="data[@alias='Date']" order="descending" />
        </xsl:apply-templates>
      </channel>
    </rss>

  </xsl:template>

  <xsl:template match="node">
    <xsl:if test="position() &lt;= $RSSNoItems">
      <item>
        <title>
          <xsl:value-of select="@nodeName"/>
        </title>
        <link>
          <xsl:value-of select="$SiteURL"/>
          <xsl:value-of select="umbraco.library:NiceUrl(@id)"/>
        </link>
        <pubDate>
          <xsl:value-of select="umbraco.library:FormatDateTime(data[@alias='Date'],'r')" />
        </pubDate>
        <guid>
          <xsl:value-of select="$SiteURL"/>
          <xsl:value-of select="umbraco.library:NiceUrl(@id)"/>
        </guid>
        <content:encoded>
          <xsl:value-of select="concat('&lt;![CDATA[ ', ./data [@alias='bodyText'],']]&gt;')" disable-output-escaping="yes"/>
        </content:encoded>
      </item>
    </xsl:if>
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