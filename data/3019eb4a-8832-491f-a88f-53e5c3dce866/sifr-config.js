/*****************************************************************************
It is adviced to place the sIFR JavaScript calls in this file, keeping it
separate from the `sifr.js` file. That way, you can easily swap the `sifr.js`
file for a new version, while keeping the configuration.

You must load this file *after* loading `sifr.js`.

That said, you're of course free to merge the JavaScript files. Just make sure
the copyright statement in `sifr.js` is kept intact.
*****************************************************************************/

// Make an object pointing to the location of the Flash movie on your web server.
// Try using the font name as the variable name, makes it easy to remember which
// object you're using. As an example in this file, we'll use Futura.
var Amasis_MT_font = { src: '/Media/Assets/sIFR/Amasis_MT.swf' };

// Now you can set some configuration settings.
// See also <http://wiki.novemberborn.net/sifr3/JavaScript+Configuration>.
// One setting you probably want to use is `sIFR.useStyleCheck`. Before you do that,
// read <http://wiki.novemberborn.net/sifr3/DetectingCSSLoad>.

sIFR.useStyleCheck = true;

    // Next, activate sIFR:
    sIFR.activate(Amasis_MT_font);

// If you want, you can use multiple movies, like so:
//
//    var futura = { src: '/path/to/futura.swf' };
//    var garamond = { src '/path/to/garamond.swf' };
//    var rockwell = { src: '/path/to/rockwell.swf' };
//    
//    sIFR.activate(futura, garamond, rockwell);
//
// Remember, there must be *only one* `sIFR.activate()`!


/*
==============================================================
Warren: Use jQuery ready (DOM) to check if class name exists.
i.e the live editing toolbar (Canvas)
===============================================================
*/
    $(document).ready(function() {
        if ($("div#LiveEditingToolbar").length <= 0) {
            //Canvas Editing is NOT enabled

            //Replace header <h1> with class of flashHeader	
            sIFR.replace(Amasis_MT_font, {
                selector: 'h1.flashHeader',
                css: [
                '.sIFR-root { font-weight:normal; color:#f49ac1; leading:-10; letter-spacing:-2; text-transform:uppercase; }',
                'a { text-decoration: none }',
                'a:link { color: #f49ac1 }',
                'a:hover { color: #FFFFFF }'
                ],
                wmode: 'transparent'
            });

            //Replace header <h2> with class of flashHeader
            sIFR.replace(Amasis_MT_font, {
                selector: 'h2.flashHeader',
                css: [
                '.sIFR-root { font-weight:normal; color:#FFFFFF; leading:-3; letter-spacing:-1; }',
                'a {color:#FFFFFF; text-decoration:none;}',
                'strong { font-weight:bold; color:#f49ac1; }'
                ],
                wmode: 'transparent'
            });

            //Replace header <h2> which inside XSLTSearch
            sIFR.replace(Amasis_MT_font, {
                selector: '#xsltsearch h2',
                css: [
                '.sIFR-root { font-weight:normal; color:#f49ac1; leading:-3; letter-spacing:-1; }'
                ],
                wmode: 'transparent'
            });

            //Replace header <h4> that is inside a DIV which is inside a div with a class of newsList
            sIFR.replace(Amasis_MT_font, {
                selector: 'div.newsList div h4',
                css: [
                '.sIFR-root { font-weight:normal; color:#619ca7; leading:-3; letter-spacing:-1; }',
                'a { text-decoration: none }',
                'a:link { color: #619ca7 }',
                'a:hover { color: #FFFFFF }'
                ],
                wmode: 'transparent'
            });

        }
        else {
            //Lets REMOVE the CSS class that sIFR adds
            sIFR.removeFlashClass();
        }
    });

