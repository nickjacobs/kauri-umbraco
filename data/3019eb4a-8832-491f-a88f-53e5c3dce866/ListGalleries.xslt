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

        <div class="galleryGrid clearfix">

            <!--
            =============================================================
            For Each child node of the currentpage WHERE the node 
            type alias is equal to Gallery
            =============================================================
            -->
            <xsl:for-each select="$currentPage/node [@nodeTypeAlias = 'CWS_Gallery']">
               
                <!--
                =============================================================
                Lets apply our user specified sorting from our variables
                =============================================================
                -->
                <xsl:sort select="@*[name() = $SortBy]" order="{$SortOrder}" data-type="{$DataType}"/>
               
                <!--
                =============================================================
                Lets Only display the photo galleries that have photos
                =============================================================
                -->
                <xsl:if test="count(current()/node [@nodeTypeAlias = 'CWS_Photo']) &gt;=1">
                    
                    <div>
                        <!--
                        =============================================================
                        Lets change the class on the <div> tag above dynamically
                        =============================================================
                        -->                    
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <!--
                                =============================================================
                                When the position in the for each loop has 1 remainder over
                                
                                For Example:
                                
                                1/3 = 0 & 1 remainder		1 mod 3 = 1
                                2/3 = 0 & 2 remainders		2 mod 3 = 2
                                3/3 = 1 & 0 remainders		3 mod 3 = 0
                                =============================================================
                                -->
                                <xsl:when test="position() mod 3 = 1">
                                    <xsl:text>
                                        first item left
                                    </xsl:text>
                                </xsl:when>

                                <!--
                                =============================================================
                                Otherwise lets set it to 'item left'
                                =============================================================
                                -->
                                <xsl:otherwise>
                                    <xsl:text>
                                        item left
                                    </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>                       
                    
                        <a href="{umbraco.library:NiceUrl(@id)}">

                            <!--
                            =============================================================
                            Gallery Thumbnail dimensions: 208px x 108px
                            =============================================================
                            -->
                            
                            <xsl:choose>
                                <!--
                                =============================================================
                                When GalleryThumbnail is NOT empty then display the image
                                =============================================================
                                -->
                                <xsl:when test="data [@alias ='galleryThumbnail'] != ''">                                    
                                    <img src="{data [@alias ='galleryThumbnail']}" alt="{@nodeName}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!--
                                    =============================================================
                                    Otherwise we use a default blank placeholder
                                    =============================================================
                                    -->                                    
                                    <img src="/Assets/Placeholders/gallery_placeholder.gif" alt="{@nodeName}"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <xsl:value-of select="@nodeName"/>
                        </a>

                        <!--
                        =============================================================
                        Setup a variable called PhotoText
                        =============================================================
                        -->
                        <xsl:variable name="PhotoText">
                            <xsl:choose>
                                <!--
                                =============================================================
                                If the count of photos is greater than 1
                                =============================================================
                                -->
                                <xsl:when test="count(current()/node [@nodeTypeAlias = 'CWS_Photo']) &gt; 1">
                                    <xsl:value-of select="' Photos'" />
                                </xsl:when>

                                <!--
                                =============================================================
                                Otherwise we must have 1 photo
                                =============================================================
                                -->
                                <xsl:otherwise>
                                    <xsl:value-of select="' Photo'" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>

                        <span>
                            <!-- eg text output: 2 Photos -->
                            <xsl:value-of select="count(./node)"/>
                            <xsl:value-of select="$PhotoText"/>
                        </span>
                    </div>

                    <!--
                    =============================================================
                    After very 3rd item insert a <br/>
                    =============================================================
                    -->
                    <xsl:if test="position() mod 3 = 0">
                        <br class="clearBoth"/>
                    </xsl:if>


                </xsl:if>

            </xsl:for-each>
        </div>

    </xsl:template>

</xsl:stylesheet>