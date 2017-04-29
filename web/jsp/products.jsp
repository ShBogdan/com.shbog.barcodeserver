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
    <%--<link rel="stylesheet" href="../css/dataTables.css">--%>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.12/css/jquery.dataTables.min.css">
    <link href="https://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel="stylesheet">
    <style type="text/css">
        .ui-autocomplete {
            position: absolute;
            cursor: default;
            z-index: 30 !important;
            color: #1c94c4;
            background: #670d10;
        }

        tfoot input {
            width: 100%;
            padding: 3px;
            box-sizing: border-box;
            font-weight: bold;
        }

        tfoot {
            display: table-header-group;
        }

        .margin {
            margin-top: 10px;
            width: 1000px;
        }

        .ui-widget-content {
            background: #F9F9F9;
        }

        .ui-widget-header {
            background: #e7e7e7;
            border: 1px solid #bcbcbc;
            color: black;
            font-weight: bold;
        }

        .components, .compound {
            white-space: -moz-pre-wrap !important; /* Mozilla, since 1999 */
            white-space: -pre-wrap; /* Opera 4-6 */
            white-space: -o-pre-wrap; /* Opera 7 */
            white-space: pre-wrap; /* css-3 */
            word-wrap: break-word; /* Internet Explorer 5.5+ */
            word-break: break-all;
            white-space: normal;
        }

        .varButton, .btnCompound, .varACCButton {
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #ffffff), color-stop(1, #f6f6f6));
            background: -moz-linear-gradient(top, #ffffff 5%, #f6f6f6 100%);
            background: -webkit-linear-gradient(top, #ffffff 5%, #f6f6f6 100%);
            background: -o-linear-gradient(top, #ffffff 5%, #f6f6f6 100%);
            background: -ms-linear-gradient(top, #ffffff 5%, #f6f6f6 100%);
            background: linear-gradient(to bottom, #ffffff 5%, #f6f6f6 100%);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#f6f6f6', GradientType=0);
            background-color: #ffffff;
            -moz-border-radius: 42px;
            -webkit-border-radius: 42px;
            border-radius: 42px;
            border: 2px solid #dcdcdc;
            display: inline-block;
            cursor: pointer;
            color: #666666;
            font-family: Arial;
            font-size: 15px;
            font-weight: bold;
            padding: 3px 7px;
            text-decoration: none;
            margin-top: 5px;
            margin-right: 5px;
            margin-bottom: 5px;
            margin-left: 5px;
        }

        .varButton:hover, .btnCompound:hover, .varACCButton:hover {
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #f6f6f6), color-stop(1, #ffffff));
            background: -moz-linear-gradient(top, #f6f6f6 5%, #ffffff 100%);
            background: -webkit-linear-gradient(top, #f6f6f6 5%, #ffffff 100%);
            background: -o-linear-gradient(top, #f6f6f6 5%, #ffffff 100%);
            background: -ms-linear-gradient(top, #f6f6f6 5%, #ffffff 100%);
            background: linear-gradient(to bottom, #f6f6f6 5%, #ffffff 100%);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f6f6f6', endColorstr='#ffffff', GradientType=0);
            background-color: #f6f6f6;
        }

        .varButton:active, .btnCompound:active {
            position: relative;
            top: 1px;
        }

        .remove, .button_create_product, .addComponent, .addComponentEdit, .loadFileXml {
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #f9f9f9), color-stop(1, #e9e9e9));
            background: -moz-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background: -webkit-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background: -o-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background: -ms-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background: linear-gradient(to bottom, #f9f9f9 5%, #e9e9e9 100%);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f9f9f9', endColorstr='#e9e9e9', GradientType=0);
            background-color: #f9f9f9;
            -moz-border-radius: 3px;
            -webkit-border-radius: 3px;
            border-radius: 3px;
            border: 1px solid #dcdcdc;
            display: inline-block;
            cursor: pointer;
            color: #666666;
            font-family: Arial;
            font-size: 15px;
            font-weight: bold;
            padding: 3px 24px;
            text-decoration: none;
            margin-left: 5px;
        }

        .remove:hover, .button_create_product:hover, .addComponent:hover, .addComponentEdit:hover, .loadFileXml:hover {
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #e9e9e9), color-stop(1, #f9f9f9));
            background: -moz-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background: -webkit-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background: -o-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background: -ms-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background: linear-gradient(to bottom, #e9e9e9 5%, #f9f9f9 100%);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#e9e9e9', endColorstr='#f9f9f9', GradientType=0);
            background-color: #e9e9e9;
            margin-left: 5px;
        }

        .remove:active, .button_create_product:active, .addComponent:active, .loadFileXml:active {
            position: relative;
            top: 1px;
            margin-left: 5px;
        }
    </style>
</head>

<body class="products">
<script>
    function previewFile() {
        if (!isEdit) {
            var preview = document.getElementById('inputImg');
        } else {
            var preview = document.getElementById('edit_inputImg');
        }
        var file = document.getElementsByClassName('image')[0].files[0];
        var reader = new FileReader();
//        console.log(file)
        if (file.size > 1200000) {
            alert("фото не может весить больше 1 мегабайта");
            closeImage();
            return;
        }
        reader.addEventListener("load", function () {
            preview.src = reader.result;
        }, false);
        if (file) {
            reader.readAsDataURL(file);
        }
        $(".x").show().css("margin-right", "10px");
    }
    function closeImage() {
        var blank = "${pageContext.request.contextPath}/image/bgr.jpg";
        $(".inputImg").attr("src", blank);
        $(".x").hide();
        var el = $('.image');
        el.wrap('<form>').closest('form').get(0).reset();
        el.unwrap();
    }

</script>
<div class="temp">
    <button id="button" class="remove">Удалить выделенное</button>
    <button id="button_create_product" class="button_create_product">Добавить продукт</button>
</div>
<hr>
<table id="products_table" class="display" cellspacing="0" width="100%">
    <thead>
    <tr>
        <th>id</th>
        <th>Категория</th>
        <th>Тип</th>
        <th>Название</th>
        <th>Производитель</th>
        <th>Штрихкод</th>
        <th></th>
        <th></th>
    </tr>
    </thead>
    <tfoot>
    <tr>
        <th>id</th>
        <th class="searchable">Категория</th>
        <th class="searchable">Тип</th>
        <th class="searchable">Название</th>
        <th class="searchable">Производитель</th>
        <th class="searchable">Штрихкод</th>
        <th></th>
        <th></th>
    </tr>
    </tfoot>
    <tbody>
    </tbody>
</table>

<div class="dialog_create_product" title="Создать продукт" hidden>
    <table style="width: 1000px;" border="0" cellspacing="2" cellpadding="2" align="center">
        <tbody>
        <tr>
            <td align="center" width="50%">
                <form action="" enctype="multipart/form-data" method="post" name="attachfileform">
                    <table>
                        <tbody>
                        <tr>
                            <td><img class="inputImg" id="inputImg" style="max-width: 100%; height: 130px;" alt=""/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="x" hidden onclick="closeImage()">[X]</span>
                                <input type="button" class="loadFileXml" value="Загрузить фото"
                                       onclick="document.getElementsByClassName('image')[0].click();"/>
                                <input type="file" name="attachfile" onchange="previewFile();" class="image"
                                       style="display:none;">
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </form>

            </td>
            <td align="center" width="40%" valign="top">
                <table style="width: 100%;" border="0" cellspacing="0" cellpadding="5" align="center">
                    <tbody>
                    <tr>
                        <td>
                            <input class="selectCategory" style="width: 100%; display:table-cell;" type="text" placeholder="Категория!"
                                   list="selectCategory"/>
                            <datalist id="selectCategory"></datalist>

                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input class="prodType" style="width: 100%;" maxlength="155" type="text" placeholder="Тип"
                                   list="prodType"/>
                            <datalist id="prodType"></datalist>
                        </td>
                    </tr>
                    <tr>
                        <td><textarea class="prodName" rows="2" style="width: 100%;" maxlength="155" type="text"
                                      placeholder="Название"></textarea></td>
                    </tr>
                    <tr>
                        <td><input class="prodProvider" style="width: 100%;" maxlength="155" type="text"
                                   placeholder="Производитель"/></td>
                    </tr>
                    <tr>
                        <td><input class="prodCode" style="width: 100%;" maxlength="18" type="text"
                                   placeholder="штрих-код"/></td>
                    </tr>
                    </tbody>
                </table>
            </td>
        </tr>
        </tbody>
    </table>
    <table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 1000px">
        <tbody>
        <tr>
            <td width="50%" align="center"><b>Состав</b>
                <hr>
            </td>
            <td width="50%" align="center"><b>Все компоненты категории</b>
                <hr>
            </td>
        </tr>
        <tr>
            <td class="components" height="200px" valign="top"></td>
            <td class="compound" height="200px" valign="top"></td>
        </tr>
        <tr>
            <td align="center" width="50%">
                <div class="divInput" align="center">
                    <input class="getInputComponent" placeholder="Новый компонент" type="text"
                           style="display:table-cell; width:60%" maxlength="50" list="components">
                    <button class="addComponent" style="display:table-cell; width:36%">Добавить</button>
                    <datalist id="components"></datalist>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
    <hr class="margin">
    <table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 1000px">
        <tbody>
        <tr>
            <td width="50%" align="center"><b>Добавки</b></td>
            <td width="50%" align="center"><b>Ограничения</b></td>
        </tr>
        <tr>
            <td class="dobavki" valign="top"></td>
            <td class="ogranicenija" valign="top"></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="dialog_edit_product" title="Изменить продукт" hidden>
    <table style="width: 1000px;" border="0" cellspacing="2" cellpadding="2" align="center">
        <tbody>
        <tr>
            <td align="center" width="50%">
                <form action="" enctype="multipart/form-data" method="post" name="attachfileform">
                    <table>
                        <tbody>
                        <tr>
                            <td><img class="inputImg" id="edit_inputImg" style="max-width: 100%; height: 130px;"
                                     alt=""/></td>
                        </tr>
                        <tr>
                            <td>
                                <span class="x" hidden onclick="closeImage()">[X]</span>
                                <input type="button" class="loadFileXml" value="Загрузить фото"
                                       onclick="document.getElementsByClassName('image')[0].click();"/>
                                <input type="file" name="attachfile" onchange="previewFile();" class="image"
                                       style="display:none;">
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </form>

            </td>
            <td align="center" width="40%" valign="top">
                <table style="width: 100%;" border="0" cellspacing="0" cellpadding="5" align="center">
                    <tbody>
                    <tr>
                        <td>
                            <select class="edit_selectCategory" style="width: 100%">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><input class="edit_prodType" style="width: 100%;" maxlength="155" type="text"
                                   placeholder="Тип" list="edit_prodType"/>
                            <datalist id="edit_prodType"></datalist>
                        </td>
                    </tr>
                    <tr>
                        <td><textarea class="edit_prodName" rows="2" style="width: 100%;" maxlength="155" type="text"
                                      placeholder="Название"></textarea></td>
                    </tr>
                    <tr>
                        <td><input class="edit_prodProvider" style="width: 100%;" maxlength="155" type="text"
                                   placeholder="Производитель"/></td>
                    </tr>
                    <tr>
                        <td><input class="edit_prodCode" style="width: 100%;" maxlength="18" type="text"
                                   placeholder="штрих-код"/></td>
                    </tr>
                    </tbody>
                </table>
            </td>
        </tr>
        </tbody>
    </table>
    <table class="edit_sostav" style="width: 1000px;" border="0" cellspacing="2" cellpadding="2" align="center">
        <tbody>
        <tr>
            <td align="center" width="50%"><strong>Состав</strong>
                <hr/>
            </td>
            <td align="center" width="50%"><strong>Все компоненты категории</strong>
                <hr/>
            </td>
        </tr>
        <tr>
            <td class="components" valign="top" height="200px"></td>
            <td class="compound" valign="top" height="200px"></td>
        </tr>
        <tr>
            <td align="center" width="50%">
                <div class="divInputEdit" align="center">
                    <input class="getInputComponentEdit" placeholder="Новый компонент" type="text"
                           style="display:table-cell; width:60%" list="edit_components">
                    <button class="addComponentEdit" style="display:table-cell; width:36%">Добавить</button>
                    <datalist id="edit_components"></datalist>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
    <hr class="margin">
    <table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 1000px">
        <tbody>
        <tr>
            <td width="50%" align="center"><b>Добавки</b></td>
            <td width="50%" align="center"><b>Ограничения</b></td>
        </tr>
        <tr>
            <td class="dobavki" valign="top"></td>
            <td class="ogranicenija" valign="top"></td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>