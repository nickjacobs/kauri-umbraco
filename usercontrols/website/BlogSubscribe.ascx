<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BlogSubscribe.ascx.cs" Inherits="usercontrols_website_BlogSubscribe" %>

<input type="hidden" id="hfBlogId" value="<%=BlogId %>" />

<fieldset class="threeColumn blogEmail" id="fsBlogSubscribe">
    <label for="tbUpdates"><span></span>sign up for blog updates via email</label>
    <input id="tbUpdates" type="text" value="type your email address here" />
    <a class="buttonSignup" href="#">sign up</a>
    <span class="error"></span> 
    <span class="success">Your signup was successful</span>
    <span class="wait"><img alt="loading.." src="/resources/images/ui/ajax-loader.gif">Subscribing..</span>
</fieldset>

<asp:PlaceHolder ID="phForward" runat="server" Visible="false">
    <fieldset class="threeColumn blogEmail" id="fsBlogForwardSplash">
        <label for="tbUpdates"><span></span>forward this article</label>
        <input type="text" value="" />
    </fieldset>
    <fieldset class="threeColumn blogEmail" id="fsBlogForward" style="margin-top:10px;display:none;">
        <input id="tbForwardName" type="text" value="type your name here" />
        <input id="tbForwardEmail" type="text" value="type your email address here" />
        <div class="friendemails">
            <input type="text" value="your friend's email address" />
        </div>
        <a class="buttonAdd" href="#">+ add friend</a>
        <a class="buttonSignup buttonSignupAlt" href="#">forward</a>
        <div class="clearer"></div>
        <span class="error error2"></span> 
        <span class="success success2">Blog successfully forwarded</span>
        <span class="wait wait2"><img alt="forwarding.." src="/resources/images/ui/ajax-loader.gif">Forwarding..</span>
    </fieldset>
</asp:PlaceHolder>

