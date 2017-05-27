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
		.custom-selectCategory {
			position: relative;
			display: inline-block;
		}

		.custom-selectCategory-toggle {
			position: absolute;
			top: 0;
			bottom: 0;
			margin-left: -1px;
			padding: 0;
		}

		.custom-selectCategory-input {
			margin: 0;
			padding: 5px 10px;
		}

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
	<button id="button" class="remove actionButton">Удалить выделенное</button>
	<button id="button_create_product" class="button_create_product actionButton">Добавить продукт</button>
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
								<input type="button" class="loadFileXml actionButton" value="Загрузить фото"
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
						<td><input class="prodCode" style="width: 80%;" maxlength="18" type="text"
								   placeholder="штрих-код"/>
							<button class="checkBarcode actionButton" style="float: right;">&#x27f3;</button>
						</td>
					</tr>
					<tr>
						<td>
							<input class="selectCategory" style="width: 100%;" maxlength="155" type="text"
								   placeholder="Категория"
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
					<button class="addComponent actionButton" style="display:table-cell; width:36%">Добавить</button>
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
								<input type="button" class="loadFileXml actionButton" value="Загрузить фото"
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
						<td><input class="edit_prodCode" style="width: 80%;" maxlength="18" type="text"
								   placeholder="штрих-код"/>
							<button class="edit_checkBarcode actionButton" style="float: right;">&#x27f3;</button>
						</td>
					</tr>
					<tr>
						<td>
							<input class="edit_selectCategory" style="width: 100%;" maxlength="155" type="text"
								   placeholder="Категория"
								   list="edit_selectCategory"/>
							<datalist id="edit_selectCategory"></datalist>
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
					<button class="addComponentEdit actionButton" style="display:table-cell; width:36%">Добавить
					</button>
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