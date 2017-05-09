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
		.placeholerValueAvalible::-webkit-input-placeholder {
			color: #e34b4e
		}

		.placeholerNormal::-webkit-input-placeholder {
			color: #9c9c9c
		}

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

		.adminButton {
			color: #2b2b2b;
			text-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
			letter-spacing: 1px;
		}

		.adminButton:hover {
			color: #e34b4e;
			text-shadow: 0 12 16px rgba(0, 0, 0, 0.24);
			letter-spacing: 1px;
		}

		.custom-combobox {
			position: relative;
			display: inline-block;
		}

		.custom-combobox-toggle {
			position: absolute;
			top: 0;
			bottom: 0;
			margin-left: -1px;
			padding: 0;
		}

		.custom-combobox-input {
			margin: 0;
			padding: 5px 10px;
		}
	</style>
	<script src="//code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
	<%--<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>--%>
	<script src="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
	<script src="https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/barcoder.js"></script>
	<script src="${pageContext.request.contextPath}/js/naturalSort.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script>
		var urlDb = "${pageContext.request.contextPath}/DbInterface";
		$(document).ready(function () {
			window.imageId = 0;
			window.isEdit = false;
			window.removeImage = false;
			$('#menu').load("info.jsp");
			var imageUrl;
			var table;
			var e_table;
			var newprod_table;
			var type_table;
			var edit_type_table;
			var dell_edit_type_table;
			var exclude;
			var edit_tableRow;
			var dell_edit_tableRow;
			var edit_e_tableRow;
			var dell_edit_e_tableRow;
			var componets_array_ID = [];
			var varButton = [];
			var comp_index;
			var varBtn_index;
			var autocompleteInpComponents = [];
			var autocompleteInpTypes = [];
			var componentGroup = [];
			var dictionaryAutoCompCompon = {};
			var categories = [];
			var cBoxs = [];
			var cell;
			var catId;
			var listBarcode = [];
			var permission = '${permission}';
			if (permission == '1') {
				$('.menuItem').append('' +
					'<p> <button class="button" id="btn1">Сводка</button> ' +
					'<button class="button" id="btn2">Каталог</button>' +
					'<button class="button" id="btn3">Продукты</button>' +
					'<button class="button" id="btn4">Добавки</button>' +
					'<button class="button" id="btn5">Типы</button>' +
					'<button class="button" id="btn6">Ограничения</button>' +
					'<button class="button" id="btn7">Загрузки</button>' +
					'</p>')
			} else {
				$('.menuItem').append(' ' +
					'<p> <button class="button" id="btn1">Сводка</button> ' +
					' <button class="button" id="btn2">Каталог</button>' +
					'<button class="button" id="btn3">Продукты</button>' +
					'<button class="button" id="btn6">Загрузки</button>' +
					'</p>')
			}
			$(document).click(function (event) {
				<%--console.log(${sessionScope.username});--%>
				<%--console.log('<%= session.getAttribute("username") %>');--%>
			});
			$(document).on('click', '#btn1', function () {
				$('#menu').load("info.jsp");
				fillBarcodeList();


			});
			$(document).on('click', '#btn2', function () {
				$('#menu').load("catalog.jsp", function () {
					//добавить катгорию
					fill_main_section();
					$(".addSection").on("click", "#addSection", (function () {
						$.ajax({
							url: urlDb,
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
					}));
					//заполнить таблицу
					function fill_main_section() {
						$.ajax({
							url: urlDb,
							data: {
								getSection: "getSection"
							},
							type: 'POST',
							dataType: 'text',
							success: function (data) {
								$("#main_section").append(data);
							},
							error: function (request, status, error) {
							}
						})
					}

					//обрабатываем кнопки в таблице
					$("#main_section").on("click", "td", (function () {
						var _id = $(this).parent().parent().attr("id")
						var _id_cat = $(this).parent().attr("id")
						var rName = $(this).parent("tr").children("td:first").text();
						var element = document.getElementById("removeName");
						element.innerHTML = rName;

						if (this.className === "parent") {
							$(".child-" + _id).toggle()
						}
						if (this.className === "remove-" + _id) {
							$("#remove").dialog({
								autoOpen: true,
								modal: true,
								buttons: {
									OK: function () {
										$(this).dialog("destroy");
										$.ajax({
											url: urlDb,
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

									},
									CANSEL: function () {
										$(this).dialog("close")
									}
								},
								width: 300
							})
						}
						if (this.className === "rename-" + _id) {
							$("#rename").dialog({
								autoOpen: true,
								modal: true,
								buttons: {
									OK: function () {
										$(this).dialog("destroy"),
											$.ajax({
												url: urlDb,
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
									}
								},
								width: 600

							})
						}
						if (this.className === "addCategory-" + _id) {
							$("#addCategory").dialog({
								autoOpen: true,
								modal: true,
								buttons: {
									OK: function () {
										$(this).dialog("destroy"),
											$.ajax({
												url: urlDb,
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
									}
								},
								width: 600
							})
						}
						if (this.className === "removeCat") {
							$("#remove").dialog({
								autoOpen: true,
								modal: true,
								buttons: {
									OK: function () {
										$(this).dialog("destroy");
										$.ajax({
											url: urlDb,
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
									},
									CANSEL: function () {
										$(this).dialog("close")
									}
								},
								width: 300
							})
						}
						if (this.className === "renameCat") {
							$("#renameCat").dialog({
								autoOpen: true,
								modal: true,
								buttons: {
									OK: function () {
										$(this).dialog("destroy"),
											$.ajax({
												url: urlDb,
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
							url: urlDb,
							data: {getProducts: "getProducts"},
							dataSrc: "products",
							type: "POST"
						},
						"pageLength": 25,
						"lengthMenu": [[10, 25, 50, 100, 500, 1000, 5000, -1], [10, 25, 50, 100, 500, 1000, 5000, "All"]],
						"columnDefs": [
							{"targets": 0, "visible": false},
							{"targets": 4, "wodht": "20%"},
							{"targets": 5, "wodht": "20%"},
							{
								"targets": 6,
								"orderable": false,
								"searchable": false,
								"width": "1%",
								"data": null,
								"defaultContent": "<button id = 'edit'>&#8601;</button>"
							},
							{
								"targets": 7,
								"orderable": false,
								"searchable": false,
								"width": "1%",
								"data": null,
								"defaultContent": "<button id = 'select'>&#10003;</button>"
							}
						]
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
							var prodId = table.row('.selected').data()[0];
							imageUrl = "${pageContext.request.contextPath}/image/images/" + prodId + ".jpg";

							$.ajax({
								url: urlDb,
								data: {
									removeProduct: "removeProduct",
									prod_id: prodId
								},
								type: 'POST',
								dataType: 'text',
								success: function (output) {
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});
							$.ajax({
								url: '${pageContext.request.contextPath}/FileUploadServlet',
								data: {removeFile: imageUrl},
								type: 'POST',
								success: function (data) {
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
						var index = componets_array_ID.indexOf($(this).attr("id"))
						if (!(index > -1)) {
							$(".components").append($(this));
							componets_array_ID.push($(this).attr("id"));
							fillDobOgr()
						} else {
							alert("Данный компонент присутствует в составе продукта")
						}
					});
					$(".components").on("click", ".btnCompound", function () {
						$(".compound").append($(this));
						comp_index = componets_array_ID.indexOf($(this).attr("id"));
						if (comp_index > -1) {
							componets_array_ID.splice(comp_index, 1);
//                            console.log('btnCompound deleted')
							fillDobOgr()
						}
					});
					$(".components").on("click", ".varButton", function () {
						$(this).remove();
						varBtn_index = varButton.indexOf($(this).text());
						if (!isEdit) {
//                            console.log("In")
							if (varBtn_index > -1) {
								varButton.splice(varBtn_index, 1);
//                                console.log(varButton)
							}
						}
						if (isEdit) {
							comp_index = componets_array_ID.indexOf($(this).attr("id"));
							if (comp_index > -1) {
								componets_array_ID.splice(comp_index, 1);
								fillDobOgr()
							}
						}
//                        console.log('varButton deleted')
					});
					$(".components").on("click", ".varACCButton", function () {
						$(this).remove();
						comp_index = componets_array_ID.indexOf($(this).attr("id"));
						if (comp_index > -1) {
							componets_array_ID.splice(comp_index, 1);
//                            console.log('varACCButton deleted')
							fillDobOgr()
						}
					});
					$(".divInput").on("click", ".addComponent", function () {
						var input = $(".getInputComponent").val().trim();
						var reg = /^[EeЕе][0-9]/i.exec(input)
						if (reg) {
							input = "Е" + input.substring(1);
						}
						comp_index = varButton.indexOf(input);
						if (input == "") {
//                            console.log("Its empty divInput")
							return;
						}
						if (comp_index > -1) {
//                            console.log("over in the array")
							alert("Данный компонент присутствует в составе продукта")
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
//                                console.log('in dictionary')
								var index = componets_array_ID.indexOf(compId)
								if (!(index > -1)) {
//                                    console.log('not in the array')
									componets_array_ID.push(compId);
									$(".components").append("<button class=\"varACCButton\"" + "id=" + "\"" + compId + "\"" + ">" + input + "</button>");
									$(".getInputComponent").val('');
									fillDobOgr();
								} else {
									alert("Данный компонент присутствует в составе продукта")
								}
							}
						}
					});
					$(".divInputEdit").on("click", ".addComponentEdit", function () {
						var input = $(".getInputComponentEdit").val().trim();
						comp_index = varButton.indexOf(input);
						if (input.trim() == "") {
//                            console.log("Its empty divInputEdit")
							return;
						}
						var reg = /^[EeЕе][0-9]/i.exec(input)
						if (reg) {
							input = "Е" + input.substring(1);
						}
						if (comp_index > -1) {
//                            console.log("over in the array")
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
//                                console.log('in dictionary')
								var index = componets_array_ID.indexOf(id)
								if (!(index > -1)) {
//                                    console.log('not in the array')
									componets_array_ID.push(id);
									$(".components").append("<button class=\"varACCButton\"" + "id=" + "\"" + id + "\"" + ">" + input + "</button>");
									$(".getInputComponentEdit").val('');
									fillDobOgr()
								} else {
									alert("Данный компонент присутствует в составе продукта")
								}
							}
						}
					});
				});
			});

			$(document).on('click', '#btn4', function () {
				$('#menu').load("additive.jsp", function () {
					e_table = $('#additive_table').DataTable({
						processing: true,
						ajax: {
							url: urlDb,
							data: {getComponents: "getComponents"},
							dataSrc: "additive",
							type: "POST"
						},
						"pageLength": 25,
						"lengthMenu": [[10, 25, 50, 100, 500, -1], [10, 25, 50, 100, 500, "All"]],
						"deferRender": true,
						order: [[0, 'asc']],
						"columnDefs": [
							{"targets": 0, "visible": false},
							{"targets": 1, "visible": true},
							{"targets": 2, "visible": true},
							{"targets": 3, "type": "natural"},
//                            {"targets": 3, "visible": true, "width": "1%",},
							{"targets": 4, "visible": true,},
							{"targets": 5, "visible": true,},
							{"targets": 6, "visible": true},
							{"targets": 7, "visible": true},
							{"targets": 8, "visible": false},
							{"targets": 9, "visible": false},
							{
								"targets": 10,
								"orderable": false,
								"searchable": false,
								"width": "1%",
								"data": null,
								"defaultContent": "<button id = 'edit_component'>&#8601;</button>"
							},
							{
								"targets": 11,
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
								url: urlDb,
								data: {
									removeComponent: "removeComponent",
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

					//созадаем еще одно название
					$(".divInput").on("click", ".addComponent", function () {
						var inputText = $(".getInputComponent").val().trim();
						comp_index = componentGroup.indexOf(inputText);
						var inArray = autocompleteInpComponents.indexOf(inputText);
						if (inputText == "") {
//                            console.log("Its empty")
							return;
						}
						if (inputText == $(".e_name").val()) {
							//                           console.log("Its repeat name")
							return;
						}
						if (inArray > -1) {
							alert("Компонент с таким именем уже добавлен")
							return;
						}
						if (comp_index > -1) {
							alert("Компонент с таким именем уже добавлен")
						} else {
							$(".components").append("<button class=\"varButton\">" + inputText + "</button>");
							componentGroup.push(inputText);
							$(".getInputComponent").val('');
						}
					});
					//удаляем новую кнопку
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
				$('#menu').load("types.jsp", function () {
					type_table = $('#type_table').DataTable({
						processing: true,
						ajax: {
							url: urlDb,
							data: {getTypes: "getTypes"},
							dataSrc: "types",
							type: "POST"
						},
						"pageLength": 25,
						"lengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
						"deferRender": true,
						"columnDefs": [
							{"targets": 0, "visible": false},
							{"targets": 1, "wodht": "20%"},
							{"targets": 2, "wodht": "20%"},
							{
								"targets": 3,
								"orderable": false,
								"searchable": false,
								"width": "1%",
								"data": null,
								"defaultContent": "<button id = 'button_edit_type'>&#8601;</button>"
							},
							{
								"targets": 4,
								"orderable": false,
								"searchable": false,
								"width": "1%",
								"data": null,
								"defaultContent": "<button id = 'select'>&#10003;</button>"
							}
						]

					});
//                  Поиск по колонкам
					$('#type_table .searchable').each(function () {
						var title = $(this).text();
						$(this).html('<input type="text" placeholder="Search ' + title + '" />');
					});
					type_table.columns().every(function () {
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
							var typeId = type_table.row('.selected').data()[0];
							$.ajax({
								url: urlDb,
								data: {
									removeType: "removeType",
									type_id: typeId
								},
								type: 'POST',
								dataType: 'text',
								success: function (output) {
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});
							type_table.row('.selected').remove().draw(false);
						}
					});
//                  нажатие кнопки выделить row
					$('#type_table tbody').on('click', '#select', function () {
						$($(this).parents('tr')).toggleClass('selected');
					});
				});
			});
			$(document).on('click', '#btn6', function () {
				$('#menu').load("limitations.jsp", function () {
					exclude = $('#exclude_table').DataTable({
						processing: true,
						ajax: {
							url: urlDb,
							data: {getExclude: "getExclude"},
							dataSrc: "exclude",
							type: "POST"
						},
						"pageLength": 25,
						"lengthMenu": [[10, 25, -1], [10, 25, "All"]],
						"deferRender": true,
						"columnDefs": [
							{"targets": 0, "visible": false},
							{"targets": 1},
							{
								"targets": 3,
								"orderable": false,
								"searchable": false,
								"width": "1%",
								"data": null,
								"defaultContent": "<button id = 'select'>&#10003;</button>"
							},
							{
								"targets": 2,
								"orderable": false,
								"searchable": false,
								"width": "1%",
								"data": null,
								"defaultContent": "<button id = 'edit_exclude'>&#8601;</button>"
							}]

					});
//                  Поиск по колонкам
					$('#exclude_table .searchable').each(function () {
						var title = $(this).text();
						$(this).html('<input type="text" placeholder="Search ' + title + '" />');
					});
					exclude.columns().every(function () {
						var that = this;
						$('input', this.footer()).on('keyup change', function () {
							if (that.search() !== this.value) {
								that.search(this.value).draw();
							}
						});
					});
//                  нажатие кнопки выделить row
					$('#exclude_table tbody').on('click', '#select', function () {
						$($(this).parents('tr')).toggleClass('selected');
					});
//                  удаляем выделенные елементы 100 штук
					$('.remove').click(function () {
						var i = 0;
						while (i < 100) {
							i++;
							$.ajax({
								url: urlDb,
								data: {
									removeExclude: "removeExclude",
									exclude_id: exclude.row('.selected').data()[0]
								},
								type: 'POST',
								dataType: 'text',
								success: function (output) {
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});
							exclude.row('.selected').remove().draw(false);
						}
					});

				});
			});
			$(document).on('click', '#btn7', function () {
				$('#menu').load("newproducts.jsp", function () {
					fillBarcodeList();
					newprod_table = $('#newprod_table').DataTable({
						processing: true,
						ajax: {
							url: urlDb,
							data: {getNewProducts: "getNewProducts"},
							dataSrc: "newproducts",
							type: "POST"
						},
						"pageLength": 25,
						"lengthMenu": [[10, 25, 50, 100, 500, 1000, 5000, -1], [10, 25, 50, 100, 500, 1000, 5000, "All"]],
						"deferRender": true,
						"columnDefs": [
							{"targets": 0, "visible": false},
							{"targets": 2, "wodht": "20%"},
							{
								"targets": 4,
								"orderable": false,
								"searchable": false,
								"width": "1%",
								"data": null,
								"defaultContent": "<button id = 'select'>&#10003;</button>"
							},
							{
								"targets": 3,
								"orderable": false,
								"searchable": false,
								"width": "1%",
								"data": null,
								"defaultContent": "<button id = 'edit_newproducts'>&#8601;</button>"
							}],

						"createdRow": function (row, data, index) {
							var inList = listBarcode.indexOf(data[2])
							if (inList > -1) {
								$(row).children().eq(1).css('background-color', '#E3A9B8');
								return;
							}
						},
					});

//                  Поиск по колонкам
					$('#newprod_table .searchable').each(function () {
						var title = $(this).text();
						$(this).html('<input type="text" placeholder="Search ' + title + '" />');
					});
					newprod_table.columns().every(function () {
						var that = this;
						$('input', this.footer()).on('keyup change', function () {
							if (that.search() !== this.value) {
								that.search(this.value).draw();
							}
						});
					});
//                  нажатие кнопки выделить row
					$('#newprod_table tbody').on('click', '#select', function () {
						$($(this).parents('tr')).toggleClass('selected');
					});
//                  удаляем выделенные елементы 100 штук
					$('.remove').click(function () {
						var i = 0;
						while (i < 100) {
							i++;

							$.ajax({
								url: urlDb,
								data: {
									removeTempProducts: "removeTempProducts",
									prod_id: newprod_table.row('.selected').data()[0]
								},
								type: 'POST',
								dataType: 'text',
								success: function (output) {
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});

							$.ajax({
								url: '${pageContext.request.contextPath}/FileUploadServlet',
								data: {removeNewFile: "${pageContext.request.contextPath}/image/phoneimg/" + newprod_table.row('.selected').data()[2]},
								type: 'POST',
								success: function (data) {
								}
							});
							newprod_table.row('.selected').remove().draw(false);

						}
					});

					//обработка кнопок
					$(".compound").on("click", ".btnCompound", function () {
						var index = componets_array_ID.indexOf($(this).attr("id"))
						if (!(index > -1)) {
							$(".components").append($(this));
							componets_array_ID.push($(this).attr("id"));
							fillDobOgr()
						} else {
							alert("Данный компонент присутствует в составе продукта")
						}
					});
					$(".components").on("click", ".btnCompound", function () {
						$(".compound").append($(this));
						comp_index = componets_array_ID.indexOf($(this).attr("id"));
						if (comp_index > -1) {
							componets_array_ID.splice(comp_index, 1);
							//                           console.log('btnCompound deleted')
							fillDobOgr()
						}
					});
					$(".components").on("click", ".varButton", function () {
						$(this).remove();
						varBtn_index = varButton.indexOf($(this).text());
						if (!isEdit) {
							//                          console.log("In")
							if (varBtn_index > -1) {
								varButton.splice(varBtn_index, 1);
								//                              console.log(varButton)
							}
						}
						if (isEdit) {
							comp_index = componets_array_ID.indexOf($(this).attr("id"));
							if (comp_index > -1) {
								componets_array_ID.splice(comp_index, 1);
								fillDobOgr()
							}
						}
						//                      console.log('varButton deleted')
					});
					$(".components").on("click", ".varACCButton", function () {
						$(this).remove();
						comp_index = componets_array_ID.indexOf($(this).attr("id"));
						if (comp_index > -1) {
							componets_array_ID.splice(comp_index, 1);
							//                         console.log('varACCButton deleted')
							fillDobOgr()
						}
					});
					$(".divInputEdit").on("click", ".addComponentEdit", function () {
						var input = $(".getInputComponentEdit").val().trim();
						comp_index = varButton.indexOf(input);
						if (input.trim() == "") {
							//                         console.log("Its empty divInputEdit")
							return;
						}
						var reg = /^[EeЕе][0-9]/i.exec(input)
						if (reg) {
							input = "Е" + input.substring(1);
						}
						if (comp_index > -1) {
							//                          console.log("over in the array")
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
								//                             console.log('in dictionary')
								var index = componets_array_ID.indexOf(id)
								if (!(index > -1)) {
									//                                  console.log('not in the array')
									componets_array_ID.push(id);
									$(".components").append("<button class=\"varACCButton\"" + "id=" + "\"" + id + "\"" + ">" + input + "</button>");
									$(".getInputComponentEdit").val('');
									fillDobOgr()
								} else {
									alert("Данный компонент присутствует в составе продукта")
								}
							}
						}
					})
				});
			});
			$(document).on('click', '.adminButton', function () {
				if (permission == '1') {
					$('#menu').load("admin.jsp", function () {
					})
				}
			});
			$(document).on('click', '.saveAdmin', function () {
				$.ajax({
					url: urlDb,
					data: {
						changeUserPass: "changeUserPass",
						userID: "1",
						username: $(".adminname").val(),
						userPass: $(".adminpassword").val(),
					},
					type: 'POST',
					dataType: 'text',
					success: function (data) {
						alert("Данные изменены")
					},
					error: function (request, status, error) {
						alert("Error: Could not back");
					}
				});
			})
			$(document).on('click', '.saveOper', function () {
				$.ajax({
					url: urlDb,
					data: {
						changeUserPass: "changeUserPass",
						userID: "2",
						username: $(".opername").val(),
						userPass: $(".operpassword").val(),
					},
					type: 'POST',
					dataType: 'text',
					success: function (data) {
						alert("Данные изменены")
					},
					error: function (request, status, error) {
						alert("Error: Could not back");
					}
				});
			})
			$(document).on('click', "#button_create_product", function () {
				create_product();
			});
			$(document).on('click', '#edit', function () {
				edit_tableRow = table.row($(this).parents('tr')).data();
				dell_edit_tableRow = table.row($(this).parents('tr'));
				edit_product();
			});
			$(document).on('change', '.selectCategory', function () {
				var catName = $(this).val();
				$("#selectCategory option").each(function () {
					if (catName === $(this).val()) {
						catId = $(this).text();
					}
				});
				if (categories.includes(catName)) {
					fillCompound(catId);
					fillProdType(catId, "prodType");
				} else {
					fillCompound(null);
					fillProdType(null, "prodType");
				}
			});
			$(document).on('change', '.edit_selectCategory', function () {
				var catName = $(this).val();
				$("#edit_selectCategory option").each(function () {
					if (catName === $(this).val()) {
						catId = $(this).text();
					}
				});
				if (categories.includes(catName)) {
					fillCompound(catId);
					fillProdType(catId, "edit_prodType");
				} else {
					fillCompound(null);
					fillProdType(null, "edit_prodType");
				}
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
				//               console.log(index)
				if (index == -1) {
					cBoxs.push(id)
					//                  console.log("add")
				} else {
					cBoxs.splice(index, 1);
					//                  console.log("remove")
				}
				//               console.log(cBoxs.sort())
			});
			$(document).on('click', '#button_create_exclude', function () {
				$(".addExclude").dialog({
					autoOpen: true,
					modal: true,
					buttons: {
						OK: function () {
							$.ajax({
								url: urlDb,
								data: {
									addExclude: "addExclude",
									excludeName: $(".placeholder_addExclude").val(),
								},
								type: 'POST',
								dataType: 'text',
								success: function (data) {
									exclude.row.add([
										parseInt(data, 10),
										$(".placeholder_addExclude").val(),
										"link"
									]).draw(false);
									$(".placeholder_addExclude").val('')
									$(".addExclude").dialog("close")
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});
						},
						CANSEL: function () {
							$('.addExclude').dialog("close")
						}
					},
					beforeClose: function (event, ui) {
						$(".addExclude").dialog("destroy")
					},
					width: 600
				})
			});
			$(document).on('click', '#button_create_type', function () {
				$(".dialog_create_type").dialog({
					autoOpen: true,
					modal: true,
					buttons: {
						OK: function () {
							if ($(".typeName").val().trim() == "") {
								alert("Добавьте название")
								return;
							}
							var selId;
							$("select option:selected").each(function () {
								selId = $(this).val()
							});
							$.ajax({
								url: urlDb,
								data: {
									createType: "createType",
									typeName: $(".typeName").val(),
									catName: selId,
								},
								type: 'POST',
								dataType: 'text',
								success: function (data) {
									if (parseInt(data, 10) != 0) {
										type_table.row.add([
											parseInt(data, 10),
											$(".typeName").val(),
											$(".selectCategoryForType option:selected").text(),
										]).draw(false);
										$(".dialog_create_type").dialog("close")
									} else {
										alert("Такой тип уже есть в базе");
									}
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});
						},
						CANSEL: function () {
							$('.dialog_create_type').dialog("close")
						}
					},
					open: function (event, ui) {
						$.ajax({
							url: urlDb,
							data: {
								getCategory: "getCategory",
							},
							type: 'POST',
							dataType: 'json',
							success: function (data) {
								$('.selectCategoryForType').append($("<option></option>")
									.attr("value", 0)
									.text(''));
								$.each(data, function (index, element) {
									$('.selectCategoryForType').append($("<option></option>")
										.attr("value", element[0])
										.text(element[1]));
								})
							},
							error: function (request, status, error) {
								alert("Error: Could not back");
							}
						});
					},
					beforeClose: function (event, ui) {
						console.log("is working")
						$(".typeName").val('')
						$(".selectCategoryForType").find('option').remove();

						$(".dialog_create_type").dialog("destroy")
					},
					width: 600
				})
			});
			$(document).on('click', '#button_edit_type', function () {
				edit_type_table = type_table.row($(this).parents('tr')).data();
				dell_edit_type_table = type_table.row($(this).parents('tr'));
				var selIdOld;
				$(".dialog_edit_type").dialog({
					autoOpen: true,
					modal: true,
					buttons: {
						OK: function () {
							if ($(".edit_typeName").val().trim() == "") {
								alert("Добавьте название")
								return;
							}
							//индекс выбранной категории
							var selId;
							$("select option:selected").each(function () {
								selId = $(this).val()
							});

							$.ajax({
								url: urlDb,
								data: {
									renameType: "renameType",
									type_id: edit_type_table[0],
									type_name: $(".edit_typeName").val(),
									prodCategory_id: selId,
									prodCategory_idOld: selIdOld,
								},
								type: 'POST',
								dataType: 'text',
								success: function (data) {
									if (parseInt(data, 10) != 0) {
										type_table.row.add([
											edit_type_table[0],
											$(".edit_typeName").val(),
											$(".edit_selectCategoryForType option:selected").text(),
										]).draw(false);
										type_table.row(dell_edit_type_table).remove().draw(false);
										$(".dialog_edit_type").dialog("close")
									} else {
										alert("Такой тип уже есть в базе")
									}
									;
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});
						},
						CANSEL: function () {
							$('.dialog_edit_type').dialog("close")
						}
					},
					open: function (event, ui) {
						$.ajax({
							url: urlDb,
							data: {
								getCategory: "getCategory",
							},
							type: 'POST',
							dataType: 'json',
							success: function (data) {
								$('.edit_selectCategoryForType').append($("<option></option>")
									.attr("value", 0)
									.text(''));
								$.each(data, function (index, element) {
									$('.edit_selectCategoryForType').append($("<option></option>")
										.attr("value", element[0])
										.text(element[1]));
								})
								var selectedCat = edit_type_table[2];
								$('.edit_selectCategoryForType option:contains("' + selectedCat + '")')
									.filter(function (i, el) {
										return el.innerHTML.toLowerCase().trim() === selectedCat.toLowerCase().trim();
									})
									.prop('selected', true);

								selIdOld = $("select[name='editType'] option:selected").val();
							},
							error: function (request, status, error) {
								alert("Error: Could not back");
							}
						});
						$(".edit_typeName").val(edit_type_table[1]);
					},
					beforeClose: function (event, ui) {
						$(".edit_typeName").val('')
						$(".edit_selectCategoryForType").find('option').remove();
						$(".dialog_edit_type").dialog("destroy")
					},
					width: 600
				})
			});
			$(document).on('click', '#edit_exclude', function () {
				var rowId = exclude.row($(this).parents('tr')).data()[0];
				var dellRow = exclude.row($(this).parents('tr'));
				$(".renameExclude").dialog({
					autoOpen: true,
					modal: true,
					buttons: {
						OK: function () {
							$.ajax({
								url: urlDb,
								data: {
									renameExclude: "renameExclude",
									excludeName: $(".placeholder_renameExclude").val(),
									excludeId: rowId,
								},
								type: 'POST',
								dataType: 'text',
								success: function (data) {
									exclude.row.add([
										rowId,
										$(".placeholder_renameExclude").val(),
										"link"
									]).draw(false);
									exclude.row(dellRow).remove().draw(false);
									$(".placeholder_renameExclude").val('')
									$(".renameExclude").dialog("close")
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});
						},
						CANSEL: function () {
							$('.renameExclude').dialog("close")
						}
					},
					beforeClose: function (event, ui) {
						$(".renameExclude").dialog("destroy")
					},
					width: 600
				})
			});
			$(document).on('click', '#edit_newproducts', function () {
				edit_tableRow = newprod_table.row($(this).parents('tr')).data();
				dell_edit_tableRow = newprod_table.row($(this).parents('tr'));
				var rowTable = dell_edit_tableRow.row($(this).parents('tr')[0]);
				cell = newprod_table.cell({row: rowTable[0][0], column: 2}).node();
				create_newProduct();
			});
			$(document).on('change', '.selectProdDate', function () {
				var selId;
				$("select option:selected").each(function () {
					selId = $(this).val()
				});
				fillProdGroupByDate(selId);
			});

			var create_product = function () {
				isEdit = false;
				imageUrl = undefined;
				$(".dialog_create_product").dialog({
					autoOpen: true,
					width: 1050,
					modal: true,
					position: ['middle', 10],
					buttons: {
						OK: function () {
							if (!Barcoder.validate($(".prodCode").val())) {
								alert("Код не соответствует стандарту:  EAN8, EAN12, EAN13, EAN14, EAN18, GTIN12, GTIN13, GTIN14")
								return;
							}
							if ($.inArray($(".selectCategory").val(), categories) === -1) {
								alert("Не верно указана категория продукта")
								return;
							}
							var obj = new Object();
							for (var i = 0, len = varButton.length; i < len; i++) {
								obj['name_' + i] = varButton[i];
							}
							var jsonString = JSON.stringify(obj);
							$.ajax({
								url: urlDb,
								data: {
									createProduct: "createProduct",
									prodName: $(".prodName").val(),
									prodType: $(".prodType").val(),
									prodProvider: $(".prodProvider").val(),
									prodCode: $(".prodCode").val(),
									prodCategory: catId,
									componets_array_ID: componets_array_ID.toString(),
									varButton: jsonString.toString()
								},
								type: 'POST',
								dataType: 'text',
								success: function (data) {
									if (parseInt(data, 10) != -1) {
										dynamicUpload(parseInt(data, 10));
										table.row.add([
											parseInt(data, 10),
											$(".selectCategory").val(),
											$(".prodType").val(),
											$(".prodName").val(),
											$(".prodProvider").val(),
											$(".prodCode").val()
										]).draw(false);
										$(".dialog_create_product").dialog("close")
									} else {
										//так же выбрасывает если не верно задана таблица в jsp
										alert('Такой код уже есть в базе')
									}
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
						fillCategory("selectCategory");
						fillCompound(null)
						fillProdType(null, "prodType");
						fillComponents("components");
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
					width: 1050,
					modal: true,
					position: ['middle', 10],
					buttons: {
						OK: function () {
							if (Barcoder.validate($(".edit_prodCode").val())) {
							} else {
								alert("Код не соответствует стандарту:  EAN8, EAN12, EAN13, EAN14, EAN18, GTIN12, GTIN13, GTIN14")
								return;
							}
							if ($.inArray($(".edit_selectCategory").val(), categories) === -1) {
								alert("Не верно указана категория продукта")
								return;
							}
							var obj = new Object();
							for (var i = 0, len = varButton.length; i < len; i++) {
								obj['name_' + i] = varButton[i];
							}
							var jsonString = JSON.stringify(obj);
							$.ajax({
								url: urlDb,
								data: {
									changeProduct: "changeProduct",
									prod_id: edit_tableRow[0],
									prodName: $(".edit_prodName").val(),
									prodType: $(".edit_prodType").val(),
									prodProvider: $(".edit_prodProvider").val(),
									prodCode: $(".edit_prodCode").val(),
									prodCategory: catId,
									componets_array_ID: componets_array_ID.toString(),
									varButton: jsonString.toString()
								},
								type: 'POST',
								dataType: 'text',
								success: function (data) {
									if (parseInt(data, 10) != -1) {
										dynamicUpload(edit_tableRow[0]);
										table.row.add([
											edit_tableRow[0],
											$(".edit_selectCategory").val(),
											$(".edit_prodType").val(),
											$(".edit_prodName").val(),
											$(".edit_prodProvider").val(),
											$(".edit_prodCode").val()
										]).draw(false);
										table.row(dell_edit_tableRow).remove().draw(false);
										$(".dialog_edit_product").dialog("close")
									} else {
										alert('Такой код уже есть в базе')
									}
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});
						},
						CANSEL: function () {
							$(".dialog_edit_product").dialog("close")
						}
					},
					open: function (event, ui) {
						imageUrl = "${pageContext.request.contextPath}/image/images/" + edit_tableRow[0] + ".jpg";
						var reloadImage = imageUrl + "?t=" + new Date().getTime();
						doesFileExist(imageUrl,
							function () {
								$(".inputImg").attr("src", reloadImage);
								$(".x").show();
							}, function () {
								var blank = "${pageContext.request.contextPath}/image/bgr.jpg";
								$(".inputImg").attr("src", blank);
								$(".x").hide();
							})

						var selectedCat = edit_tableRow[1];
						fillCategory("edit_selectCategory");
						$("#edit_selectCategory option").each(function () {
							if (selectedCat === $(this).val()) {
								catId = $(this).text();
							}
						});

						$(".edit_selectCategory").val(selectedCat);

						fillProductCompound(edit_tableRow[0]);
						fillCompound(catId);
						fillProdType(catId, "edit_prodType");
						fillComponents("edit_components");
						$(".edit_prodType").val(edit_tableRow[2]);
						$(".edit_prodName").val(edit_tableRow[3]);
						$(".edit_prodProvider").val(edit_tableRow[4]);
						$(".edit_prodCode").val(edit_tableRow[5]);
					},
					beforeClose: function (event, ui) {
						closeEditDialog();
					}
				});
			};

			var create_newProduct = function () {
				isEdit = true;
				$(".dialog_edit_product").dialog({
					autoOpen: true,
					width: 1050,
					modal: true,
					position: ['middle', 10],
					buttons: {
						OK: function () {
							if (Barcoder.validate($(".edit_prodCode").val())) {
							} else {
								alert("Код не соответствует стандарту:  EAN8, EAN12, EAN13, EAN14, EAN18, GTIN12, GTIN13, GTIN14")
								return;
							}
							if ($.inArray($(".edit_selectCategory").val(), categories) === -1) {
								alert("Не верно указана категория продукта")
								return;
							}
							var obj = new Object();
							for (var i = 0, len = varButton.length; i < len; i++) {
								obj['name_' + i] = varButton[i];
								//                              console.log(varButton[i]);
							}
							var jsonString = JSON.stringify(obj);

							$.ajax({
								url: urlDb,
								data: {
									createProduct: "createProduct",
									prodName: $(".edit_prodName").val(),
									prodType: $(".edit_prodType").val(),
									prodProvider: $(".edit_prodProvider").val(),
									prodCode: $(".edit_prodCode").val(),
									prodCategory: catId,
									componets_array_ID: componets_array_ID.toString(),
									varButton: jsonString.toString()
								},
								type: 'POST',
								dataType: 'text',
								success: function (data) {
									if (parseInt(data, 10) != -1) {
										dynamicUpload(parseInt(data, 10));
										cell.style.backgroundColor = '#E3A9B8'
										$(".dialog_edit_product").dialog("close")
									} else {
										alert('Такой код уже есть в базе')
									}
								},
								error: function (request, status, error) {
									alert("Error: Could not back");
								}
							});
						},
						CANSEL: function () {
							$(".dialog_edit_product").dialog("close")
						}
					},
					open: function (event, ui) {
						var uploadImg_1 = "${pageContext.request.contextPath}/image/phoneimg/" + edit_tableRow[2] + "_1.jpg" + "?t=" + new Date().getTime();
						doesFileExist(uploadImg_1,
							function () {
								$(".upload_inputImg_1").attr("src", uploadImg_1);
							}, function () {
								var blank = "${pageContext.request.contextPath}/image/bgr.jpg";
								$(".upload_inputImg_1").attr("src", blank);
							});


						var uploadImg_2 = "${pageContext.request.contextPath}/image/phoneimg/" + edit_tableRow[2] + "_2.jpg" + "?t=" + new Date().getTime();
						doesFileExist(uploadImg_2,
							function () {
								$(".upload_inputImg_2").attr("src", uploadImg_2);
							}, function () {
								var blank = "${pageContext.request.contextPath}/image/bgr.jpg";
								$(".upload_inputImg_2").attr("src", blank)
							});

						var uploadImg_3 = "${pageContext.request.contextPath}/image/phoneimg/" + edit_tableRow[2] + "_3.jpg" + "?t=" + new Date().getTime();
						doesFileExist(uploadImg_3,
							function () {
								$(".upload_inputImg_3").attr("src", uploadImg_3);
							}, function () {
								var blank = "${pageContext.request.contextPath}/image/bgr.jpg";
								$(".upload_inputImg_3").attr("src", blank);
							});


						var uploadImg_4 = "${pageContext.request.contextPath}/image/phoneimg/" + edit_tableRow[2] + "_4.jpg" + "?t=" + new Date().getTime();
						doesFileExist(uploadImg_4,
							function () {
								$(".upload_inputImg_4").attr("src", uploadImg_4);
							}, function () {
								var blank = "${pageContext.request.contextPath}/image/bgr.jpg";
								$(".upload_inputImg_4").attr("src", blank)
							});

						var uploadImg_5 = "${pageContext.request.contextPath}/image/phoneimg/" + edit_tableRow[2] + "_5.jpg" + "?t=" + new Date().getTime();
						doesFileExist(uploadImg_5,
							function () {
								$(".upload_inputImg_5").attr("src", uploadImg_5);
							}, function () {
								var blank = "${pageContext.request.contextPath}/image/bgr.jpg";
								$(".upload_inputImg_5").attr("src", blank)
							});


						var selectedCat = edit_tableRow[1];
						fillCategory("edit_selectCategory");
						$("#edit_selectCategory option").each(function () {
							if (selectedCat === $(this).val()) {
								catId = $(this).text();
							}
						});

						$(".edit_selectCategory").val(selectedCat);

						fillCompound(catId);
						fillProdType(catId, "edit_prodType");
						$(".edit_prodCode").val(edit_tableRow[2]);
						fillComponents("edit_components");
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
					width: 1050,
					modal: true,
					position: ['middle', 10],
					buttons: {
						OK: function () {
							if ($(".e_name").val() == "") {
								alert("Укажите название")
								return;
							}
							if ($.inArray($(".e_name").val(), autocompleteInpComponents) != -1) {
								alert("Уже есть компонент с таким именем")
								return;
							}
							componentGroup.unshift($(".e_name").val());
							var obj = new Object();
							for (var i = 0, len = componentGroup.length; i < len; i++) {
								obj['name_' + i] = componentGroup[i];
							}
							var jsonString = JSON.stringify(obj);
							$.ajax({
								url: urlDb,
								data: {
									createComponent: "createComponent",
									additiveNamber: $(".e_namber").val(),
									additiveName: jsonString.toString(),
									additiveColor: $(".e_color").val(),
									additiveInfo: $(".info").val(),
									additivePermission: $(".permission").val(),
									additiveCBox: cBoxs.toString(),
									additiveFor: $(".e_for").val(),
									additiveNotes: $(".e_notes").val(),
									additiveType: $(".e_type").val(),
								},
								type: 'POST',
								dataType: 'text',
								success: function (data) {
									e_table.row.add([
										parseInt(data, 10),
										$(".e_type").val(),
										$(".e_for").val(),
										$(".e_namber").val(),
										$(".e_name").val(),
										$(".info").val(),
										$(".permission").val(),
										$(".e_notes").val(),
										$(".e_color").val(),
										cBoxs.toString(),
									]).draw(false);
									$(".dialog_create_additive").dialog("close")

								},
								error: function (request, status, error) {
									//                                  console.log("somthing wrong");
									alert("Error: Could not back");
								}
							});
						},
						CANSEL: function () {
							$(".dialog_create_additive").dialog("close")
						}
					},
					open: function (event, ui) {
						getCBox();
						getComponentNames();
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
					width: 1050,
					modal: true,
					position: ['middle', 10],
					buttons: {
						OK: function () {
							if ($(".e_name").val() == "") {
								alert("Укажите название")
								return;
							}
							componentGroup.unshift($(".e_name").val());
							var obj = new Object();
							for (var i = 0, len = componentGroup.length; i < len; i++) {
								obj['name_' + i] = componentGroup[i];
							}
							var jsonString = JSON.stringify(obj);
							$.ajax({
								url: urlDb,
								data: {
									changeComponent: "changeComponent",
									additiveId: edit_e_tableRow[0],
									additiveNamber: $(".e_namber").val(),
									additiveName: jsonString.toString(),
									additiveColor: $(".e_color").val(),
									additiveInfo: $(".info").val(),
									additivePermission: $(".permission").val(),
									additiveCBox: cBoxs.toString(),
									additiveFor: $(".e_for").val(),
									additiveNotes: $(".e_notes").val(),
									additiveType: $(".e_type").val()


								},
								type: 'POST',
								dataType: 'text',
								success: function (data) {
									e_table.row.add([
										edit_e_tableRow[0],
										$(".e_type").val(),
										$(".e_for").val(),
										$(".e_namber").val(),
										$(".e_name").val(),
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
						edit_e_tableRow[8] == 0 ? $('.e_color option:contains("Зеленый")').prop('selected', true) : null;
						edit_e_tableRow[8] == 1 ? $('.e_color option:contains("Желтый")').prop('selected', true) : null;
						edit_e_tableRow[8] == 2 ? $('.e_color option:contains("Крассный")').prop('selected', true) : null;

						$(".e_type").val(edit_e_tableRow[1])
						$(".e_name").val(edit_e_tableRow[4]);
						$(".e_namber").val(edit_e_tableRow[3]);
						$(".e_for").val(edit_e_tableRow[2]);
						$(".e_notes").val(edit_e_tableRow[7]);
						$(".info").val(edit_e_tableRow[5]);
						$(".permission").val(edit_e_tableRow[6]);
						getCBox(edit_e_tableRow[9])
						getComponentNames();
						$.ajax({
							url: urlDb,
							data: {getComponenNames: "getComponenNames"},
							dataSrc: "additive",
							type: "POST",
							success: function (data) {
								var obj = JSON.parse(data).additive;
								for (var i = 0, len = obj.length; i < len; i++) {
									if (edit_e_tableRow[0] == obj[i][9]) {
										$(".components").append("<button class=\"varButton\">" + obj[i][3].trim() + "</button>");
										componentGroup.push(obj[i][3].trim())
									}
								}
								;
							}
						});
					},
					beforeClose: function (event, ui) {
						closeAdditiveDialog()
					}
				});
			};

			function fillProductCompound(_compoundProductID) {
				$.ajax({
					url: urlDb,
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
					if (array.trim().length != 0) {
						cBoxs = array.split(",")
					}
					for (var i = 0; i < cBoxs.length; i++) {
						cBoxs[i] = cBoxs[i].trim();
					}
				}
				//               console.log("array = " + cBoxs.sort())

				$.ajax({
					url: urlDb,
					data: {getCBox: 'getCBox'},
					type: 'POST',
					success: function (data) {
						var obj = (JSON.parse(data)).exclude;
						for (var i = 0, len = obj.length; i < len; i++) {
							var id = obj[i][0];
							var name = obj[i][1];
							var indexChecked = cBoxs.indexOf(id);
							if (indexChecked == -1) {
								$('.exclude').append("<p><input type=\"checkbox\" class=\"cBox\" id=\"" + id + "\"/>" + name + "</p>")
							} else
								$('.exclude').append("<p><input type=\"checkbox\" class=\"cBox\" id=\"" + id + "\" checked/>" + name + "</p>")
						}
						//                       console.log(cBoxs.sort())
					}
				})
			};

			function closeDialog() {
				closeImage();
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
				$(".prodType").val('');
				$(".selectCategory").val('');

				var blank = "${pageContext.request.contextPath}/image/bgr.jpg";
				$("#inputImg").attr("src", blank);
				$("#x").hide();

				if ($(".dialog_create_product").dialog("isOpen")) {
					$(".dialog_create_product").dialog("destroy");
				}
			};

			function closeEditDialog() {
				closeImage();
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
				$(".edit_prodType").val('');
				$(".edit_selectCategory").find('option').remove();
				if ($(".dialog_edit_product").dialog("isOpen")) {
					$(".dialog_edit_product").dialog("destroy");
				}

			};

			function closeAdditiveDialog() {
				componentGroup = [];
				$(".components button").remove();
				autocompleteInpComponents = [];
				cBoxs = [];
				$.ajaxSetup({cache: false});
				$(".e_for").val('');
				$(".e_notes").val('');
				$(".exclude p").remove();
				$(".e_namber").val('');
				$(".e_name").val('');
				$(".e_color").val('0');
				$(".info").val('');
				$(".permission").val('');
				$(".e_type").val('')
				$(".getInputComponent").val('');
				if ($(".dialog_create_additive").dialog("isOpen")) {
					$(".dialog_create_additive").dialog("destroy");
				}
			};

			function getComponentNames() {
				$.ajax({
					url: urlDb,
					data: {getComponenNames: "getComponenNames"},
					dataSrc: "additive",
					type: "POST",
					success: function (data) {
						var obj = JSON.parse(data).additive;
						for (var i = 0, len = obj.length; i < len; i++) {
							autocompleteInpComponents.push(obj[i][3]);
						}
					}
				});
			};

			function fillDobOgr() {
				$(".dobavki p").remove();
				$(".ogranicenija p").remove();
				componets_array_ID.sort();
				var ogrArr = [];

				function fillArray() {
					var deferreds = [];
					var i;
					for (i = 0; i < componets_array_ID.length; i++) {
						deferreds.push(
							$.ajax({
								url: urlDb,
								data: {
									getAdditiveByID: "getAdditiveByID",
									additiveID: componets_array_ID[i],
								},
								dataSrc: "component",
								type: "POST",
								success: function (data) {
									var obj = JSON.parse(data);
									if (obj.component[2] != 0 && obj.component[2] != null) {
										//                                           console.log(obj.component[2]+" ")
										$(".dobavki").append("<p>" + obj.component[1] + "</p>");
//                                            $(".dobavki").append("<p>" + obj.component[2] + " - " + obj.component[1] + "</p>");
									}
									var ogran = obj.component[6];
									var tempOgtArr = [];
									if (ogran != null) {
										if (ogran.trim().length != 0) {
											tempOgtArr = ogran.split(",")
											var i;
											for (i = 0; i < tempOgtArr.length; i++) {
												var index = ogrArr.indexOf(tempOgtArr[i])
												if (!(index > -1)) {
													ogrArr.push(tempOgtArr[i])
												}
											}
										}
									}
								}
							})
						)
					}
					return deferreds;
				}

				$.when.apply(null, fillArray()).done(function () {
					$.ajax({
						url: urlDb,
						data: {getCBox: 'getCBox'},
						type: 'POST',
						success: function (data) {
							var jsonCboxs = (JSON.parse(data)).exclude;
							for (var i = 0, len = jsonCboxs.length; i < len; i++) {
								var id = jsonCboxs[i][0];
								var name = jsonCboxs[i][1];
								var index = ogrArr.indexOf(id)
								if (index > -1) {
									$(".ogranicenija").append("<p>" + name + "</p>");
								}
							}
						}
					})
				})
			}

			function fillComponents(elId) {
				$.ajax({
					url: urlDb,
					data: {getComponenNames: "getComponenNames"},
					dataSrc: "additive",
					type: "POST",
					success: function (data) {
						var compName;
						var compId;
						var obj = JSON.parse(data).additive;
						for (var i = 0, len = obj.length; i < len; i++) {
							compName = obj[i][3];
							compId = obj[i][0];
							dictionaryAutoCompCompon[compName] = compId;
							autocompleteInpComponents.push(compName);
						}
						;
						autocompleteInpComponents.sort();
						var options = '';
						for (var i = 0; i < autocompleteInpComponents.length; i++) {
							options += '<option value="' + autocompleteInpComponents[i] + '" />'
						}
						document.getElementById(elId).innerHTML = options;
					}
				});
			}

			function fillBarcodeList() {
				listBarcode = [];
				$.ajax({
					url: urlDb,
					data: {getBarcodes: "getBarcodes"},
					dataSrc: "barcodes",
					type: "POST",
					success: function (data) {
						var obj = JSON.parse(data);
						var i;
						for (i = 0; obj.barcodes.length > i; i++) {
							listBarcode.push(obj.barcodes[i][0]);
						}
					}
				});
			}

			function dynamicUpload(_imageId) {
				imageId = _imageId;
				var formElement = $("[name='attachfileform']")[0];
				var fd = new FormData(formElement);
				var fileInput = $("[name='attachfile']")[0];
				fd.append('file', fileInput.files[0]);
				fd.append('imageId', imageId);
				if (fileInput.files[0]) {
					//                   console.log("save")
					$.ajax({
						url: '${pageContext.request.contextPath}/FileUploadServlet',
						data: fd,
						processData: false,
						contentType: false,
						type: 'POST',
						success: function (data) {
							//                           console.log(data);
						}
					});
				} else {
					if ($(".inputImg").attr('src') == "${pageContext.request.contextPath}/image/bgr.jpg") {
						doesFileExist(imageUrl, function () {
							fd.append('removeFile', imageUrl);
							$.ajax({
								url: '${pageContext.request.contextPath}/FileUploadServlet',
								data: fd,
								processData: false,
								contentType: false,
								type: 'POST',
								success: function (data) {
								}
							});
						});

					}
				}
			}

			function closeImage() {
				var blank = "${pageContext.request.contextPath}/image/bgr.jpg";
				$(".inputImg").attr("src", blank);
				$(".x").hide();
				var el = $('.image');
				el.wrap('<form>').closest('form').get(0).reset();
				el.unwrap();
			}

			function doesFileExist(urlToFile, success, error) {
				$.ajax({
					url: urlToFile,
					error: error,
					success: success,
				});
			}

			function fillProdType(catId, prod_type_) {
				var prod_type = '.' + prod_type_;
				$(prod_type).val('');
				autocompleteInpTypes = [];
				$.ajax({
					url: urlDb,
					data: {
						getProdType: "getProdType",
						setCategory: catId
					},
					dataSrc: "prodtype",
					type: "POST",
					success: function (data) {
						var typeName;
						var obj = JSON.parse(data).prodtype;
						for (var i = 0, len = obj.length; i < len; i++) {
							typeName = obj[i][0];
							autocompleteInpTypes.push(typeName);
						}
						;
						autocompleteInpTypes.sort();
						var options = '';
						for (var i = 0; i < autocompleteInpTypes.length; i++) {
							options += '<option value="' + autocompleteInpTypes[i] + '" />'
						}
						document.getElementById(prod_type_).innerHTML = options;
						//set texet and color if types present
						if (autocompleteInpTypes.length > 0) {
							$(prod_type).removeClass('placeholerNormal');
							$(prod_type).addClass('placeholerValueAvalible');
							$(prod_type).attr("placeholder", "Есть доступные типы");
						} else {
							$(prod_type).removeClass('placeholerValueAvalible');
							$(prod_type).addClass('placeholerNormal');
							$(prod_type).attr("placeholder", "Тип");
						}
					}
				});

			}

			function fillCompound(catId) {
				varButton = [];
				componets_array_ID = [];
				$(".compound button").remove();
				$(".components button").remove();
				$(".dobavki p").remove();
				$(".ogranicenija p").remove();
				$.ajax({
					url: urlDb,
					data: {
						getCompound: "getCompound",
						catId: catId
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

			function fillCategory(elementId) {
				categories = [];
				$.ajax({
					url: urlDb,
					data: {
						getCategory: "getCategory",
					},
					type: 'POST',
					dataType: 'json',
					async: false,
					success: function (data) {
						var options = '';
						$.each(data, function (index, element) {
							options += '<option value="' + element[1] + '"/>' + element[0] + '</option>'
							categories.push(element[1])
						})
						document.getElementById(elementId).innerHTML = options;
					},
					error: function (request, status, error) {
						alert("Error: Could not back");
					}
				});
			}

			function fillProdGroupByDate(date) {
				document.getElementsByClassName("catTab")[0].innerHTML = "";
				$.ajax({
					url: urlDb,
					data: {
						getProdGroupByDate: "getProdGroupByDate",
						date: date,
					},
					type: 'POST',
					success: function (data) {
						var obj = JSON.parse(data).prodGroupByDate;
						$('.catTab').append("<table class=\"main_section\" style=\"width: 100%\" border=\"0\" ></table>")
						for (var i = 0; obj.length > i; i++) {
							$('.main_section').append('<tr><td>' + obj[i][0] + '</td><td>' + obj[i][1] + '</td></tr>');
						}
					}
				})
			}
		});

	</script>
</head>
<body>
<table align="center" style="width:100%;">
	<tbody>
	<tr>
		<td class="menuItem"></td>
		<td style="text-align: right;">
			<text class="adminButton">${username}&nbsp</text>
			<a href="${pageContext.request.contextPath}/LogoutServlet">
				<button class="button">Выход</button>
			</a></td>
	</tr>
	</tbody>
</table>
<hr/>
<div id="menu" style="width:100%; height:400px;float:left">
</div>
</body>
</html>