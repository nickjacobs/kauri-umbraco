<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ContactForm.ascx.cs" Inherits="UserControls_Website_ContactForm" %>

<asp:PlaceHolder ID="phForm" runat="server">
    <div class="form">
        <asp:PlaceHolder runat="server" ID="phValidationError" Visible="false">
            <div id="errorMsg">
                <a name="ErrorSummary"></a>
                <p class="error"><asp:Literal ID="litValidationError" runat="server" EnableViewState="false"></asp:Literal></p>
            </div>
            <script type="text/javascript">
                window.location = '#ErrorSummary';
            </script>
        </asp:PlaceHolder>
        <div id="innerForm">            
            <label for="<%=tbFirstName.ClientID %>">First Name *</label>
            <asp:TextBox Runat="server" ID="tbFirstName" CssClass="inputText"></asp:TextBox>
            <div class="clearer">&nbsp;</div>
            
            <label for="<%=tbLastName.ClientID %>">Last Name *</label>
            <asp:TextBox Runat="server" ID="tbLastName" CssClass="inputText"></asp:TextBox>
            <div class="clearer">&nbsp;</div>
                 
            <label for="<%=tbEmail.ClientID %>">Email Address *</label>
            <asp:TextBox runat="server" ID="tbEmail" CssClass="inputText"></asp:TextBox>
            <div class="clearer">&nbsp;</div>   
            
            <label for="<%=tbQuestion.ClientID %>">Question *</label>
            <asp:TextBox Runat="server" ID="tbQuestion" CssClass="fieldMessage" textMode="Multiline" ></asp:TextBox>
            <div class="clearer">&nbsp;</div>
            
            <asp:LinkButton runat="server" ID="lbSend" OnClick="lbSend_Click" CssClass="medBlueButton">
                <span class="leftEdge"></span><span class="middlePortion">ASK</span><span class="rightEdge"></span>
            </asp:LinkButton>
            <div class="clearer"></div>
		</div>
    </div>
</asp:PlaceHolder>
<asp:PlaceHolder ID="phSuccess" runat="server" Visible="false">
    <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
</asp:PlaceHolder>
<asp:PlaceHolder ID="phError" runat="server" Visible="false">
    <p><asp:Literal ID="litError" runat="server"></asp:Literal></p>
</asp:PlaceHolder>