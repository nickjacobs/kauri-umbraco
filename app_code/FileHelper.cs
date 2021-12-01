using System;
using System.Xml;
using System.Xml.XPath;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using umbraco.cms.businesslogic.media;

namespace BKA.Base.Helpers
{
    public class FileHelper
    {
        public static string GetFilePath(string mediaId)
        {
            int i;
            if (mediaId != null && int.TryParse(mediaId, out i))
            {
                Media m = new Media(i);
                if (m != null && m.getProperty("umbracoFile") != null && m.getProperty("umbracoFile").Value != null)
                    return m.getProperty("umbracoFile").Value.ToString();

            }
            return "";
        }

        public static string GetMimeType(string fileName)
        {
            string mimeType = "application/unknown";
            string ext = System.IO.Path.GetExtension(fileName).ToLower();
            Microsoft.Win32.RegistryKey regKey = Microsoft.Win32.Registry.ClassesRoot.OpenSubKey(ext);
            if (regKey != null && regKey.GetValue("Content Type") != null)
                mimeType = regKey.GetValue("Content Type").ToString();
            return mimeType;
        }

        public static string GetFileSize(string filePath)
        {
            FileInfo f = new FileInfo(filePath);
            if (f.Length >= 1024 * 1024)
                return (f.Length / 1024 / 1024) + "MB";
            else if (f.Length >= 1024)
                return (f.Length / 1024) + "KB";
            else
                return f.Length + "bytes";
        }

        public static void StreamFile(string filePath)
        {
            FileInfo finfo = new FileInfo(filePath);

            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(filePath));
            HttpContext.Current.Response.ContentType = GetMimeType(Path.GetFileName(filePath)) + "; name=" + Path.GetFileName(filePath);
            HttpContext.Current.Response.AddHeader("Content-Length", finfo.Length.ToString());
            HttpContext.Current.Response.WriteFile(filePath);
            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.Close();
        }
    }
}