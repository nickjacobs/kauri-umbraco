<%@ Control Language="c#" AutoEventWireup="false" Codebehind="AutoForm.ascx.cs" Inherits="umbracoUtilities.AutoForm" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<asp:Panel id="PanelInput" runat="server">
	<div id="umbracoAutoForm">
	<asp:ValidationSummary EnableClientScript="False" CssClass="umbracoAutoFormValidationSummary" id="valSummary" Runat="server"></asp:ValidationSummary>
  <fieldset>
			<asp:PlaceHolder id="PHEditFields" runat="server"></asp:PlaceHolder>
		<p><asp:Button id="Button1" runat="server" cssClass="umbracoAutoFormButton" Text="Button"></asp:Button></p>
	</fieldset>		
	</div>
</asp:Panel>
<asp:Panel id="PanelThanks" runat="server" Visible="False">
	<p>
		<asp:Literal id="LiteralThanks" runat="server"></asp:Literal></p>
</asp:Panel>
