function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

/*
		CSS Browser Selector v0.4.0 (Nov 02, 2010)
		Rafael Lima (http://rafael.adm.br)
		http://rafael.adm.br/css_browser_selector
		License: http://creativecommons.org/licenses/by/2.5/
		Contributors: http://rafael.adm.br/css_browser_selector#contributors
*/
		function css_browser_selector(u){var ua=u.toLowerCase(),is=function(t){return ua.indexOf(t)>-1},g='gecko',w='webkit',s='safari',o='opera',m='mobile',h=document.documentElement,b=[(!(/opera|webtv/i.test(ua))&&/msie\s(\d)/.test(ua))?('ie ie'+RegExp.$1):is('firefox/2')?g+' ff2':is('firefox/3.5')?g+' ff3 ff3_5':is('firefox/3.6')?g+' ff3 ff3_6':is('firefox/3')?g+' ff3':is('gecko/')?g:is('opera')?o+(/version\/(\d+)/.test(ua)?' '+o+RegExp.$1:(/opera(\s|\/)(\d+)/.test(ua)?' '+o+RegExp.$2:'')):is('konqueror')?'konqueror':is('blackberry')?m+' blackberry':is('android')?m+' android':is('chrome')?w+' chrome':is('iron')?w+' iron':is('applewebkit/')?w+' '+s+(/version\/(\d+)/.test(ua)?' '+s+RegExp.$1:''):is('mozilla/')?g:'',is('j2me')?m+' j2me':is('iphone')?m+' iphone':is('ipod')?m+' ipod':is('ipad')?m+' ipad':is('mac')?'mac':is('darwin')?'mac':is('webtv')?'webtv':is('win')?'win'+(is('windows nt 6.0')?' vista':''):is('freebsd')?'freebsd':(is('x11')||is('linux'))?'linux':'','js']; c = b.join(' '); h.className += ' '+c; return c;}; css_browser_selector(navigator.userAgent);
		$(document).ready(function () {

		    $('.publicationLinks a.secure').click(function () {
		        $('#fileName').val($(this).attr('title'));
		        $('.lightBoxContainer, .lightBox').fadeIn();
		    });

		    $('.btnClose, .lightBoxContainer').click(function () {
		        $('.lightBoxContainer, .lightBox').fadeOut();
		    });

		    $('.noLink').click(function (ev) {
		        ev.preventDefault();
		        ev.stopPropagation();
		    });


		    $('.btnDownload').click(function (ev) {
		        LogDownload();
		    });


		});





	/* ~~~~~~~~~~~~~ browser upgrade ~~~~~~~~~~~~~*/
	$(document).ready(function(){
		$('#close_ie6upgrade').mousedown(function(){
			$('#ie6').slideUp();
			return false;	
		})
	});


/* ~~~~~~~~~~~~~ Blog ~~~~~~~~~~~~~*/

