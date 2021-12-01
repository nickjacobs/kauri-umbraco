<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ListSubscriptions.ascx.cs" Inherits="usercontrols_dashboards_ListSubscriptions" %>

<br />
<h1>Subscription Log</h1>
<hr />
<asp:Repeater runat="server" ID="downloadList" >
    <HeaderTemplate>
    <table border="0" cellpadding="5" cellspacing="1">
        <tr bgcolor="#808080">
            <td>Users Name</td>
            <td>Email</td>
            <td>Date</td>          
        </tr>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>
            <td><%# DataBinder.Eval(Container, "DataItem.Name")%></td>
            <td><%# DataBinder.Eval(Container, "DataItem.Email")%></td>
            <td><%# DataBinder.Eval(Container, "DataItem.Date")%></td>           
        </tr>
    </ItemTemplate>
    <AlternatingItemTemplate>
      <tr bgcolor="#cecece">
            <td><%# DataBinder.Eval(Container, "DataItem.Name")%></td>
            <td><%# DataBinder.Eval(Container, "DataItem.Email")%></td>
            <td><%# DataBinder.Eval(Container, "DataItem.Date")%></td>            
        </tr>
    </AlternatingItemTemplate>    
    <FooterTemplate></table></FooterTemplate>
</asp:Repeater>