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

    <script>
        $(document).ready(function () {
            var table;
            var e_table;
            var isEdit;
            var edit_tableRow;
            var dell_edit_tableRow;
            var edit_e_tableRow;
            var dell_edit_e_tableRow;
            var componets_array_ID = [];
            var varButton = [];
            var comp_index;
            var varBtn_index;
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            $('#btn1').click(function () {
                $('#menu').load("info.jsp");
            });
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            $('#btn2').click(function () {
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
                            alert(this.className)
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
                                        $(this).dialog("close"),
                                                alert("Cansel")
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
                                        $(this).dialog("close"),
                                                alert("Cansel")
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
                                        $(this).dialog("close"),
                                                alert("Cansel")
                                    }
                                },
                                width: 600

                            })
                        }
                    }));

//                    var category_table = $('#category_table').DataTable({
//                        processing : true,
//                        ajax : {
//                            url : "/DbInterface",
//                            data: {getCategory : "getCategory"},
//                            dataSrc : "category",
//                            type : "POST"
//                        },
//                        "aaSorting": [[1,'asc']],
//                        "pageLength" : 25,
//                        "lengthMenu" : [ [ 10, 25, -1 ], [ 10, 25, "All" ] ],
//                        "deferRender": true,
//                        columns: [
//                            { title: "id" },
//                            { title: "Каталог" },
//                            { title: "Edit" },
//                            { title: "Select" }
//                        ],
//                        "columnDefs": [
//                            { "visible": false, "targets": 0 },
//                            { "targets": 1, "wodht":"30%" },
//                            {
//                                "targets": 3,
//                                "orderable": false,
//                                "searchable": false,
//                                "width": "1%",
//                                "data": null,
//                                "defaultContent": "<button id = 'select'>S</button>"
//                            },
//                            {
//                                "targets": 2,
//                                "orderable": false,
//                                "searchable": false,
//                                "width": "1%",
//                                "data": null,
//                                "defaultContent": "<button id = 'edit'>E</button>"
//                            } ]
//
//                    });
                });
            });
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            $('#btn3').click(function () {
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
                            {"targets": 0, "visible": true},
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

//                  Скрыть елементы
//                    $('a.toggle-vis').on( 'click', function (e) {
//                        e.preventDefault();
//
//                        // Get the column API object
//                        var column = table.column( $(this).attr('data-column') );
//
//                        // Toggle the visibility
//                        column.visible( ! column.visible() );
//                    } );

//                  поиск в смоем диве
//                    $('#search-inp').on('keyup',function(){
//                        table.search($(this).val()).draw() ;
//                    });

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
                        if(!componets_array_ID.includes($(this).attr("id"))){
                            $(".components").append($(this));
                            componets_array_ID.push($(this).attr("id"));
                        }
                    });
                    $(".components").on("click", ".btnCompound", function () {
                        $(".compound").append($(this));
                        comp_index = componets_array_ID.indexOf($(this).attr("id"));
                        if (comp_index > -1) {
                            componets_array_ID.splice(comp_index, 1);
                        }
                    });
                    $(".components").on("click", ".varButton", function () {
                        $(this).remove();
                        varBtn_index = varButton.indexOf($(this).text());
                        if(!isEdit){
                            if (comp_index > -1) {
                                varButton.splice(varBtn_index, 1);
                            }
                        }
                        if (isEdit) {
                            comp_index = componets_array_ID.indexOf($(this).attr("id"));
                            if (comp_index > -1) {
                                componets_array_ID.splice(comp_index, 1);
                            }
                        }
                    });
                    $(".divInput").on("click", ".addComponent", function () {
                        if ($(".getInputComponent").val() != "") {
                            $(".components").append("<button class=\"varButton\">" + $(".getInputComponent").val() + "</button>");
                            varButton.push($(".getInputComponent").val());
                            $(".getInputComponent").val('');
                        }
                    })
                    $(".divInputEdit").on("click", ".addComponentEdit", function () {
                        if ($(".getInputComponentEdit").val() != "") {
                            $(".components").append("<button class=\"varButton\">" + $(".getInputComponentEdit").val() + "</button>");
                            varButton.push($(".getInputComponentEdit").val());
                            $(".getInputComponentEdit").val('');
                        }
                    })
                });
            });
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            $('#btn4').click(function () {
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
//                            {"targets": 3, "wodht": "20%"},
                            {
                                "targets": 5,
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
//                  Поиск по колонкам
                    $('#additive_table .searchable').each(function () {
                        var title = $(this).text();
                        $(this).html('<input type="text" placeholder="Search ' + title + '" />');
                    });
                    e_table.columns().every(function () {
                        var that = this;
                        $('input', this.footer()).on('keyup change', function () {
                            if (that.search() !== this.value) {
                                that
                                        .search(this.value)
                                        .draw();
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
                })
            });
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            $('#btn5').click(function () {
                $('#menu').load("limitations.jsp");
            });
            function closeDialog() {
                componets_array_ID = [];
                varButton = [];
                $.ajaxSetup({cache: false});
                $(".getInputComponent").val('');
                $(".prodName").val('');
                $(".prodProvider").val('');
                $(".prodCode").val('');
                $(".selectCategory").find('option').remove();
                if ($(".dialog_create_product").dialog("isOpen")) {
                    $(".dialog_create_product").dialog("destroy");
                }
            }
            function closeAdditiveDialog() {
                   $(".e_namber").val('');
                $(".e_name").val('');
                $(".e_color").val('0');
                $(".info").val('');
                $(".permission").val('');
                $(".getInputComponentEdit").val('');
                $('#c0:checked').prop('checked', false);
                $('#c1:checked').prop('checked', false);
                $('#c2:checked').prop('checked', false);
                $('#c3:checked').prop('checked', false);
                $('#c4:checked').prop('checked', false);
                $('#c5:checked').prop('checked', false);
                $('#c6:checked').prop('checked', false);
                $('#c7:checked').prop('checked', false);
                if ($(".dialog_create_additive").dialog("isOpen")) {
                    $(".dialog_create_additive").dialog("destroy");
                }
            }

            function closeEditDialog() {
                componets_array_ID = [];
                varButton = [];
                $.ajaxSetup({cache: false});
                $(".getInputComponent1").val('');
                $(".edit_prodName").val('');
                $(".edit_prodProvider").val('');
                $(".edit_prodCode").val('');
                $(".edit_selectCategory").find('option').remove();
                if ($(".dialog_edit_product").dialog("isOpen")) {
                    $(".dialog_edit_product").dialog("destroy");
                }
                ;
            }

            $(document).on('click', "#button_create_product", function () {
                create_product();
            })
            $(document).on('click', '#edit', function () {
                edit_tableRow = table.row($(this).parents('tr')).data();
                dell_edit_tableRow = table.row($(this).parents('tr'));

                edit_product();
//                $('.dialog_change_product').data('openFor', 'change');
//                $('.dialog_change_product').data('prodId', data[0]);
//                $('.dialog_change_product').data('prodCategory', data[1]);
//                $('.dialog_change_product').data('prodProvider', data[2]);
//                $('.dialog_change_product').data('prodName', data[3]);
//                $('.dialog_change_product').data('prodCode', data[4]);
//                $('.dialog_change_product').dialog('option', 'title', 'Редактировать это');
            });
            $(document).on('change', '.selectCategory', function () {
                alert("run")
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
                create_additive();

            })
//            $(document).on('click', '#edit', function () {
//                edit_e_tableRow = e_table.row($(this).parents('tr')).data();
//                dell_edit_e_tableRow = e_table.row($(this).parents('tr'));
//                alert('редактировать добавку')
//
//            });



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
                        var openFor = $(this).data("openFor");
                        var prodId = $(this).data("prodId");
                        var prodCategory = $(this).data("prodCategory");
                        var prodProvider = $(this).data("prodProvider");
                        var prodName = $(this).data("prodName");
                        var prodCode = $(this).data("prodCode");

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
//                                    $('.selectCategory option:contains(temp)').prop('selected',true);

                                })
                                fillCompound($(".selectCategory").val())
                            },
                            error: function (request, status, error) {
                                alert("Error: Could not back");
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
//                            $.ajax({
//                                url: "/DbInterface",
//                                data: {
//                                    removeProduct: "removeProduct",
//                                    prod_id: edit_tableRow[0]
//                                },
//                                type: 'POST',
//                                dataType: 'text',
//                                success: function (output) {
//                                },
//                                error: function (request, status, error) {
//                                    alert("Error: Could not back");
//                                }
//                            });
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
                            $.ajax({
                                url: "/DbInterface",
                                data: {
                                    createAdditive: "createAdditive",
                                    additiveNamber: $(".e_namber").val(),
                                    additiveName: $(".e_name").val(),
                                    additiveColor: $(".e_color").val(),
                                    additiveInfo: $(".info").val(),
                                    additivePermission: $(".permission").val(),
                                    additiveCBox: cBoxToArray().toString(),
//                                    componets_array_ID: componets_array_ID.toString(),
//                                    varButton: varButton.toString()
                                },
                                type: 'POST',
                                dataType: 'text',
                                success: function (data) {
                                    $.post("/DbInterface",
                                            {
                                                getAdditiveID: "getAdditiveID",
                                            },
                                            function (data) {
                                                e_table.row.add([
                                                    parseInt(data, 10),
                                                    $(".e_name").val(),
                                                    $(".e_namber").val(),
                                                    $(".info").val(),
                                                ]).draw(false);
                                                $(".dialog_create_additive").dialog("close")
                                            }
                                    );
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
            }

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
                    },
                    error: function (request, status, error) {
                        alert("Error: Could not back");
                    }
                });

            }

            function cBoxToArray() {
                var cBoxs=[];
                $('#c0:checked').val() =="on" ? cBoxs.push(1) : cBoxs.push(0);
                $('#c1:checked').val() =="on" ? cBoxs.push(1) : cBoxs.push(0);
                $('#c2:checked').val() =="on" ? cBoxs.push(1) : cBoxs.push(0);
                $('#c3:checked').val() =="on" ? cBoxs.push(1) : cBoxs.push(0);
                $('#c4:checked').val() =="on" ? cBoxs.push(1) : cBoxs.push(0);
                $('#c5:checked').val() =="on" ? cBoxs.push(1) : cBoxs.push(0);
                $('#c6:checked').val() =="on" ? cBoxs.push(1) : cBoxs.push(0);
                $('#c7:checked').val() =="on" ? cBoxs.push(1) : cBoxs.push(0);
                return cBoxs;
            }

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
            }

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
            <a href="../LogoutServlet"><button class="button">Выход</button>​</a>
        </td>
    </tr>
    </tbody>
</table>

<hr/>

<div id="menu" style="width:100%; height:400px;float:left">
</div>
</body>
</html>