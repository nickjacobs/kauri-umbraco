<%@ Control Language="C#" Debug="true" AutoEventWireup="true" CodeFile="EmailAFriendForm.ascx.cs" Inherits="umbracowebsitewizard_site.Usercontrols.EmailAFriendForm" %>

<div id="FormFields" runat="server" visible="true">
    <h2 class="flashHeader">        
        <asp:Literal ID="formHeader" runat="server"></asp:Literal>
    </h2>
    
    <div class="clearfix form" >
        <div class="left text">
        
            <asp:ValidationSummary ID="ValidationSummaryText" 
                runat="server"            
                ForeColor="" 
                CssClass="errorMessage"
                HeaderText="Please review the following errors:" />
                                 
            <p>
                The page you are sending to your friend is 
                <asp:HyperLink ID="emailLink" runat="server">www.yourdomain.co.uk/About.aspx</asp:HyperLink>
            </p>
        </div>
    
        <div class="left fields">
            <fieldset>
                <legend>Friends Details</legend>
                
                <asp:Label ID="lblFriendsName" AssociatedControlID="friendsName" CssClass="first" runat="server">Friends Name</asp:Label>
                <asp:TextBox ID="friendsName" runat="server"></asp:TextBox>
                <br />
                
                <asp:Label ID="lblFriendsEmail" AssociatedControlID="friendsEmail" runat="server">Friends Email</asp:Label>
                <asp:TextBox ID="friendsEmail" runat="server"></asp:TextBox>                               
            </fieldset>
            
            <fieldset>
                <legend>Your Details</legend>
                
                <asp:Label ID="lblYourName" AssociatedControlID="yourName" runat="server">Your name</asp:Label>
                <asp:TextBox ID="yourName" runat="server"></asp:TextBox>
                <br />
                
                <asp:Label ID="lblYourEmail" AssociatedControlID="yourEmail" runat="server">Your Email</asp:Label>
                <asp:TextBox ID="yourEmail" runat="server"></asp:TextBox>
                <br />
                
                <asp:Label ID="lblYourMessage" AssociatedControlID="yourMessage" runat="server">Your Message</asp:Label>
                <asp:TextBox ID="yourMessage" runat="server" TextMode="MultiLine" Rows="5" Columns="25"></asp:TextBox>
                <br />                                
                
                <button id="btnSubmit" runat="server" onserverclick="btnSubmit_Click">Send to Friend</button>
                                             
            </fieldset>        
            
        </div>
        
    </div>
    
    <asp:CustomValidator ID="RequiredFriendName" 
        runat="server"
        ControlToValidate="friendsName"
        Display="None" 
        ErrorMessage="Please enter your friends name"
        Text=""
        ValidateEmptyText="true" 
        onservervalidate="RequiredFriendName_ServerValidate"></asp:CustomValidator>
     
    <asp:CustomValidator ID="RequiredFriendEmail" 
        runat="server"
        ControlToValidate="friendsEmail"
        Display="None"
        ErrorMessage="Please enter your friends email"
        Text=""
        ValidateEmptyText="true" 
        onservervalidate="RequiredFriendEmail_ServerValidate"></asp:CustomValidator>
        
    <asp:CustomValidator ID="RequiredFieldYourName" 
        runat="server"
        ControlToValidate="yourName"
        Display="None"
        ErrorMessage="Please enter your name"
        Text=""
        ValidateEmptyText="true" 
        onservervalidate="RequiredFieldYourName_ServerValidate"></asp:CustomValidator>
        
    <asp:CustomValidator ID="RequiredFieldYourEmail" 
        runat="server"
        ControlToValidate="yourEmail"
        Display="None"
        ErrorMessage="Please enter your email"
        Text=""
        ValidateEmptyText="true" 
        onservervalidate="RequiredFieldYourEmail_ServerValidate"></asp:CustomValidator>
  
    <asp:CustomValidator ID="CheckFriendEmail" 
        runat="server"
        ControlToValidate="friendsEmail"
        Display="None"
        ErrorMessage="Please enter a valid email address for your friend"
        Text=""
        ValidateEmptyText="false" 
        onservervalidate="CheckFriendEmail_ServerValidate"></asp:CustomValidator>
        
    <asp:CustomValidator ID="CheckYourEmail" 
        runat="server"
        ControlToValidate="yourEmail"
        Display="None"
        ErrorMessage="Please enter a valid email address for you"
        Text=""
        ValidateEmptyText="false"
        onservervalidate="CheckYourEmail_ServerValidate"></asp:CustomValidator>
    
</div>

     

<div id="Error" runat="server" visible="false">
    <asp:Label ID="errorMessage" runat="server" Text=""></asp:Label>
</div>

<div id="ThankYou" runat="server" visible="false">
    <h2 class="flashHeader">
        <asp:Literal ID="thankyouHeader" runat="server"></asp:Literal>  
    </h2>
        
    <asp:Literal ID="thankyouMessage" runat="server"></asp:Literal>    
</div>