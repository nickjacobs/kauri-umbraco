using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using umbraco.BusinessLogic;
using umbraco.cms.businesslogic.web;
using umbraco.presentation.nodeFactory;

public partial class masterpages_Unsubscribe : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (!string.IsNullOrEmpty(Request.QueryString["service"]) &&
                (Request.QueryString["service"].Trim().ToLower() == "blogcomments" || Request.QueryString["service"].Trim().ToLower() == "blog") &&
                !string.IsNullOrEmpty(Request.QueryString["id"]) &&
                BKA.Validation.Validator.IsGuid(Request.QueryString["id"]))
            {
                using (SqlConnection sqlConnection = new SqlConnection(ConfigurationManager.AppSettings["umbracoDbDSN"]))
                {
                    sqlConnection.Open();

                    string strCommand = "";
                    if (Request.QueryString["service"].Trim().ToLower() == "blogcomments")
                    {
                        strCommand = @"
UPDATE utBlogCommentSubscription
SET Subscribed=0
WHERE Id=@id";
                    }
                    else if (Request.QueryString["service"].Trim().ToLower() == "blog")
                    {
                        strCommand = @"
UPDATE utBlogUpdateSubscription
SET Subscribed=0
WHERE Id=@id";
                    }

                    if (strCommand != "")
                    {
                        SqlCommand command = new SqlCommand(strCommand, sqlConnection);
                        command.CommandType = CommandType.Text;
                        command.Parameters.AddWithValue("@id", new Guid(Request.QueryString["id"]));
                        command.ExecuteNonQuery();
                        command.Dispose();
                    }
                }

                litContent.Text = "<p>You have been unsubscribed</p>";
            }
            else
            {
                litContent.Text = "<p>There was an error while attempting to unsubscribe you. <br />Please contact us.</p>";
            }
        }
    }
}
