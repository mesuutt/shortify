
window.onload = function (ev) {

    var urlInput = document.getElementById("destinationUrl");
    urlInput.focus();

    urlInput.addEventListener('paste', function (event) {
        var url = event.clipboardData.getData('text');
        if (!isValidUrl(url)) return;
        shortify(url);

    });

    urlInput.addEventListener('keypress', function (event) {
        var code = event.which || event.keyCode;

        if (code == 13) {
            var url = event.target.value;
            if (!isValidUrl(url)) return;
            shortify(url);
        }
    });

    function isValidUrl(url) {
        // https://stackoverflow.com/a/15855457/1027507
        return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[/?#]\S*)?$/i.test(url);
    }

    function shortify(url) {
        var r = new XMLHttpRequest();
        r.open("POST", window.location.origin + "/urls", true);
        r.setRequestHeader('Content-Type', 'application/json');
        r.onreadystatechange = function () {
            if (r.readyState != 4 || r.status != 200) return;
            var data = JSON.parse(r.responseText);
            urlInput.value = data.short_url;
            urlInput.select();
        };

        r.send(JSON.stringify({'url': url}));
    }
}
