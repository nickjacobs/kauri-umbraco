<%@ Control Language="C#" Debug="false" AutoEventWireup="true" CodeFile="ContactForm_logs.ascx.cs" Inherits="umbracowebsitewizard_site.Usercontrols.ContactForm_logs" %>

<link href="/usercontrols/dashboards/log.css" rel="stylesheet" type="text/css" />
<script src="/usercontrols/dashboards/log_script.js" type="text/javascript"></script>

<div class="container contact">
    <div id="xsltResultsDiv" class="xsltResults left" runat="server">
        
    </div>
    <div class="displayLog left">
        <strong>Name:</strong> <span class="name"></span><br />
        <strong>Address Line 1:</strong> <span class="addressLine1"></span><br />
        <strong>Address Line 2:</strong> <span class="addressLine2"></span><br />
        <strong>Email:</strong> <span class="email"></span><br />
        <strong>Message:</strong> <span class="message"></span><br />
    </div>
</div>
