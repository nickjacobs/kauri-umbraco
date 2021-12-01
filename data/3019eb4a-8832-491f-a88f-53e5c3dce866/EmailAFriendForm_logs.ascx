<%@ Control Language="C#" Debug="false" AutoEventWireup="true" CodeFile="EmailAFriendForm_logs.ascx.cs" Inherits="umbracowebsitewizard_site.Usercontrols.EmailAFriendForm_logs" %>

<link href="/usercontrols/dashboards/log.css" rel="stylesheet" type="text/css" />
<script src="/usercontrols/dashboards/log_script.js" type="text/javascript"></script>

<div class="container emailAFriend">
    <div id="xsltResultsDiv" class="xsltResults left" runat="server">
        
    </div>
    <div class="displayLog left">
        <strong>URL:</strong> <span class="url"></span><br />
        <strong>Friend Name:</strong> <span class="friendName"></span><br />
        <strong>Friend Email:</strong> <span class="friendEmail"></span><br />
        <strong>Your Name:</strong> <span class="yourName"></span><br />
        <strong>Your Email:</strong> <span class="yourEmail"></span><br />
        <strong>Message:</strong> <span class="message"></span>
    </div>
</div>
