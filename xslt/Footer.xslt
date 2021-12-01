<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:KKSClasses.Sitemap="urn:KKSClasses.Sitemap"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets KKSClasses.Sitemap">
  
  
  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:param name="currentPage"/>
  <xsl:variable name="homeNode" select="umbraco.library:GetXmlNodeById(1244)"/>
  <xsl:variable name="managenentTeam" select="umbraco.library:GetXmlNodeById(1359)"/>    
  
    
    <xsl:template match="/">
    <div class="footerContainer">
        <div class="managementTeam clearfix">
            <h4>
                <xsl:value-of select="$managenentTeam/@nodeName" disable-output-escaping="yes" />
             </h4>
            <xsl:for-each select="$managenentTeam/node">
                <xsl:choose>
                    <xsl:when test="./data[@alias='linkUrl'] !='' and ./data[@alias='logo'] !=''">
                        <a href="{./data[@alias='linkUrl']}" target="_Blank">
                            <xsl:value-of select="./data[@alias='title']" disable-output-escaping="yes" />
                            <img src="/handlers/imageStream.ashx?side=1&amp;maxSide=127&amp;path={umbraco.library:GetMedia(./data[@alias='logo'], 'false')/data [@alias='umbracoFile']}" />
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="./data[@alias='logo'] !=''">
                        <a href="#" class="noLink">
                            <xsl:value-of select="./data[@alias='title']" disable-output-escaping="yes" />
                            <img src="/handlers/imageStream.ashx?side=1&amp;maxSide=127&amp;path={umbraco.library:GetMedia(./data[@alias='logo'], 'false')/data [@alias='umbracoFile']}" />
                        </a>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>  
        </div>
        <div class="footer clearfix">
            <div class="col">
                <h3>
                    <xsl:value-of select="$homeNode/data[@alias='footerLeftTitle']" disable-output-escaping="yes" />                    
                </h3>               
                    <xsl:value-of select="$homeNode/data[@alias='footerLeftContent']" disable-output-escaping="yes" /> 
            </div>
            <fieldset>
                <h4>Subscribe To The Newsletter</h4>
                <label>Your Name</label>
                <div>
                    <input type="text" class="userName" />
                </div>
                <label>Your Email</label>
                <div>
                     <input type="text" class="userEmail" />
                </div>
                <p class="success">Thanks for your subscription</p>
                <p class="error">Please enter a correct email address</p>               
                <a href="javascript:SendFooterContact();">Send</a>
            </fieldset>            
            <div class="footerSocial">
                <div class="fb-like" data-href="https://www.facebook.com/TheKauriDiebackManagementProgramme" data-send="false" data-layout="button_count" data-width="85" data-show-faces="false" data-font="arial">
                    <xsl:text> </xsl:text>
                </div>              
                <a href="https://twitter.com/share" class="twitter-share-button" data-count="horizontal">Tweet</a>
                <script type="text/javascript" src="//platform.twitter.com/widgets.js" >
                    <xsl:text> </xsl:text>
                </script>
            </div> 
            <div class="footerDetail clearfix">
                <xsl:if test="$homeNode/data[@alias='termsOfUseLinkURL']!=''">                
                <a href="{umbraco.library:NiceUrl($homeNode/data[@alias='termsOfUseLinkURL'])}">
                    <xsl:if test="$homeNode/data[@alias='termsOfUseLinkText']!=''">
                        <xsl:value-of select="$homeNode/data[@alias='termsOfUseLinkText']" disable-output-escaping="yes" />
                    </xsl:if>
                </a>
                </xsl:if>
                    <xsl:if test="$homeNode/data[@alias='privacyPolicyURL']!=''">
                <a href="{umbraco.library:NiceUrl($homeNode/data[@alias='privacyPolicyURL'])}">
                    <xsl:if test="$homeNode/data[@alias='privacyPolicyLinkText']!=''">
                        <xsl:value-of select="$homeNode/data[@alias='privacyPolicyLinkText']" disable-output-escaping="yes" />
                    </xsl:if>
                </a>
                </xsl:if>
                <xsl:if test="$homeNode/data[@alias='freeLinkURL']!=''">
                    <a href="{$homeNode/data[@alias='freeLinkURL']}" target="_blank">
                        <xsl:if test="$homeNode/data[@alias='freeLinkText']!=''">
                            <xsl:value-of select="$homeNode/data[@alias='freeLinkText']" disable-output-escaping="yes" />
                        </xsl:if>
                    </a>
                </xsl:if>
              <a href="{umbraco.library:NiceUrl(1820)}">Sitemap</a>
                <a href="http://www.bka.co.nz" class="bkaLink" target="_Blank">website by bka</a>
            </div>
        </div>
    </div>
</xsl:template>
</xsl:stylesheet>