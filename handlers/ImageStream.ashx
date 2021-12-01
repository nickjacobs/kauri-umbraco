<%@ WebHandler Language="C#" Class="BKA.Handlers.ImageStream" %>
using System;
using System.Web;
using System.Web.Services;
using System.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;

namespace BKA.Handlers{
    
    /// <summary>
    /// Summary description for ImageStream
    ///     QueryString Options:       
    ///         Option 1: "path": send the relative path to an existing image on the file system
    ///             Optional "defaultpath": the relative path to a backup image if the "path" option is not found
    ///         
    ///         Optional for use with above options: 
    ///             "maxside" (int) resizes the image (either width or height) to that maxside size, streams the new size, and stores the resized image in the file system for later use
    ///             "side" (int) options:[0=normal,1=width,2=height] representing which side to resize, defaults to width
    ///         
    ///         Option 2: "Crop": to crop the image specified, after resizing and only return a portion of it.
    ///             "cropTop" (int) the distance from the top of the fullsize image (after resizing) to the top of the cropped section
    ///             "cropLeft" (int) the disatnce from the left edge of the fullsize image (after resizing) to the left of the cropped section
    ///             "cropWidth" (int) the maximum width of image post cropping
    ///             "cropHeight" (int) the mamimum height of the image post cropping
    /// 
    /// 
    /// </summary>
    [WebService(Namespace = "http://www.bka.co.nz/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ImageStream : IHttpHandler{
        public void ProcessRequest(HttpContext context){


            if (!string.IsNullOrEmpty(context.Request.QueryString["path"]))
            {

                string relativeFilePath = context.Request.QueryString["path"];  // relative path
                string physicalFilePath = context.Request.MapPath(relativeFilePath);

                //Set up cropping variables
                bool doCrop = false;
                string cropTop="";
                string cropLeft="";
                string cropWidth="";
                string cropHeight="";
                try
                {
                    cropTop = context.Request.QueryString["cropTop"];
                    cropLeft = context.Request.QueryString["cropLeft"];
                    cropWidth = context.Request.QueryString["cropWidth"];
                    cropHeight = context.Request.QueryString["cropHeight"];
                    if (cropTop.Length > 0 && cropLeft.Length > 0 && cropWidth.Length > 0 && cropHeight.Length > 0)
                    {
                        doCrop = true;
                    }
                }
                catch
                {
                }

                //Set up resizing variables
                string resizeMaxSide = "";
                string resizeSide = "";
                bool doResize = false;
                try {
                    resizeMaxSide = context.Request.QueryString["maxside"];
                    resizeSide = context.Request.QueryString["side"];
                    if (resizeMaxSide.Length > 0)
                    {
                        doResize = true;
                    }
                    if (resizeSide.Length == 0)
                    {
                        resizeSide = "1";
                    }
                }
                catch
                {
                }

                //Set up transient image objects
                string currentFilePath = physicalFilePath;
        
                // if the file doesn't exist
                if (!System.IO.File.Exists(currentFilePath))
                {
                    context.Trace.Warn("File not found: " + currentFilePath + ", trying to resort to 'defaultpath' setting.");
                    currentFilePath = context.Request.MapPath(context.Request.QueryString["defaultpath"]);
                    if (!System.IO.File.Exists(currentFilePath)) //check to see if the default path exists
                    {
                        context.Response.StatusCode = 404;
                        context.Trace.Warn("ERROR: File with path AND default not provided.");
                        return;
                    }
                }
 
                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                // ~~~~ At this point we know currentFilePath points to a valid image ~~~~
                // ~~~~ Time to start manipulating it                                 ~~~~ 
                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                try
                {
                    if (!doCrop && !doResize) // Output raw image
                    {
                        OutputImage(currentFilePath, context);
                    }

                    if (doResize)
                    {
                        currentFilePath = ImagePathWithManipulation(currentFilePath, int.Parse(resizeMaxSide), context);
                    }

                    if (doCrop)
                    {
                        currentFilePath = ImagePathWithCropping(currentFilePath, cropTop, cropLeft, cropWidth, cropHeight, context);
                    }
                }
                catch (Exception x)
                {
                    context.Response.StatusCode = 404;
                    context.Trace.Warn("Error with Image Manipulation:" + x.ToString());
                    return;
                }

                OutputImage(currentFilePath, context);
            }
            else
            {
                context.Response.StatusCode = 404;
                context.Trace.Warn("No filepath provided");
                return;
            }

        }

        // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        void OutputImage(string FilePath, HttpContext context)
        {
            // Apply caching rules
            context.Response.AddFileDependency(FilePath);

            context.Response.Cache.SetETagFromFileDependencies();
            context.Response.Cache.SetLastModifiedFromFileDependencies();
            context.Response.Cache.SetExpires(DateTime.Now.AddHours(24));
            context.Response.Cache.SetCacheability(HttpCacheability.Public);
            context.Response.Cache.SetValidUntilExpires(false);
            context.Response.Cache.VaryByParams["*"] = true;
            
            // stream the actual file
            context.Response.ContentType = getMimeType(FilePath);
            context.Response.WriteFile(FilePath);            
        }

        // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        public string ImagePathWithCropping(string FilePath, string cropTop, string cropLeft, string cropWidth, string cropHeight, HttpContext context)
        {
            string extension = FilePath.Substring(FilePath.LastIndexOf(".") + 1);
            string FilePathWithoutExtension = FilePath.Remove(FilePath.LastIndexOf("."));
            
            string croppedFilePath = FilePathWithoutExtension + "_crop_" + cropTop + "_" + cropLeft + "_" + cropWidth + "_" + cropHeight + "." + extension;

            context.Trace.Warn("Checking for: " + croppedFilePath);

            try
            {
                if (System.IO.File.Exists(croppedFilePath) && (System.IO.File.GetLastWriteTime(croppedFilePath) > System.IO.File.GetLastWriteTime(FilePath)))
                {
                    return croppedFilePath;
                }

                context.Trace.Warn("Creating cropped image: " + croppedFilePath);
                createCroppedFile(FilePath, croppedFilePath, cropTop, cropLeft, cropWidth, cropHeight, context);
                return croppedFilePath;

            
            }
            catch (Exception x)
            {
                context.Trace.Warn("Error running cropping manipulation:" + x.ToString());
                return FilePath;
            }
        
        }
        // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        void createCroppedFile(string currentFilePath, string newFilePath, string sCropTop, string sCropLeft, string sCropWidth, string sCropHeight, HttpContext context){
            //open exisitng file
            //perform crop
            //save file
            
            ImageFormat oFormat = ImageFormat.Jpeg;
            int nCropTop = Int32.Parse(sCropTop);
            int nCropLeft = Int32.Parse(sCropLeft);
            int nCropWidth = Int32.Parse(sCropWidth);
            int nCropHeight = Int32.Parse(sCropHeight);

            try{
                System.Drawing.Image oImg = System.Drawing.Image.FromFile(currentFilePath);
                Rectangle oCropRectangle = new Rectangle(nCropLeft, nCropTop, nCropWidth, nCropHeight);

                System.Drawing.Image oCroppedImage = new Bitmap(nCropWidth, nCropHeight);

                oCroppedImage = cropImage(oImg, oCropRectangle);

                oCroppedImage.Save(newFilePath, oFormat);

                oCroppedImage.Dispose();
            }
            catch (Exception x) {
                HttpContext.Current.Trace.Warn("Error in GenerateThumbNail: " + x.ToString());
            }
            
        }        
        
        // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        /// <summary>
        /// Returns the physicalFilePath to the image and resizes in the process (or not if file already exists)
        /// </summary>
        /// <param name="physicalFilePath"></param>
        /// <param name="context"></param>
        public string ImagePathWithManipulation(string physicalFilePath, int maxSide, HttpContext context){
            string extension = physicalFilePath.Substring(physicalFilePath.LastIndexOf(".") + 1);
            string physicalPathWithoutExtension = physicalFilePath.Remove(physicalFilePath.LastIndexOf("."));
            string resizedPhysicalPath = physicalPathWithoutExtension + "_maxside_" + maxSide.ToString() + "_" + context.Request.QueryString["side"] + "." + extension;

            context.Trace.Warn("Checking for: " + resizedPhysicalPath);


            try{

                if (System.IO.File.Exists(resizedPhysicalPath) && (System.IO.File.GetLastWriteTime(resizedPhysicalPath) > System.IO.File.GetLastWriteTime(physicalFilePath)))
                {
                    context.Trace.Warn("Streaming existing unique image size: " + maxSide.ToString());
                    return resizedPhysicalPath;
                }
                else if (System.IO.File.Exists(physicalFilePath))
                {
                    Image imgInput = Image.FromFile(physicalFilePath);
                    int max = Math.Max(imgInput.Width, imgInput.Height);
                    imgInput.Dispose();
                    if (max != maxSide)
                    {
                        context.Trace.Warn("Creating and Streaming new image size: " + maxSide.ToString());
                        ResizeToMaxSide(resizedPhysicalPath, physicalFilePath, maxSide);
                        return resizedPhysicalPath;
                    }
                }
                return physicalFilePath;
            }
            catch (Exception x){
                context.Trace.Warn("Error running ImagePathWithManipulation:" + x.ToString());
                return physicalFilePath;
            }
        }

        public void ResizeToMaxSide(string resizedImagePhysicalFilePath, string originalImagePhysicalFilePath, int maxSideSize){
            int side = 0;
            if (!string.IsNullOrEmpty(System.Web.HttpContext.Current.Request.QueryString["side"])){
                //get value
                int.TryParse(System.Web.HttpContext.Current.Request.QueryString["side"], out side);
                //validate value
                if (side < 0 || side > 2)
                    side = 0;
            }
            ResizeToMaxSide(resizedImagePhysicalFilePath, originalImagePhysicalFilePath, maxSideSize, side);
        }
        public void ResizeToMaxSide(string resizedImagePhysicalFilePath, string originalImagePhysicalFilePath, int MaxSideSize, int side){
            int intNewWidth;
            int intNewHeight;
            Image imgInput = Image.FromFile(originalImagePhysicalFilePath);

            //Determine image format
            //ImageFormat fmtImageFormat = imgInput.RawFormat;

            //get image original width and height
            int intOldWidth = imgInput.Width;
            int intOldHeight = imgInput.Height;

            //determine if landscape or portrait
            int intMaxSide;
            
            if ((side == 1) || ((side == 0) && intOldWidth >= intOldHeight)){
                intMaxSide = intOldWidth;
            }else{
                intMaxSide = intOldHeight;
            }

            if (intMaxSide > MaxSideSize){
                //set new width and height
                double dblCoef = MaxSideSize / (double)intMaxSide;
                intNewWidth = Convert.ToInt32(dblCoef * intOldWidth);
                intNewHeight = Convert.ToInt32(dblCoef * intOldHeight);
            }else{
                intNewWidth = intOldWidth;
                intNewHeight = intOldHeight;
            }

            imgInput.Dispose();

            GenerateThumbNail(resizedImagePhysicalFilePath, originalImagePhysicalFilePath, ImageFormat.Jpeg, intNewWidth, intNewHeight);
        }

        protected void GenerateThumbNail(string sResizedFilePath, string sOrgFilePath, ImageFormat oFormat, int width, int height){
            try{
                //System.Drawing.Image oImg = System.Drawing.Image.FromFile(sPhysicalPath + @"\" + sOrgFileName);
                System.Drawing.Image oImg = System.Drawing.Image.FromFile(sOrgFilePath);
                System.Drawing.Image oThumbNail = new Bitmap(width + 2, height + 2); //, oImg.PixelFormat

                Graphics oGraphic = Graphics.FromImage(oThumbNail);
                oGraphic.CompositingQuality = CompositingQuality.HighQuality;
                oGraphic.SmoothingMode = SmoothingMode.HighQuality;
                oGraphic.InterpolationMode = InterpolationMode.HighQualityBicubic;
                oGraphic.PixelOffsetMode = PixelOffsetMode.HighQuality;

                // make it slightly too big
                Rectangle oSourceRectangle = new Rectangle(0, 0, width + 2, height + 2);
                oGraphic.DrawImage(oImg, oSourceRectangle);

                Rectangle oDestinationRectangle = new Rectangle(1, 1, width, height);
                System.Drawing.Image oThumbnailCropped = new Bitmap(width, height, oImg.PixelFormat);
                oThumbnailCropped = cropImage(oThumbNail, oDestinationRectangle);

                oThumbnailCropped.Save(sResizedFilePath, oFormat);

                oThumbNail.Dispose();
                oImg.Dispose();
            }
            catch (Exception x) {
                HttpContext.Current.Trace.Warn("Error in GenerateThumbNail: " + x.ToString());
            }
        }

        private static Image cropImage(Image img, Rectangle cropArea){
            Bitmap bmpImage = new Bitmap(img);
            Bitmap bmpCrop = bmpImage.Clone(cropArea,
            bmpImage.PixelFormat);
            return (Image)(bmpCrop);
        }

        private string getMimeType(string fileName)
        {
            string mimeType = "application/unknown";
            string ext = System.IO.Path.GetExtension(fileName).ToLower();
            Microsoft.Win32.RegistryKey regKey = Microsoft.Win32.Registry.ClassesRoot.OpenSubKey(ext);
            if (regKey != null && regKey.GetValue("Content Type") != null)
                mimeType = regKey.GetValue("Content Type").ToString();
            return mimeType;
        }

        public bool IsReusable { get { return true; } }
    }
}