<script type="text/javascript">
    $(document).ready(function() {
        //subscribe
        $('#fsBlogSubscribe').mouseover(function() {
            $('#fsBlogSubscribe>label').fadeOut(100);
        });
        $('#fsBlogSubscribe>a.buttonSignup').click(function() {
            blogSubscribe();
            return false;
        });
        $('#fsBlogSubscribe input#tbUpdates').keyup(function(event) {
            if (event.keyCode == '13') {
                blogSubscribe();
            }
        });
        setupDefaultTextReset($('#fsBlogSubscribe input#tbUpdates'), 'type your email address here');

        //forward
        $('#fsBlogForwardSplash').mouseover(function() {
            $('#fsBlogForwardSplash').fadeOut(10);
            $('#fsBlogForward').fadeIn(100);
        });
        $('#fsBlogForward a.buttonAdd').click(function() {
            $('div.friendemails').append('<input type="text" value="your friend\'s email address" />');
            setupDefaultTextReset($('div.friendemails input:last'), "your friend's email address");
            return false;
        });
        $('#fsBlogForward>a.buttonSignup').click(function() {
            blogForward();
            return false;
        });
        $('#fsBlogForward input#tbUpdates').keyup(function(event) {
            if (event.keyCode == '13') {
                blogForward();
            }
        });
        setupDefaultTextReset($('#fsBlogForward input#tbForwardName'), 'type your name here');
        setupDefaultTextReset($('#fsBlogForward input#tbForwardEmail'), 'type your email address here');
        setupDefaultTextReset($('div.friendemails input'), "your friend's email address");
    });
    function blogSubscribe() {
        var email = $('#fsBlogSubscribe input#tbUpdates').val();
        $('#fsBlogSubscribe span.error').html('');
        $('#fsBlogSubscribe input#tbUpdates').removeClass('error');

        if (trim(email) == '' ||
        trim(email) == 'type your email address here') {
            $('#fsBlogSubscribe span.error').html('Please enter your email address');
        }
        else if (!isValidEmail(email)) {
            $('#fsBlogSubscribe span.error').html('Please enter a valid email address');
        }
        if ($('#fsBlogSubscribe span.error').html() != '') {
            $('#fsBlogSubscribe span.error').fadeIn(500);
            $('#fsBlogSubscribe input#tbUpdates').addClass('error');
            setTimeout(function() { $('#fsBlogSubscribe span.error').fadeOut(500); }, 3000);
        }
        else {
            //send
            $('#fsBlogSubscribe span.wait').show();
            $.post("/handlers/BlogSubscriptionHandler.ashx", { email: email }, function(data) {
                $('#fsBlogSubscribe span.wait').hide();

                if (data.indexOf('Error:') != -1) {
                    $('#fsBlogSubscribe span.error').fadeIn(500);
                    $('#fsBlogSubscribe span.error').html('An error had occured. Please try again later.');
                }
                else if (data.indexOf('Success') != -1) {
                    $('#fsBlogSubscribe span.success').fadeIn(500);
                }
            });
        }
    }
    function blogForward() {
        var name = $('#fsBlogForward input#tbForwardName').val();
        var email = $('#fsBlogForward input#tbForwardEmail').val();
        var friendemail = $('#fsBlogForward div.friendemails input').val();
        $('#fsBlogForward span.error').html('');
        $('#fsBlogForward input#tbForwardName').removeClass('error');
        $('#fsBlogForward input#tbForwardEmail').removeClass('error');
        $('#fsBlogForward div.friendemails input').removeClass('error');

        var errorMessage = '';
        if (trim(name) == '' ||
            trim(name) == 'type your name here') {
            $('#fsBlogForward input#tbForwardName').addClass('error');
            errorMessage += 'Please enter your name<br />';
        }
        if (trim(email) == '' ||
            trim(email) == 'type your email address here') {
            $('#fsBlogForward input#tbForwardEmail').addClass('error');
            errorMessage += 'Please enter your email address<br />';
        }
        else if (!isValidEmail(email)) {
            $('#fsBlogForward input#tbForwardEmail').addClass('error');
            errorMessage += 'Please enter a valid email address<br />';
        }
        if (trim(friendemail) == '' ||
            trim(friendemail) == 'type your email address here') {
            $('#fsBlogForward div.friendemails input').addClass('error');
            errorMessage += "Please enter your friend's email address<br />";
        }
        else if (!isValidEmail(friendemail)) {
            $('#fsBlogForward div.friendemails input').addClass('error');
            errorMessage += "Please enter your friend's valid email address<br />";
        }
        if (errorMessage != '') {
            $('#fsBlogForward span.error').html(errorMessage)
            $('#fsBlogForward span.error').fadeIn(500);
        }
        else {
            var emails = '';
            $('div.friendemails input:text').each(function() {
                if ($(this).val() != '' &&
                    $(this).val() != "your friend's email address" &&
                    isValidEmail($(this).val())) {

                    emails += $(this).val() + ',';
                }
            });

            //send
            $('#fsBlogForward span.wait').show();
            $.post("/handlers/BlogForwardHandler.ashx", { blogid: $('#hfBlogId').val(), name: name, email: email, emails:emails }, function(data) {
                $('#fsBlogForward span.wait').hide();

                if (data.indexOf('Error:') != -1) {
                    $('#fsBlogForward span.error').fadeIn(500);
                    $('#fsBlogForward span.error').html('An error had occured. Please try again later.');
                }
                else if (data.indexOf('Success') != -1) {
                    $('#fsBlogForward input#tbForwardName').hide();
                    $('#fsBlogForward input#tbForwardEmail').hide();
                    $('#fsBlogForward div.friendemails').hide();
                    $('#fsBlogForward a.buttonAdd').hide();
                    $('#fsBlogForward a.buttonSignup').hide();
                    $('#fsBlogForward span.success').css('display', 'block');
                }
            });
        }
    }
</script>