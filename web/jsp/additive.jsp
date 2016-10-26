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
    <link href="https://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel="stylesheet">
    <style type="text/css">
        tfoot input {
            width: 100%;
            padding: 3px;
            box-sizing: border-box;
            font-weight: bold;
        }
        /*textarea {*/
        /*display: inline-block;*/
        /*width: 100%;*/
        /*margin-bottom: 10px;*/
        /*}*/
        /*.ui-widget {*/
        /*font-family: Verdana,Arial,sans-serif;*/
        /*font-size: .8em;*/
        /*}*/

        .ui-widget-content {
            background: #F9F9F9;
            /*border: 1px solid #90d93f;*/
            /*color: #222222;*/
        }

        /*.ui-dialog {*/
        /*left: 0;*/
        /*outline: 0 none;*/
        /*padding: 0 !important;*/
        /*position: absolute;*/
        /*top: 0;*/
        /*}*/

        /*#success {*/
        /*padding: 0;*/
        /*margin: 0;*/
        /*}*/

        /*.ui-dialog .ui-dialog-content {*/
        /*background: none repeat scroll 0 0 transparent;*/
        /*border: 0 none;*/
        /*overflow: auto;*/
        /*position: relative;*/
        /*padding: 0 !important;*/
        /*}*/

        .ui-widget-header {
            background:#e7e7e7;
            border: 1px solid #bcbcbc;
            color: black;
            font-weight: bold;
        }

        /*.ui-dialog .ui-dialog-titlebar {*/
        /*padding: 0.1em .5em;*/
        /*position: relative;*/
        /*font-size: 1em;*/
        /*}*/
        /*.ui-dialog .ui-dialog-titlebar-close{*/
        /*position: absolute;*/
        /*right: .3em;*/
        /*top: 50%;*/
        /*width: 20px;*/
        /*margin: -10px 0 0 0;*/
        /*padding: 1px;*/
        /*height: 20px;*/
        /*}*/
        .components, .compound {
            white-space: -moz-pre-wrap !important;  /* Mozilla, since 1999 */
            white-space: -pre-wrap;      /* Opera 4-6 */
            white-space: -o-pre-wrap;    /* Opera 7 */
            white-space: pre-wrap;       /* css-3 */
            word-wrap: break-word;       /* Internet Explorer 5.5+ */
            word-break: break-all;
            white-space: normal;
        }
        /*.varButton, .btnCompound{*/
        /*!*border: 1px solid black;*!*/
        /*!*background-color: lightblue;*!*/
        /*margin-top: 5px;*/
        /*margin-right: 5px;*/
        /*margin-bottom: 5px;*/
        /*margin-left: 5px;*/
        /*}*/
        /*.varButton{*/
        /*background-color: lightblue;*/
        /**/
        /*}*/

        .varButton, .btnCompound  {
            background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #ffffff), color-stop(1, #f6f6f6));
            background:-moz-linear-gradient(top, #ffffff 5%, #f6f6f6 100%);
            background:-webkit-linear-gradient(top, #ffffff 5%, #f6f6f6 100%);
            background:-o-linear-gradient(top, #ffffff 5%, #f6f6f6 100%);
            background:-ms-linear-gradient(top, #ffffff 5%, #f6f6f6 100%);
            background:linear-gradient(to bottom, #ffffff 5%, #f6f6f6 100%);
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#f6f6f6',GradientType=0);
            background-color:#ffffff;
            -moz-border-radius:42px;
            -webkit-border-radius:42px;
            border-radius:42px;
            border:2px solid #dcdcdc;
            display:inline-block;
            cursor:pointer;
            color:#666666;
            font-family:Arial;
            font-size:15px;
            font-weight:bold;
            padding:3px 7px;
            text-decoration:none;
            margin-top: 5px;
            margin-right: 5px;
            margin-bottom: 5px;
            margin-left: 5px;
        }
        .varButton:hover, .btnCompound:hover  {
            background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #f6f6f6), color-stop(1, #ffffff));
            background:-moz-linear-gradient(top, #f6f6f6 5%, #ffffff 100%);
            background:-webkit-linear-gradient(top, #f6f6f6 5%, #ffffff 100%);
            background:-o-linear-gradient(top, #f6f6f6 5%, #ffffff 100%);
            background:-ms-linear-gradient(top, #f6f6f6 5%, #ffffff 100%);
            background:linear-gradient(to bottom, #f6f6f6 5%, #ffffff 100%);
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#f6f6f6', endColorstr='#ffffff',GradientType=0);
            background-color:#f6f6f6;
        }
        .varButton:active, .btnCompound:active {
            position:relative;
            top:1px;
        }

        .remove, .button_create_additive, .addComponent {
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
        .remove:hover , .button_create_additive:hover, .addComponent:hover {
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
        .remove:active, .button_create_additive:active, .addComponent:active {
            position:relative;
            top:1px;
            margin-left: 5px;
        }
        tfoot {
            display: table-header-group;
        }
    </style>
</head>

<body class="additive">
<button id = "button" class="remove">Удалить выделенное</button>
<button id = "button_create_additive" class="button_create_additive">Добавить добавку</button>
<hr>
<table id="additive_table" class="display" cellspacing="0" width="100%">
    <thead>
    <tr>
        <th>id</th>
        <th>Название</th>
        <th>Номер</th>
        <th>Описание</th>
        <th>Запрет</th>
        <th>Цвет</th>
        <th>cbox</th>
        <th></th>
        <th></th>
    </tr>
    </thead>
    <tfoot>
    <tr>
        <th>id</th>
        <th class="searchable">Тип добавки</th>
        <th class="searchable">Номер</th>
        <th class="searchable">Описание</th>
        <th></th>
        <th></th>
        <th></th>
        <th></th>
        <th></th>
    </tr>
    </tfoot>
    <tbody>
    </tbody>
</table>

<div class="dialog_create_additive" title="Создать добавку" hidden>
    <table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 800px">
        <tbody>
        <tr>
            <td align="center">
                <input  class="e_namber" placeholder="Номер" type="text" style="width: 80px" maxlength="10" />
                <input  class="e_name" placeholder="Название" type="text" style="width: 520px" maxlength="150" />
                <select style="width: 100px" class="e_color">
                    <option value="0">Зеленый</option>
                    <option value="1">Желтый</option>
                    <option value="2">Крассный</option>
                </select>
            </td>
        </tr>
        </tbody>
    </table>

    <table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 700px">
        <tbody>
        <tr>
            <td width="50%" align="center"><b>Описание</b><hr></td>
            <td width="50%" align="center"><b>Запрет/разрешение</b><hr></td>
        </tr>
        <tr>
            <td valign="top"><textarea rows="10" cols="40" class="info"></textarea></td>
            <td valign="top"><textarea rows="10" cols="40" class="permission"></textarea></td>
        </tr>
        </tbody>
    </table>
    <table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 700px">
        <tbody>
        <tr>
            <td width="50%" align="center"><b>Соотвецтвует Компоненту</b><hr></td>
            <td width="50%" align="center"><b>Ограничение</b><hr></td>
        </tr>
        <tr>
            <td class = "components"  height="300px" valign="top"></td>
            <td class = "compound"  height="300px" valign="top">
                <p><input type="checkbox" id="c0"/>Не рекомендуется вегетарианцам</p>
                <p><input type="checkbox" id="c1"/>Может содержать ГМО</p>
                <p><input type="checkbox" id="c2"/>Не рекомендуется детям</p>
                <p><input type="checkbox" id="c3"/>Не рекомендуется беременным</p>
                <p><input type="checkbox" id="c4"/>Не рекомендуется с заболеваниями ЖКТ</p>
                <p><input type="checkbox" id="c5"/>Не рекомендуется с астмой</p>
                <p><input type="checkbox" id="c6"/>Не рекомендуется с ССЗ</p>
                <p><input type="checkbox" id="c7"/>Не рекомендуется с сахарным диабетом</p></td>
        </tr>
        </tbody>
    </table>
    <div class="divInput" align="center">
        <input class = "getInputComponent" placeholder="название компонента" type="text" maxlength="50" list="components"><button class="addComponent" >Добавить название</button>
        <datalist id="components"></datalist>
    </div>

</div>
</body>
</html>