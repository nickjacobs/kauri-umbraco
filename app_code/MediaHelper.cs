using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using umbraco.cms.businesslogic.media;

/// <summary>
/// Summary description for MediaHelper
/// </summary>
public class MediaHelper
{
	public MediaHelper()
	{
		//
		// TODO: Add constructor logic here
		//
	}

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
}