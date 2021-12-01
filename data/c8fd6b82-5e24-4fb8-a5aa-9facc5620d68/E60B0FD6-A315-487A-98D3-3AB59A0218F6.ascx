<%@ Control Language="c#" AutoEventWireup="false" Codebehind="RunWizard.ascx.cs" Inherits="websiteWizard.RunWizard" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<h3 style="margin-left: 0px;">Configure Your New Website</h3>
<asp:Panel ID="config" Runat="server" Visible="True">
	<P>Congratulations - your new site is now installed!<BR>
		<BR>
		All that's left is a little bit of configuration. After these four questions 
		and press "Finish", then I'll show your new website when I'm done.<BR>
	</P>
	<P><STRONG>Navigation</STRONG><BR>
	</P>
	<P>
		<asp:RadioButtonList id="Navigation" runat="server">
			<asp:ListItem Value="uwwNaviTopLeft" Selected="True">Top + Left</asp:ListItem>
			<asp:ListItem Value="uwwNaviPullDown">Pull Down Menus</asp:ListItem>
		</asp:RadioButtonList></P>
	<P><STRONG>Breadcrums</STRONG><BR>
		<asp:RadioButtonList id="Breadcrums" runat="server">
			<asp:ListItem Value="">No</asp:ListItem>
			<asp:ListItem Value="top">Yes, At top (before content)</asp:ListItem>
			<asp:ListItem Value="bottom" Selected="True">Yes, At bottom (after content)</asp:ListItem>
		</asp:RadioButtonList></P>
	<P><STRONG>News</STRONG><BR>
		<asp:RadioButtonList id="News" runat="server">
			<asp:ListItem Value="">No</asp:ListItem>
			<asp:ListItem Value="1">Yes</asp:ListItem>
			<asp:ListItem Value="2" Selected="True">Yes + Latest Two Item on the Front Page</asp:ListItem>
		</asp:RadioButtonList></P>
	<P><STRONG>Meta Data</STRONG></P>
	<P>
		<asp:RadioButtonList id="MetaData" runat="server">
			<asp:ListItem Value="" Selected="True">No</asp:ListItem>
			<asp:ListItem Value="1">Yes, Html</asp:ListItem>
			<asp:ListItem Value="2">Yes, Dublin Core</asp:ListItem>
		</asp:RadioButtonList></P>
	<P>
		<asp:Button id="Button1" runat="server" Text="Finish"></asp:Button></P>
</asp:Panel>
<asp:Panel ID="finish" Runat="server" Visible="False">
<p>Your site is now 
configured and published!<BR><BR><A href="../../" target="_blank">Click here to preview 
		it!</A><BR>
</p></asp:Panel>
