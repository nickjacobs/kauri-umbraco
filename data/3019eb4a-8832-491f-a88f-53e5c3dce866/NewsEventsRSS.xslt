<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxml="urn:schemas-microsoft-com:xslt"
    xmlns:umbraco.library="urn:umbraco.library"
    xmlns:rssdatehelper="urn:rssdatehelper"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    exclude-result-prefixes="msxml umbraco.library">


    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:param name="currentPage"/>

    <!-- Update these variables to modify the feed -->
    <xsl:variable name="siteURL" select="concat('http://',umbraco.library:RequestServerVariables('HTTP_HOST'))"/>
    <xsl:variable name="rssNoItems" select="/macro/rssNoItems"/>    
    <xsl:variable name="rssTitle" select="/macro/rssTitle"/>
    <xsl:variable name="rssDescription" select="/macro/rssDescription"/>

    <!-- This gets all news and events and orders by updateDate to use for the pubDate in RSS feed -->
    <xsl:variable name="pubDate">
        <xsl:for-each select="$currentPage/ancestor-or-self::root/node [@nodeTypeAlias = 'CWS_Home']//node [@nodeTypeAlias = 'CWS_NewsEventsList']/node [string(data [@alias='umbracoNaviHide']) != '1']">
            <xsl:sort select="@createDate" data-type="text" order="descending" />
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
            xmlns:dc="http://purl.org/dc/elements/1.1/">

            <channel>
                <title>
                    <xsl:value-of select="$rssTitle"/>
                </title>
                <link>
                    <xsl:value-of select="$siteURL"/>
                </link>
                <pubDate>
                    <xsl:value-of select="$pubDate"/>
                </pubDate>
                <generator>umbraco</generator>
                <description>
                    <xsl:value-of select="$rssDescription"/>
                </description>
                <language>en</language>

                <xsl:apply-templates select="$currentPage/ancestor-or-self::root/node [@nodeTypeAlias = 'CWS_Home']//node [@nodeTypeAlias = 'CWS_NewsEventsList']/node [string(data [@alias='umbracoNaviHide']) != '1']">
                    <xsl:sort select="@createDate" order="descending" />
                </xsl:apply-templates>
            </channel>
        </rss>

    </xsl:template>

    <xsl:template match="node">
        <xsl:if test="position() &lt;= $rssNoItems">
            <item>
                <title>
                    <xsl:value-of select="@nodeName"/>
                </title>
                <link>
                    <xsl:value-of select="$siteURL"/>
                    <xsl:value-of select="umbraco.library:NiceUrl(@id)"/>
                </link>
                <pubDate>
                    <xsl:value-of select="umbraco.library:FormatDateTime(@createDate,'r')" />
                </pubDate>
                <guid>
                    <xsl:value-of select="$siteURL"/>
                    <xsl:value-of select="umbraco.library:NiceUrl(@id)"/>
                </guid>
                <content:encoded>
                    <xsl:value-of select="concat('&lt;![CDATA[ ', ./data [@alias='bodyText'],']]&gt;')" disable-output-escaping="yes"/>
                </content:encoded>
            </item>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>