function isValidEmail(email) {
    var regex = /([\w\d\-_]+)(\.[\w\d\-_]+)*@([\w\d\-_]+\.)([\w\d\-_]+\.)*([\w]{2,3})/;
    if (regex.test(email))
        return true;
    else
        return false;
}
function trim(str, chars) {
    return ltrim(rtrim(str, chars), chars);
}
function ltrim(str, chars) {
    chars = chars || '\\s';
    return str.replace(new RegExp('^[" + chars + "]+', 'g'), '');
}
function rtrim(str, chars) {
    chars = chars || '\\s';
    return str.replace(new RegExp('[" + chars + "]+$', 'g'), '');
}
function setupDefaultTextReset(obj, message) {
    obj.click(function () {
        if (obj.val() == message)
            obj.val('');
    });
    obj.blur(function () {
        if (obj.val() == '')
            obj.val(message);
    });
}
function PostBackOnReturn(event, postbackMethod) {
    if (event) {
        if (event.keyCode == 13) {
            __doPostBack(postbackMethod, '');
        }
    }
}
String.prototype.startsWith = function (str) { return (this.match("^" + str) == str); }
String.prototype.trim = function () { return trim(this); }
function blogReplyClicked(e) {
    var comment = $(this).parent();
    var commentId = $(this).attr("rel");
    var replyFormHTML = $("#commentReplyFormTemplate").html().toString();
    replyFormHTML = replyFormHTML.replace(/\-commentId/gi, "-" + commentId);


    comment.after(replyFormHTML);

    $("#send-" + commentId).attr("rel", commentId);


    var cvalid = new validator();
    cvalid.applyFormValidation({
        validationMessage: "Oops you missed these required fields...",
        validationMessages: $("#validationMessage-" + commentId),
        fieldErrorClass: "errorState",
        submitButton: $("#send-" + commentId),
        doPostback: function (e, z) {

            var commentID = $(e).attr("rel");

            var name = $("#name-" + commentID).val();
            var email = $("#email-" + commentID).val();
            var comment = $("#commentText-" + commentID).val();
            var websiteURL = $("#website-" + commentID).val();


            $(e).parent().html('Submitting... Please Wait');

            //this is for the devs to sort out, if needed
            //return; //remove this statement when going into development
            jQuery.post('/handlers/BlogCommentReply.ashx', { commentid: commentID, name: name, email: email, comment: comment, websiteurl: websiteURL }, function (data) {
                if (data.indexOf('Success') >= 0) {
                    if (data.indexOf("Success:posted") >= 0) {
                        $('.commentReply').html('<div class="reply"><p><span class="commentor">' + name + '</span>&nbsp;&nbsp;' + comment + '</p></div>');
                    }
                    else {
                        $('.commentReply').html('<div class="reply"><p>' + comment + '<br /><em>Your reply is now submitted and pending approval</em><br /><span class="commentor">' + name + '</span></p></div>');
                        window.location = '#divBlogReplyComment-' + commentID;
                    }
                }
                else {
                    $('.commentReply div.commentFormContainer p.blog-reply-error').html('An error had occurred. Please try again later.');
                    $('.commentReply div.commentFormContainer p.blog-reply-error').css('display', 'block');
                }
                z.preventDefault();
                return false;
            });
            z.preventDefault();
            return false;
        },
        fields: [
        { type: "required", control: $("#commentText-" + commentId), msg: "A comment is required", dt: "Comment" },
        { type: "required", control: $("#name-" + commentId), msg: "Your name is required", dt: "Name is required" },
        { type: "notrequired", control: $("#website-" + commentId), dt: "Your Website URL (optional)" },
        { type: "regex", control: $("#email-" + commentId), msg: "A valid email is required", dt: "Email is required but not published", expression: /^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/ }

    ]
    });
    e.preventDefault();
    return false;
}
/* ~~~~~~~~~~~~~ End Blog ~~~~~~~~~~~~~*/



/* ~~~~~~~~~~ Send the footer subscription form ~~~~~~*/
function SendFooterContact() {
    var userName = $(".userName").val();
    var userEmail = $(".userEmail").val();
    var doc = "None";
    if (!isValidEmailAddress(userEmail)) {
        $(".error").show();
        $(".error").html("It seems you have entered an incorrect email address - please try again.");
        $(".success").hide();
    } else {
        $.get('/handlers/EmailSignUp.ashx', { Email: userEmail, Name: userName, doc: doc, userType: 'Subscription'}, function (data) {
            if (data == "Success") {
                $(".error").hide();
                $(".success").show();
                $(".success").html("You have successfully subscribed to our newsletters. Thank you for your interest!");
                            
                $(".userName").val("");
                $(".userEmail").val("");
            } else {
                $(".error").show();
                $(".error").html();
            }
        });
    }
}

/*~~~~~~~~~~~~~~~~~~ Log the downloads ~~~~~~~~~~~*/
function LogDownload() {
   
    var userName = $("#dl_userName").val();
    var userEmail = $("#dl_userEmail").val();
    var doc = $("#fileName").val();    

    if (!isValidEmailAddress(userEmail)) {
        $(".dl_error").show();
        $(".dl_error").html("It seems you have entered an incorrect email address - please try again.");
        // $(".dl_success").hide();
    } else {

        alert(doc);

        $.get('/handlers/EmailSignUp.ashx', { Email: userEmail, Name: userName, doc: doc, userType: 'Download' }, function (data) {
            if (data == "Success") {
                $(".dl_error").hide();
                //Do we need success message?
                // $(".dl_success").show();
                // $(".dl_success").html("You have successfully subscribed to our newsletters. Thank you for your interest!");

              //  $(".userName").val("");
              // $(".userEmail").val("");
            } else {
                $(".dl_error").show();
                $(".dl_error").html();
            }
        });
    }
}


function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
    return pattern.test(emailAddress);
};



//___________________ Do the site search _____________________//

