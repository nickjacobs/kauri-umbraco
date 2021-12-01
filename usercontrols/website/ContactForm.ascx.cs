using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

// Extra Namespaces we have imported
using System.Net;
using System.Net.Mail;
using System.Net.Configuration;
using System.Text.RegularExpressions;
using System.Configuration;
using System.Web.Configuration;
using System.Xml;
using System.Text;
using System.IO;

using umbraco;
using umbraco.presentation.nodeFactory;

public partial class UserControls_Website_ContactForm : System.Web.UI.UserControl
{
    #region Properties from Umbraco

    private string _EmailTo, _EmailSubject, _EmailBody, _EmailReplyFrom, _EmailReplySubject, _EmailReplyBody, _ThankYouMessageText;
    private bool _EnableSSL;

    public string EmailTo
    {
        get
        {
            return _EmailTo;
        }
        set
        {
            _EmailTo = value;
        }
    }

    public string EmailSubject
    {
        get
        {
            return _EmailSubject;
        }
        set
        {
            _EmailSubject = value;
        }
    }

    public string EmailBody
    {
        get
        {
            return _EmailBody;
        }
        set
        {
            _EmailBody = value;
        }
    }

    public string EmailReplyFrom
    {
        get
        {
            return _EmailReplyFrom;
        }
        set
        {
            _EmailReplyFrom = value;
        }
    }

    public string EmailReplySubject
    {
        get
        {
            return _EmailReplySubject;
        }
        set
        {
            _EmailReplySubject = value;
        }
    }

    public string EmailReplyBody
    {
        get
        {
            return _EmailReplyBody;
        }
        set
        {
            _EmailReplyBody = value;
        }
    }

    public string ThankYouMessageText
    {
        get
        {
            return _ThankYouMessageText;
        }
        set
        {
            _ThankYouMessageText = value;
        }
    }

    public bool EnableSSL
    {
        get
        {
            return _EnableSSL;
        }
        set
        {
            _EnableSSL = value;
        }
    }

    #endregion

    #region PageEvents

    protected void Page_Load(object sender, EventArgs e)
    {

    }


    public void lbSend_Click(object sender, EventArgs e)
    {
        if (isValid())
        {
            string strEmailFrom, strEmailTo, strEmailSubject, strEmailBody, strTime, strDate;

            strEmailFrom = tbEmail.Text;   //The email will be sent from the address the user typed in the form.
            strEmailTo = EmailTo;
            strEmailSubject = EmailSubject;
            strTime = String.Format("{0:HH:mm:ss}", DateTime.Now);
            strDate = String.Format("{0:dd/MM/yyyy}", DateTime.Now);
            strEmailBody = parseBody(EmailBody);

            SmtpClient mySMTPClient = new SmtpClient();
            if (EnableSSL)
            {
                mySMTPClient.EnableSsl = true;
            }

            /*
            ===============================================================
            TRY to send email using the web.config settings to site owner
            ===============================================================
            */
            try
            {
                MailMessage mm = new MailMessage(strEmailFrom, strEmailTo, strEmailSubject, strEmailBody);
                mm.IsBodyHtml = true;
                mySMTPClient.Send(mm);

                phForm.Visible = false;
                phError.Visible = false;
                phSuccess.Visible = true;
                litSuccess.Text = ThankYouMessageText;
            }
            catch (SmtpException ex)
            {
                phForm.Visible = false;
                phError.Visible = true;
                phSuccess.Visible = false;
                litError.Text = "An error had occurred. Please try again later.";

                //If we fail to send email immediately stop runnning code
                return;
            }

            /*
            ====================================================================================
            Now the email is sent out to the owner, lets send out an email
            to let the user know we have recieved their email & will respond shortly
            ====================================================================================
            */
            string strEmailReplyFrom, strEmailReplySubject, strEmailReplyBody;

            strEmailReplyFrom = EmailReplyFrom;
            strEmailReplySubject = EmailReplySubject;
            strEmailReplyBody = EmailReplyBody;
            strEmailReplyBody = parseBody(strEmailReplyBody);
            try
            {
                MailMessage mm = new MailMessage(strEmailReplyFrom, strEmailFrom, strEmailReplySubject, strEmailReplyBody);
                mm.IsBodyHtml = true;
                mySMTPClient.Send(mm);

                phForm.Visible = false;
                phError.Visible = false;
                phSuccess.Visible = true;
            }

            catch (SmtpException ex)
            {
                //don't care if email fails to send to user
            }

            /*
            ========================================================
            Log the item to the XML file
            ========================================================
            */
            logItem(tbFirstName.Text + " " + tbLastName.Text, tbEmail.Text, strEmailBody);
        }
    }


