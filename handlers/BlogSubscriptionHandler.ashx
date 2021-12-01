<%@ WebHandler Language="C#" Class="BlogSubscriptionHandler" %>

using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Web;
using System.Configuration;

public class BlogSubscriptionHandler : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        if (!string.IsNullOrEmpty(context.Request.Form["email"]) &&
            BKA.Validation.Validator.IsValidEmail(context.Request.Form["email"]))
        {
            using (SqlConnection sqlConnection = new SqlConnection(ConfigurationManager.AppSettings["umbracoDbDSN"]))
            {
                sqlConnection.Open();

                string strCommand = @"
DECLARE @count int
SELECT @count=COUNT(*)
FROM utBlogUpdateSubscription
WHERE Email=@email
	
IF @count=0
BEGIN
	INSERT INTO utBlogUpdateSubscription
	(      Id,      Email, Subscribed)
	VALUES(NEWID(),@email, 1)
END";

                SqlCommand command = new SqlCommand(strCommand, sqlConnection);
                command.CommandType = CommandType.Text;
                command.Parameters.AddWithValue("@email", context.Request.Form["email"]);
                command.ExecuteNonQuery();
                command.Dispose();
            }
            
            context.Response.Write("Success");
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

}