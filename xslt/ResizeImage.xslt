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

  <xsl:variable name="propertyAlias" select="/macro/propertyAlias" />
  <xsl:variable name="maxWidth" select="/macro/maxWidth" />
  <xsl:variable name="altText" select="/macro/altText" />
  <xsl:variable name="class" select="/macro/class" />
  <xsl:variable name="htmlID" select="/macro/htmlID" />

  <xsl:param name="currentPage"/>

  <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

  <xsl:template match="/">

    <!-- Set default value for alt andtitle text if not specifically set -->
    <xsl:variable name="altTextValue">
      <xsl:choose>
        <xsl:when test="$altText != ''">
          <xsl:value-of select="$altText"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$currentPage/@nodeName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>



    <xsl:if test="$currentPage/data [@alias = $propertyAlias] != ''">

      <!-- check if we need class or id properties added -->
      <xsl:choose>
        <xsl:when test="$htmlID != ''">

          <xsl:choose>
            <xsl:when test="$class != ''">
              <!-- class=yes, ID=yes-->
              <img src="/handlers/imageStream.ashx?side=1&amp;maxSide={$maxWidth}&amp;path={$currentPage/data [@alias = $propertyAlias]}" alt="{$altTextValue}" title="{$altTextValue}" class="{$class}" id="{$htmlID}"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- class=no, ID=yes-->
              <img src="/handlers/imageStream.ashx?side=1&amp;maxSide={$maxWidth}&amp;path={$currentPage/data [@alias = $propertyAlias]}" alt="{$altTextValue}" title="{$altTextValue}" id="{$htmlID}" />
            </xsl:otherwise>
          </xsl:choose>

        </xsl:when>
        <xsl:otherwise>

            <xsl:choose>
            <xsl:when test="$class != ''">
              <!-- class=yes, ID=no-->
              <img src="/handlers/imageStream.ashx?side=1&amp;maxSide={$maxWidth}&amp;path={$currentPage/data [@alias = $propertyAlias]}" alt="{$altTextValue}" title="{$altTextValue}" class="{$class}" />
            </xsl:when>
            <xsl:otherwise>
              <!-- class=no, ID=no-->
              <img src="/handlers/imageStream.ashx?side=1&amp;maxSide={$maxWidth}&amp;path={$currentPage/data [@alias = $propertyAlias]}" alt="{$altTextValue}" title="{$altTextValue}" />
            </xsl:otherwise>
          </xsl:choose>

        </xsl:otherwise>
      </xsl:choose>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>