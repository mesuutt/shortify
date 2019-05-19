
$(function(){
    var $input = $("#destinationUrl");
    $input.get(0).focus();

    //$input.on('paste', switchButtons);
    $input.on('input', switchButtons);

    $input.on('keypress', function (event) {
        var code = event.which || event.keyCode;
        switchButtons();
        if (code == 13) checkAndShortify();
    });

    $('#btnShortUrl').on('click', checkAndShortify);
    $('#btnCopyUrl').on('click', function(){
        var $btn = $(this);
        $input.get(0).select();
        document.execCommand('copy');
        $btn.addClass('is-primary').removeClass('is-info').html("Copied");
        setTimeout(function(){
            $btn.addClass('is-info').removeClass('is-primary').html("Copy");
        }, 500);
    });

    $('body').on('click', '.btnCopy', function(){
        var $btn = $(this);
        var url = $btn.closest('.box').find('.shortenedUrl').attr('href');
        $('#copyInput').val(url).get(0).select();
        document.execCommand('copy');
        $btn.addClass('is-primary').removeClass('is-info').html("Copied");
        setTimeout(function(){
            $btn.addClass('is-info').removeClass('is-primary').html("Copy");
        }, 500);
    });

    function switchButtons(){
        $('#btnShortUrl').show();
        $('#btnCopyUrl').hide();
    }

    function checkAndShortify() {
        var url = $input.val();
        if (!isValidUrl(url)) return;
        if (url.startsWith(window.location.origin)) return;

        shortifyUrl(url).then(addLink).then(function(){
            $('#btnShortUrl').hide();
            $('#btnCopyUrl').show();
        });
    }

    function addLink(data) {
        $("#shortenedUrlsCon").empty();
        var template = $("#shortenedUrlBoxTemplate").clone();
        template.removeAttr("id");
        template.find(".destinationUrl").html($('#destinationUrl').val())
        template.find(".shortenedUrl").html(data.short_url).attr('href', data.short_url);
        template.appendTo("#shortenedUrlsCon").show();
        $input.val(data.short_url);
        $input.get(0).select();
    }

    function isValidUrl(url) {
        // https://stackoverflow.com/a/15855457/1027507
        return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[/?#]\S*)?$/i.test(url);
    }

    function shortifyUrl(url) {
        return fetch(window.location.origin + "/urls", {
            method: 'POST',
            // mode: 'cors',
            body: JSON.stringify({'url': url}),
            headers: {
                'Content-Type': 'application/json',
            },
        }).then(function(response){
            return response.json();
        });
    }
});
