function init(){var E;tinyMCEPopup.resizeToInnerSize();E=tinyMCE.selectedInstance;window.setTimeout("insertHelpIFrame();",10);var B=document.getElementById("plugintablecontainer");var A=tinyMCE.getParam("plugins","",true,",");if(A.length==0){document.getElementById("plugins_tab").style.display="none"}var D="";D+='<table id="plugintable">';D+="<thead>";D+="<tr>";D+="<td>"+tinyMCE.getLang("lang_plugin")+"</td>";D+="<td>"+tinyMCE.getLang("lang_author")+"</td>";D+="<td>"+tinyMCE.getLang("lang_version")+"</td>";D+="</tr>";D+="</thead>";D+="<tbody>";for(var C=0;C<E.plugins.length;C++){var F=getPluginInfo(E.plugins[C]);D+="<tr>";if(F.infourl!=null&&F.infourl!=""){D+='<td width="50%" title="'+A[C]+'"><a href="'+F.infourl+'" target="mceplugin">'+F.longname+"</a></td>"}else{D+='<td width="50%" title="'+A[C]+'">'+F.longname+"</td>"}if(F.authorurl!=null&&F.authorurl!=""){D+='<td width="35%"><a href="'+F.authorurl+'" target="mceplugin">'+F.author+"</a></td>"}else{D+='<td width="35%">'+F.author+"</td>"}D+='<td width="15%">'+F.version+"</td>";D+="</tr>"}D+="</tbody>";D+="</table>";B.innerHTML=D}function getPluginInfo(A){if(tinyMCE.plugins[A].getInfo){return tinyMCE.plugins[A].getInfo()}return{longname:A,authorurl:"",infourl:"",author:"--",version:"--"}}function insertHelpIFrame(){var A='<iframe width="100%" height="300" src="'+tinyMCE.themeURL+"/docs/"+tinyMCE.settings.docs_language+'/index.htm"></iframe>';document.getElementById("iframecontainer").innerHTML=A;A="";A+='<a href="http://www.moxiecode.com" target="_blank"><img src="http://tinymce.moxiecode.com/images/gotmoxie.png" alt="Got Moxie?" border="0" /></a> ';A+='<a href="http://sourceforge.net/projects/tinymce/" target="_blank"><img src="http://sourceforge.net/sflogo.php?group_id=103281" alt="Hosted By Sourceforge" border="0" /></a> ';A+='<a href="http://www.freshmeat.net/projects/tinymce" target="_blank"><img src="http://tinymce.moxiecode.com/images/fm.gif" alt="Also on freshmeat" border="0" /></a> ';document.getElementById("buttoncontainer").innerHTML=A};