<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<html lang="ru">
<head>
    <meta charset="utf-8">
    <title>jQuery UI Dialog functionality</title>
    <link href="https://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
    <script src="https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
    <!-- CSS -->
    <%--<style>--%>
        <%--.ui-widget-header,  .ui-state-default{--%>
            <%--background:#e7e7e7;--%>
            <%--border: 1px solid #bcbcbc;--%>
            <%--color: black;--%>
            <%--font-weight: bold;--%>
        <%--}--%>
        <%--/*.invalid { color: red; }*/--%>
        <%--textarea {--%>
            <%--display: inline-block;--%>
            <%--width: 100%;--%>
            <%--margin-bottom: 10px;--%>
        <%--}--%>
    <%--</style>--%>
    <!-- Javascript -->
    <script type="text/javascript">
        $(function(){
            $( "#dialog-6" ).dialog({
                autoOpen: false,
                buttons: {
                    OK: function() {
                        $( this ).dialog( "destroy" ),
                        alert("done")
                    },
                    CANSEL: function() {
                        $( this ).dialog( "destroy" ),
                                alert("Cansel")
                    }
                },
//                beforeClose: function( event, ui ) {
//                    if ( !$( "#terms" ).prop( "checked" ) ) {
//                        event.preventDefault();
//                        $( "[for=terms]" ).addClass( "invalid" );
//                    }
//                },
                width: 600
            });
            $( "#opener-5" ).click(function() {
                $( "#dialog-6" ).dialog( "open" );
            });
        });
    </script>
</head>
<body>
<div id="dialog-6" title="Перейменовать" style="../css/jquery-ui.css">

    <textarea> </textarea>
    <%--<div>--%>
        <%--<label for="terms">I accept the terms</label>--%>
        <%--<input type="checkbox" id="terms">--%>
    <%--</div>--%>
</div>
<button id="opener-5">Open Dialog</button>
</body>
</html>