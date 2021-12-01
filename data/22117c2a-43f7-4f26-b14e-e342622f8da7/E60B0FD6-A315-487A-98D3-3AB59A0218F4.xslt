<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	exclude-result-prefixes="msxml umbraco.library">


<xsl:output method="html"/>

<xsl:variable name="action" select="/umbSubscribeUnsubscribe/action"/>
<xsl:variable name="errors" select="/umbSubscribeUnsubscribe/errors"/>


<xsl:template match="/">
<!-- header and body -->
<h3><xsl:value-of select="/umbSubscribeUnsubscribe/header" disable-output-escaping="yes"/></h3>
<p><xsl:value-of select="/umbSubscribeUnsubscribe/body" disable-output-escaping="yes"/></p>

<!-- status handling -->
<xsl:choose>
<xsl:when test="$action = 'deleted' or $action = 'unsubscribe'">
You've been unsubscribed
</xsl:when>
<xsl:when test="$action = 'created' or $action = 'subscribe'">
You're subscribed
</xsl:when>
<xsl:otherwise>

<!-- error handling -->
<xsl:if test="count($errors/*) &gt; 0">
<span style="color: red">
<xsl:choose>
<xsl:when test="$errors/error = 'nameEmpty'">
Please fill your name
</xsl:when>
<xsl:when test="$errors/error = 'emailEmpty'">
Please type your e-mail address
</xsl:when>
<xsl:when test="$errors/error = 'emailInvalid'">
Error in e-mail
</xsl:when>
<xsl:when test="$errors/error = 'emailExists'">
You are already subscribed!
</xsl:when>
<xsl:otherwise>
An unhandled error occured (<xsl:value-of select="$errors/error"/>).
</xsl:otherwise>
</xsl:choose>
<br/></span>
</xsl:if>

<!-- form design -->
Name: <input type="text" name="umbSubscribeName" value="{/umbSubscribeUnsubscribe/name}"/><br/>
E-mail: <input type="text" name="umbSubscribeEmail" value="{/umbSubscribeUnsubscribe/email}"/><br/>
<input type="radio" name="umbSubscribeMemberAction" value="subscribe" checked="1"/> Subscribe
<input type="radio" name="umbSubscribeMemberAction" value="unsubscribe"/> Unsubscribe
<input type="submit" value="OK"/>
</xsl:otherwise>
</xsl:choose>

</xsl:template>

</xsl:stylesheet>