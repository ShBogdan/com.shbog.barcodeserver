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
    <%--<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.12/css/jquery.dataTables.min.css">--%>
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
        #addSection {
            background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #f9f9f9), color-stop(1, #e9e9e9));
            background:-moz-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background:-webkit-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background:-o-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background:-ms-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background:linear-gradient(to bottom, #f9f9f9 5%, #e9e9e9 100%);
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#f9f9f9', endColorstr='#e9e9e9',GradientType=0);
            background-color:#f9f9f9;
            -moz-border-radius:3px;
            -webkit-border-radius:3px;
            border-radius:3px;
            border:1px solid #dcdcdc;
            display:inline-block;
            cursor:pointer;
            color:#666666;
            font-family:Arial;
            font-size:15px;
            font-weight:bold;
            padding:3px 24px;
            text-decoration:none;
            margin-left: 5px;
        }
        #addSection:hover {
            background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #e9e9e9), color-stop(1, #f9f9f9));
            background:-moz-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background:-webkit-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background:-o-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background:-ms-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background:linear-gradient(to bottom, #e9e9e9 5%, #f9f9f9 100%);
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#e9e9e9', endColorstr='#f9f9f9',GradientType=0);
            background-color:#e9e9e9;
            margin-left: 5px;
        }
        #addSection:active {
            position:relative;
            top:1px;
            margin-left: 5px;
        }




    </style>
    <title>Title</title>
</head>
<body>
<div class="addSection">
    <input id="getInputSection" placeholder="название раздела" type="text"><button id="addSection">Создать раздел</button>
</div>
<hr>
<table id="main_section">
    <%--<tbody id="1">--%>
    <%--<tr class="par">--%>
    <%--<td class="parent">1</td>--%>
    <%--<td class="remove-1"><button>Удалить</button></td>--%>
    <%--<td class="rename-1"><button >Пейменовать</button></td>--%>
    <%--<td class="addCategory-1"><button >Добавить категорию</button></td>--%>
    <%--</tr>--%>
    <%--<tr class="child-1"  id = "234">--%>
    <%--<td>1.1</td>--%>
    <%--<td class="removeCat"><button>Удалить</button></td>--%>
    <%--<td class="renameCat"><button >Пейменовать</button></td>--%>
    <%--</tr>--%>
    <%--<tr class="child-1"  id = "2344">--%>
    <%--<td>1.2</td>--%>
    <%--<td class="removeCat"><button>Удалить</button></td>--%>
    <%--<td class="renameCat"><button >Пейменовать</button></td>--%>
    <%--</tr>--%>
    <%--</tbody>--%>
</table>
</body>
<div id="rename" title="Перейменовать" hidden><input class = "placeholder_rename" placeholder="название каталога" type="text"></div>
<div id="addCategory" title="Добавить" hidden><input class = "placeholder_addCategory" placeholder="название категории" type="text"></div>
<div id="renameCat" title="Перейменовать" hidden><input class = "placeholder_renameCat" placeholder="название категории" type="text"></div>
</html>
