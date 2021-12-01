<%@ WebHandler Language="C#" Class="BlogCommentReply" %>

using System;
using System.Web;
using System.Net.Mail;
using System.Configuration;
using umbraco.presentation.nodeFactory;
using umbraco.cms.businesslogic.web;

public class BlogCommentReply : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        if (!string.IsNullOrEmpty(context.Request.Form["commentid"]) &&
            !string.IsNullOrEmpty(context.Request.Form["name"]) &&
            !string.IsNullOrEmpty(context.Request.Form["email"]) &&
            !string.IsNullOrEmpty(context.Request.Form["comment"]))
        {
            if (BKA.Validation.Validator.IsInteger(context.Request.Form["commentid"]) &&
                BKA.Validation.Validator.IsValidEmail(context.Request.Form["email"].ToString()))
            {
                try
                {
                    int commentID = int.Parse(context.Request.Form["commentid"]);
                    string name = context.Request.Form["name"];
                    string email = context.Request.Form["email"];
                    string strComment = context.Request.Form["comment"];
                    DocumentType dtComment = DocumentType.GetByAlias("BlogPostComment");

                    Document blogRoot = new Document(int.Parse(ConfigurationManager.AppSettings["Blog.RootId"]));
                    Document newComment = Document.MakeNew("comment by " + name, dtComment, new umbraco.BusinessLogic.User(0), commentID);

                    newComment.getProperty("name").Value = name;
                    newComment.getProperty("email").Value = email;
                    newComment.getProperty("comment").Value = strComment;
                    if (blogRoot.getProperty("IsCommentApprovalRequired").Value.ToString() == "1")
                    {
                        newComment.getProperty("IsApproved").Value = false;
                        //send email to administrator
                        notifyAdmin(blogRoot, commentID, email, name, strComment);
                    }
                    else
                    {
                        newComment.getProperty("IsApproved").Value = true;
                    }                    

                    newComment.Save();
                    newComment.Publish(new umbraco.BusinessLogic.User(0));

                    umbraco.library.UpdateDocumentCache(newComment.Id);

                    if (blogRoot.getProperty("IsCommentApprovalRequired").Value.ToString() == "1")
                    {
                        context.Response.Write("Success:pending approval");
                    }
                    else
                    {
                        context.Response.Write("Success:posted:" + umbraco.library.LongDate(newComment.CreateDateTime.ToString()));
                    }

                    Node parentComment = new Node(commentID);

                    if (blogRoot.getProperty("SendCommentUpdateEmails").Value.ToString().Trim() == "1")
                    {
                        Umlaut.Umb.Blog.BlogComment.Notify(name, email, parentComment.Parent.Id, strComment, true);
                    }
                }
                catch (Exception ex)
                {
                    context.Response.Write("Error:" + ex.Message + "\r" + ex.StackTrace);
                }
            }
            else
            {
                context.Response.Write("Error:validation error");
            }
        }
        else
        {
            context.Response.Write("Error:missing querystring");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void notifyAdmin(Document blogRoot, int commentID, string emailFrom, string name, string comment)
    {
        Node currentBlog = new Node(commentID).Parent;

        string emailTo = blogRoot.getProperty("AdminEmail").Value.ToString();
        string emailSubject = blogRoot.getProperty("CommentEmailSubject").Value.ToString();
        string emailBody = blogRoot.getProperty("CommentEmailBody").Value.ToString();
        emailBody = emailBody.Replace("[Name]", name);
        emailBody = emailBody.Replace("[Email]", emailFrom);
        emailBody = emailBody.Replace("[BlogName]", currentBlog.Name);
        emailBody = emailBody.Replace("[BlogDate]", DateTime.Parse(currentBlog.GetProperty("Date").Value).ToString("d MMM yyyy"));
        emailBody = emailBody.Replace("[Comment]", comment);

        MailMessage mm = new MailMessage(emailFrom, emailTo, emailSubject, emailBody);
        mm.IsBodyHtml = false;
        SmtpClient smtp = new SmtpClient();
        smtp.Send(mm);

        mm.Dispose();
    }
}