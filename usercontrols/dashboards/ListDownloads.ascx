<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ListDownloads.ascx.cs" Inherits="usercontrols_dashboards_ListDownloads" %>
<br />
<h1>Download Log</h1>
<hr />
<asp:Repeater runat="server" ID="downloadList" >
    <HeaderTemplate>
    <table border="0" cellpadding="5" cellspacing="1">
        <tr bgcolor="#808080">
            <td>Users Name</td>
            <td>Email</td>
            <td>Date</td>
            <td>Document</td>
        </tr>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>
            <td><%# DataBinder.Eval(Container, "DataItem.Name")%></td>
            <td><%# DataBinder.Eval(Container, "DataItem.Email")%></td>
            <td><%# DataBinder.Eval(Container, "DataItem.Date")%></td>
            <td><a target="_blank" href="<%# DataBinder.Eval(Container, "DataItem.Document")%>"><%# DataBinder.Eval(Container, "DataItem.Document")%></a></td>
        </tr>
    </ItemTemplate>
    <AlternatingItemTemplate>
      <tr bgcolor="#cecece">
            <td><%# DataBinder.Eval(Container, "DataItem.Name")%></td>
            <td><%# DataBinder.Eval(Container, "DataItem.Email")%></td>
            <td><%# DataBinder.Eval(Container, "DataItem.Date")%></td>
            <td><a target="_blank" href="<%# DataBinder.Eval(Container, "DataItem.Document")%>"><%# DataBinder.Eval(Container, "DataItem.Document")%></a></td>
        </tr>
    </AlternatingItemTemplate>    
    <FooterTemplate></table></FooterTemplate>
</asp:Repeater>