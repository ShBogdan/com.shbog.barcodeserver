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
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.12/css/jquery.dataTables.min.css">

</head>
<body>
    <fieldset>
        <legend>Administrator</legend>
        Login:<br>
        <input type="text" class="adminname" value='${adminname}'>
        <br>
        Pass:<br>
        <input type="text" class="adminpassword" value='${adminpassword}'>
        <br><br>
        <button class="saveAdmin">Сохранить</button>
    </fieldset>

    <fieldset>
        <legend>Operator</legend>
        Login:<br>
        <input type="text" class="opername" value='${opername}'>
        <br>
        Pass:<br>
        <input type="text" class="operpassword" value='${operpassword}'>
        <br><br>
        <button class="saveOper">Сохранить</button>
    </fieldset>
</body>
</html>
