using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using umbraco.presentation.nodeFactory;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for Sitemap
/// </summary>
public partial class Sitemap : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        sitemap();
    }

    public void sitemap()
    {
        StringBuilder str = new StringBuilder();
        Node parent = new Node(1244);

        str.Append("<ul>");
        foreach (Node child in parent.Children)
        {
            str.AppendFormat("<li><a href={0}>{1}</a></li>", umbraco.library.NiceUrl(child.Id), child.Name);
            if (child.Children != null && child.Id != 1328 && child.Id != 1289)
            {
                str.Append("<ul><br/>");
                foreach (Node grandChild in child.Children)
                {
                    str.AppendFormat("<li><a href={0}>{1}</a></li>", umbraco.library.NiceUrl(grandChild.Id), grandChild.Name);
                }
                
                str.Append("</ul>");
            }

        }
        str.Append("</ul><br/>");
        litSitemap.Text = str.ToString();
    }
}