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

    <!-- Get Properties of how to sort the Galleries -->
    <xsl:variable name="SortOrder" select="$currentPage/data [@alias = 'sortOrder']" />
    <xsl:variable name="SortBy" select="$currentPage/data [@alias = 'sortBy']" />

    <!--
    =============================================================
    Lets setup a variable called DataType. If the user has
    chosen 'sortOrder' from the sortBy dropdown list, then we
    need to set the datatype variable to = number otherwise it
    will sort the data wrongly.    
    =============================================================
    -->
    <xsl:variable name="DataType">
        <xsl:choose>
            <xsl:when test="$SortBy='sortOrder'">
                <xsl:value-of select="'number'" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'text'" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/">

        <div class="photoGrid clearfix">

            <!--
            =============================================================
            For Each child node of the currentpage WHERE the node 
            type alias is equal to Photo
            =============================================================
            -->
            <xsl:for-each select="$currentPage/node [@nodeTypeAlias = 'CWS_Photo']">

                <!--
                =============================================================
                Lets apply our user specified sorting from our variables
                =============================================================
                -->
                <xsl:sort select="@*[name() = $SortBy]" order="{$SortOrder}" data-type="{$DataType}"/>


                <div>

                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="position() mod 4 = 1">
                                <xsl:text>
                                        first item left
                                    </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>
                                        item left
                                    </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>

                    <a href="{umbraco.library:NiceUrl(@id)}">
                        <!-- 151px x 108px -->
                        <xsl:choose>
                            <xsl:when test="data [@alias ='photoThumbnail'] != ''">
                                <img src="{data [@alias ='photoThumbnail']}" alt="{@nodeName}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- use DEFAULT blank placeholder -->
                                <img src="/Assets/Placeholders/photo_placeholder.gif" alt="{@nodeName}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <xsl:value-of select="@nodeName" />
                    </a>
                    <span>
                        <xsl:value-of select="data [@alias = 'photoText']"/>
                    </span>
                </div>

                <!--
                =============================================================
                After very 4th item insert a <br/> 
                =============================================================
                -->
                <xsl:if test="position() mod 4 = 0">
                    <br class="clearBoth"/>
                </xsl:if>

            </xsl:for-each>


        </div>

    </xsl:template>

</xsl:stylesheet>