using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

using umbraco.presentation.nodeFactory;
using umbraco.cms.businesslogic.media;

public partial class usercontrols_website_SiteSearchResults : System.Web.UI.UserControl
{
        

    protected void Page_Load(object sender, EventArgs e)
    {
        string SearchQuery;
        if (Request.QueryString["search"] != null || Request.QueryString["search"] != "") {           
            SearchQuery = Request.QueryString["search"].ToString();
        
            int pageNum = 1;
            int PAGE_SIZE = int.Parse(ConfigurationManager.AppSettings["ContentSearch.ResultsPerPage"]);
            int totalRecords = KKSClasses.DataClasses.Helpers.SQLIndex.Search(SearchQuery).Count();

            if (!string.IsNullOrEmpty(Request.QueryString["page"]))
                int.TryParse(Request.QueryString["page"], out pageNum);

            var results = KKSClasses.DataClasses.Helpers.SQLIndex.Search(SearchQuery).Skip((pageNum - 1) * PAGE_SIZE).Take(PAGE_SIZE);

            StringBuilder searchStr = new StringBuilder();
            searchStr.AppendFormat("<div class='searchResults'>");

            foreach (var item in results)
            {
                if (item.ItemType == "PageBlock")
                {
                    searchStr.AppendFormat(@"<div class='searchResult'>
                        <a href='{3}'><h3>{0}</h3></a> 
                        <p>{2}... <a href='{3}'><span class='more'>more</span></a></p>
                        </div> ", HttpUtility.HtmlEncode(item.Title), umbraco.library.NiceUrl(int.Parse(item.NodeId.ToString())),
                      umbraco.library.TruncateString(umbraco.library.StripHtml(item.Synopsis), 200, ""), umbraco.library.NiceUrl(int.Parse(item.ParentNodeId.ToString())) + "?id=" + item.NodeId.ToString());
                          
                }
                else {
                    searchStr.AppendFormat(@"<div class='searchResult'>
                        <a href='{1}'><h3>{0}</h3></a> 
                        <p>{2}... <a href='{1}'><span class='more'>more</span></a></p>
                        </div> ", HttpUtility.HtmlEncode(item.Title), umbraco.library.NiceUrl(int.Parse(item.NodeId.ToString())),
                          umbraco.library.TruncateString(umbraco.library.StripHtml(item.Synopsis), 200, ""));
                          
                }
                   
            }
            searchStr.AppendFormat("</div>");
            litSearchResults.Text = searchStr.ToString();
           litPaging.Text = generatePaging(pageNum, SearchQuery, totalRecords);
        } 
    }
    




    private string generatePaging(int page, string query, int totalRecords)
    {
      //  Node PageID = new Node(int.Parse(Node.GetCurrent().ToString()));
        
        string url = Request.Url.ToString();
        Uri uri = new Uri(url);
        url = uri.GetLeftPart(UriPartial.Path) + "?search=" + query;

            int PAGE_SIZE = int.Parse(ConfigurationManager.AppSettings["ContentSearch.ResultsPerPage"]);     

            if (totalRecords <= PAGE_SIZE)
                return string.Empty;

            int totalPages = totalRecords / PAGE_SIZE + (totalRecords % PAGE_SIZE > 0 ? 1 : 0);
            page = page > totalPages ? totalPages - 1 : page - 1;

            StringBuilder sb = new StringBuilder();     

            sb.Append("<div class='paging clearfix'>");
            sb.Append("<span>page:</span>");
        

            if (totalPages > 1 && page > 0)
                sb.AppendFormat("<a href='{0}&amp;page={2}' class='prev'>previous</a>", url, query, page + 1 - 1);
            if (totalPages > 1 && page - 2 > 0)
                sb.AppendFormat("<a href='{0}&amp;page={2}'>{2}</a>", url, query, 1);

            if (totalPages > 5 && page - 3 > 0)
                sb.Append("<span>&hellip;</span>");

            for (int i = 0; i <= totalPages - 1; i++)
            {
                if (i == page)
                    sb.AppendFormat("<a href='{0}&amp;page={2}' class='active'>{2}</a>", url, query, i + 1);

                if (i != page && page > i - 3 && page < i + 3)
                    sb.AppendFormat("<a href='{0}&amp;page={2}'>{2}</a>", url, query, i + 1);
            }

            if (totalPages > 5 && page + 3 < totalPages - 1)
                sb.Append("<span>&hellip;</span>");

            if (totalPages > 1 && page + 2 < totalPages - 1)
                sb.AppendFormat("<a href='{0}&amp;page={2}'>{2}</a>", url, query, totalPages);
            if (totalPages > 1 && page + 1 < totalPages)
                sb.AppendFormat("<a href='{0}&amp;page={2}' class='next'>next</a>", url, query, page + 1 + 1);

            sb.Append("</div>");
            return sb.ToString();
       
    }



}

