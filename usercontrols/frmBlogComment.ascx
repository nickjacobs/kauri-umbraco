<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="frmBlogComment.ascx.cs" Inherits="Umlaut.Umb.Blog.frmBlogComment" %>

<div class="commentFormContainer" id="commentform">
    <label>
        <textarea rows="5" cols="5" id="tbMessage" runat="server" class="comment">Comment</textarea>
    </label>
    <div class="clearer"></div>
    <label for="<%= tbName.ClientID %>" class="half left">
        <asp:TextBox ID="tbName" runat="server" Text="Name is required" class="commentorName"></asp:TextBox>
    </label>
    <label for="<%= tbEmail.ClientID %>" class="half">
        <asp:TextBox ID="tbEmail" runat="server" Text="Email is required but not published" class="commentorEmail"></asp:TextBox>
    </label>
<%--    <label for="<%= tbWebsite.ClientID %>" class="half left">
        <asp:TextBox ID="tbWebsite" runat="server" Text="Your Website URL (optional)" class="commentorEmail"></asp:TextBox>
    </label>
    <label class="checkLabel" for="subscribe">
        <input type="checkbox" name="subscribe" id="subscribe" />
        <span>Subscribe to comments</span>
    </label>--%>
    <div class="clearer"></div>
    <asp:LinkButton ID="lbSubmit" runat="server" OnClick="lbSubmit_Click" CssClass="buttonSend">Submit</asp:LinkButton>
    <div class="clearer"></div>
    <div id="validationMessage" class="validationMessage">
                
    </div>
    <asp:PlaceHolder ID="phError" runat="server" Visible="false">
        <p class="error"><asp:Literal ID="litError" runat="server"></asp:Literal></p>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="phSuccess" runat="server" Visible="false">
        <div class="success">
            <asp:Literal ID="litSuccessMessage" runat="server"></asp:Literal>
        </div>
        <div class="clearer"></div>
    </asp:PlaceHolder>
</div>


<script type="text/javascript">                
    $(document).ready(function() {      
        var valid = new validator();
        valid.applyFormValidation({
            validationMessages: $("#validationMessage"),
            fieldErrorClass: "errorState",
            submitButton: $("#<%= lbSubmit.ClientID %>"),
            doPostback: function(){<%= Page.GetPostBackClientEvent(lbSubmit, "") %>},
            fields: [
                { type: "required", control: $("#<%= tbMessage.ClientID %>"), msg: "A comment is required", dt: "Comment" },
                { type: "required", control: $("#<%= tbName.ClientID %>"), msg: "Your name is required", dt: "Name is required" },                
                { type: "regex", control: $("#<%= tbEmail.ClientID %>"), msg: "A valid email is required", dt: "Email is required but not published", expression: /^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/ }               
            ]
        });
        $(".replyBtn").click(blogReplyClicked);
    });
</script>
<asp:PlaceHolder ID="phErrorScript" runat="server" Visible="false">
<script type="text/javascript">
    window.location.hash = '#commentform';
</script>
</asp:PlaceHolder>