    private void logItem(string strName, string strEmail, string strMessage)
    {
        string strTime = String.Format("{0:HH:mm:ss}", DateTime.Now);
        string strDate = String.Format("{0:dd/MM/yyyy}", DateTime.Now);

        string filePath = Server.MapPath("~/data/contact_form_log.xml");

        //Check if XML file exists
        if (!File.Exists(filePath))
        {
            //XML file DOES not exist yet.

            // Create a new XmlTextWriter instance
            XmlTextWriter writer = new XmlTextWriter(filePath, Encoding.UTF8);

            //Set the XML writer to indent the XML as opposed to all one line.
            writer.Formatting = Formatting.Indented;

            // start writing XML!
            writer.WriteStartDocument();

            // Create the <logs> root XML node
            writer.WriteStartElement("logs");

            // Creating the <log> node
            writer.WriteStartElement("log");

            // Adding the time attribute to the <log> node. <log time="14:52:23">
            writer.WriteAttributeString("time", strTime);

            // Adding the date attribute to the <log> node. <log time="14:52:23" date="22/02/2009">
            writer.WriteAttributeString("date", strDate);


            /*
            ========================================================
            Add the <field alias="name"> node
            ========================================================
            */

            // Creating the <field> node inside the <log> node
            writer.WriteStartElement("field");

            //Add the alias attribute to the <field> node. <field alias="name">
            writer.WriteAttributeString("alias", "name");

            //Write value of the field node.
            writer.WriteString(strName);

            //Close the <field> node inside the <log> node
            writer.WriteEndElement();


            /*
            ========================================================
            Add the <field alias="email"> node
            ========================================================
            */

            // Creating the <field> node inside the <log> node
            writer.WriteStartElement("field");

            //Add the alias attribute to the <field> node. <field alias="email">
            writer.WriteAttributeString("alias", "email");

            //Write value of the field node.
            writer.WriteString(strEmail);

            //Close the <field> node inside the <log> node
            writer.WriteEndElement();


            /*
            ========================================================
            Add the <field alias="question"> node
            ========================================================
            */
            // Creating the <field> node inside the <log> node
            writer.WriteStartElement("field");

            //Add the alias attribute to the <field> node. <field alias="question">
            writer.WriteAttributeString("alias", "question");

            //Write value of the field node, wrapped inside a CData tag
            writer.WriteCData(strMessage);

            //Close the <field> node inside the <log> node
            writer.WriteEndElement();



            //Close the <log> node
            writer.WriteEndElement();

            //Close the <logs> node
            writer.WriteEndDocument();

            //Stop using the XML writer & close the XML file.
            writer.Close();

        }
        else
        {
            //XML file already exists so lets add to the XML file.

            //Open up the XML file we already have.
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.Load(filePath);


            //Create a new XML <log> node
            XmlElement logNode = xmlDoc.CreateElement("log");

            // Adding the time attribute to the <log> node. <log time="14:52:23">
            logNode.SetAttribute("time", strTime);

            // Adding the date attribute to the <log> node. <log time="14:52:23" date="22/02/2009">
            logNode.SetAttribute("date", strDate);

            /*
            ========================================================
            Add the <field alias="name"> node
            ========================================================
            */

            //Create a new xml <field> node
            XmlElement fieldNodeName = xmlDoc.CreateElement("field");

            //Add the alias attribute to the <field> node. <field alias="name">
            fieldNodeName.SetAttribute("alias", "name");

            //Write value of the field node.
            fieldNodeName.InnerText = strName;

            //Add our <field> node to our <log> node
            logNode.AppendChild(fieldNodeName);


            /*
            ========================================================
            Add the <field alias="email"> node
            ========================================================
            */

            //Create a new xml <field> node
            XmlElement fieldNodeEmail = xmlDoc.CreateElement("field");

            //Add the alias attribute to the <field> node. <field alias="email">
            fieldNodeEmail.SetAttribute("alias", "email");

            //Write value of the field node.
            fieldNodeEmail.InnerText = strEmail;

            //Add our <field> node to our <log> node
            logNode.AppendChild(fieldNodeEmail);


            /*
            ========================================================
            Add the <field alias="question"> node
            ========================================================
            */

            //Create a new xml <field> node
            XmlElement fieldNodeMessage = xmlDoc.CreateElement("field");

            //Add the alias attribute to the <field> node. <field alias="question">
            fieldNodeMessage.SetAttribute("alias", "question");

            //Create a CDATA section that wraps the message text
            XmlCDataSection fieldNodeCData = xmlDoc.CreateCDataSection(strMessage);

            //Add our cdata tag/node to our <field> node
            fieldNodeMessage.AppendChild(fieldNodeCData);

            //Add our <field> node to our <log> node
            logNode.AppendChild(fieldNodeMessage);



            //Add our built up logNode that contains our <field> nodes to the main xml document
            xmlDoc.SelectSingleNode("/logs").AppendChild(logNode);

            xmlDoc.Save(filePath);
        }

    }

