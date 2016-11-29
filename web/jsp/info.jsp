<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0, post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");
%>
<%
    try {
        if ((session.getAttribute("username")).toString() == null || (session.getAttribute("password")).toString() == null) {
            response.sendRedirect("index.jsp");
        }
    } catch (Exception e) {
        response.sendRedirect("index.jsp");
    }
%>
<html>
<head>
    <style>
        .main_section {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%; /*50*/
        }
        .par {
            border: 1px solid #b0b0b0;
            text-align: left;
            padding: 8px;
            background-color: #dbdbdb;
        }
        .main_section td {
            padding-top: 4px;
            padding-bottom: 4px;
            white-space: nowrap;
            width: 100%;
        }
        tr:nth-child(even) {
            background-color: #f8f8f8;
        }
    </style>
    <script>
        fillProdGroupDate();
        function fillProdGroupDate() {
            $.ajax({
                url: "/DbInterface",
                data: {
                    getProdGroupDate: "getProdGroupDate",
                },
                type: 'POST',
                success: function (data) {
                    $('.selectProdDate').append($("<option></option>").attr("value", 'empty').text('Пусто'));
                    $('.selectProdDate').append($("<option></option>").attr("value", 'all').text('За все время'));
                    var obj = JSON.parse(data).prodDates;
                    for(var i=0; obj.length > i; i++){
                        $('.selectProdDate').append($("<option></option>").attr("value", obj[i][0]).text(obj[i][0]));
                    }
                }
            })
        }
    </script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.12/css/jquery.dataTables.min.css">
</head>
<body>
<select class="selectProdDate" style="width: 50%">
</select>
<div class="catTab" style="width: 50%">
</div>
</body>
</html>

