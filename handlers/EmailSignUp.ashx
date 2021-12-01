<%@ WebHandler Language="C#" Class="EmailSignUp" %>
using System;
using System.Web;
using System;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using System.Web.SessionState;
using BKA.ShoppingCart;
using umbraco.BusinessLogic;
using umbraco.cms.businesslogic.web;
using umbraco.presentation.nodeFactory;
using KKSClasses;

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


public class EmailSignUp : IHttpHandler {

 public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string Email = context.Request.QueryString["Email"];
        string Name = context.Request.QueryString["Name"];    
        string document = context.Request.QueryString["doc"];   
        string userType = context.Request.QueryString["UserType"];
        string strEmailFrom, strEmailTo, strEmailSubject, strEmailBody, strTime, strDate;              
        Node homeNode = new Node(1244);
                
        strEmailFrom = Email;   //The email will be sent from the address the user typed in the form.
        strEmailTo = GetPropertyValue(homeNode, "emailTo");
        strEmailSubject = GetPropertyValue(homeNode, "emailSubject");
        strTime = String.Format("{0:HH:mm:ss}", DateTime.Now);
        strDate = String.Format("{0:dd/MM/yyyy}", DateTime.Now);
        strEmailBody = parseBody(GetPropertyValue(homeNode, "emailBody"), Email, Name,document, userType);
        
        try
        {
            //logItem(context, ContactFistName + " " + ContactLastName, strSendersEmail, strEmailBody);         
            KKSClasses.EmailHelper.SendEmail(Email, GetPropertyValue(homeNode, "emailTo").ToString(), strEmailSubject, strEmailBody);
            if (!KKSClasses.EmailToDB.downloadExists(Email, document))
            {
                KKSClasses.EmailToDB.addNewDownload(Name, Email, document, userType);
            }
            context.Response.Write("Success");
        }
        catch (SmtpException ex)
        {
            context.Response.Write("Failed" + ex.ToString());
            //If we fail to send email immediately stop runnning code
            return;
        } 

        logItem(context, Name, Email, strEmailBody);
    }
    
   private string parseBody(string body,string Email, string Name, string document, string userType)
    {
        body = body.Replace("\r\n", "\r").Replace("\n", "\r").Replace("\r", "<br/>");
        body = body.Replace("[Name]", Name);
        body = body.Replace("[Email]", Email);      
        body = body.Replace("[Document]", document); 
        body = body.Replace("[UserType]", userType); 
        body = body.Replace("[Date]", DateTime.Now.ToShortDateString());
        body = body.Replace("[Time]", DateTime.Now.ToShortTimeString());
        body = "<html><body>" + body + "</body></html>";
        return body;

    }       

    private string GetPropertyValue(Node nd, string propertyName)
    {
        Property prop = nd.GetProperty(propertyName);
        if (prop != null && !string.IsNullOrEmpty(prop.Value))
            return prop.Value;

        return "";
    }
    


    private void logItem(HttpContext context, string strName, string strEmail, string strMessage)
    {
        string strTime = String.Format("{0:HH:mm:ss}", DateTime.Now);
        string strDate = String.Format("{0:dd/MM/yyyy}", DateTime.Now);

        string filePath = context.Server.MapPath("~/data/contact_form_log.xml");

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
            writer.WriteCData("Hananui Website: Email Sign Up");

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
            XmlCDataSection fieldNodeCData = xmlDoc.CreateCDataSection("Hananui Website: Unit Location Floor Plan Map Request");

            //Add our cdata tag/node to our <field> node
            fieldNodeMessage.AppendChild(fieldNodeCData);

            //Add our <field> node to our <log> node
            logNode.AppendChild(fieldNodeMessage);

            //Add our built up logNode that contains our <field> nodes to the main xml document
            xmlDoc.SelectSingleNode("/logs").AppendChild(logNode);

            xmlDoc.Save(filePath);
        }
    }
      

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}
