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
    <title>Success Page</title>
    <style type="text/css">
        .button {
            background-color: #e7e7e7; /* Green */
            color: black; /*text color*/
            padding: 10px 16px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.4s;
            cursor: pointer;
            border-radius: 12px;
            border: 2px solid #e7e7e7;
            font-weight: bold
        }

        .button:hover {
            box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.24), 0 17px 50px 0 rgba(0, 0, 0, 0.19);
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.4s;
            background-color: white; /* Green */
            color: black; /*text color*/
        }
    </style>
    <script type="text/javascript" language="javascript" src="//code.jquery.com/jquery-1.12.3.js">
    </script>
    <script type="text/javascript" language="javascript"
            src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js">
    </script>
    <script src="https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

    <script>
        $(document).ready(function () {
            var table;
            var e_table;
            var exclude;
            var isEdit;
            var edit_tableRow;
            var dell_edit_tableRow;
            var edit_e_tableRow;
            var dell_edit_e_tableRow;
            var componets_array_ID = [];
            var varButton = [];
            var comp_index;
            var varBtn_index;
            var autocompleteInpComponents = [];
            var componentGroup = [];
            var dictionaryAutoCompCompon = {};
            var cBoxs = [];

            $(document).on('click', '#btn1', function () {
                $('#menu').load("info.jsp");
            });
            $(document).on('click', '#btn2', function () {
                $('#menu').load("catalog.jsp", function () {
                    //добавить катгорию
                    fill_main_section()
                    $(".addSection").on("click", "#addSection", (function () {
                        $.ajax({
                            url: "/DbInterface",
                            data: {
                                addSection: "addSection",
                                sectionName: $("#getInputSection").val()
                            },
                            type: 'POST',
                            dataType: 'text',
                            success: function (output) {
                                $("#getInputSection").val(''),
                                        $("#main_section tbody").remove(),
                                        fill_main_section()
                            },
                            error: function (request, status, error) {
                                alert("Error: Could not back");
                            }
                        });
                    }))
                    //заполнить таблицу
                    function fill_main_section() {
                        $.ajax({
                            url: "/DbInterface",
                            data: {
                                getSection: "getSection"
                            },
                            type: 'POST',
                            dataType: 'text',
                            success: function (data) {
                                $("#main_section").append(data);
                            },
                            error: function (request, status, error) {
                                alert("Error: Лажа");
                            }
                        })
                    }

                    //обрабатываем кнопки в таблице
                    $("#main_section").on("click", "td", (function () {
                        var _id = $(this).parent().parent().attr("id")
                        var _id_cat = $(this).parent().attr("id")
                        if (this.className === "parent") {
                            $(".child-" + _id).toggle()
                        }
                        if (this.className === "remove-" + _id) {
//                            alert(this.className)
                            $.ajax({
                                url: "/DbInterface",
                                data: {
                                    removeSection: "removeSection",
                                    sectionId: _id
                                },
                                type: 'POST',
                                dataType: 'text',
                                success: function (output) {
                                    $("#main_section tbody").remove(),
                                            fill_main_section()
                                },
                                error: function (request, status, error) {
                                    alert("Error: Could not back");
                                }
                            })
                        }
                        if (this.className === "rename-" + _id) {
                            $("#rename").dialog({
                                autoOpen: true,
                                buttons: {
                                    OK: function () {
                                        $(this).dialog("destroy"),
                                                $.ajax({
                                                    url: "/DbInterface",
                                                    data: {
                                                        renameSection: "renameSection",
                                                        newName: $(".placeholder_rename").val(),
                                                        sectionId: _id
                                                    },
                                                    type: 'POST',
                                                    dataType: 'text',
                                                    success: function (output) {
                                                        $("#main_section tbody").remove(),
                                                                fill_main_section()
                                                    },
                                                    error: function (request, status, error) {
                                                        alert("Error: Could not back");
                                                    }
                                                });
                                        $(".placeholder_rename").val('')
                                    },
                                    CANSEL: function () {
                                        $(this).dialog("close")
//                                                alert("Cansel")
                                    }
                                },
                                width: 600

                            })
                        }
                        if (this.className === "addCategory-" + _id) {
                            $("#addCategory").dialog({
                                autoOpen: true,
                                buttons: {
                                    OK: function () {
                                        $(this).dialog("destroy"),
                                                $.ajax({
                                                    url: "/DbInterface",
                                                    data: {
                                                        addCategory: "addCategory",
                                                        catName: $(".placeholder_addCategory").val(),
                                                        sectionId: _id
                                                    },
                                                    type: 'POST',
                                                    dataType: 'text',
                                                    success: function (output) {
                                                        $("#main_section tbody").remove(),
                                                                fill_main_section()
                                                    },
                                                    error: function (request, status, error) {
                                                        alert("Error: Could not back");
                                                    }
                                                });
                                        $(".placeholder_addCategory").val('')
                                    },
                                    CANSEL: function () {
                                        $(this).dialog("close")
//                                                alert("Cansel")
                                    }
                                },
                                width: 600

                            })
                        }
                        if (this.className === "removeCat") {
                            $.ajax({
                                url: "/DbInterface",
                                data: {
                                    removeCat: "removeCat",
                                    catId: _id_cat
                                },
                                type: 'POST',
                                dataType: 'text',
                                success: function (output) {
                                    $("#main_section tbody").remove(),
                                            fill_main_section()
                                },
                                error: function (request, status, error) {
                                    alert("Error: Could not back");
                                }
                            })
                        }
                        if (this.className === "renameCat") {
                            $("#renameCat").dialog({
                                autoOpen: true,
                                buttons: {
                                    OK: function () {
                                        $(this).dialog("destroy"),
                                                $.ajax({
                                                    url: "/DbInterface",
                                                    data: {
                                                        renameCat: "renameCat",
                                                        newName: $(".placeholder_renameCat").val(),
                                                        catId: _id_cat
                                                    },
                                                    type: 'POST',
                                                    dataType: 'text',
                                                    success: function (output) {
                                                        $("#main_section tbody").remove(),
                                                                fill_main_section()
                                                    },
                                                    error: function (request, status, error) {
                                                        alert("Error: Could not back");
                                                    }
                                                });
                                        $(".placeholder_renameCat").val('')
                                    },
                                    CANSEL: function () {
                                        $(this).dialog("close")
//                                                alert("Cansel")
                                    }
                                },
                                width: 600

                            })
                        }
                    }));
                });
            });
            $(document).on('click', '#btn3', function () {
                $('#menu').load("products.jsp", function () {
                    table = $('#products_table').DataTable({
                        processing: true,
                        ajax: {
                            url: "/DbInterface",
                            data: {getProducts: "getProducts"},
                            dataSrc: "products",
                            type: "POST"
                        },
                        "pageLength": 25,
                        "lengthMenu": [[10, 25, 50, 100, 500, 1000, 5000, -1], [10, 25, 50, 100, 500, 1000, 5000, "All"]],
                        "deferRender": true,
                        "columnDefs": [
                            {"targets": 0, "visible": false},
                            {"targets": 4, "wodht": "20%"},
                            {
                                "targets": 6,
                                "orderable": false,
                                "searchable": false,
                                "width": "1%",
                                "data": null,
                                "defaultContent": "<button id = 'select'>&#10003;</button>"
                            },
                            {
                                "targets": 5,
                                "orderable": false,
                                "searchable": false,
                                "width": "1%",
                                "data": null,
                                "defaultContent": "<button id = 'edit'>&#8601;</button>"
                            }]

                    });
//                  Поиск по колонкам
                    $('#products_table .searchable').each(function () {
                        var title = $(this).text();
                        $(this).html('<input type="text" placeholder="Search ' + title + '" />');
                    });
                    table.columns().every(function () {
                        var that = this;

                        $('input', this.footer()).on('keyup change', function () {
                            if (that.search() !== this.value) {
                                that
                                        .search(this.value)
                                        .draw();
                            }
                        });
                    });

//                  удаляем выделенные елементы 100 штук
                    $('#button').click(function () {
                        var i = 0;
                        while (i < 100) {
                            i++;
//                            alert(table.row('.selected').data()[0]);
                            $.ajax({
                                url: "/DbInterface",
                                data: {
                                    removeProduct: "removeProduct",
                                    prod_id: table.row('.selected').data()[0]
                                },
                                type: 'POST',
                                dataType: 'text',
                                success: function (output) {
//                                    alert("Елемент удален");
                                },
                                error: function (request, status, error) {
                                    alert("Error: Could not back");
                                }
                            });
                            table.row('.selected').remove().draw(false);
                        }
                    });

//                  нажатие кнопки выделить row
                    $('#products_table tbody').on('click', '#select', function () {
//                                var data = table.row( $(this).parents('tr') ).data();
//                                alert( data[0] +"'s salary is: "+ data[ 2 ] );
                        $($(this).parents('tr')).toggleClass('selected');
                    });

                    //обработка кнопок
                    $(".compound").on("click", ".btnCompound", function () {
                        if (!componets_array_ID.includes($(this).attr("id"))) {
                            $(".components").append($(this));
                            componets_array_ID.push($(this).attr("id"));
                            fillDobOgr()
                        }
                    });
                    $(".components").on("click", ".btnCompound", function () {
                        $(".compound").append($(this));
                        comp_index = componets_array_ID.indexOf($(this).attr("id"));
                        if (comp_index > -1) {
                            componets_array_ID.splice(comp_index, 1);
                            console.log('btnCompound deleted')
                            fillDobOgr()
                        }
                    });
                    $(".components").on("click", ".varButton", function () {
                        $(this).remove();
                        varBtn_index = varButton.indexOf($(this).text());
                        if (!isEdit) {
                            console.log("In")
                            if (varBtn_index > -1) {
                                varButton.splice(varBtn_index, 1);
                                console.log(varButton)
                            }
                        }
                        if (isEdit) {
                            comp_index = componets_array_ID.indexOf($(this).attr("id"));
                            if (comp_index > -1) {
                                componets_array_ID.splice(comp_index, 1);
                                fillDobOgr()
                            }
                        }
                        console.log('varButton deleted')
                    });
                    $(".components").on("click", ".varACCButton", function () {
                        $(this).remove();
                        comp_index = componets_array_ID.indexOf($(this).attr("id"));
                        if (comp_index > -1) {
                            componets_array_ID.splice(comp_index, 1);
                            console.log('varACCButton deleted')
                            fillDobOgr()
                        }
                    });
                    $(".divInput").on("click", ".addComponent", function () {
                        var input = $(".getInputComponent").val().trim();
                        comp_index = varButton.indexOf(input);
                        if (input == "") {
                            console.log("Its empty divInput")
                            return;
                        }
                        if (input.search(/,/i) > -1) {
                            alert("Недопустимый символ ','")
                            return;
                        }
                        if (comp_index > -1) {
                            console.log("over in the array")
                            return;
                        }
                        if (!(input in dictionaryAutoCompCompon)) {
                            $(".components").append("<button class=\"varButton\">" + input + "</button>");
                            varButton.push(input);
                            $(".getInputComponent").val('');
                            return;
                        }
                        var compId;
                        for (var name in dictionaryAutoCompCompon) {
                            if (name == input) {
                                compId = dictionaryAutoCompCompon[name];
                                console.log('in dictionary')
                                console.log('name ' + name)
                                console.log('index ' + compId)
                                if (!componets_array_ID.includes(compId)) {
                                    console.log('not in the array')
                                    componets_array_ID.push(compId);
                                    $(".components").append("<button class=\"varACCButton\"" + "id=" + "\"" + compId + "\"" + ">" + input + "</button>");
                                    $(".getInputComponent").val('');
                                    fillDobOgr();

                                }
                            }
                        }
                    })
                    $(".divInputEdit").on("click", ".addComponentEdit", function () {
                        var input = $(".getInputComponentEdit").val().trim();
                        comp_index = varButton.indexOf(input);
                        if (input.trim() == "") {
                            console.log("Its empty divInputEdit")
                            return;
                        }
                        if (input.search(/,/i) > -1) {
                            alert("Недопустимый символ ','")
                            return
                        }
                        if (comp_index > -1) {
                            console.log("over in the array")
                            return;
                        }
                        if (!(input in dictionaryAutoCompCompon)) {
                            $(".components").append("<button class=\"varButton\">" + input + "</button>");
                            varButton.push(input);
                            $(".getInputComponentEdit").val('');
                            return;
                        }
                        for (var name in dictionaryAutoCompCompon) {
                            if (name == input) {
                                var id = dictionaryAutoCompCompon[name];
                                console.log('in dictionary')
                                console.log('name ' + name)
                                console.log('index ' + id)
                                if (!componets_array_ID.includes(id)) {
                                    console.log('not in the array')
                                    componets_array_ID.push(id);
                                    $(".components").append("<button class=\"varACCButton\"" + "id=" + "\"" + id + "\"" + ">" + input + "</button>");
                                    $(".getInputComponentEdit").val('');
                                    fillDobOgr()
                                }
                            }
                        }
                    })
                });
            });
            $(document).on('click', '#btn4', function () {
                $('#menu').load("additive.jsp", function () {
                    e_table = $('#additive_table').DataTable({
                        processing: true,
                        ajax: {
                            url: "/DbInterface",
                            data: {getAdditive: "getAdditive"},
                            dataSrc: "additive",
                            type: "POST"
                        },
                        "pageLength": 25,
                        "lengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                        "deferRender": true,
                        "columnDefs": [
                            {"targets": 0, "visible": false},
                            {"targets": 1, "visible": true},
                            {"targets": 2, "visible": true, "width": "1%",},
                            {"targets": 5, "visible": true},
                            {"targets": 6, "visible": true},
                            {"targets": 7, "visible": false},
                            {"targets": 8, "visible": false},
                            {
                                "targets": 9,
                                "orderable": false,
                                "searchable": false,
                                "width": "1%",
                                "data": null,
                                "defaultContent": "<button id = 'edit_component'>&#8601;</button>"
                            },
                            {
                                "targets": 10,
                                "orderable": false,
                                "searchable": false,
                                "width": "1%",
                                "data": null,
                                "defaultContent": "<button id = 'select'>&#10003;</button>"
                            }
                        ]
                    });
//                  Поиск по колонкам
                    $('#additive_table .searchable').each(function () {
                        var title = $(this).text();
                        $(this).html('<input type="text" placeholder="Search ' + title + '" />');
                    });
                    e_table.columns().every(function () {
                        var that = this;
                        $('input', this.footer()).on('keyup change', function () {
                            if (that.search() !== this.value) {
                                that.search(this.value).draw();
                            }
                        });
                    });
//                  нажатие кнопки выделить row
                    $('#additive_table tbody').on('click', '#select', function () {
                        $($(this).parents('tr')).toggleClass('selected');
                    });
//                  удаляем выделенные елементы 100 штук
                    $('.remove').click(function () {
                        var i = 0;
                        while (i < 100) {
                            i++;
                            $.ajax({
                                url: "/DbInterface",
                                data: {
                                    removeAdditive: "removeAdditive",
                                    additive_id: e_table.row('.selected').data()[0]
                                },
                                type: 'POST',
                                dataType: 'text',
                                success: function (output) {
                                },
                                error: function (request, status, error) {
                                    alert("Error: Could not back");
                                }
                            });
                            e_table.row('.selected').remove().draw(false);
                        }
                    });

                    $(".divInput").on("click", ".addComponent", function () {
                        comp_index = componentGroup.indexOf($(".getInputComponent").val());
                        if ($(".getInputComponent").val().trim() == "") {
                            console.log("Its empty")
                            return;
                        }
                        if ($(".getInputComponent").val().trim() == $(".e_name").val()) {
                            console.log("Its repeat name")
                            return;
                        }
                        if (comp_index > -1) {
                            console.log("over in the array")
                        } else {
                            $(".components").append("<button class=\"varButton\">" + $(".getInputComponent").val().trim() + "</button>");
                            componentGroup.push($(".getInputComponent").val().trim());
                            $(".getInputComponent").val('');
                            console.log(componentGroup)
                        }
                    });
                    $(".components").on("click", ".varButton", function () {
                        $(this).remove();
                        comp_index = componentGroup.indexOf($(this).text());
                        if (comp_index > -1) {
                            componentGroup.splice(comp_index, 1);
                        }
                    });
                })
            });
            $(document).on('click', '#btn5', function () {
                $('#menu').load("limitations.jsp", function () {


                    exclude = $('#exclude_table').DataTable({
                        processing: true,
                        ajax: {
                            url: "/DbInterface",
                            data: {getExclude: "getExclude"},
                            dataSrc: "exclude",
                            type: "POST"
                        },
                        "pageLength": 25,
                        "lengthMenu": [[10, -1], [10, "All"]],
                        "deferRender": true,
                        "columnDefs": [
                            {"targets": 0, "visible": true},
                            {"targets": 1},
                            {"targets": 2, "visible": true, "wodht": "20%"},
                            {
                                "targets": 3,
                                "orderable": false,
                                "searchable": false,
                                "width": "1%",
                                "data": null,
                                "defaultContent": "<button id = 'select'>&#10003;</button>"
                            },
                            {
                                "targets": 4,
                                "orderable": false,
                                "searchable": false,
                                "width": "1%",
                                "data": null,
                                "defaultContent": "<button id = 'edit'>&#8601;</button>"
                            }]

                    });
                });
            });

            $(document).on('click', "#button_create_product", function () {
                create_product();
            });
            $(document).on('click', '#edit', function () {
                edit_tableRow = table.row($(this).parents('tr')).data();
                dell_edit_tableRow = table.row($(this).parents('tr'));
                edit_product();
            });
            $(document).on('change', '.selectCategory', function () {
//                alert("run")
                var selId;
                $("select option:selected").each(function () {
                    selId = $(this).val()
                });
                fillCompound(selId);
            });
            $(document).on('change', '.edit_selectCategory', function () {
                var selId;
                $("select option:selected").each(function () {
                    selId = $(this).val()
                });
                fillCompound(selId)
            });
            $(document).on('click', "#button_create_additive", function () {
                $('.dialog_create_additive').prop('title', 'Создать добавку');
                create_additive();
            });
            $(document).on('click', '#edit_component', function () {
                edit_e_tableRow = e_table.row($(this).parents('tr')).data();
                dell_edit_e_tableRow = e_table.row($(this).parents('tr'));
                $('.dialog_create_additive').prop('title', 'Редактировать');
                edit_additive();
            });
            $(document).on('click', ".cBox", function () {
                var id = $(this).attr("id");
                var index = cBoxs.indexOf(id)
                console.log(index)
                if (index == -1) {
                    cBoxs.push(id)
                    console.log("add")
                } else {
                    cBoxs.splice(index, 1);
                    console.log("remove")
                }
                console.log(cBoxs.sort())
            })


            var create_product = function () {
                isEdit = false;
                $(".dialog_create_product").dialog({
                    autoOpen: true,
                    width: 800,
                    modal: true,
                    buttons: {
                        OK: function () {
                            $.ajax({
                                url: "/DbInterface",
                                data: {
                                    createProduct: "createProduct",
                                    prodName: $(".prodName").val(),
                                    prodProvider: $(".prodProvider").val(),
                                    prodCode: $(".prodCode").val(),
                                    prodCategory: $(".selectCategory").val(),
                                    componets_array_ID: componets_array_ID.toString(),
                                    varButton: varButton.toString()
                                },
                                type: 'POST',
                                dataType: 'text',
                                success: function (data) {
                                    $.post("/DbInterface",
                                            {
                                                getProductID: "getProductID",
                                            },
                                            function (data) {
                                                table.row.add([
                                                    parseInt(data, 10),
                                                    $(".selectCategory option:selected").text(),
                                                    $(".prodProvider").val(),
                                                    $(".prodName").val(),
                                                    $(".prodCode").val()
                                                ]).draw(false);
                                                $(".dialog_create_product").dialog("close")
                                            }
                                    );
                                },
                                error: function (request, status, error) {
                                    alert("Error: Could not back");
                                }
                            });
                        },
                        CANSEL: function () {
                            $(".dialog_create_product").dialog("close")
                        }
                    },
                    open: function (event, ui) {
                        console.log("open");
                        //формируем select
                        $.ajax({
                            url: "/DbInterface",
                            data: {
                                getCategory: "getCategory",
                            },
                            type: 'POST',
                            dataType: 'json',
                            success: function (data) {
                                $.each(data, function (index, element) {
                                    $('.selectCategory').append($("<option></option>")
                                            .attr("value", element[0])
                                            .text(element[1]));
                                })
                                fillCompound($(".selectCategory").val())
                            },
                            error: function (request, status, error) {
                                alert("Error: Could not back");
                            }
                        });
                        $.ajax({
                            url: "/DbInterface",
                            data: {getAdditive: "getAdditive"},
                            dataSrc: "additive",
                            type: "POST",
                            success: function (data) {
                                var obj = JSON.parse(data);
                                var compName;
                                var compId;
                                obj.additive.forEach(function (item, i, obj) {
                                    console.log( obj)
                                    if (item[3].search(/,/i) > -1) {
                                        var arr = item[3].split(',');
                                        var index;
                                        for (index = 0; index < arr.length; ++index) {
                                            console.log("index is " + index + " name " + arr[index])
                                            compName = arr[index];
                                            compId = item[0]
                                            dictionaryAutoCompCompon[compName] = compId;
                                            autocompleteInpComponents.push(compName);

                                        }
                                    } else {
                                        compName = item[3];
                                        compId = item[0]
                                        dictionaryAutoCompCompon[compName] = compId;
                                        autocompleteInpComponents.push(compName);

                                    }
                                });

                                autocompleteInpComponents.sort();
                                var options = '';
                                for (var i = 0; i < autocompleteInpComponents.length; i++) {
                                    options += '<option value="' + autocompleteInpComponents[i] + '" />'
                                }
                                ;
                                document.getElementById('components').innerHTML = options;
                            }
                        });
                    },
                    close: function (event, ui) {
                        $(".dialog_create_product").dialog("close")
                    },
                    beforeClose: function (event, ui) {
                        closeDialog();
                    }
                });
            };

            var edit_product = function () {
                isEdit = true;
                $(".dialog_edit_product").dialog({
                    autoOpen: true,
                    width: 800,
                    modal: true,
                    buttons: {
                        OK: function () {
                            $.ajax({
                                url: "/DbInterface",
                                data: {
                                    changeProduct: "changeProduct",
                                    prod_id: edit_tableRow[0],
                                    prodName: $(".edit_prodName").val(),
                                    prodProvider: $(".edit_prodProvider").val(),
                                    prodCode: $(".edit_prodCode").val(),
                                    prodCategory: $(".edit_selectCategory").val(),
                                    componets_array_ID: componets_array_ID.toString(),
                                    varButton: varButton.toString()
                                },
                                type: 'POST',
                                dataType: 'text',
                                success: function (data) {
                                    table.row.add([
                                        edit_tableRow[0],
                                        $(".edit_selectCategory option:selected").text(),
                                        $(".edit_prodProvider").val(),
                                        $(".edit_prodName").val(),
                                        $(".edit_prodCode").val()
                                    ]).draw(false);
                                    table.row(dell_edit_tableRow).remove().draw(false);
                                    $(".dialog_edit_product").dialog("close")
                                },
                                error: function (request, status, error) {
                                    alert("Error: Could not back");
                                }
                            });
//                            $(".dialog_edit_product").dialog("close")

                        },
                        CANSEL: function () {
                            $(".dialog_edit_product").dialog("close")
                        }
                    },
                    open: function (event, ui) {
                        $.ajax({
                            url: "/DbInterface",
                            data: {
                                getCategory: "getCategory",
                            },
                            type: 'POST',
                            dataType: 'json',
                            success: function (data) {
                                $.each(data, function (index, element) {
                                    $('.edit_selectCategory').append($("<option></option>")
                                            .attr("value", element[0])
                                            .text(element[1]));
//                                    $('.edit_selectCategory option:contains(temp)').prop('selected',true);

                                })
                                fillProductCompound(edit_tableRow[0])
                                $('.edit_selectCategory option:contains("' + edit_tableRow[1] + '")').prop('selected', true);
                                fillCompound($(".edit_selectCategory").val())
                                $(".edit_prodProvider").val(edit_tableRow[2]);
                                $(".edit_prodName").val(edit_tableRow[3]);
                                $(".edit_prodCode").val(edit_tableRow[4]);
                            },
                            error: function (request, status, error) {
                                alert("Error: Could not back");
                            }
                        });
                        $.ajax({
                            url: "/DbInterface",
                            data: {getAdditive: "getAdditive"},
                            dataSrc: "additive",
                            type: "POST",
                            success: function (data) {
                                var obj = JSON.parse(data);
                                var compName;
                                var compId;
                                obj.additive.forEach(function (item, i, obj) {
                                    console.log(item[3])
                                    if (item[3].search(/,/i) > -1) {
                                        var arr = item[1].split(',');
                                        var index;
                                        for (index = 0; index < arr.length; ++index) {
                                            console.log("index is " + index + " name " + arr[index])
                                            compName = arr[index];
                                            compId = item[0]
                                            dictionaryAutoCompCompon[compName] = compId;
                                            autocompleteInpComponents.push(compName);

                                        }
                                    } else {
                                        compName = item[3];
                                        compId = item[0]
                                        dictionaryAutoCompCompon[compName] = compId;
                                        autocompleteInpComponents.push(compName);

                                    }
                                });

                                autocompleteInpComponents.sort();
                                var options = '';
                                for (var i = 0; i < autocompleteInpComponents.length; i++) {
                                    options += '<option value="' + autocompleteInpComponents[i] + '" />'
                                }

                                document.getElementById('edit_components').innerHTML = options;

                            }
                        });
                    },
                    close: function (event, ui) {
                        $(".dialog_edit_product").dialog("close");
                    },
                    beforeClose: function (event, ui) {
                        closeEditDialog();
                    }
                });
            };

            var create_additive = function () {
                isEdit = false;
                $(".dialog_create_additive").dialog({
                    autoOpen: true,
                    width: 850,
                    modal: true,
                    buttons: {
                        OK: function () {
                            if ($.inArray($(".e_name").val(), autocompleteInpComponents) != -1) {
                                alert("Уже есть компонент с таким именем")
                                return;
                            }
                            componentGroup.unshift($(".e_name").val());
                            console.log("arr = " + componentGroup.toString())
                            $.ajax({
                                url: "/DbInterface",
                                data: {
                                    createAdditive: "createAdditive",
                                    additiveNamber: $(".e_namber").val() == "" ? 0 : $(".e_namber").val(),
                                    additiveName: componentGroup.toString(),
                                    additiveColor: $(".e_color").val(),
                                    additiveInfo: $(".info").val(),
                                    additivePermission: $(".permission").val(),
                                    additiveCBox: cBoxs.toString(),
                                    additiveFor: $(".e_for").val(),
                                    additiveNotes: $(".e_notes").val()

                                },
                                type: 'POST',
                                dataType: 'text',
                                success: function (data) {
                                    e_table.row.add([
                                        parseInt(data, 10),
                                        $(".e_for").val(),
                                        $(".e_namber").val(),
                                        componentGroup.toString(),
                                        $(".info").val(),
                                        $(".permission").val(),
                                        $(".e_notes").val(),
                                        $(".e_color").val(),
                                        cBoxs.toString(),
                                    ]).draw(false);
                                    $(".dialog_create_additive").dialog("close")

                                },
                                error: function (request, status, error) {
                                    console.log("somthing wrong");
                                    alert("Error: Could not back");
                                }
                            });
                        },
                        CANSEL: function () {
                            $(".dialog_create_additive").dialog("close")
                        }
                    },
                    open: function (event, ui) {
                        fillGroupAdditive();
                        getCBox();
                    },
                    beforeClose: function (event, ui) {
                        closeAdditiveDialog()
                    }
                });
            };

            var edit_additive = function () {
                isEdit = false;
                $(".dialog_create_additive").dialog({
                    autoOpen: true,
                    width: 850,
                    modal: true,
                    buttons: {
                        OK: function () {
                            componentGroup.unshift($(".e_name").val());
                            console.log("arr " + componentGroup.toString())
                            $.ajax({
                                url: "/DbInterface",
                                data: {
                                    changeAdditive: "changeAdditive",
                                    additiveId: edit_e_tableRow[0],
                                    additiveNamber: $(".e_namber").val(),
                                    additiveName: componentGroup.toString(),
                                    additiveColor: $(".e_color").val(),
                                    additiveInfo: $(".info").val(),
                                    additivePermission: $(".permission").val(),
                                    additiveCBox: cBoxs.toString(),
                                    additiveFor: $(".e_for").val(),
                                    additiveNotes: $(".e_notes").val()

                                },
                                type: 'POST',
                                dataType: 'text',
                                success: function (data) {
                                    console.log(componentGroup.toString());
                                    e_table.row.add([
                                        edit_e_tableRow[0],
                                        $(".e_for").val(),
                                        $(".e_namber").val(),
                                        componentGroup.toString(),
                                        $(".info").val(),
                                        $(".permission").val(),
                                        $(".e_notes").val(),
                                        $(".e_color").val(),
                                        cBoxs.toString(),
                                    ]).draw(false);
                                    e_table.row(dell_edit_e_tableRow).remove().draw(false);
                                    $(".dialog_create_additive").dialog("close")
                                },
                                error: function (request, status, error) {
                                    alert("Error: Could not back");
                                }
                            });
                        },
                        CANSEL: function () {
                            $(".dialog_create_additive").dialog("close")
                        }
                    },
                    open: function (event, ui) {
                        edit_e_tableRow[7] == 0 ? $('.e_color option:contains("Зеленый")').prop('selected', true) : null;
                        edit_e_tableRow[7] == 1 ? $('.e_color option:contains("Желтый")').prop('selected', true) : null;
                        edit_e_tableRow[7] == 2 ? $('.e_color option:contains("Крассный")').prop('selected', true) : null;

                        var arr = edit_e_tableRow[3].split(",");
                        $(".e_name").val(arr[0]);
                        $(".e_namber").val(edit_e_tableRow[2]);
                        $(".e_for").val(edit_e_tableRow[1]);
                        $(".e_notes").val(edit_e_tableRow[6]);
                        $(".info").val(edit_e_tableRow[4]);
                        $(".permission").val(edit_e_tableRow[5]);
                        getCBox(edit_e_tableRow[8])

                        fillGroupAdditive();
                        arr.shift();
                        arr.sort();
                        arr.forEach(function (item, i, arr) {
                            $(".components").append("<button class=\"varButton\">" + item.trim() + "</button>");
                            componentGroup.push(item.trim())
                        });
                    },
                    close: function (event, ui) {
                        $(".dialog_create_additive").dialog("close")
                    },
                    beforeClose: function (event, ui) {
                        closeAdditiveDialog()
                    }
                });
            };

            function fillCompound(_compoundID) {
                varButton = [];
                componets_array_ID = [];
                $(".compound button").remove();
                $(".components button").remove();
                $.ajax({
                    url: "/DbInterface",
                    data: {
                        getCompound: "getCompound",
                        compoundID: _compoundID
                    },
                    type: 'POST',
                    dataType: 'text',
                    success: function (data) {
                        $(".compound").append(data)
                    },
                    error: function (request, status, error) {
                        alert("Error: Could not back");
                    }
                });
            };

            function fillProductCompound(_compoundProductID) {
                $.ajax({
                    url: "/DbInterface",
                    data: {
                        getProductCompound: "getProductCompound",
                        compoundProductID: _compoundProductID
                    },
                    type: 'POST',
                    dataType: 'text',
                    success: function (data) {
                        if (isEdit) {
                            $(".components button").remove().end();
                        }
                        $(".components").append(data);
                        var parent = document.querySelector('.dialog_edit_product');
                        var elements = parent.getElementsByClassName('varButton');
                        for (var i = 0; i < elements.length; i++) {
                            componets_array_ID.push(elements[i].id);
                        }
                        fillDobOgr();
                    },
                    error: function (request, status, error) {
                        alert("Error: Could not back");
                    }
                });
            };

            function getCBox(array) {
                if (array != null) {
                    if(array.trim().length != 0){
                        cBoxs = array.split(",")
                    }
                }
                console.log("array = " + cBoxs.sort())

                $.ajax({
                    url: "/DbInterface",
                    data: {getCBox: 'getCBox'},
                    type: 'POST',
                    success: function (data) {
                        var obj = (JSON.parse(data)).exclude;
                        obj.forEach(function (item, i, obj) {
                            var id = item[0];
                            var name = item[1];
                            var indexChecked = cBoxs.indexOf(id);
                            if (indexChecked == -1) {
                                $('.exclude').append("<p><input type=\"checkbox\" class=\"cBox\" id=\"" + id + "\"/>" + name + "</p>")
                            } else
                                $('.exclude').append("<p><input type=\"checkbox\" class=\"cBox\" id=\"" + id + "\" checked/>" + name + "</p>")
                        })
                        console.log(cBoxs.sort())
                    }
                })
            };

            function fillCBox(cBoxArray) {

                $(".cBox #8").prop("checked", true)
                $("#5").prop("checked", true)

//                cBoxArray[0] == 1 ? $("#c0").prop("checked", true) : null;
            };

            function closeDialog() {
                componets_array_ID = [];
                varButton = [];
                autocompleteInpComponents = [];
                $(".dobavki p").remove();
                $(".ogranicenija p").remove();
                $.ajaxSetup({cache: false});
                $(".getInputComponent").val('');
                $(".prodName").val('');
                $(".prodProvider").val('');
                $(".prodCode").val('');
                $(".selectCategory").find('option').remove();
                if ($(".dialog_create_product").dialog("isOpen")) {
                    $(".dialog_create_product").dialog("destroy");
                }
            };

            function closeEditDialog() {
                componets_array_ID = [];
                autocompleteInpComponents = [];
                varButton = [];
                $(".dobavki p").remove();
                $(".ogranicenija p").remove();
                $.ajaxSetup({cache: false});
                $(".getInputComponentEdit").val('');
                $(".edit_prodName").val('');
                $(".edit_prodProvider").val('');
                $(".edit_prodCode").val('');
                $(".edit_selectCategory").find('option').remove();
                if ($(".dialog_edit_product").dialog("isOpen")) {
                    $(".dialog_edit_product").dialog("destroy");
                }

            };

            function closeAdditiveDialog() {
                autocompleteInpComponents = [];
                cBoxs = [];
                $.ajaxSetup({cache: false});
                $(".exclude p").remove();
                $(".e_namber").val('');
                $(".e_name").val('');
                $(".e_color").val('0');
                $(".info").val('');
                $(".permission").val('');
                $(".getInputComponent").val('');
//                $('#c0:checked').prop('checked', false);
//                $('#c1:checked').prop('checked', false);
//                $('#c2:checked').prop('checked', false);
//                $('#c3:checked').prop('checked', false);
//                $('#c4:checked').prop('checked', false);
//                $('#c5:checked').prop('checked', false);
//                $('#c6:checked').prop('checked', false);
//                $('#c7:checked').prop('checked', false);
                if ($(".dialog_create_additive").dialog("isOpen")) {
                    $(".dialog_create_additive").dialog("destroy");
                }
            };

            function fillGroupAdditive() {
                //в аргумент добавить id изменяемого компонента
                console.log("group")
                componentGroup = [];
                $(".components button").remove();

            };

            function fillDobOgr() {
                $(".dobavki p").remove();
                $(".ogranicenija p").remove();
                componets_array_ID.sort();
                componets_array_ID.forEach(function (compId, i, componets_array_ID) {
                    console.log(compId);
                    $.ajax({
                        url: "/DbInterface",
                        data: {
                            getAdditiveByID: "getAdditiveByID",
                            additiveID: compId,
                        },
                        dataSrc: "component",
                        type: "POST",
                        success: function (data) {
                            var obj = JSON.parse(data);
                            console.log(obj);
                            console.log(obj.component[1] + "in obj");
                            if (obj.component[2] != 0) {
                                $(".dobavki").append("<p>E" + obj.component[2] + " - " + obj.component[1] + "</p>");
                            }
                            var ogran = obj.component[6];
                            var ogrArr = [];
                            if (ogran != null) {
                                if(ogran.trim().length != 0){
                                    ogrArr = ogran.split(",")
                                    $.ajax({
                                        url: "/DbInterface",
                                        data: {getCBox: 'getCBox'},
                                        type: 'POST',
                                        success: function (data) {
                                            var obj = (JSON.parse(data)).exclude;
                                            obj.forEach(function (item, i, obj) {
                                                var id = item[0];
                                                var name = item[1];
                                                var indexChecked = ogrArr.indexOf(id);
                                                if (indexChecked > -1) {
                                                    $(".ogranicenija").append("<p>" + name + "</p>");
                                                }
                                            })
                                            console.log(cBoxs.sort())
                                        }
                                    })


                                }
                            }
                        }
                    })
                });
            }

            function cBoxToArray() {return cBoxs;};
            function fillProductNames(_compoundProductID) {
                $.ajax({
                    url: "/DbInterface",
                    data: {
                        getProductCompound: "getProductNames",
                        compoundProductID: _compoundProductID
                    },
                    type: 'POST',
                    dataType: 'text',
                    success: function (data) {
                        $(".components button").remove().end();
                        $(".components").append(data)
                    },
                    error: function (request, status, error) {
                        alert("Error: Could not back");
                    }
                });
            };
            function fillInputComponent() {
                $.ajax({
                    url: "/DbInterface",
                    data: {getAdditive: "getAdditive"},
                    dataSrc: "additive",
                    type: "POST",
                    success: function (data) {
                        var obj = JSON.parse(data);
                        obj.additive.forEach(function (item, i, obj) {
                            autocompleteInpComponents.push(item[3]);
                            console.log(autocompleteInpComponents)
                        });
                        console.log("Success: " + autocompleteInpComponents);
//                        $( ".getInputComponent" ).autocomplete({
//                            source: autocompleteInpComponents,
//                        });
//                        $( ".getInputComponentEdit" ).autocomplete({
//                            source: autocompleteInpComponents,
//                        });
                    }
                })
            };

        });
    </script>
</head>
<body>
<table align="center" style="width:100%;">
    <tbody>
    <tr>
        <td>
            <p>
                <button class="button" id="btn1">Сводка</button>
                <button class="button" id="btn2">Каталог</button>
                <button class="button" id="btn3">Продукты</button>
                <button class="button" id="btn4">Добавки</button>
                <button class="button" id="btn5">Ограничения</button>
            </p>
        </td>
        <td style="text-align: right;">${username}&nbsp;</h5>
            <a href="../LogoutServlet">
                <button class="button">Выход</button>
                ​</a>
        </td>
    </tr>
    </tbody>
</table>

<hr/>

<div id="menu" style="width:100%; height:400px;float:left">
</div>
</body>
</html>