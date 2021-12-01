<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	exclude-result-prefixes="msxml msxsl umbraco.library">
	
    <xsl:output method="xml" omit-xml-declaration="yes"/>

    
    <xsl:template match="/">
    
        <h1>Latest 10 records</h1>

        <ul class="form_logs">
            <xsl:for-each select="//log">

                <xsl:sort select="umbraco.library:FormatDateTime(@date, 'yyyyMMdd')" order="descending" data-type="number"/>
                <xsl:sort select="@time" order="descending"/>

                <xsl:if test="position() &lt;= 10">
                    <li>
                        <a href="#">
                            <xsl:value-of select="umbraco.library:FormatDateTime(@date, 'dd MMMM yyyy')"/> @ <xsl:value-of select="@time"/>
                        </a>
                        <ul>
                            <xsl:for-each select="field">
                                <li class="{@alias}">
                                    <xsl:value-of select="current()"/>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </li>
                </xsl:if> 
            </xsl:for-each>
        </ul>

        <xsl:if test="count(//log) &gt; 10">
            <h1>Archive</h1>

            <ul class="form_logs">
                <xsl:for-each select="//log">

                    <xsl:sort select="umbraco.library:FormatDateTime(@date, 'yyyyMMdd')" order="descending" data-type="number"/>
                    <xsl:sort select="@time" order="descending"/>

                    <xsl:if test="position() &gt; 10">
                        <li>
                            <a href="#">
                                <xsl:value-of select="umbraco.library:FormatDateTime(@date, 'dd MMMM yyyy')"/> @ <xsl:value-of select="@time"/>
                            </a>
                            <ul>
                                <xsl:for-each select="field">
                                    <li class="{@alias}">
                                        <xsl:value-of select="current()"/>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </xsl:if>

                
    </xsl:template>

</xsl:stylesheet>