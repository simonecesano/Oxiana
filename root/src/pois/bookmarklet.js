javascript: (function() {
    var w = window.open("");
    w.location.href = "http://localhost:3000/poi/add?url=" + unescape(encodeURIComponent(window.location.href)) + "&sel=" + encodeURIComponent(document.getSelection())
})()
