using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using umbraco.presentation.nodeFactory;

public partial class usercontrols_website_BlogSubscribe : System.Web.UI.UserControl
{
    protected string BlogId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Node currentNode = Node.GetCurrent();
            BlogId = currentNode.Id.ToString();

            if (currentNode.NodeTypeAlias == "BlogPost")
            {
                phForward.Visible = true;
            }
        }
    }
}
