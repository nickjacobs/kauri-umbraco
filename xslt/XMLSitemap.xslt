<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	exclude-result-prefixes="msxml umbraco.library">
	
    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:param name="currentPage"/>


    <!--
    ====================================================
    This XSLT creates an XML sitemap used for search
    engines. Following these guidelines
    http://www.sitemaps.org
    ====================================================
    -->

    <!--
    ====================================================
    We setup two parameters.
    
    maxLevelForSitemap allows you to configure how deep 
    the sitemap should go.
    
    url is the root url - eg: http://localhost
    ====================================================
    -->
    <xsl:variable name="maxLevelForSitemap" select="6"/>
    <xsl:variable name="url" select="concat('http://',umbraco.library:RequestServerVariables('HTTP_HOST'))" />


    <xsl:template match="/">
        <!-- change the mimetype for the current page to xml -->
        <xsl:value-of select="umbraco.library:ChangeContentType('text/xml')"/>
        
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

            <!--
            ====================================================
            This <URL> node is for the homepage/root page
            ====================================================
            -->
            <url>
                <loc>
                    <xsl:value-of select="concat($url,'/')"/>
                </loc>
                <lastmod>
                    <xsl:value-of select="concat($currentPage/ancestor-or-self::node [@level=1]/@updateDate,'+00:00')" />
                </lastmod>
            </url>

            <!--
            ====================================================
            RUN template drawNodes passing the parent variable
            as the ROOT node.
            ====================================================
            -->
            <xsl:call-template name="drawNodes">
                <xsl:with-param name="parent" select="$currentPage/ancestor-or-self::node [@level=1]"/>
            </xsl:call-template>
        </urlset>
    </xsl:template>


    <xsl:template name="drawNodes">
        <xsl:param name="parent"/>

        <!--
        ====================================================
        If the parent variable is NOT protected
        ====================================================
        -->
        <xsl:if test="umbraco.library:IsProtected($parent/@id, $parent/@path) = 0">


            <!--
            ====================================================
            For each CHILD node of the parent variable node
            WHERE umbracoNaviHide is NOT true AND the node's
            level is less than and equal to the 
            maxLevelForSitemap variable.
            ====================================================
            -->
            <xsl:for-each select="$parent/node [string(./data [@alias='umbracoNaviHide']) != '1' and @level &lt;= $maxLevelForSitemap]">
                <url>
                    <loc>
                        <xsl:value-of select="$url"/><xsl:value-of select="umbraco.library:NiceUrl(@id)"/>
                    </loc>
                    <lastmod>
                        <xsl:value-of select="concat(@updateDate,'+00:00')" />
                    </lastmod>                   
                </url>

                <!--
                ====================================================
                IF the number of child nodes from the current node
                in the for-each loop WHERE umbracoNaviHide is NOT true 
                AND the node's levels are less than and equal to the 
                maxLevelForSitemap variable is GREATER than 0.
                ====================================================
                -->
                <xsl:if test="count(current()/node [string(./data [@alias='umbracoNaviHide']) != '1' and @level &lt;= $maxLevelForSitemap]) &gt; 0">

                    <!--
                    ====================================================
                    As we have further child nodes recall the same
                    template we are in with the parent variable set to
                    as the current node in the for-each loop.
                    ====================================================
                    -->
                    <xsl:call-template name="drawNodes">
                        <xsl:with-param name="parent" select="current()"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
