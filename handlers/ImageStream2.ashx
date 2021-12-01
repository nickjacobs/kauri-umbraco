<%@ WebHandler Language="C#" Class="ImageStream" %>

using System;
using System.Web;
using System.Drawing;
using System.IO;
using BKA.Base.Helpers;

public class ImageStream : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        int width = -1;
        int height = -1;
        if (!string.IsNullOrEmpty(context.Request.QueryString["path"]))
        {
            int.TryParse(context.Request.QueryString["width"], out width);
            int.TryParse(context.Request.QueryString["height"], out height);
            if (width > 0 || height > 0)
            {

                string mode = "resize";
                if (!string.IsNullOrEmpty(context.Request.QueryString["mode"]) &&
                    context.Request.QueryString["mode"].ToLower() == "resizecrop")
                    mode = "resizecrop";

                if (context.Request.QueryString["path"].Substring(0, 1) != "~" && context.Request.QueryString["path"].Substring(0, 1) != "/")
                {
                    string url = context.Request.QueryString["path"];
                    url = url.Replace("http://", "");
                    string host = url.Substring(0, url.IndexOf('/'));
                    string path = url.Substring(url.IndexOf('/'), (url.Length - url.IndexOf('/')));
                    string redirectPath = string.Empty;
                    if (host.IndexOf("http://") < 0)
                    {
                        redirectPath = string.Format("http://{0}/handlers/imageStream.ashx?width={1}&height={2}&path=~{3}&mode={4}", host, width, height, path,mode);
                    }
                    else
                    {
                        redirectPath = string.Format("http://{0}/handlers/imageStream.ashx?width={1}&height={2}&path={3}&mode={4}", host, width, height, path, mode);
                    }
                    

                    //context.Response.Write(redirectPath);
                    context.Response.Redirect(redirectPath, true);
                }
                
                string mappedFilePath = context.Server.MapPath(context.Request.QueryString["path"]);
                string newMappedFilePath = Path.GetDirectoryName(mappedFilePath) + @"\" + Path.GetFileNameWithoutExtension(mappedFilePath) + "_" + mode + "_" + width + "_" + height + Path.GetExtension(mappedFilePath);
                bool resizedFileOutOfDate = true;
                if (File.Exists(newMappedFilePath))
                {
                    FileInfo fiOrig = new FileInfo(mappedFilePath);
                    FileInfo fiNew = new FileInfo(newMappedFilePath);
                    if (fiNew.LastWriteTime > fiOrig.LastWriteTime &&
                        fiNew.CreationTime > fiOrig.CreationTime)
                        resizedFileOutOfDate = false;
                }
                if (!File.Exists(newMappedFilePath) || resizedFileOutOfDate)
                {
                    using (Bitmap bitmapOrig = (Bitmap)Bitmap.FromFile(mappedFilePath))
                    {
                        if (width <= 0)
                            width = (int)(((double)bitmapOrig.Height / (double)height) * bitmapOrig.Width);
                        else if(height <= 0)
                            height = (int)(((double)bitmapOrig.Width / (double)width) * bitmapOrig.Height);
                        
                        Bitmap bitmapNew;
                        if (mode == "resizecrop")
                            bitmapNew = ImageManipulation.ResizeToFit(bitmapOrig, width, height, ImageManipulation.ResizeMode.Crop);
                        else
                            bitmapNew = ImageManipulation.ResizeToFit(bitmapOrig, width, height, ImageManipulation.ResizeMode.NoCrop);

                        if (File.Exists(newMappedFilePath))
                            File.Delete(newMappedFilePath);
                        bitmapNew.Save(newMappedFilePath);
                    }
                }

                context.Response.AddFileDependency(newMappedFilePath);
                //context.Response.Cache.SetETagFromFileDependencies();
                context.Response.Cache.SetLastModifiedFromFileDependencies();
                context.Response.Cache.SetExpires(DateTime.Now.AddHours(1));
                context.Response.Cache.SetCacheability(HttpCacheability.Public);
                context.Response.Cache.SetValidUntilExpires(false);
                context.Response.Cache.VaryByParams["*"] = true;
                context.Response.ContentType = FileHelper.GetMimeType(newMappedFilePath);
                context.Response.WriteFile(newMappedFilePath);
            }
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}
