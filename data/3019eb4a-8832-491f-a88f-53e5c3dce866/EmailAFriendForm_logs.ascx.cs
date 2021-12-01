using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

// Extra Namespaces we have imported
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.IO;
using System.Text;
using umbraco;

namespace umbracowebsitewizard_site.Usercontrols
{
    public partial class EmailAFriendForm_logs : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string XMLfilePath = Server.MapPath("~/data/email_a_friend_form_log.xml");
            string XSLTfilePath = Server.MapPath("~/data/form_log.xslt");

            //Check if XML file exists
            if (!File.Exists(XMLfilePath))
            {
                xsltResultsDiv.InnerHtml = "<div class='notice'><h2>Warning</h2><p>The email_a_friend_form_log.xml file does not containt any logs or does not exist.</p></div>";
                return;
            }
            else
            {
                //Load the XML doc
                XPathDocument myXMLDoc = new XPathDocument(XMLfilePath);

                XslTransform myXSLT = new XslTransform();

                //Load the XSLT
                myXSLT.Load(XSLTfilePath);


                //Get umbraco.library to work
                XsltArgumentList xslArgs = new XsltArgumentList();
                xslArgs.AddExtensionObject("urn:umbraco.library", new umbraco.library());

                MemoryStream ms = new MemoryStream();
                XmlTextWriter myWriter = new XmlTextWriter(ms, Encoding.UTF8);

                StreamReader rd = new StreamReader(ms);

                //do the actual transform of XML
                myXSLT.Transform(myXMLDoc, xslArgs, myWriter);

                ms.Position = 0;
                string strResult = rd.ReadToEnd();

                rd.Close();
                ms.Close();

                xsltResultsDiv.InnerHtml = strResult;
            }

        }
    }
}