$(document).ready(function () {  

    var qSearchString = getQuerystring("search");
   
    if (qSearchString != '') {
        $("#searchString").val(URLDecode(qSearchString));
    }

    function URLDecode(psEncodeString) {
        // Create a regular expression to search all +s in the string
        var lsRegExp = /\+/g;
        // Return the decoded string
        return unescape(String(psEncodeString).replace(lsRegExp, " "));
    }   
      //  doSearch();   
});

function doSearch() {
    var Category = "";
    var SearchString = "";    
    SearchString = $('#searchString').val();

    if (SearchString != '') {        
            window.location = "/search-results?search=" + SearchString;        
    }
}


//get the querystring
function getQuerystring(key, default_) {
    if (default_ == null) default_ = "";
    key = key.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + key + "=([^&#]*)");
    var qs = regex.exec(window.location.href);
    if (qs == null)
        return default_;
    else
        return qs[1];
}

$(function () {

    try{
        $('#formModal').easyModal({
            top: 2,
            autoOpen: false,
            overlayOpacity: 0.8
        });
    }
    catch (err) { }

    $('#formModal input,#formModal textarea').each(function () {
        var placeholder = $(this).attr('placeholder');
        if ($(this).val() == '') {
            $(this).val(placeholder);
        }
    }).focus(function () {
        var placeholder = $(this).attr('placeholder');
        if ($(this).val() == placeholder) {
            $(this).val('');
        }
    }).blur(function () {
        var placeholder = $(this).attr('placeholder');
        if ($(this).val() == '') {
            $(this).val(placeholder);
        }
    });
    
    $('#btnRegistrationForm').click(function () {
        $('#formModal').trigger('openModal');

       
    });

    $('#btnCloseForm').click(function () {
        $('#formModal').trigger('closeModal');
    });

    $('.checkbox').click(function () {
        if ($(this).hasClass('checked') == true) {
            $(this).removeClass('checked');
        } else {
            $(this).addClass('checked');
        }
    });

    $('.btnRegister').click(function () {
        var r = validateRegisterForm();
        if (r) {
            var firstName = getVal('#regFirstName');
            var lastName = getVal('#regLastName');
            var email = getVal('#regEmail');
            var address = getVal('#regAddress');
            var city = getVal('#regCity');
            var categories = getCategories();
            var msg = getVal('#regMessage');

            $.post('/handlers/userhandler.ashx',
                { 'firstName': firstName, 'lastName': lastName, 'email': email, 'address': address, 'city': city, 'categories': categories, 'msg': msg },
                function (data) {
                    if (data == 'true') {
                        $('#pInfo').text('Registration successfully completed.');
                        $('#pInfo').removeClass('error');
                        $('#pInfo').addClass('success');
                    } else {
                        $('#pInfo').text('Cannot register.');
                        $('#pInfo').removeClass('success');
                        $('#pInfo').addClass('error');
                    }
                    $('#pInfo').show();
            }).error(function () {
            })
        }
    })

});

function getVal(id){
    var val = $(id).val();
    val = val.replace($(id).attr('placeholder'),'');
    return val;
}

function getCategories() {
    var data = '';
    /*
    $('.checkboxContainer').each(function () {
        data += $(this).prev('h4').text()+'::';
        $(this).find('.checked').each(function () {
            data += $(this).next('span').text() + ';;';
        });
        data += '||';
    })
    */
    $('.checkboxContainer .checkbox').each(function () {
        if ($(this).hasClass('checked')) {
            data += $(this).next('span').text() + "::Yes;;";
        } else {

            data += $(this).next('span').text() + "::No;;";
        }
    })
    return data;
}

function validateRegisterForm() {
    var r = true;

    $('.required').each(function () {
        var placeholder = $(this).attr('placeholder');
        var val = $(this).val();
        if (val != '' && val != placeholder) {
            $(this).removeClass('borderErr');
        } else {
            $(this).addClass('borderErr');
            r = false;
        }
    });

    var email = $('#regEmail').val();
    if (email != '' && email != $('#regEmail').attr('placeholder')) {
        if (!isValidEmailAddress(email)) {
            $('#regEmail').addClass('borderErr');
            r = false;
        } else {
            $('#regEmail').removeClass('borderErr');
        }
    }

    $('.requiredCheckbox').each(function () {
        if ($(this).find('.checked').length == 0) {
            $(this).addClass('borderErr');
            r = false;
        } else {
            $(this).removeClass('borderErr');
        }
    })

    return r;
}
