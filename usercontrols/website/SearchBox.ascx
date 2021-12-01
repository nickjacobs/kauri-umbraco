<%@ Control Language="C#" Debug="false" AutoEventWireup="true" CodeFile="SearchBox.ascx.cs" Inherits="umbracowebsitewizard_site.Usercontrols.SearchBox" %>

<div class="right searchBox">    
    <asp:TextBox ID="searchText" runat="server"></asp:TextBox>
    <button id="btnSearch" runat="server" onserverclick="btnSearch_Click">Search</button>
</div>