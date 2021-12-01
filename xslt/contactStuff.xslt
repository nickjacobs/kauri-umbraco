<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

  <h1>Contact</h1>
  <h3>
    Phone 
    <span class="contact" style="color: #525D64;">
      <xsl:value-of select="$currentPage/data[@alias='phone']" disable-output-escaping="yes"></xsl:value-of>
    </span>
  </h3>
  <h3>
    Fax 
    <span class="contact" style="color: #525D64;">
      <xsl:value-of select="$currentPage/data[@alias='fax']" disable-output-escaping="yes"></xsl:value-of>
    </span>
  </h3>
  <h3>
    Mobile 
    <span class="contact" style="color: #525D64;">
      <xsl:value-of select="$currentPage/data[@alias='mobile']" disable-output-escaping="yes"></xsl:value-of>
    </span>
  </h3>
  <h3>
    Email 
    <span class="contact">
      <a href="mailto:{$currentPage/data[@alias='email']}">
      <xsl:value-of select="$currentPage/data[@alias='email']" disable-output-escaping="yes"></xsl:value-of>
      </a>
    </span>
  </h3>
 

</xsl:template>

</xsl:stylesheet>