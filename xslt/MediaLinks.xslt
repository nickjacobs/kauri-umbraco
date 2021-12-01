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
    
    <xsl:template match="/">
        <xsl:for-each select="$currentPage/node">
            <xsl:call-template name="listItems">
                <xsl:with-param name="parent" select="." />
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>   
    
    <xsl:template name="listItems">
        <xsl:param name="parent"/>
        <xsl:choose>
            <xsl:when test="$parent/data[@alias='externalLink']!=''">
                <a href="{$parent/data[@alias='externalLink']}" target="_blank">
                    <xsl:if test="$parent/data[@alias='image']!=''">
                        <img title="{$parent/data[@alias='title']}" alt="{$parent/data[@alias='title']}" src="/handlers/imageStream.ashx?side=1&amp;maxSide=138&amp;path={umbraco.library:GetMedia($parent/data[@alias='image'], 'false')/data [@alias='umbracoFile']}"/>
                    </xsl:if>
                  <h3>
                    <xsl:value-of select="$parent/data[@alias='datetext']" disable-output-escaping="yes"/>
                  </h3>
                    <h3>
                        <xsl:value-of select="$parent/data[@alias='title']" disable-output-escaping="yes"/>
                    </h3>
                    <xsl:value-of select="$parent/data[@alias='synopsis']" disable-output-escaping="yes"/>
                </a>
            </xsl:when>
            <xsl:otherwise>             
                <xsl:choose>
                <xsl:when test="$parent/data[@alias='mediaLibraryLink']!=''">
                    <a href="{umbraco.library:GetMedia($parent/data[@alias='mediaLibraryLink'], 'false')/data [@alias='umbracoFile']}" target="_blank">
                        <xsl:if test="$parent/data[@alias='image']!=''">
                            <img title="{$parent/data[@alias='title']}" alt="{$parent/data[@alias='title']}" src="/handlers/imageStream.ashx?side=1&amp;maxSide=138&amp;path={umbraco.library:GetMedia($parent/data[@alias='image'], 'false')/data [@alias='umbracoFile']}"/>
                        </xsl:if>

                      <h3>
                        <xsl:value-of select="$parent/data[@alias='datetext']" disable-output-escaping="yes"/>
                      </h3>
                      <h3>
                        <xsl:value-of select="$parent/data[@alias='title']" disable-output-escaping="yes"/>
                      </h3>
                        <xsl:value-of select="$parent/data[@alias='synopsis']" disable-output-escaping="yes"/>
                    </a>
                </xsl:when>
                    <xsl:otherwise>
                        <a href="{umbraco.library:NiceUrl($parent/@id)}">
                            <xsl:if test="$parent/data[@alias='image']!=''">
                                <img title="{$parent/data[@alias='title']}" alt="{$parent/data[@alias='title']}" src="/handlers/imageStream.ashx?side=1&amp;maxSide=138&amp;path={umbraco.library:GetMedia($parent/data[@alias='image'], 'false')/data [@alias='umbracoFile']}"/>
                            </xsl:if>
                          <h3>
                            <xsl:value-of select="$parent/data[@alias='datetext']" disable-output-escaping="yes"/>
                          </h3>
                            <h3>
                                <xsl:value-of select="$parent/data[@alias='title']" disable-output-escaping="yes"/>
                            </h3>
                            <xsl:value-of select="$parent/data[@alias='synopsis']" disable-output-escaping="yes"/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>  
            </xsl:otherwise>   
        </xsl:choose>               
    </xsl:template>
</xsl:stylesheet>