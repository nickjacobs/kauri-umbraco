﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using umbraco.presentation.nodeFactory;

public partial class usercontrols_website_Community : System.Web.UI.UserControl
{
    protected string Output = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Node currentNode = Node.GetCurrent();
        StringBuilder sb = new StringBuilder();
        foreach (Node childNode in currentNode.Children)
        {

            sb.Append("<div class=\"communityContainer\">");
            sb.Append("<div class=\"communityContainerTitle\">" + HttpUtility.HtmlEncode(childNode.GetProperty("communityTitle").Value) + "</div>");
            sb.Append("<div class=\"communityContainersynopsis\">" + HttpUtility.HtmlEncode(childNode.GetProperty("synopsis").Value) + "..." + "<a class=\"\" href=\"" + childNode.NiceUrl + "\" id=\"communityProject\" >more</a>" +"</div>");
            sb.Append("<div class=\"communityProjectimageContainer\">");
            if (childNode.GetProperty("image").Value != "")
            {
                sb.Append("<img class=\"communityimage\" src=\"/handlers/ImageStream2.ashx?mode=resize&width=205&path=" + MediaHelper.GetFilePath(childNode.GetProperty("image").Value) + "\" />");
            }
            sb.Append("</div>");
            sb.Append("</div>");
        }
        litOutput.Text = sb.ToString();
    }
}