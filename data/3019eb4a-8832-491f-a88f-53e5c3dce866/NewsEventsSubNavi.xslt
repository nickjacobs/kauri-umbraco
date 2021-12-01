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
    
    <xsl:variable name="noOfItems" select="3" />

    <xsl:template match="/">
    
        <ul class="events">
            <xsl:for-each select="$currentPage/ancestor-or-self::node//node [@nodeTypeAlias ='CWS_NewsEventsList']/node">
                <xsl:sort select="@createDate" order="ascending"/>

                <!-- Position() <= $noOfItems -->
                <xsl:if test="position()&lt;= $noOfItems">
                    <li>
                        <a href="{umbraco.library:NiceUrl(@id)}">
                            <em>
                                <!-- Date Format: 15.12.08 -->
                                <xsl:choose>
                                    <xsl:when test="@nodeTypeAlias = 'EventItem'">
                                        <xsl:value-of select="umbraco.library:FormatDateTime(data [@alias='eventDate'], 'dd.MM.yy')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="umbraco.library:FormatDateTime(@createDate, 'dd.MM.yy')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </em>
                            <span>
                                <xsl:value-of select="@nodeName"/>
                            </span>
                        </a>
                    </li>
                </xsl:if>
                
            </xsl:for-each>
        </ul>

    </xsl:template>

</xsl:stylesheet>