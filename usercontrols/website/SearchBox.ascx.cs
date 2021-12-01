using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace umbracowebsitewizard_site.Usercontrols
{
    public partial class SearchBox : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            //Check if search querystring is present in URL.
            //string searchQuerystring = Request.QueryString["search"];

            //if (searchQuerystring != String.Empty)
            //{
            //    searchText.Text = searchQuerystring;
            //}

        }

        public void btnSearch_Click(object sender, EventArgs e)
        {
            string searchQuery = searchText.Text;
            Response.Redirect("/CWS_search.aspx?search=" + searchQuery);
        }
    }
}