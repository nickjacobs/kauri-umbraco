<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BlogSearch.ascx.cs" Inherits="usercontrols_website_BlogSearch" %>

<fieldset class="searchblog">
    <asp:TextBox ID="tbSearch" runat="server" Text="search blog"></asp:TextBox>
    <asp:LinkButton ID="lbSearch" runat="server" CssClass="search" OnClick="lbSearch_Click">search</asp:LinkButton>
</fieldset>

<script type="text/javascript">
    $(document).ready(function() {
        setupDefaultTextReset($('#<%=tbSearch.ClientID %>'), 'search blog');
    });
</script>