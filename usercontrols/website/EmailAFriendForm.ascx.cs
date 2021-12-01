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
    public partial class EmailAFriendForm : System.Web.UI.UserControl
    {
        #region Properties from Umbraco

        private string _EmailSubjectToFriend, _EmailMessageToFriend, _EmailFrom, _FormHeader, _ThankYouHeaderText, _ThankYouMessageText;
        private bool _EnableSSL;

            public string EmailSubjectToFriend
            {
                get
                {
                    return _EmailSubjectToFriend;
                }
                set
                {
                    _EmailSubjectToFriend = value;
                }
            }

            public string EmailMessageToFriend
            {
                get
                {
                    return _EmailMessageToFriend;
                }
                set
                {
                    _EmailMessageToFriend = value;
                }
            }

            public string EmailFrom
            {
                get
                {
                    return _EmailFrom;
                }
                set
                {
                    _EmailFrom = value;
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



                //Set these back to empty strings              
                emailLink.NavigateUrl = string.Empty;
                emailLink.Text = string.Empty;


                /*
                ========================================================
                Lets check if an ID is being passed to the 
                page if not display error
                ========================================================
                */

                string strNodeID = Request.QueryString["nodeID"];

                if (strNodeID == string.Empty)
                {
                    /*
                    ========================================================
                    NO nodeID passed in. So display error message
                    ========================================================
                    */
                    
                    //Set the label control text property with an error message.
                    errorMessage.Text = "You are missing a nodeID. Please go back and try again.";

                    //Make the div with ID = error visible
                    Error.Visible = true;

                    //Stop everything we are doing and exit.
                    return;
                }
                else
                {
                    /*
                    ========================================================
                    FOUND an ID in querystring - Lets check its not made up
                    ========================================================
                    */

                    string strCheckForNode = umbraco.library.QueryForNode(strNodeID);

                    if (strCheckForNode == string.Empty)
                    {
                       /*
                        ========================================================
                        Querystring not a valid node ID - show error
                        ========================================================
                        */

                        //Set the label control text property with an error message.
                        errorMessage.Text = "The nodeID does not exist. Please go back and try again.";

                        //Make the div with ID = error visible
                        Error.Visible = true;

                        //Stop everything we are doing and exit.
                        return;
                    }
                }

                //Call BuildLink function with our nodeID querystring
                string strURL = BuildLink(Convert.ToInt32(Request.QueryString["nodeID"]));

                //Set the text with our link we got back from BuildLink that is set in strURL
                emailLink.NavigateUrl = strURL;
                emailLink.Text = strURL;
    
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

                string  strFriendsName, strFriendsEmail, strYourName, strYourEmail, 
                        strEmailSubject, strEmailBody, strMessage, strTime, strDate, strURL;

                strFriendsName = friendsName.Text;      //This is the friends name that the user is sending it to.
                strFriendsEmail = friendsEmail.Text;    //This variable will be used to send the email to.
                
                strYourName = yourName.Text;            //This is the persons name who filled in the form.
                strYourEmail = yourEmail.Text;          //This vairable is used to send as the email 'from'
                strMessage = yourMessage.Text;          //This is the users message to their friend.

                strEmailSubject = EmailSubjectToFriend; //This is the subject line for the email that be sent to the Friend.
                strEmailBody = EmailMessageToFriend;    //This is the main email text that will be sent that has the placeholders in.

                strTime = String.Format("{0:HH:mm:ss}", DateTime.Now);      //This is the current time in format of 17:04:53
                strDate = String.Format("{0:dd/MM/yyyy}", DateTime.Now);    //This is the current date in format of 10/02/2009


                strURL = BuildLink(Convert.ToInt32(Request.QueryString["nodeID"]));


                /*
                ========================================================
                Find and Replace [FriendName]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[FriendName]", strFriendsName);

                /*
                ========================================================
                Find and Replace [FriendEmail]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[FriendEmail]", strFriendsEmail);

                /*
                ========================================================
                Find and Replace [YourName]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[YourName]", strYourName);

                /*
                ========================================================
                Find and Replace [YourEmail]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[YourEmail]", strYourEmail);


                /*
                ========================================================
                Find and Replace [Message]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[Message]", strMessage);


                /*
                ========================================================
                Find and Replace [Date]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[Date]", strDate);

                /*
                ========================================================
                Find and Replace [Time]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[Time]", strTime);


                /*
                ========================================================
                Find and Replace [URL]
                ========================================================
                */
                strEmailBody = strEmailBody.Replace("[URL]", strURL);


                /*
                ========================================================
                Find and Replace [FriendName]
                ========================================================
                */
                strEmailSubject = strEmailSubject.Replace("[FriendName]", strFriendsName);


                /*
                ==============================================================
                Find and Replace [FriendEmail]
                ==============================================================
                */
                strEmailSubject = strEmailSubject.Replace("[FriendEmail]", strFriendsEmail);

                
                /*
                ==============================================================
                Find and Replace [YourName]
                ==============================================================
                */
                strEmailSubject = strEmailSubject.Replace("[YourName]", strYourName);


                /*
                ==============================================================
                Find and Replace [YourEmail]
                ==============================================================
                */
                strEmailSubject = strEmailSubject.Replace("[YourEmail]", strYourEmail);


                /*
                ==============================================================
                Find and Replace [Message]
                ==============================================================
                */
                strEmailSubject = strEmailSubject.Replace("[Message]", strMessage);


                /*
                ==============================================================
                Find and Replace [Date]
                ==============================================================
                */
                strEmailSubject = strEmailSubject.Replace("[Date]", strDate);


                /*
                ==============================================================
                Find and Replace [Time]
                ==============================================================
                */
                strEmailSubject = strEmailSubject.Replace("[Time]", strTime);


                /*
                ==============================================================
                Find and Replace [URL]
                ==============================================================
                */
                strEmailSubject = strEmailSubject.Replace("[URL]", strURL);




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
                    mySMTPClient.Send(EmailFrom, strFriendsEmail, strEmailSubject, strEmailBody);                    
                }
                catch (SmtpException ex)
                {
                    //If mail fails to send for any reason
                    errorMessage.Text = ex.Message;
                    Error.Visible = true;
                    FormFields.Visible = true;

                    //If we fail to send email immediately stop runnning code
                    return;
                }

                /*
                ========================================================
                Log the item to the XML file
                ========================================================
                */
                logItem(strURL, strFriendsName, strFriendsEmail, strYourName, strYourEmail, strMessage);


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
                Error.Visible = false;              //Hide the Error DIV
                ThankYou.Visible = true;            //SHOW our thankyou message DIV

               
            }

            private string BuildLink(int strNodeID)
            {
                Node pageFromNodeID = new Node(strNodeID);
                return "http://" + Request.ServerVariables["SERVER_NAME"] + pageFromNodeID.NiceUrl;    //Set our variable to be the currentPage's URL              
            }

            //Call this to log the email a friend form to XML file.
            private void logItem(string strURL, string strFriendName, string strFriendEmail, string strYourName, string strYourEmail, string strMessage)
            {
                string strTime = String.Format("{0:HH:mm:ss}", DateTime.Now);
                string strDate = String.Format("{0:dd/MM/yyyy}", DateTime.Now);

                string filePath = Server.MapPath("~/data/email_a_friend_form_log.xml");


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
                    Add the <field alias="url"> node
                    ========================================================
                    */
                    // Creating the <field> node inside the <log> node
                    writer.WriteStartElement("field");

                    //Add the alias attribute to the <field> node. <field alias="url">
                    writer.WriteAttributeString("alias", "url");

                    //Write value of the field node.
                    writer.WriteString(strURL);

                    //Close the <field> node inside the <log> node
                    writer.WriteEndElement();


                    /*
                    ========================================================
                    Add the <field alias="friendName"> node
                    ========================================================
                    */

                    // Creating the <field> node inside the <log> node
                    writer.WriteStartElement("field");

                    //Add the alias attribute to the <field> node. <field alias="friendName">
                    writer.WriteAttributeString("alias", "friendName");

                    //Write value of the field node.
                    writer.WriteString(strFriendName);

                    //Close the <field> node inside the <log> node
                    writer.WriteEndElement();


                    /*
                    ========================================================
                    Add the <field alias="friendEmail"> node
                    ========================================================
                    */

                    // Creating the <field> node inside the <log> node
                    writer.WriteStartElement("field");

                    //Add the alias attribute to the <field> node. <field alias="friendEmail">
                    writer.WriteAttributeString("alias", "friendEmail");

                    //Write value of the field node.
                    writer.WriteString(strFriendEmail);

                    //Close the <field> node inside the <log> node
                    writer.WriteEndElement();


                    /*
                    ========================================================
                    Add the <field alias="yourName"> node
                    ========================================================
                    */

                    // Creating the <field> node inside the <log> node
                    writer.WriteStartElement("field");

                    //Add the alias attribute to the <field> node. <field alias="yourName">
                    writer.WriteAttributeString("alias", "yourName");

                    //Write value of the field node.
                    writer.WriteString(strYourName);

                    //Close the <field> node inside the <log> node
                    writer.WriteEndElement();


                    /*
                    ========================================================
                    Add the <field alias="yourEmail"> node
                    ========================================================
                    */

                    // Creating the <field> node inside the <log> node
                    writer.WriteStartElement("field");

                    //Add the alias attribute to the <field> node. <field alias="yourEmail">
                    writer.WriteAttributeString("alias", "yourEmail");

                    //Write value of the field node.
                    writer.WriteString(strYourEmail);

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
                    Add the <field alias="url"> node
                    ========================================================
                    */

                    //Create a new xml <field> node
                    XmlElement fieldNodeURL = xmlDoc.CreateElement("field");

                    //Add the alias attribute to the <field> node. <field alias="url">
                    fieldNodeURL.SetAttribute("alias", "url");

                    //Write value of the field node.
                    fieldNodeURL.InnerText = strURL;

                    //Add our <field> node to our <log> node
                    logNode.AppendChild(fieldNodeURL);

                    /*
                    ========================================================
                    Add the <field alias="friendName"> node
                    ========================================================
                    */

                    //Create a new xml <field> node
                    XmlElement fieldNodeFriendName = xmlDoc.CreateElement("field");

                    //Add the alias attribute to the <field> node. <field alias="friendName">
                    fieldNodeFriendName.SetAttribute("alias", "friendName");

                    //Write value of the field node.
                    fieldNodeFriendName.InnerText = strFriendName;

                    //Add our <field> node to our <log> node
                    logNode.AppendChild(fieldNodeFriendName);


                    /*
                    ========================================================
                    Add the <field alias="friendEmail"> node
                    ========================================================
                    */

                    //Create a new xml <field> node
                    XmlElement fieldNodeFriendEmail = xmlDoc.CreateElement("field");

                    //Add the alias attribute to the <field> node. <field alias="friendEmail">
                    fieldNodeFriendEmail.SetAttribute("alias", "friendEmail");

                    //Write value of the field node.
                    fieldNodeFriendEmail.InnerText = strFriendEmail;

                    //Add our <field> node to our <log> node
                    logNode.AppendChild(fieldNodeFriendEmail);


                    /*
                    ========================================================
                    Add the <field alias="yourName"> node
                    ========================================================
                    */

                    //Create a new xml <field> node
                    XmlElement fieldNodeYourName = xmlDoc.CreateElement("field");

                    //Add the alias attribute to the <field> node. <field alias="yourName">
                    fieldNodeYourName.SetAttribute("alias", "yourName");

                    //Write value of the field node.
                    fieldNodeYourName.InnerText = strYourName;

                    //Add our <field> node to our <log> node
                    logNode.AppendChild(fieldNodeYourName);

                    /*
                    ========================================================
                    Add the <field alias="yourEmail"> node
                    ========================================================
                    */

                    //Create a new xml <field> node
                    XmlElement fieldNodeYourEmail = xmlDoc.CreateElement("field");

                    //Add the alias attribute to the <field> node. <field alias="yourEmail">
                    fieldNodeYourEmail.SetAttribute("alias", "yourEmail");

                    //Write value of the field node.
                    fieldNodeYourEmail.InnerText = strYourEmail;

                    //Add our <field> node to our <log> node
                    logNode.AppendChild(fieldNodeYourEmail);


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


                    //Save the file
                    xmlDoc.Save(filePath);
                }

            }


        #endregion

        #region validation
            protected void RequiredFriendName_ServerValidate(object source, ServerValidateEventArgs args)
            {
                if (friendsName.Text == String.Empty)
                {
                    friendsName.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    friendsName.CssClass = "";
                    args.IsValid = true;
                }
            }

            protected void RequiredFriendEmail_ServerValidate(object source, ServerValidateEventArgs args)
            {
                if (friendsEmail.Text == String.Empty)
                {
                    friendsEmail.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    friendsEmail.CssClass = "";
                    args.IsValid = true;
                }
            }


            protected void RequiredFieldYourName_ServerValidate(object source, ServerValidateEventArgs args)
            {
                if (yourName.Text == String.Empty)
                {
                    yourName.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    yourName.CssClass = "";
                    args.IsValid = true;
                }
            }

            protected void RequiredFieldYourEmail_ServerValidate(object source, ServerValidateEventArgs args)
            {
                if (yourEmail.Text == String.Empty)
                {
                    yourEmail.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    yourEmail.CssClass = "";
                    args.IsValid = true;
                }
            }

            protected void CheckFriendEmail_ServerValidate(object source, ServerValidateEventArgs args)
            {

                //Email Regex String
                Regex reg = new Regex(@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*");

                // Check if there is NO match in Regex
                if (!reg.IsMatch(friendsEmail.Text))
                {
                    //Does not match RegEx - Invalid email address

                    friendsEmail.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    friendsEmail.CssClass = "";
                    args.IsValid = true;
                }
            }

            protected void CheckYourEmail_ServerValidate(object source, ServerValidateEventArgs args)
            {

                //Email Regex String
                Regex reg = new Regex(@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*");

                // Check if there is NO match in Regex
                if (!reg.IsMatch(yourEmail.Text))
                {
                    //Does not match RegEx - Invalid email address

                    yourEmail.CssClass = "error";
                    args.IsValid = false;
                }
                else
                {
                    yourEmail.CssClass = "";
                    args.IsValid = true;
                }
            }

        #endregion
            
    }
}