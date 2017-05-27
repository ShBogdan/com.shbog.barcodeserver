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
    <link href="https://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel="stylesheet">
    <style>
        #main_section {
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
        #main_section td {
            padding-top: 4px;
            padding-bottom: 4px;
            white-space: nowrap;
            width: 100%;
        }
        tr:nth-child(even) {
            background-color: #f8f8f8;
        }
        .ui-widget-header,.ui-state-default{
            background:#e7e7e7;
            border: 1px solid #bcbcbc;
            color: black;
            font-weight: bold;
        }
        .placeholder_rename, .placeholder_addCategory, .placeholder_renameCat {
            display: inline-block;
            width: 100%;
            margin-bottom: 10px;
        }

    </style>
    <title>Title</title>
</head>
<body>
<div class="addSection">
    <input id="getInputSection" placeholder="название раздела" type="text"><button id="addSection" class="actionButton">Создать раздел</button>
</div>
<hr>
<table id="main_section">
</table>
</body>
<hr>
<p>Нельзя удалить родительский элемент если есть дочерний</p>
<div id="rename" title="Переименовать" hidden><input class = "placeholder_rename" placeholder="название каталога" type="text"></div>
<div id="addCategory" title="Добавить" hidden><input class = "placeholder_addCategory" placeholder="название категории" type="text"></div>
<div id="renameCat" title="Переименовать" hidden><input class = "placeholder_renameCat" placeholder="название категории" type="text"></div>
<div id="remove" title="Удалить запись?" hidden><p id = "removeName"></p></div>
</html>
