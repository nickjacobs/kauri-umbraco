var templateEditing=false;var macroEditElement=null;function openDialog(A,B,C,D){window.status="";strFeatures="dialogWidth="+C+"px;dialogHeight="+D+"px;scrollbars=no;center=yes;border=thin;help=no;status=no";strTitle=window.showModalDialog(B,"MyDialog",strFeatures);return strTitle}function setRichTextObject(A){currentRichTextDocument=document.frames[A+"_holder"].document;currentRichTextObject=document.frames[A+"_holder"].document.getElementById("holder")}function umbracoEditorCommand(C,B,A){setRichTextObject(C);currentRichTextDocument=document.frames[C+"_holder"].document;currentRichTextDocument.execCommand(B,true,A);currentRichTextDocument.focus()}function umbracoInsertField(G,F,D,B,C,H,I,E){if(navigator.userAgent.match("MSIE")){if(textareaEditorMode=="undefined"&&document.selection.createRange().parentElement().tagName=="DIV"){alert("FOCUS OUTSIDE OF THE EDITOR\n--------------------------------------------------------------------------\n\nPlease place the cursor where you wish to insert the code by using either mouse or keyboard.");return}}var A="Insert umbraco field";if(D=="UMBRACOGETDICTIONARY"){A="Insert Dictionary Item"}top.openModal(I+F+".aspx?tagName="+D+"&tagText="+B+"&move="+E+"&objectId=meh",A,H,C)}function umbracoInsertFieldDo(C,B,A){insertCodeAtCaret(document.getElementById(C),B)}function xbfInsertAtCaretAndMove(C,A,B){insertCodeAtCaret(document.getElementById(theObjectId),A)}function umbracoInsertMacro(C,B){setRichTextObject(C);macroEditElement=null;if(document.selection.createRange().parentElement().tagName!="BODY"){var A=nytVindue(B+"/dialogs/editMacro.aspx?editor=true&umbPageId="+umbPageId+"&umbVersionId="+umbVersionId,600,350)}}function umbracoTemplateInsertMacro(){top.openModal("dialogs/editMacro.aspx","Insert macro",600,500)}function umbracoInsertMacroDo(A){A=A.replace(/\'/gi,"&#039;");xbfInsertAtCaretAndMove(document.forms[0].TemplateBody,A)}function umbracoEditMacroDo(C,B,A){if(macroEditElement!=null){macroEditElement.outerHTML=A}else{currentRichTextDocument.selection.createRange().pasteHTML(A)}macroEditElement=null}function nytVindue(B,C,A){window.open(B,"nytVindue","width="+C+",height="+A+",scrollbars=yes")}function umbracoImage(A){if(A!=undefined){setRichTextObject(A)}if(document.selection.createRange().parentElement().tagName!="BODY"){var H="";H=""+openDialog("insertImage","dialogs/insertimage.aspx",560,540);if(H.toString()!="undefined"&&H!=""){var F;var I;var G;var D;var E="";var B;var C;H=H.split("|||");F=H[0];I=H[1];G=H[2];D=H[3];imageTitle=H[4];B=H[5];C=H[6];if(G!=""&&G!="0"&&G.toString()!="undefined"&&D!=""&&D!="0"&&D.toString()!="undefined"){E=' onResize="umbracoImageResizeUpdateSize()" onResizeEnd="defaultStatus = \'\'; umbracoImageResize(this);" onresizestart="umbracoImageResizeStart(this);" width="'+G+'" height="'+D+'" umbracoOrgWidth="'+B+'" umbracoOrgHeight="'+C+'"'}document.selection.createRange().pasteHTML('<img src="'+I+'" title="'+imageTitle+'" alt="'+F+'"'+E+">")}}}function doRelation(){var A=nytVindue(umbracoConstGuiFolderName+"/umbracoRelation.aspx?table=dataStructure&id="+umbracoQuerystring,600,350)}function umbracoInsertTable(D){setRichTextObject(D);var C="";C=""+openDialog("insertTable","dialogs/insertTable.aspx",470,560);if(C.toString()!="undefined"&&C!=""){var B=currentRichTextDocument.selection;if(B!=null){var A=B.createRange();if(A!=null){if(A.text!=""&&B.type=="Text"){A.pasteHTML(C+A.html)}else{A.pasteHTML(C)}}}}currentRichTextDocument.focus()}function umbracoAnchor(D){setRichTextObject(D);insertAnchor=""+openDialog("insertAnchor","dialogs/insertAnchor.aspx",390,260);if(insertAnchor!=""&&insertAnchor!="undefined"){var C=currentRichTextDocument.selection;if(C!=null){var A=C.createRange();if(A!=null){var B=currentRichTextDocument.selection.createRange().htmlText;currentRichTextDocument.selection.createRange().pasteHTML('<a name="'+insertAnchor+'">'+B+"</a>")}}}}function umbracoLink(B){setRichTextObject(B);var H="";var C=currentRichTextDocument.selection;var D="";if(C!=null){var A=C.createRange();if(A!=null){if(A.text==""){var F=A.parentElement();while(F.tagName!="A"&&F.parentNode.tagName!="BODY"){F=F.parentNode}if(F.tagName=="A"){document.frames[B+"_holder"].umbracoEditA(F);return""}}if(A.text!=""&&C.type=="Text"){D=A.htmlText;H=""+openDialog("insertLink","dialogs/insertlink.aspx",440,480);if(H.toString()!="undefined"&&H!=""){if(H.substr(0,4)=="true"){currentRichTextDocument.execCommand("CreateLink",false,formatLink(H.substr(H.indexOf("|")+1,H.length)));if(A.parentElement().tagName=="A"){A.parentElement().target="_blank"}}else{currentRichTextDocument.execCommand("CreateLink",false,formatLink(H.substr(H.indexOf("|")+1,H.length)))}}}else{if(C.type=="Control"){var I=A.item(0);var D="<"+I.tagName;var G=I.attributes;for(var E=0;E<G.length;E++){if(G[E].nodeName=="border"){D+=" "+G[E].nodeName+'="0"'}else{if(G[E].nodeValue!=null&&G[E].nodeValue!=""&&G[E].nodeValue!="inherit"&&G[E].nodeName!="start"){D+=" "+G[E].nodeName+'="'+G[E].nodeValue+'"'}}}D+=">";H=""+openDialog("insertLink","dialogs/insertlink.aspx",440,480);if(H.toString()!="undefined"&&H!=""){if(H.substr(0,4)=="true"){D='<a href="'+formatLink(H.substr(H.indexOf("|")+1,H.length))+'" target="_blank">'+D+"</a>"}else{D='<a href="'+formatLink(H.substr(H.indexOf("|")+1,H.length))+'">'+D+"</a>"}}A.item(0).outerHTML=D}}}}currentRichTextObject.focus()}function formatLink(A){return A.replace(/\%3f/g,"?")}function umbracoScriptlet(){var D=parent.parent.openDialog("umbracoScriptlet","settings/umbracoScriptlet.aspx",500,250);var C='<img src="'+umbracoConstGuiFolderName+'/images/umbracoScriptlet.gif" ALT="'+D+'" UMBRACO="umbracoScriptlet">';var B=currentRichTextDocument.selection;if(B!=null){var A=B.createRange();if(A!=null&&B.type=="Text"){A.pasteHTML(C)}}}function doSubmitAndPublish(){document.contentForm.doPublish.value="true";doSubmit()}function viewHTML(A){setRichTextObject(A);window.open("viewHTML.aspx?rnd="+top.returnRandom(),"nytVindue","width=700,height=500,scrollbars=auto")}function umbracoInsertForm(B){setRichTextObject(B);var A=openDialog("umbracoForm","dialogs/insertFormField.aspx?rnd="+top.returnRandom(),450,480);if(A){currentRichTextDocument.selection.createRange().pasteHTML(A)}}function umbracoTextGen(B){setRichTextObject(B);var A=openDialog("umbracoTextGen","dialogs/inserttextGen.aspx?rnd="+top.returnRandom(),450,330);if(A){currentRichTextDocument.selection.createRange().pasteHTML(A.replace(/&amp;/g,"&"))}}function addStyle(D,E){setRichTextObject(E);var B=D[D.selectedIndex].value;var C=currentRichTextDocument.selection;if(C!=null){var A=C.createRange();if(A!=null){if(B!=""){setClass(B)}}}D.selectedIndex=0;currentRichTextObject.focus()}function setClass(C){if(currentRichTextDocument.selection.type=="Text"){var A=currentRichTextDocument.selection;var B=A.createRange().htmlText;A.clear();B=B.replace(/<span CLASS=\/?.*?>/gi,"");B=B.replace(/<\/span>/gi,"");B=B.replace(/<h\/?.*?>/gi,"");B=B.replace(/<\/h\/?.*?>/gi,"");B=B.replace(/<p>/gi,"");B=B.replace(/<\/p>/gi,"");if(C.indexOf(".")>-1){C='<span class="'+C.replace(/[.]/gi,"")+'">'+B+"</span>"}else{C="<"+C+">"+B+"</"+C+">"}currentRichTextDocument.selection.createRange().pasteHTML(C)}else{alert(parent.uiKeys.errors_stylesMustMarkBeforeSelect)}}function umbracoShowStyles(B){setRichTextObject(B);var A=currentRichTextObject.innerHTML;if(A.indexOf("styleMarkStart.gif")>0){A=A.replace(/<img alt=\"Style: ([^"]+)\" \/?.*?>/gi,"<span class=$1>");A=A.replace(/<img alt=\"Formatering slut\" \/?.*?>/gi,"</span>")}else{if(A.indexOf("<span")>-1||A.indexOf("<SPAN")>-1){A=A.replace(/<span CLASS=(\/?.*?)>/gi,'<img src="images/editor/styleMarkStart.gif" alt="Style: $1">');A=A.replace(/<span>/gi,"");A=A.replace(/<\/span>/gi,'<img src="images/editor/styleMarkEnd.gif" alt="Formatering slut">')}else{alert(parent.uiKeys.errors_stylesNoStylesOnPage)}}currentRichTextObject.innerHTML=A};