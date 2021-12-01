<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegisterForm.ascx.cs" Inherits="usercontrols_website_RegisterForm" %>
<div id="formModal">
    <%--<a href="#" id="btnCloseForm"></a>--%>
    <asp:Literal ID="ltClose" runat="server"></asp:Literal>
    <div class="registrationForm">
        <h1>Registration form</h1>
        <input id="regFirstName" placeholder="First name" class="required" />
        <input id="regLastName" placeholder="Last name" class="required" />
        <input id="regEmail"  placeholder="Email" class="required" />
        <input id="regAddress" placeholder="Address" class="required" />
        <input id="regCity" placeholder="City" class="required" />
        <%--<h4>Catering requirements</h4>
        <div class="requiredCheckbox">
            <div class="container">
                <a href="#" class="checkbox" id="ckVegetarian"></a><span>Vegetarian</span>
            </div>
            <div class="container">
                <a href="#" class="checkbox" id="ckGlutenFree"></a><span>Gluten Free</span>
            </div>
        </div>

        <h4>Select which day (or days)</h4>
        <div class="requiredCheckbox">
            <div class="container">
                <a href="#" class="checkbox" id="ckDay1"></a><span>Day 1 - kauri Dieback Symoosium</span>
            </div>
            <div class="container">
                <a href="#" class="checkbox" id="ckDay2"></a><span>Day 2 - Tree Injection Demostration</span>
            </div>
        </div>--%>
        <asp:Literal ID="ltCategories" runat="server"></asp:Literal>
        <textarea id="regMessage" placeholder="Please submit any questions/issues you would like discussed (optional)" ></textarea>
        <p id="pInfo" style="display:none;">test</p>
        <a href="javascript:void(0)" class="btnRegister"></a>
    </div>
</div>