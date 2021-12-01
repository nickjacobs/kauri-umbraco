using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using umbraco.presentation.nodeFactory;
using System.Configuration;


public partial class usercontrols_website_RegisterForm : System.Web.UI.UserControl
{
    private bool _showClose = true;
    public bool ShowClose 
    { 
        get { return _showClose;}
        set { _showClose = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (_showClose == true)
        {
            ltClose.Text = "<a href='#' id='btnCloseForm'></a>";
        }

        bindCategories();
    }

    private void bindCategories()
    {
        //<h4>Select which day (or days)</h4>
        //<div class="requiredCheckbox">
        //    <div class="container">
        //        <a href="#" class="checkbox" id="ckDay1"></a><span>Day 1 - kauri Dieback Symoosium</span>
        //    </div>
        //    <div class="container">
        //        <a href="#" class="checkbox" id="ckDay2"></a><span>Day 2 - Tree Injection Demostration</span>
        //    </div>
        //</div>
        int formId =Convert.ToInt32(ConfigurationManager.AppSettings["NodeId.RegisterForm"]);
        Node registerForm = new Node(formId);
        string morelink =  "";
        string symposiumFlierLink = "";
        if (registerForm.GetProperty("moreInfoLink") != null &&
            registerForm.GetProperty("moreInfoLink").Value.Trim() != "")
        {
            morelink = registerForm.GetProperty("moreInfoLink").Value.Trim();
        }
        if (registerForm.GetProperty("symposiumFlierLink") != null &&
          registerForm.GetProperty("symposiumFlierLink").Value.Trim() != "")
        {
            symposiumFlierLink = registerForm.GetProperty("symposiumFlierLink").Value.Trim();
        }
       
        foreach (Node categories in registerForm.Children)
        {
            ltCategories.Text += string.Format("<h4>{0}</h4>",categories.Name);
            string cls = "requiredCheckbox";
            if (categories.GetProperty("optional").Value == "1")
            {
                cls = "";
            }
            ltCategories.Text += string.Format("<div class='{0} checkboxContainer'>", cls);
            foreach (Node category in categories.Children)
            {
                ltCategories.Text += "<div class='container'>";
                ltCategories.Text += string.Format("<a href='javascript:void(0)' class='checkbox' id='ck{0}'></a><span>{1}</span>", category.Id.ToString(), category.Name);
                ltCategories.Text += "</div>";
            }
            ltCategories.Text += "</div>";
        }
        ltCategories.Text += "<div class='container' style='width:440px;'>";
        ltCategories.Text += string.Format("<a href='{0}' target='_blank' class='link'>Click here for more information</a>",morelink);
        ltCategories.Text += "</div>";
        ltCategories.Text += "<div class='container' style='width:440px;'>";
        ltCategories.Text += string.Format("<a href='{0}' target='_blank' class='link'>Click here to see the flier for this event</a>", symposiumFlierLink);
        ltCategories.Text += "</div>";
    }
}