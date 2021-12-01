<%@ Control Language="c#" AutoEventWireup="false" Codebehind="buildIndex.ascx.cs" Inherits="umbracoUtilities.buildIndex" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<h3 style="margin-left: 0px">Build the Search Index</h3>
<asp:Panel ID="config" Runat="server" Visible="True">
	<P>Congratulations - the umbraco Utilities package is installed!<BR>
		<BR>
		Click the button below to start populating the search index (recommended).</P>
	<P>
		<asp:Button id="Button1" runat="server" Text="Populate Index"></asp:Button></P>
</asp:Panel>
<asp:Panel ID="finish" Runat="server" Visible="False">
	<P>Your site is now indexed!
	</P>
	<P>
		<asp:Literal id="Literal1" runat="server"></asp:Literal></P>
</asp:Panel>
