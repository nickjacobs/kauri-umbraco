<%@ WebHandler Language="C#" Class="BlogForwardHandler" %>

using System;
using System.Web;
using System.Configuration;
using umbraco.presentation.nodeFactory;
using Umlaut.Umb.Blog;

public class BlogForwardHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        
        int blogId;
        if (!string.IsNullOrEmpty(context.Request.Form["blogid"]) &&
            int.TryParse(context.Request.Form["blogid"], out blogId) &&
            !string.IsNullOrEmpty(context.Request.Form["name"]) &&
            !string.IsNullOrEmpty(context.Request.Form["email"]) &&
            BKA.Validation.Validator.IsValidEmail(context.Request.Form["email"]) &&
            !string.IsNullOrEmpty(context.Request.Form["emails"]))
        {
            Node node = new Node(blogId);

            string from = context.Request.Form["email"];
            string to;
            string subject = "BKA blog article: " + node.Name;
            string body;
            string emailTemplate = IOHelper.ReadFile(context.Server.MapPath("/App_Data/EmailTemplates/Generic.html"));
            emailTemplate = emailTemplate.Replace("{Title1}", "bka blog");
            emailTemplate = emailTemplate.Replace("{SiteURL}", ConfigurationManager.AppSettings["SiteURL"]);

            string[] emails = context.Request.Form["emails"].Split(',');
            foreach (string email in emails)
            {
                if (BKA.Validation.Validator.IsValidEmail(email))
                {
                    to = email;
                    body = string.Format(@"
<p style=""margin:0;color:#999;"">Hi there,</p>
<p style=""margin:0;color:#999;"">{0} thought you might be interested in reading this blog post:</p>
<p style=""margin:0;color:#999;"">&nbsp;</p>
<p style=""font:36px/36px Arial, Helvetica, sans-serif; color:#09F; margin:0 0 22px 0;"">{1}</p>
<p style=""margin: 0;"">{2}</p>
<p style=""margin: 0""><a style=""margin: 0; font: 14px Arial, Helvetica, sans-serif; color: #09F;"" href=""{3}"">read article</a></p>",
          HttpUtility.HtmlEncode(context.Request.Form["name"]),
          HttpUtility.HtmlEncode(node.Name),
          HttpUtility.HtmlEncode(node.GetProperty("introText").Value),
          ConfigurationManager.AppSettings["SiteURL"].TrimEnd('/') + umbraco.library.NiceUrl(node.Id));
                    body = emailTemplate.Replace("{Content}", body);
                    Email.SendEmail(from, to, subject, body);
                }
            }
            context.Response.Write("Success");
        }
        else
        {
            context.Response.Write("Error:missing or invalid post parameters");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}