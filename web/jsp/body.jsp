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
    </head>

<div class="dialog_create_product" title="Создать продукт" >
    <table align="center" border="0" cellpadding="5" cellspacing="0" style="width: 70%">
        <tbody>
        <tr>
            <td>
                <select class="selectCategory" style="width: 100%">
                </select>
            </td>
        </tr>
        <tr>
            <td><input class="prodName" placeholder="Название" type="text" style="width:  100%" maxlength="50"></td>
        </tr>
        <tr>
            <td><input class="prodProvider" placeholder="Производитель" type="text" style="width:  100%" maxlength="50"></td>
        </tr>
        <tr>
            <td><input class="prodCode" placeholder="штрих-код" type="text" style="width:  100%" maxlength="50"></td>
        </tr>
        </tbody>
    </table>
    <table class="sostav" align="center" border="0" cellpadding="2" cellspacing="2" style="width: 700px">
        <tbody>
        <tr>
            <td width="50%" align="center"><b>Компоненты</b><hr></td>
            <td width="50%" align="center"><b>Состав</b><hr></td>
        </tr>
        <tr>
            <td class = "components"  height="200px" valign="top"></td>
            <td class = "compound"  height="200px" valign="top"></td>
        </tr>
        </tbody>
    </table>
    <div class="divInput"align="center">
        <input class = "getInputComponent" placeholder="название компонента" type="text" maxlength="50"><button class="addComponent" >Добавить компонент</button>
    </div>
</div>
</body>
</html>