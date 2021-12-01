using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class usercontrols_website_BlogSearch : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            tbSearch.Attributes["onkeypress"] = "PostBackOnReturn(event, '" + lbSearch.ClientID.Replace('_', '$').Replace("BlogSearch$", "BlogSearch_") + "')";
        }
    }

    protected void lbSearch_Click(object sender, EventArgs e)
    {
        if (tbSearch.Text.Trim() != string.Empty)
        {
            string searchQuery = tbSearch.Text;
            Response.Redirect("/blogsearchresults.aspx?search=" + searchQuery);
        }
    }
}
