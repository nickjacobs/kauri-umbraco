using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KKSClasses;


public partial class usercontrols_dashboards_ListDownloads : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {       
        downloadList.DataSource = KKSClasses.EmailToDB.ListAllDownloads();
        downloadList.DataBind();
    }
}