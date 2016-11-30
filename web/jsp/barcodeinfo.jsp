<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<html>
<head>
    <%--<title>Title</title>--%>
    <%--<script type="text/javascript" language="javascript" src="//code.jquery.com/jquery-1.12.3.js">--%>
    <%--</script>--%>
    <%--<script>--%>

        <%--getBarcodeInfo(getParameterByName("code"));--%>
        <%--function getParameterByName(name, url) {--%>
            <%--if (!url) {--%>
                <%--url = window.location.href;--%>
            <%--}--%>
            <%--name = name.replace(/[\[\]]/g, "\\$&");--%>
            <%--var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),--%>
                    <%--results = regex.exec(url);--%>
            <%--if (!results) return null;--%>
            <%--if (!results[2]) return '';--%>
            <%--return decodeURIComponent(results[2].replace(/\+/g, " "));--%>
        <%--}--%>
        <%--function getBarcodeInfo(code){--%>
            <%--$.ajax({--%>
                <%--url: "/DbInterface",--%>
                <%--data: {--%>
                    <%--getBarcodeInfo: "getBarcodeInfo",--%>
                    <%--barcode: code,--%>
                <%--},--%>
                <%--dataSrc: "barcode",--%>
                <%--type: "POST",--%>
                <%--success: function (data){--%>
                    <%--var obj = JSON.parse(data);--%>
                    <%--console.log(obj)--%>
                    <%--$('.info').append(obj)--%>
                <%--}--%>
            <%--})--%>
        <%--}--%>
    <%--</script>--%>
</head>
<body>
<p>Hello</p>
<p class = 'info'></p>
</body>
</html>
