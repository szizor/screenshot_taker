
$(function() {

    "use strict";

    var flash_wrapper   = $('.flash_wrapper'),
        flash_error     = flash_wrapper.find('#flash_error'),
        flash_notice    = flash_wrapper.find('#flash_notice'),
        flash_close     = flash_wrapper.find('.flash_close'),
        _image_id       = document.getElementById('image_id').value,
        _shot_id_       = null,
        image_message   = $('#holder .message').hide(),
        $document       = $(document),
        $window         = $(window);

    var showFlashNotice = function(msg) {
        flash_error.hide();
        flash_wrapper.show();
        arguments.length && flash_notice.html(msg);
        flash_notice.fadeIn();
    };

    var showFlashError = function (msg) {
        flash_notice.hide();
        flash_wrapper.show();
        arguments.length && flash_error.html(msg);
        flash_error.fadeIn();
    };

    var hideFlash = function (delay) {
        arguments.length ? flash_wrapper.delay(delay).fadeOut('fast') : flash_wrapper.fadeOut('fast');
    };

    // handles the top thumbnails
    var thumbnails = {
        $thumbs     : $('.thumbnails'),
        $thumbs_li  : null,
        init: function () {
            this.$thumbs_li     = this.$thumbs.find('li');
            // if there is no thumbnails active (init state),
            // mark the first one (default) as active
            !this.$thumbs_li.hasClass('active') && this.$thumbs_li.first().addClass('active');
            this.bindEvents();
        },
        bindEvents: function () {
            flash_close.on('click', function() {
                hideFlash();
            });
            $(':checkbox').live('click',function() {
                $(this).closest('form').submit();
            });
        }
    };
    thumbnails.init();

    var ctas = {
        holder      : $('.buttons-holder'),
        upload      : {},
        from_url    : {},
        share       : {},
        purchase    : {},
        ui          : {},
        init: function () {
            this.upload.holder      = this.holder.find('.upload');
            this.upload.inputFile   = this.upload.holder.find('input[type="file"]');
            this.upload.btn         = this.upload.holder.find('.btn');
            this.from_url.holder    = this.holder.find('.from_url');
            this.from_url.btn       = this.from_url.holder.find('.btn');
            this.share.holder       = this.holder.find('.share').addClass('hidden');
            this.share.btn          = this.share.holder.find('.btn');
            this.share.tooltip      = this.share.holder.find('.tooltip-wrapper');
            this.share.urlWraper    = this.share.tooltip.find('.header');
            this.share.inputURL     = this.share.urlWraper.find('#share_url');
            this.share.social       = this.share.tooltip.find('.body');
            this.share.loader       = this.share.tooltip.find('.loading');
            this.ui.rss_holder      = $('.megaphone');
            this.ui.rss_icon        = this.ui.rss_holder.find('.icn');
            this.ui.rss_tooltip     = this.ui.rss_holder.find('.tooltip-wrapper');
            this.ui.rss_input       = this.ui.rss_holder.find('.subscribe-rss-input');
            this.ui.rss_button      = this.ui.rss_holder.find('.subscribe-rss-btn');
            this.purchase.holder    = this.holder.find('.purchase').addClass('hidden');
            this.purchase.btn       = this.purchase.holder.find('.btn');
            this.purchase.tooltip   = this.purchase.holder.find('.tooltip-wrapper');
            this.bindEvents();
        },
        bindEvents: function () {
            // this.ui.rss_icon.on('click', function (e) {
            //     e.stopPropagation();
            //     if (!ctas.ui.rss_tooltip.is(':visible')) {
            //         ctas.ui.rss_input.focus();
            //         $document.on('click', function(e) {
            //             !$(e.target).parents('.tooltip-wrapper').length && ctas.ui.rss_tooltip.hide();
            //         });
            //     } else {
            //         $document.off('click');
            //     }
            //     ctas.ui.rss_input.removeClass('error').val("");
            //     ctas.ui.rss_button.removeClass('error');
            //     ctas.ui.rss_tooltip.toggle();
            // });
            this.ui.rss_input.on('keypress', function(e) {
                ctas.ui.rss_input.removeClass('error');
                ctas.ui.rss_button.removeClass('error');
                e.keyCode === 13 && ctas.ui.rss_button.trigger('click');
            });
            this.ui.rss_button.on('click', function () {
                var reg = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
                    email = ctas.ui.rss_input[0].value,
                    url = "http://feedburner.google.com/fb/a/mailverify?uri=placeit&email=" + email;
                if (reg.test(ctas.ui.rss_input[0].value)) {
                    window.open(url, "Subscribe PlaceIt RSS", "width=550, height=600", false);
                } else {
                    ctas.ui.rss_input.addClass('error').focus();
                    ctas.ui.rss_button.addClass('error');
                }
            });

            this.upload.inputFile.on('change', function (e) {
                (e.target.value !== "") && uploader.processing(this.files);
            });

            this.upload.btn.on('click', function () {
                ctas.upload.inputFile.trigger('click');
            });

            this.from_url.btn.on('click', function () {
                var url = prompt("website url"),
                    bg  = $(':checkbox').is(':checked');
                if (url) {
                    uploader.$holder.addClass("processing");
                    showFlashNotice("Please wait a few seconds while we grab a screenshot and process it!");
                    uploader.whileProcessing();
                    $.ajax({
                        url     : '/productshots/url2png_v6',
                        data    : {
                            'shot_id': _image_id,
                            'bg'     : bg,
                            'url': url
                        },
                        success: function (data) {
                            if (data !== "error") {
                                setTimeout(function () {
                                  uploader.checkQueue(data, true);
                                }, 2000);
                            } else {
                                showFlashError("Url not found");
                                uploader.$holder.removeClass();
                                uploader.$loader.addClass('hidden');
                                ctas.share.holder.addClass('hidden');
                            }
                        }
                    });
                }
            });

            this.share.btn.on('click', function (e) {
                e.stopPropagation();
                ctas.share.inputURL.on('click', function() {
                    ctas.share.inputURL[0].focus();
                    ctas.share.inputURL[0].select();
                });

                if (!ctas.share.tooltip.is(':visible')) {
                    ctas.share.inputURL.trigger('click');
                    (ctas.share.inputURL[0].value === "") && ctas.createShareButtons();
                    $document.on('click', function(e) {
                        !$(e.target).parents('.tooltip').length && ctas.share.tooltip.hide();
                    });
                } else {
                    $document.off('click');
                }
                ctas.share.tooltip.toggle();
            });
            this.purchase.btn.on('click', function (e) {
                e.preventDefault();
                ctas.purchase.tooltip.toggle();
            });
        },
        createShareButtons: function() {
            $.ajax({
                url     : '/productshots/store_in_s3',
                data    : {'id': $('#image_holder').attr('src')},
                success : function (data) {
                    if (data !== "error") {
                        var url = 'http://placeit.breezi.com' + '/' + data,
                            s3  = 'http://s3.amazonaws.com/place-it/public',
                            t = '<a href="https://twitter.com/share" class="twitter-share-button" data-url="'+ url +'" data-count="none" data-via="breeziapp">Tweet</a>',
                            f = '<iframe src="//www.facebook.com/plugins/like.php?href=' + url +'%2F&amp;send=false&amp;layout=standard&amp;width=85&amp;show_faces=false&amp;font=arial&amp;colorscheme=light&amp;action=like&amp;height=24&amp;locale=en_US" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:85px; height:24px;" allowTransparency="true"></iframe>',
                            g = '<div class="g-plusone" data-size="medium" data-annotation="inline" data-width="120" data-href="'+ url +'"></div>',
                            p = '<a href="http://pinterest.com/pin/create/button/?url='+ url +'&media='+ s3 + $('#image_holder').attr('src') +'" class="pin-it-button" count-layout="none"><img border="0" src="//assets.pinterest.com/images/PinExt.png" title="Pin It" /></a>',
                            l = '<script src="//platform.linkedin.com/in.js" type="text/javascript"></script> \
                                <script type="IN/Share" data-url="'+ url +'"></script>';

                        ctas.share.inputURL[0].value = url;
                        ctas.share.social.find('.twitter').append(t);
                        ctas.share.social.find('.facebook').append(f);
                        ctas.share.social.find('.gplus').append(g);
                        ctas.share.social.find('.pinterest').append(p);
                        ctas.share.social.find('.linkedin').append(l);

                        ctas.share.urlWraper.fadeIn();
                        ctas.share.social.fadeIn();
                        ctas.share.loader.hide();

                        (function(doc, script) {
                            var js,
                                fjs = doc.getElementsByTagName(script)[0],
                                frag = doc.createDocumentFragment(),
                                add = function(url, id) {
                                    if (doc.getElementById(id)) {return;}
                                    js = doc.createElement(script);
                                    js.src = url;
                                    id && (js.id = id);
                                    frag.appendChild( js );
                                };
                            add('http://apis.google.com/js/plusone.js');
                            add('//platform.twitter.com/widgets.js');
                            fjs.parentNode.insertBefore(frag, fjs);
                        }(document, 'script'));

                        // CopytoClipboard
                        $('#copytoclipboard').zclip({
                            path: '/javascripts/zclip/ZeroClipboard.swf',
                            copy: function() {
                                return ctas.share.inputURL[0].value;
                            },
                            afterCopy: function(){
                                showFlashNotice("Copied to clipboard: " + ctas.share.inputURL[0].value);
                            }
                        });
                        $('#copytoclipboard').zclip('show');
                    }
                }
            });
        }
    };
    ctas.init();

    // handles the html5 upload
    var uploader = {
        $holder     : $(document.getElementById('holder')),
        $loader     : $(document.getElementById('loader')),
        $fileupload : $(document.getElementById('upload')),
        tests       : {},
        support     : {},
        init: function () {
            // making sure jquery has the dataTransfer property
            $.event.props.push('dataTransfer');

            uploader.tests.filereader   = typeof FileReader != 'undefined';
            uploader.tests.dnd          = 'draggable' in document.createElement('span');
            uploader.tests.formdata     = !!window.FormData;
            uploader.tests.progress     = "upload" in new XMLHttpRequest;
            uploader.support.filereader = document.getElementById('filereader');
            uploader.support.formdata   = document.getElementById('formdata');
            uploader.support.progress   = document.getElementById('progress');
            uploader.acceptedTypes = {
                'image/png' : true,
                'image/jpeg': true,
                'image/jpg' : true
            };
            this.bindEvents();
        },
        bindEvents: function () {
            this.$fileupload.find('input').on('change', function () {
                uploader.processing(this.files);
            });

            if (uploader.tests.dnd) {
                uploader.$holder.on({
                    dragover: function () {
                        uploader.$holder.addClass('hover');
                        return false;
                    },
                    dragend: function () {
                        uploader.$holder.removeClass();
                        return false;
                    },
                    drop: function (e) {
                        e.stopPropagation();
                        e.preventDefault();
                        uploader.processing(e.dataTransfer.files);
                    }
                });
            } else {
                uploader.$fileupload.addClass('hidden');
            }
        },
        whileProcessing: function () {
            uploader.$loader.removeClass();
            ctas.share.holder.removeClass('hidden');
            ctas.purchase.holder.removeClass('hidden');
            ctas.share.tooltip.hide();
            ctas.share.social.find('.twitter, .facebook, .gplus, .pinterest, .linkedin').html("");
            ctas.share.urlWraper.hide();
            ctas.share.inputURL[0].value = "";
            ctas.share.social.hide();
            ctas.share.loader.show();
            $('.footer-center').html("");
        },
        processing: function (files) {
            uploader.$holder.removeClass().addClass('processing');
            uploader.readFiles(files);
        },
        checkQueue: function (image_id, url2png) {
            var timestamp = new Date().getTime();
            ctas.purchase.btn.data("shot_id", image_id);
            if (url2png === true) {
                // URL2PNG == true
                $.ajax({
                    url     : '/productshots/queue' + "?" + timestamp,
                    data    : {'shot_id': image_id},
                    success : function (data) {
                        if (data == "queue") {
                            setTimeout(function () {
                                uploader.checkQueue(image_id, url2png);
                            }, 2000);
                        } else {
                            var img     = $("#image_holder"),
                                clone   = img.clone().attr("src", data);
                            clone.load(function(){
                                img.replaceWith( clone );
                                uploader.$holder.removeClass();
                                uploader.$loader.addClass('hidden');
                                $('.footer-center').html("<span class='desc'>Screenshot by <a href='http://url2png.com/'>URL2PNG</a></span>");
                                hideFlash(2000);
                                image_message.show().delay(8000).fadeOut('slow');
                            });
                        }
                    }
                });
            } else {
                hideFlash();
                $.ajax({
                    url     : '/productshots/queue' + "?" + timestamp,
                    data    : {'shot_id': image_id},
                    success : function (data) {
                        if (data == "queue") {
                            setTimeout(function () {
                                uploader.checkQueue(image_id);
                            }, 2000);
                        } else {
                            console.log("replace")
                            var img     = $("#image_holder"),
                                clone   = img.clone().attr("src", data);
                            clone.load(function(){
                                img.replaceWith( clone );
                                uploader.$holder.removeClass();
                                uploader.$loader.addClass('hidden');
                                image_message.show().delay(8000).fadeOut('slow');
                            });
                        }
                    }
                });
            }
        },
        readFiles: function (files) {
            var auth_token  = window._token,
                bg          = $(':checkbox').is(':checked'),
                formData    = uploader.tests.formdata ? new FormData() : null;

            formData.append('id', _image_id || 1);
            formData.append('authenticity_token', auth_token);

            for (var i = 0; i < files.length; i++) {
                if (uploader.tests.formdata) {
                    formData.append('file', files[i]);
                    formData.append('bg', bg);
                }
            }
            function get_XmlHttp() {
              // create the variable that will contain the instance of the XMLHttpRequest object (initially with null value)
              var xmlHttp = null;

              if(window.XMLHttpRequest) {       // for Forefox, IE7+, Opera, Safari, ...
                xmlHttp = new XMLHttpRequest();
              }
              else if(window.ActiveXObject) {   // for Internet Explorer 5 or 6
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
              }
              return xmlHttp;
            }
            // now post a new XHR request .
            if (uploader.acceptedTypes[files[0].type] === true && files[0].size < 5242880) {
                this.whileProcessing();
                var timestamp = new Date().getTime();
                if (uploader.tests.formdata) {
                    var xhr =  get_XmlHttp();
                    xhr.open('POST', "/productshots/upload" + "?" + timestamp, true);
                    xhr.onload = function(e) {
                        (this.response == "error")
                            ? console.log("img_rule not set")
                            : console.log("received");uploader.checkQueue(this.response);
                    }
                    xhr.onreadystatechange =console.log("Ready...");
                    // var progressBar = document.querySelector('progress');
                    // xhr.onprogress = function(e) {
                    //     if (e.lengthComputable) {
                    //       progressBar.value = (e.loaded / e.total) * 100;
                    //       progressBar.textContent = progressBar.value; // Fallback for unsupported browsers.
                    //     }
                    //   };
                }
                console.log("sending...")
                xhr.send(formData);
                return false
            } else {
                showFlashError("Sorry that's not a valid filetype, please use only .jpg or .png smaller that 5 mbs.");
                uploader.$holder.removeClass();
                uploader.$loader.addClass('hidden');
            }
        }
    };
    uploader.init();
});
