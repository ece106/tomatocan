//Thanks, StackOverflow guy! https://stackoverflow.com/questions/17195738/dynamically-adjust-text-color-based-on-background-image/20596033#20596033

window.onload = function() {
    var img = document.getElementById('userBannerImage');
    var c = document.createElement('canvas');
    var ctx = c.getContext('2d');
    var w = img.clientWidth; var h = img.clientHeight;
    c.width = w;
    c.height = h;
    ctx.drawImage(img, 0, 0);
    var data = ctx.getImageData(0, 0, w, h).data;
    var brightness = 0;
    var sX = 200, sY = 10, eX = 80, eY = 40;
    var start = (w * sY + sX) * 4, end = (w * eY + eX) * 4;
    for (var i = start, n = end; i < n; i += 4) {
        var r = data[i],
            g = data[i + 1],
            b = data[i + 2];
        brightness += 0.34 * r + 0.5 * g + 0.16 * b;
        if (brightness !== 0) brightness /= 2;
    }
    if (brightness > 0.5) var nameColor = "#8C1D40";
    else var nameColor = "#FFC627";
    if (brightness > 0.5) var descColor = "black";
    else var descColor = "white";
    document.getElementById('profileName').style.color = nameColor;
    document.getElementById('profileDescription').style.color = descColor;
    img.crossOrigin = "Anonymous";
};
