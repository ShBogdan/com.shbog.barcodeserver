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
        .ui-autocomplete { position: absolute; cursor: default;z-index:30 !important; color: #1c94c4; background: #670d10;}
        tfoot input {
            width: 100%;
            padding: 3px;
            box-sizing: border-box;
            font-weight: bold;
        }
        tfoot {
            display: table-header-group;
        }
        .margin{
            margin-top: 10px;
            width: 700px;
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

        .varButton, .btnCompound, .varACCButton  {
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
        .varButton:hover, .btnCompound:hover, .varACCButton:hover  {
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

        .remove, .button_create_product, .addComponent, .addComponentEdit{
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
        .remove:hover , .button_create_product:hover, .addComponent:hover, .addComponentEdit:hover{
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
        .remove:active, .button_create_product:active, .addComponent:active {
            position:relative;
            top:1px;
            margin-left: 5px;
        }

    </style>
</head>

<body class="products">
<script>
   function previewFile() {
        var preview = document.querySelector('img');
        var file = document.querySelector('input[type=file]').files[0];
        var reader  = new FileReader();
        reader.addEventListener("load", function () {
            preview.src = reader.result;
        }, false);
        if (file) {
            reader.readAsDataURL(file);
        }
        $("#x").show().css("margin-right","10px");
    }
    function closeImage(){
        var blank="http://upload.wikimedia.org/wikipedia/commons/c/c0/Blank.gif";
        $("#inputImg").attr("src",blank);
        $("#x").hide();
    }

    function dynamicUpload(){
        var formElement = $("[name='attachfileform']")[0];
        var fd = new FormData(formElement);
        var fileInput = $("[name='attachfile']")[0];
        fd.append('file', fileInput.files[0] );
        fd.append('myname', 99 ); //how to read value?


        $.ajax({
            url: '../FileUploadServlet',
            data: fd,
            processData: false,
            contentType: false,
            type: 'POST',
            success: function(data){
                console.log(data);
            }
        });
    }

</script>
<div class="temp">
    <button id = "button" class="remove">Удалить выделенное</button>
    <button id = "button_create_product" class="button_create_product">Добавить продукт</button>
</div>
<hr>
<table id="products_table" class="display" cellspacing="0" width="100%">
    <thead>
    <tr>
        <th>id</th>
        <th>Категория</th>
        <th>Производитель</th>
        <th>Название</th>
        <th>Штрихкод</th>
        <th></th>
        <th></th>
    </tr>
    </thead>
    <tfoot>
    <tr>
        <th>id</th>
        <th class="searchable">Каталог</th>
        <th class="searchable">Производитель</th>
        <th class="searchable">Название</th>
        <th class="searchable">Штрихкод</th>
        <th></th>
        <th></th>
    </tr>
    </tfoot>
    <tbody>
    </tbody>
</table>
<div class="dialog_create_product" title="Создать продукт" hidden>
    <table style="width: 700px;" border="0" cellspacing="2" cellpadding="2" align="center">
        <tbody>
        <tr>
            <td align="center" width="30%">
                <form action="" id="attachfileform" name="attachfileform" method="post" enctype="multipart/form-data">
                    <img id = "inputImg" style="max-width: 100%; height: 150px;"/><br>
                    <span id="x" hidden onclick="closeImage()" >[X]</span>
                    <input type="button" id="loadFileXml" value="loadXml" onclick="document.getElementById('image').click();" />
                    <input type="file"  name="attachfile" onchange="previewFile();  //this.value=null; return false;" id="image" style="display:none;" class = ".addPhoto"  >
                    <input type="button" class="update_but"  value="Upload File" onclick="dynamicUpload()"/>
                </form>

            </td>
            <td align="center" width="70%">
                <table style="width: 100%;" border="0" cellspacing="0" cellpadding="5" align="center">
                    <tbody>
                    <tr>
                        <td>
                            <select class="selectCategory" style="width: 100%">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><input class="prodName" style="width: 100%;" maxlength="50" type="text" placeholder="Название" /></td>
                    </tr>
                    <tr>
                        <td><input class="prodProvider" style="width: 100%;" maxlength="50" type="text" placeholder="Производитель" /></td>
                    </tr>
                    <tr>
                        <td><input class="prodCode" style="width: 100%;" maxlength="18" type="text" placeholder="штрих-код" /></td>
                    </tr>
                    </tbody>
                </table>
            </td>
        </tr>
        </tbody>
    </table>

    <table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 700px">
        <tbody>
        <tr>
            <td width="50%" align="center"><b>Состав</b><hr></td>
            <td width="50%" align="center"><b>Все компоненты категории</b><hr></td>
        </tr>
        <tr>
            <td class = "components"  height="200px" valign="top"></td>
            <td class = "compound"  height="200px" valign="top"></td>
        </tr>
        <tr>
            <td align="center" width="50%">
                <div class="divInput" align="center">
                    <input class = "getInputComponent" placeholder="Новый компонент" type="text" style="display:table-cell; width:60%" maxlength="50" list="components"><button class="addComponent" style="display:table-cell; width:36%">Добавить</button>
                    <datalist id="components"></datalist>
                </div>
            </td>
        </tr>
        </tbody>
    </table>

    <hr class= "margin">
    <table  align="center" border="0" cellpadding="2" cellspacing="2" style="width: 700px">
        <tbody>
        <tr>
            <td width="50%" align="center"><b>Добавки</b></td>
            <td width="50%" align="center"><b>Ограничения</b></td>
        </tr>
        <tr>
            <td class = "dobavki" valign="top"></td>
            <td class = "ogranicenija" valign="top"></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="dialog_edit_product" title="Изменить продукт" hidden>
    <table align="center" border="0" cellpadding="5" cellspacing="0" style="width: 70%">
        <tbody>
        <tr>
            <td>
                <select class="edit_selectCategory" style="width: 100%">
                </select>
            </td>
        </tr>
        <tr>
            <td><input class="edit_prodName" placeholder="Название" type="text" style="width:  100%" maxlength="50"></td>
        </tr>
        <tr>
            <td><input class="edit_prodProvider" placeholder="Производитель" type="text" style="width:  100%" maxlength="50"></td>
        </tr>
        <tr>
            <td><input class="edit_prodCode" placeholder="штрих-код" type="text" style="width:  100%" maxlength="18"></td>
        </tr>
        </tbody>
    </table>
    <table class="edit_sostav" style="width: 700px;" border="0" cellspacing="2" cellpadding="2" align="center">
        <tbody>
        <tr>
            <td align="center" width="50%"><strong>Состав</strong><hr/></td>
            <td align="center" width="50%"><strong>Все компоненты категории</strong><hr /></td>
        </tr>
        <tr>
            <td class="components" valign="top" height="200px"></td>
            <td class="compound" valign="top" height="200px"></td>
        </tr>
        <tr>
            <td align="center" width="50%">
                <div class="divInputEdit"align="center">
                    <input class = "getInputComponentEdit" placeholder="Новый компонент" type="text" style="display:table-cell; width:60%" list="edit_components"><button class="addComponentEdit" style="display:table-cell; width:36%">Добавить</button>
                    <datalist id="edit_components"></datalist>
                </div>
            </td>
        </tr>
        </tbody>
    </table>

    <hr class= "margin">
    <table  align="center" border="0" cellpadding="2" cellspacing="2" style="width: 700px">
        <tbody>
        <tr>
            <td width="50%" align="center"><b>Добавки</b></td>
            <td width="50%" align="center"><b>Ограничения</b></td>
        </tr>
        <tr>
            <td class = "dobavki" valign="top"></td>
            <td class = "ogranicenija" valign="top"></td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>