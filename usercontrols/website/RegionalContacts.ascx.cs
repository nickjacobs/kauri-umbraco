using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using umbraco.presentation.nodeFactory;

public partial class usercontrols_website_RegionalContacts : System.Web.UI.UserControl
{
    protected string Output = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Node currentNode = Node.GetCurrent();
        StringBuilder sb = new StringBuilder();
        foreach (Node childNode in currentNode.Children)
        {
        sb.Append("<div class=\"regionalContact\">");
        sb.Append("<div class=\"regionalimageContainer\">");
        if (childNode.GetProperty("image").Value != "")
        {
            sb.Append("<img class=\"regionalContactimage\" src=\"/handlers/ImageStream2.ashx?mode=resize&width=234&path=" + MediaHelper.GetFilePath(childNode.GetProperty("image").Value) + "\" />");
        }
        sb.Append("</div>");
        sb.Append("<div class=\"nameregionalContact\">" + childNode.Name + "</div>");
        sb.Append("<div class=\"positionregionalContact\">" + HttpUtility.HtmlEncode(childNode.GetProperty("position").Value) + "</div>");
        sb.Append("<div class=\"phoneregionalContact\"><span class=\"spanphoneregionalContact\">" + HttpUtility.HtmlEncode(childNode.GetProperty("phone").Value) + "</span></div>");
        sb.Append("<div class=\"emailregionalContact\"><a href=\"" + "mailto:" + childNode.GetProperty("email").Value + "\" class=\"spanemailregionalContact\"> Click here to email </a></div>");
        sb.Append("</div>");

        }
        litOutput.Text = sb.ToString();
    }
}