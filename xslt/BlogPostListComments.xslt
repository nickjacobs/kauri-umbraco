<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
  xmlns:BKA.UmbracoHelper.MenuHelper="urn:BKA.UmbracoHelper.MenuHelper"
	xmlns:BlogLibrary="urn:BlogLibrary"
	exclude-result-prefixes="msxml umbraco.library BKA.UmbracoHelper.MenuHelper BlogLibrary">


  <xsl:output method="html" omit-xml-declaration="yes"/>

  <xsl:param name="currentPage"/>

  <xsl:variable name="resultsPerPage" select="50"/>

  <xsl:variable name="pageNumber">
    <xsl:choose>
      <xsl:when test="umbraco.library:RequestQueryString('page') &lt;= 0 or string(umbraco.library:RequestQueryString('page')) = '' or string(umbraco.library:RequestQueryString('page')) = 'NaN'">1</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="umbraco.library:RequestQueryString('page')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:variable name="resultsCount" select="count($currentPage/node [@nodeTypeAlias='BlogPostComment' and data[@alias='IsApproved']=1])"/>
    <xsl:if test="$resultsCount &gt; 0">
        <h2><xsl:value-of select="$resultsCount"></xsl:value-of>&nbsp;
            <xsl:choose>
                <xsl:when test="$resultsCount = 1">response</xsl:when>
                <xsl:otherwise>responses</xsl:otherwise>
            </xsl:choose>
            to '<xsl:value-of select="$currentPage/@nodeName"/>'</h2>                  

          <xsl:for-each select="$currentPage/node [@nodeTypeAlias='BlogPostComment' and data[@alias='IsApproved']=1]">
            <xsl:sort select="substring(@createDate,1,4)" order="ascending"/>
            <xsl:sort select="substring(@createDate,6,2)" order="ascending"/>
            <xsl:sort select="substring(@createDate,9,2)" order="ascending"/>
            <xsl:sort select="substring(@createDate,12,2)" order="ascending"/>
            <xsl:sort select="substring(@createDate,15,2)" order="ascending"/>

              
            <xsl:if test="position() &gt; $resultsPerPage * (number($pageNumber)-1) and
                position() &lt;= $resultsPerPage * (number($pageNumber) - 1) + $resultsPerPage">

                <div class="postedDetail">
                    BY: <span><strong><xsl:value-of select="data[@alias='name']"/></strong></span>
                    &nbsp;&nbsp;&nbsp;&nbsp;ON: <span><strong><xsl:value-of select="umbraco.library:FormatDateTime(@createDate, 'dd MMMM yyyy') "/></strong></span>
                </div>
                <p>
                  <xsl:value-of select="umbraco.library:ReplaceLineBreaks(data [@alias = 'comment'])" disable-output-escaping="yes"/>
                </p>


              <xsl:if test="count(./node [@nodeTypeAlias='BlogPostComment' and data[@alias='IsApproved']=1]) &gt; 0">
                <!-- Replies -->
                <xsl:for-each select="./node [@nodeTypeAlias='BlogPostComment' and data[@alias='IsApproved']=1]">
                  <xsl:sort select="substring(@createDate,1,4)" order="ascending"/>
                  <!-- year  -->
                  <xsl:sort select="substring(@createDate,6,2)" order="ascending"/>
                  <!-- month -->
                  <xsl:sort select="substring(@createDate,9,2)" order="ascending"/>
                  <!-- day   -->
                  <xsl:sort select="substring(@createDate,12,2)" order="ascending"/>
                  <!-- hour -->
                  <xsl:sort select="substring(@createDate,15,2)" order="ascending"/>
                  <!-- min -->
                  <div>
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="position()=1 and data[@alias='IsAuthorResponse'] = '1'">reply firstReply authorReply</xsl:when>
                        <xsl:when test="position()=1 and data[@alias='IsAuthorResponse'] = '0'">reply firstReply</xsl:when>
                        <xsl:when test="data[@alias='IsAuthorResponse'] = '1'">reply authorReply</xsl:when>
                        <xsl:otherwise>reply</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>

                    <xsl:if test="position()=1">
                      <img class="point" src="/resources/images/ui/blogvoicebox.gif" alt="." />
                    </xsl:if>
                    <p>
                      <span class="commentor">
                        <xsl:choose>
                          <xsl:when test="data[@alias='IsAuthorResponse'] = '1'">
                            The author replies
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="data [@alias = 'name']"/> replies
                          </xsl:otherwise>
                        </xsl:choose>
                      </span>
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <xsl:value-of select="umbraco.library:ReplaceLineBreaks(data [@alias = 'comment'])" disable-output-escaping="yes"/>
                    </p>
                    <div class="clearer">&nbsp;</div>
                  </div>
                </xsl:for-each>
              </xsl:if>
              <div class="blog-reply-comment" id="divBlogReplyComment-{@id}"></div>
              <input type="hidden" value="{@id}" />
            </xsl:if>
          </xsl:for-each>
          <xsl:value-of select="BlogLibrary:GeneratePaging($resultsCount, $pageNumber, $resultsPerPage, 'paging')" disable-output-escaping="yes"/>
          <xsl:value-of select="' '"/>
      <div class="clearer">&nbsp;</div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>