    #endregion

    #region Validation
    private bool isValid()
    {
        //reset errors
        phValidationError.Visible = false;
        litValidationError.Text = "";
        tbFirstName.CssClass = "inputText";
        tbLastName.CssClass = "inputText";
        tbEmail.CssClass = "inputText";
        tbQuestion.CssClass = "";

        //validation
        bool isValid = true;

        //Check fields
        checkRequired(ref tbFirstName, ref isValid, "Please enter your First Name");
        checkRequired(ref tbLastName, ref isValid, "Please enter your Last Name");
        if (checkRequired(ref tbEmail, ref isValid, "Please enter your Email Address"))
            checkEmail(ref tbEmail, ref isValid, "The enter a valid Email Address");
        checkRequired(ref tbQuestion, ref isValid, "Please enter your Question");

        if (!isValid)
        {
            phValidationError.Visible = true;
        }

        return isValid;
    }

    private bool checkEmail(ref TextBox tb, ref bool isValid, string errorMessage)
    {
        if (!Regex.IsMatch(tb.Text, @"^([\w\d\-_]+)(\.[\w\d\-_]+)*@([\w\d\-_]+\.)([\w\d\-_]+\.)*([\w]{2,3})$"))
        {
            tb.CssClass = "inputText error";
            isValid = false;
            litValidationError.Text = string.Concat(litValidationError.Text, errorMessage + "<br/>");
            return false;
        }
        return true;
    }

    private bool checkRequired(ref TextBox tb, ref bool isValid, string errorMessage)
    {
        if (tb.Text.Trim() == "")
        {
            tb.CssClass = "inputText error";
            isValid = false;
            litValidationError.Text = string.Concat(litValidationError.Text, errorMessage + "<br/>");
            return false;
        }
        return true;
    }

    private string parseBody(string body)
    {
        body = body.Replace("\r\n", "\r").Replace("\n", "\r").Replace("\r", "<br/>");
        body = body.Replace("[FirstName]", tbFirstName.Text);
        body = body.Replace("[LastName]", tbLastName.Text);
        body = body.Replace("[Email]", tbEmail.Text);
        body = body.Replace("[Question]", umbraco.library.ReplaceLineBreaks(tbQuestion.Text));
        body = body.Replace("[Date]", DateTime.Now.ToShortDateString());
        body = body.Replace("[Time]", DateTime.Now.ToShortTimeString());
        body = "<html><body>" + body + "</body></html>";
        return body;

    }

    #endregion

}
