//Only run this if the DOM is ready
$(function() {

    $(".contact .form_logs li").click(function() {

        var logName = $(this).find("ul li.name").text();
        var logAddressLine1 = $(this).find("ul li.addressLine1").text();
        var logAddressLine2 = $(this).find("ul li.addressLine2").text();
        var logEmail = $(this).find("ul li.email").text();
        var logMessage = $(this).find("ul li.message").text();

        $(".contact .displayLog span.name").text(logName);
        $(".contact .displayLog span.addressLine1").text(logAddressLine1);
        $(".contact .displayLog span.addressLine2").text(logAddressLine2);
        $(".contact .displayLog span.email").text(logEmail);
        $(".contact .displayLog span.message").text(logMessage);


        //Remove selected class from previous item
        $(this).parents().find(".contact .form_logs li.selected").removeClass("selected");

        //Add selected class
        $(this).addClass("selected");

        return false;
    });


    $(".emailAFriend .form_logs li").click(function() {

        var logURL = $(this).find("ul li.url").text();
        var logFriendName = $(this).find("ul li.friendName").text();
        var logFriendEmail = $(this).find("ul li.friendEmail").text();
        var logYourName = $(this).find("ul li.yourName").text();
        var logYourEmail = $(this).find("ul li.yourEmail").text();
        var logMessage = $(this).find("ul li.message").text();

        $(".emailAFriend .displayLog span.url").text(logURL);
        $(".emailAFriend .displayLog span.friendName").text(logFriendName);
        $(".emailAFriend .displayLog span.friendEmail").text(logFriendEmail);
        $(".emailAFriend .displayLog span.yourName").text(logYourName);
        $(".emailAFriend .displayLog span.yourEmail").text(logYourEmail);
        $(".emailAFriend .displayLog span.message").text(logMessage);


        //Remove selected class from previous item
        $(this).parents().find(".emailAFriend .form_logs li.selected").removeClass("selected");

        //Add selected class
        $(this).addClass("selected");

        return false;
    });
});  