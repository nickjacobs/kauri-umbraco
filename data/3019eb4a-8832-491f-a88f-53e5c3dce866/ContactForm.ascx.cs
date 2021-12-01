using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
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

namespace umbracowebsitewizard_site.Usercontrols
{
    public partial class ContactForm : System.Web.UI.UserControl
    {

        #region Properties from Umbraco

        private string _EmailTo, _EmailSubject, _EmailBody, _EmailReplyFrom, _EmailReplySubject, _EmailReplyBody, _FormHeader, _FormText, _ThankYouHeaderText, _ThankYouMessageText;
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

            public string FormHeader
            {
                get
                {
                    return _FormHeader;
                }
                set
                {
                    _FormHeader = value;
                }
            }

            public string FormText
            {
                get
                {
                    return _FormText;
                }
                set
                {
                    _FormText = value;
                }
            }

            public string ThankYouHeaderText
            {
                get
                {
                    return _ThankYouHeaderText;
                }
                set
                {
                    _ThankYouHeaderText = value;
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
                /*
                ========================================================
                Get the variables from the form and populate the
                literal controls on the usercontrol .ascx file
                ========================================================
                */

                // Get the currentNode and call it currentNode
                Node currentNode = Node.GetCurrent();

                /*
                ========================================================
                Build up the formHeader text as follows.
                The node name in strong to make it pink in sIFR and
                then our FormHeaderText from our node we are passing in
                ========================================================
                */
                formHeader.Text = "<strong>" + currentNode.Name + ".</strong> " + umbraco.library.RemoveFirstParagraphTag(FormHeader);

                /*
                ========================================================
                We are just settig formText to be equal to our property 
                from our macro to FormText
                ========================================================
                */
                umbraco.library.RemoveFirstParagraphTag(formText.Text = FormText);
            }

            public void btnSubmit_Click(object sender, EventArgs e)
            {

                //Proceed only if the vaidation is successfull
                if (!Page.IsValid)
                {
                    //Stop everything we are doing and exit.
                    return;
                }


                /*
                ========================================================
                Get the variables from the form and set them in strings
                ========================================================
                */

                string strName, strAddressLine1, strAddressLine2, strMessage;

                strName = name.Text;
                strAddressLine1 = addressLine1.Text;
                strAddressLine2 = addressLine2.Text;
                strMessage = message.Text;


                /*
                ========================================================
                Lets set the values passed in from the Macro
                ========================================================
                */

                string strEmailFrom, strEmailTo, strEmailSubject, strEmailBody, strTime, strDate;

                strEmailFrom = emailAddress.Text;   //The email will be sent from the address the user typed in the form.
                strEmailTo = EmailTo;
                strEmailSubject = EmailSubject;
                strTime = String.Format("{0:HH:mm:ss}", DateTime.Now);
                strDate = String.Format("{0:dd/MM/yyyy}", DateTime.Now);

                /*
                ========================================================
                Lets Replace the placeholders in the email message body
                ========================================================
                */
                strEmailBody = EmailBody;


                /*
                ========================================================
                Find and Replace [Name]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[Name]", strName);


                /*
                ========================================================
                Find and Replace [AddressLine1]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[AddressLine1]", strAddressLine1);

                /*
                ========================================================
                Find and Replace [AddressLine2]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[AddressLine2]", strAddressLine2);

                /*
                ========================================================
                Find and Replace [Email]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[Email]", strEmailFrom);

                /*
                ========================================================
                Find and Replace [Message]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[Message]", strMessage);

                /*
                ========================================================
                Find and Replace [Time]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[Time]", strTime);

                /*
                ========================================================
                Find and Replace [Date]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[Date]", strDate);


                /*
                ===========================================================
                Lets setup the SMTP client using settings from web.config
                ===========================================================
                */
                SmtpClient mySMTPClient = new SmtpClient();

                //If EnableSSL set to true lets enable it on our SMTP object.
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
                    // Send email (From email address, Recipients email address, Email Subject, Email Message)
                    mySMTPClient.Send(strEmailFrom, strEmailTo, strEmailSubject, strEmailBody);

                }
                catch (SmtpException ex)
                {
                    //If mail fails to send for any reason
                    errorMessage.Text = ex.Message;
                    ErrorMailSettings.Visible = true;
                    FormFields.Visible = true;

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



                /*
                ========================================================
                Find and Replace [Name]
                ========================================================
                */
                strEmailReplyBody = strEmailReplyBody.Replace("[Name]", strName);



                try
                {
                    // Send email (From email address, Recipients email address, Email Subject, Email Message)
                    mySMTPClient.Send(strEmailReplyFrom, strEmailFrom, strEmailReplySubject, strEmailReplyBody);

                }

                catch (SmtpException ex)
                {
                    //If mail fails to send for any reason
                    errorMessage.Text = ex.Message;
                    ErrorMailSettings.Visible = true;
                    FormFields.Visible = true;

                    //If we fail to send email immediately stop runnning code
                    return;
                }

                /*
                ========================================================
                Log the item to the XML file
                ========================================================
                */
                logItem(strName, strAddressLine1, strAddressLine2, strEmailFrom, strMessage);


                /*
                ========================================================
                Set Thankyou text from our contact node in our 
                hidden thankyou DIV
                ========================================================
                */                
                thankyouHeader.Text = ThankYouHeaderText;
                thankyouMessage.Text = ThankYouMessageText;

                /*
                ========================================================
                Hide & Show div's to show our thankyou message
                ========================================================
                */
                FormFields.Visible = false;         //Hide the FormFields DIV
                ErrorMailSettings.Visible = false;  //Hide the errormessage DIV
                ThankYou.Visible = true;            //SHOW our thankyou message DIV
            }


            //Call this to log the contact form to XML file.
            private void logItem(string strName, string strAddressLine1, string strAddressLine2, string strEmail, string strMessage)
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
                            Add the <field alias="addressLine1"> node
                            ========================================================
                            */

                            // Creating the <field> node inside the <log> node
                            writer.WriteStartElement("field");

                            //Add the alias attribute to the <field> node. <field alias="addressLine1">
                            writer.WriteAttributeString("alias", "addressLine1");

                                //Write value of the field node.
                                writer.WriteString(strAddressLine1);

                            //Close the <field> node inside the <log> node
                            writer.WriteEndElement();


                            /*
                            ========================================================
                            Add the <field alias="addressLine2"> node
                            ========================================================
                            */

                            // Creating the <field> node inside the <log> node
                            writer.WriteStartElement("field");

                            //Add the alias attribute to the <field> node. <field alias="addressLine2">
                            writer.WriteAttributeString("alias", "addressLine2");

                                //Write value of the field node.
                                writer.WriteString(strAddressLine2);

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
                            Add the <field alias="message"> node
                            ========================================================
                            */
                            // Creating the <field> node inside the <log> node
                            writer.WriteStartElement("field");

                            //Add the alias attribute to the <field> node. <field alias="message">
                            writer.WriteAttributeString("alias", "message");

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
                        Add the <field alias="addressLine1"> node
                        ========================================================
                        */

                        //Create a new xml <field> node
                        XmlElement fieldNodeAddressLine1 = xmlDoc.CreateElement("field");

                            //Add the alias attribute to the <field> node. <field alias="addressLine1">
                            fieldNodeAddressLine1.SetAttribute("alias", "addressLine1");

                                //Write value of the field node.
                                fieldNodeAddressLine1.InnerText = strAddressLine1;

                        //Add our <field> node to our <log> node
                        logNode.AppendChild(fieldNodeAddressLine1);


                        /*
                        ========================================================
                        Add the <field alias="addressLine2"> node
                        ========================================================
                        */

                        //Create a new xml <field> node
                        XmlElement fieldNodeAddressLine2 = xmlDoc.CreateElement("field");

                            //Add the alias attribute to the <field> node. <field alias="addressLine2">
                            fieldNodeAddressLine2.SetAttribute("alias", "addressLine2");

                                //Write value of the field node.
                                fieldNodeAddressLine2.InnerText = strAddressLine2;

                        //Add our <field> node to our <log> node
                        logNode.AppendChild(fieldNodeAddressLine2);

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
                        Add the <field alias="message"> node
                        ========================================================
                        */

                        //Create a new xml <field> node
                        XmlElement fieldNodeMessage = xmlDoc.CreateElement("field");

                            //Add the alias attribute to the <field> node. <field alias="message">
                            fieldNodeMessage.SetAttribute("alias", "message");

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
            protected void RequiredName_ServerValidate(object source, ServerValidateEventArgs args)
            {
                if (name.Text == String.Empty)
                {
                    name.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    name.CssClass = "";
                    args.IsValid = true;
                }
            }


            protected void RequiredEmailAddress_ServerValidate(object source, ServerValidateEventArgs args)
            {
                if (emailAddress.Text == String.Empty)
                {
                    emailAddress.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    emailAddress.CssClass = "";
                    args.IsValid = true;
                }
            }

            protected void RequiredMessage_ServerValidate(object source, ServerValidateEventArgs args)
            {
                if (message.Text == String.Empty)
                {
                    message.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    message.CssClass = "";
                    args.IsValid = true;
                }
            }

            protected void CheckEmailAddress_ServerValidate(object source, ServerValidateEventArgs args)
            {

                //Email Regex String
                Regex reg = new Regex(@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*");

                // Check if there is NO match in Regex
                if (!reg.IsMatch(emailAddress.Text))
                {
                    //Does not match RegEx - Invalid email address

                    emailAddress.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    emailAddress.CssClass = "";
                    args.IsValid = true;
                }
            }

        #endregion

    }
}

