<%@ WebHandler Language="C#" Class="UserHandler" %>

using System;
using System.Web;
using KKSClasses;

public class UserHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string firstName = context.Request["firstName"];
        string lastName = context.Request["lastName"];
        string email = context.Request["email"];
        string address = context.Request["address"];
        string city = context.Request["city"];
        string categories = context.Request["categories"];
        string msg = context.Request["msg"];

        utUser user = new utUser();
        user.firstName = firstName;
        user.lastName = lastName;
        user.email = email;
        user.address = address;
        user.city = city;
        user.categories = categories;
        user.message = msg;
        user.createDate = DateTime.Today;

        try
        {
            UserController.AddUser(user);
        
            context.Response.Write("true");
        }
        catch (Exception)
        {
            context.Response.Write("false");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}