<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:BKA.UmbracoHelper.DocumentTypes="urn:BKA.UmbracoHelper.DocumentTypes" xmlns:BKA.UmbracoHelper.MenuHelper="urn:BKA.UmbracoHelper.MenuHelper" xmlns:BKA.ShoppingCart.CartItem="urn:BKA.ShoppingCart.CartItem" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets BKA.UmbracoHelper.DocumentTypes BKA.UmbracoHelper.MenuHelper BKA.ShoppingCart.CartItem ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

  <xsl:variable name="home" select="$currentPage/ancestor-or-self::node [@level=1]"/>
  <xsl:variable name="siloNode" select="$currentPage/ancestor-or-self::node [@level=2]"/>
  
  <xsl:choose>
    <xsl:when test="$currentPage/data[@alias='umbracoNaviHide']=0 and $siloNode/data[@alias='umbracoNaviHide']=0">
      <h2 class="titleBg2Brown">
        <xsl:value-of select="$siloNode/@nodeName"/>
      </h2>
    </xsl:when>

  </xsl:choose>
  

</xsl:template>

</xsl:stylesheet>