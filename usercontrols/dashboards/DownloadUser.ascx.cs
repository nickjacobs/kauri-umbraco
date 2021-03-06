using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KKSClasses;

public partial class usercontrols_dashboards_DownloadUser : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void lbtnDownloadUser_Click(object sender, EventArgs e)
    {
        Response.ContentType = "text/plain";

        Response.AddHeader("content-disposition", "attachment;filename=" + string.Format("members-{0}.csv", string.Format("{0:ddMMyyyy}", DateTime.Today)));
        Response.Clear();

        using (StreamWriter writer = new StreamWriter(Response.OutputStream, Encoding.UTF8))
        {
            writer.Write(generateCSV());
        }
        Response.End();
    }

    private string generateCSV()
    {
        StringBuilder sb = new StringBuilder();
        List<utUser> users = UserController.GetAllUsers();
        string header = "Create Date,First Name,Last Name,Email,Address,City,";
        if(users.Count>0)
        {
            string[] category = users[0].categories.Split(new string[] { ";;" }, StringSplitOptions.RemoveEmptyEntries);
            foreach(string c in category)
            {
                header += c.Split(new string[] { "::" }, StringSplitOptions.RemoveEmptyEntries)[0] + ",";
            }
        }

        header += "Message";
        sb.AppendLine(header);

        foreach (utUser user in users)
        {
            if (string.IsNullOrEmpty(user.email) && string.IsNullOrEmpty(user.firstName))
            {
                continue;
            }
            string line = Convert.ToDateTime(user.createDate).ToString("dd/MM/yyyy") + ",";
            line += user.firstName + ",";
            line += user.lastName + ",";
            line += user.email + ",";
            line += user.address + ",";
            line += user.city + ",";
            if (user.categories != null)
            {
                string[] category = user.categories.Split(new string[] { ";;" }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string c in category)
                {
                    line += c.Split(new string[] { "::" }, StringSplitOptions.RemoveEmptyEntries)[1] + ",";
                }
            }
            if (user.message != null)
            {
                line += user.message.Replace("\n", "<br/>");
            }
            sb.AppendLine(line);
        }

        return sb.ToString();
    }

    
}