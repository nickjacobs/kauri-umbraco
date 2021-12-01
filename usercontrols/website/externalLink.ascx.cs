using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using umbraco;
using umbraco.presentation.nodeFactory;

namespace umbracowebsitewizard_site.Usercontrols
{
    public partial class ExternalLink : System.Web.UI.UserControl
    {
        #region Properties from Umbraco

            private string _LinkTarget;

            public string LinkTarget
            {
                get
                {
                    return _LinkTarget;
                }
                set
                {
                    _LinkTarget = value;
                }
            }

        #endregion

            #region PageEvents

            protected void Page_Load(object sender, EventArgs e)
            {
                Node currentNode = Node.GetCurrent();

                string sTarget = currentNode.GetProperty("linkTarget").Value.ToString();
                if (sTarget.IndexOf("http") != 0)
                    sTarget = "http://" + sTarget;

                //litDebug.Text = sTarget;
                Response.Redirect(sTarget);

            }


            #endregion




    }
}
