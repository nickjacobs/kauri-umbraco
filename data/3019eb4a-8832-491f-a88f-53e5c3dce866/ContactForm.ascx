<%@ Control Language="C#" Debug="true" AutoEventWireup="true" CodeFile="ContactForm.ascx.cs" Inherits="umbracowebsitewizard_site.Usercontrols.ContactForm" %>

<div id="FormFields" runat="server" visible="true">
    <h2 class="flashHeader">        
        <asp:Literal ID="formHeader" runat="server"></asp:Literal>
    </h2>
    
    <div class="clearfix form">
        <div class="left text">
            <asp:Literal ID="formText" runat="server"></asp:Literal>
            
            <asp:ValidationSummary ID="ValidationSummaryText" 
                runat="server"            
                ForeColor="" 
                CssClass="errorMessage"
                HeaderText="Please review the following errors:" />
        </div>
            
        <div class="left fields">

            <fieldset>
                <legend>Enquiry Form</legend>
                
                <asp:Label ID="lblName" AssociatedControlID="name" runat="server">Name</asp:Label>
                <asp:TextBox ID="name" runat="server"></asp:TextBox>
                <br/>
                
                <asp:Label ID="lblAddressLine1" AssociatedControlID="addressLine1" runat="server">Address</asp:Label>
                <asp:TextBox ID="addressLine1" runat="server"></asp:TextBox>                             
                
                <asp:Label ID="lblAddressLine2" AssociatedControlID="addressLine2" CssClass="hide" runat="server">Address Line 2</asp:Label>
                <asp:TextBox ID="addressLine2" runat="server"></asp:TextBox>
                <br/>
                
                <asp:Label ID="lblEmailAddress" AssociatedControlID="emailAddress" runat="server">Email Address</asp:Label>        
                <asp:TextBox ID="emailAddress" runat="server"></asp:TextBox>
                <br/>
                
                <asp:Label ID="lblMessage" AssociatedControlID="message" runat="server">Enquiry</asp:Label>          
                <asp:TextBox ID="message" runat="server" TextMode="MultiLine" Rows="5" Columns="25"></asp:TextBox>
                <br/>
                
                <button id="btnSubmit" runat="server" onserverclick="btnSubmit_Click">Submit Enquiry</button>                             
            </fieldset>                
        </div>
    
    </div>   
    
    <asp:CustomValidator ID="RequiredName" 
        runat="server"
        ControlToValidate="name"
        Display="None"
        ErrorMessage="Please enter your name"
        onservervalidate="RequiredName_ServerValidate"
        Text=""    
        ValidateEmptyText="true"></asp:CustomValidator>
            
    <asp:CustomValidator ID="RequiredEmailAddress" 
        runat="server"
        ControlToValidate="emailAddress"
        Display="None"
        ErrorMessage="Please enter your email"
        onservervalidate="RequiredEmailAddress_ServerValidate"
        Text=""   
        ValidateEmptyText="true"></asp:CustomValidator>
        
    <asp:CustomValidator ID="RequiredMessage" 
        runat="server" 
        ControlToValidate="message"
        Display="None"
        ErrorMessage="Please enter a message"
        onservervalidate="RequiredMessage_ServerValidate"
        Text=""
        ValidateEmptyText="true"></asp:CustomValidator>    

    <asp:CustomValidator ID="CheckEmailAddress" 
        runat="server"
        ControlToValidate="emailAddress"
        Display="None"
        ErrorMessage="Please enter a valid email address"
        onservervalidate="CheckEmailAddress_ServerValidate"
        Text=""
        ValidateEmptyText="false"></asp:CustomValidator>
     
</div>

<div id="ErrorMailSettings" runat="server" visible="false">
    <asp:Label ID="errorMessage" runat="server" Text="Label"></asp:Label>
</div>

<div id="ThankYou" runat="server" visible="false">
    <h2 class="flashHeader">
        <asp:Literal ID="thankyouHeader" runat="server"></asp:Literal>  
    </h2>
        
    <asp:Literal ID="thankyouMessage" runat="server"></asp:Literal>    
</div>


    
    