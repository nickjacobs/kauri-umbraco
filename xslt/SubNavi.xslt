<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	exclude-result-prefixes="msxml umbraco.library">


<xsl:output method="xml" omit-xml-declaration="yes"/>


  <xsl:param name="currentPage"/>

  <!-- update this variable on how deep your menu should be -->
  <xsl:variable name="maxLevelForMenu" select="3"/>

  <xsl:template match="/">
      <xsl:choose>     
        <xsl:when test="$currentPage/data[@alias='umbracoNaviHide']=0 or $currentPage/@id=1356">          
          
                  <xsl:call-template name="drawNodes">
                    <xsl:with-param name="parent" select="$currentPage/ancestor-or-self::node [@level=2]" />
                  </xsl:call-template>
        </xsl:when>
        <xsl:when test="$currentPage/@nodeTypeAlias='Blog'">
          <xsl:call-template name="drawNodes">
            <xsl:with-param name="parent" select="umbraco.library:GetXmlNodeById(1356)/ancestor-or-self::node [@level=2]" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>&nbsp;</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="drawNodes">
    <xsl:param name="parent"/>

   
    <xsl:if test="$parent/node/@id!=''">
    <xsl:if test="umbraco.library:IsProtected($parent/@id, $parent/@path) = 0 or (umbraco.library:IsProtected($parent/@id, $parent/@path) = 1 and umbraco.library:IsLoggedOn() = 1)">
        <div class="sideNav">
            <xsl:choose >
                <xsl:when test="node[@level = 4]">
                    <xsl:call-template name="listItems">
                        <xsl:with-param  name="parent" select="$parent"  />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="listItems">
                        <xsl:with-param name="parent" select="$parent" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </div>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="listItems" >
    <xsl:param name="parent"/>  
                <xsl:for-each select="$parent/node [string(./data [@alias='umbracoNaviHide']) != '1' and @level &lt;= $maxLevelForMenu]">
                <a href="{umbraco.library:NiceUrl(@id)}">
                  <xsl:if test="$currentPage/ancestor-or-self::node/@id = current()/@id">
                    <xsl:attribute name="class">
                      <xsl:text>active</xsl:text>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="@nodeName"/>
                </a>
                <xsl:if test="count(./node [string(./data [@alias='umbracoNaviHide']) != '1' and @level &lt;= $maxLevelForMenu]) &gt; 0">
                  <xsl:call-template name="drawNodes">
                    <xsl:with-param name="parent" select="."/>
                  </xsl:call-template>
                </xsl:if>    
                </xsl:for-each>  
  </xsl:template>
</xsl:stylesheet>