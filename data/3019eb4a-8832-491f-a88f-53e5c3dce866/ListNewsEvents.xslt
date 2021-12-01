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
    <xsl:param name="MaxNoChars" select="100" />

    <xsl:template match="/">

        <div class="newsList clearfix">

            <!--
            =============================================================
            For Each child node of the currentpage
            =============================================================
            -->
            <xsl:for-each select="$currentPage/node">

                <div>
                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="position() mod 3 = 1">
                                <xsl:text>
                                    first left
                                </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>
                                    left
                                </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    
                    <span>
                        <!-- Date Format: 15.12.08 -->
                        <xsl:choose>
                            <xsl:when test="current()/@nodeTypeAlias = 'EventItem'">
                                <xsl:value-of select="umbraco.library:FormatDateTime(data [@alias='eventDate'], 'dd.MM.yy')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="umbraco.library:FormatDateTime(@createDate, 'dd.MM.yy')"/>                   
                            </xsl:otherwise>
                        </xsl:choose>
                    
                        
                        
                    </span>
                    <h4>
                        <a href="{umbraco.library:NiceUrl(@id)}">
                            <xsl:value-of select="@nodeName" />
                        </a>
                    </h4>
                    <p>
                        <!-- TODO: strip HTML & truncate -->
                        <xsl:value-of select="umbraco.library:TruncateString(umbraco.library:StripHtml(data [@alias = 'bodyText']), $MaxNoChars, '...')" />
                    </p>
                </div>

                <!--
                =============================================================
                After very 3rd item insert a <br/> 
                =============================================================
                -->
                <xsl:if test="position() mod 3 = 0">
                    <br class="clearBoth"/>
                </xsl:if>
                
            </xsl:for-each>

        </div>

    </xsl:template>

</xsl:stylesheet>