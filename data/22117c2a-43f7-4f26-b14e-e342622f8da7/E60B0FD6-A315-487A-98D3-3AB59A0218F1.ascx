<%@ Control Language="c#" AutoEventWireup="false" Codebehind="umbSearchResult.ascx.cs" Inherits="umbracoUtilities.umbSearchResult" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<asp:panel id="PanelDotNet" runat="server">
	<P>
		<asp:Label id="Header" runat="server" Visible="False">Søgeresultater</asp:Label></P>
	<P>
		<asp:Label id="results" runat="server"></asp:Label></P>
</asp:panel>
<asp:panel id="PanelXslt" runat="server">
	<asp:Xml id="XmlResult" runat="server"></asp:Xml>
</asp:panel>
<asp:panel id="PanelArrows" Runat="server">
	<P class="searchArrows" align="center">
		<asp:LinkButton id="linkParent" runat="server" Visible="False" Enabled="False">Parent</asp:LinkButton>&nbsp;&nbsp;
		<asp:PlaceHolder id="googleArrows" runat="server"></asp:PlaceHolder>
		<asp:LinkButton id="linkNext" runat="server" Visible="False" Enabled="False">Next</asp:LinkButton></P>
</asp:panel>
<asp:textbox id="searchQuery" runat="server"></asp:textbox><asp:button id="Button2" runat="server" Text="Search" CssClass="searchButton"></asp:button><INPUT id="page" type="hidden" name="page">
<P></P>
<P><asp:textbox id="TextBox1" runat="server" Visible="False"></asp:textbox><asp:button id="Button3" runat="server" Visible="False" Text="Add node with id to index"></asp:button></P>
<P><asp:button id="Button1" runat="server" Visible="False" Text="Debug: Create index"></asp:button></P>
