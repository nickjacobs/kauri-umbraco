using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace BKA.Base.Helpers
{
    public class ImageManipulation
    {
        public enum ResizeMode
        {
            Crop,
            NoCrop
        }

        public static Bitmap ResizeToFit(Bitmap bitmap, int width, int height, ResizeMode resizeMode)
        {
            if (resizeMode == ResizeMode.Crop)
            {
                double aspectRatioOrig = (double)bitmap.Width / (double)bitmap.Height;
                double aspectRatioNew = (double)width / (double)height;

                if (aspectRatioOrig > aspectRatioNew)
                {
                    //resize based on height
                    double ratio = (double)bitmap.Height / (double)height;
                    int newWidth = (int)(bitmap.Width / ratio);
                    Bitmap bmpResized = Resize(bitmap, newWidth, height);

                    //now crop
                    return Crop(bmpResized, new Rectangle((int)((bmpResized.Width - width) / 2f), 0, width, height));
                }
                else
                {
                    //resize based on width
                    double ratio = (double)bitmap.Width / (double)width;
                    int newHeight = (int)(bitmap.Height / ratio);
                    Bitmap bmpResized = Resize(bitmap, width, newHeight);

                    //now crop
                    return Crop(bmpResized, new Rectangle(0, (int)((bmpResized.Height - height) / 2f), width, height));
                }
            }
            else
            {
                double aspectRatioOrig = (double)bitmap.Width / (double)bitmap.Height;
                double aspectRatioNew = (double)width / (double)height;
                if (aspectRatioOrig > aspectRatioNew)
                {
                    //resize based on width
                    double ratio = (double)bitmap.Width / (double)width;
                    int newHeight = (int)(bitmap.Height / ratio);
                    return Resize(bitmap, width, newHeight);
                }
                else
                {
                    //resize based on height
                    double ratio = (double)bitmap.Height / (double)height;
                    int newWidth = (int)(bitmap.Width / ratio);
                    return Resize(bitmap, newWidth, height);
                }
            }
        }

        private static Bitmap Crop(Bitmap bmpOrig, Rectangle cropArea)
        {
            Bitmap bmpCrop = bmpOrig.Clone(cropArea, bmpOrig.PixelFormat);
            return bmpCrop;
        }

        public static Bitmap Resize(Bitmap bitmap, int width, int height)
        {
            if (bitmap.Width == width &&
                bitmap.Height == height)
            {
                return bitmap;
            }
            else
            {
                Bitmap bmpThumb = new Bitmap(width, height);
                using (Graphics g = Graphics.FromImage(bmpThumb))
                {
                    g.CompositingQuality = CompositingQuality.HighQuality;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;

                    g.DrawImage(bitmap, 0, 0, bmpThumb.Width, bmpThumb.Height);
                }
                return bmpThumb;
            }
        }
    }
}