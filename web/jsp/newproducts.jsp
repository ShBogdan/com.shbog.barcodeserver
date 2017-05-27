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
		.warning {
			background-color: #F99 !important;
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
			/*border: 1px solid #90d93f;*/
			/*color: #222222;*/
		}

		.ui-widget-header {
			background: #e7e7e7;
			border: 1px solid #bcbcbc;
			color: black;
			font-weight: bold;
		}
	</style>
	<script>
		$(function () {
			$("#startDate").datepicker({dateFormat: "yy-mm-dd"});
			$("#endDate").datepicker({dateFormat: "yy-mm-dd"});
		});
	</script>
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
		console.log(file)
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
	function swipe(imgId) {
		console.log(imgId);
		var largeImage = document.getElementById(imgId);
		var url = largeImage.getAttribute('src');
		window.open(url, 'Image', 'width=largeImage.stylewidth,height=largeImage.style.height,resizable=1');
	}
</script>
<table>
	<tr>
		<td><p>Начальная дата: <input type="text" id="startDate"></p></td>
		<td><p>Конечная дата: <input type="text" id="endDate"></p></td>
		<td>
			<button id="getNewProductsByDate" class="actionButton">Выбрать</button>
		</td>
	</tr>
</table>
<div class="temp">
	<button id="button" class="remove actionButton">Удалить выделенное</button>
</div>
<hr>
<table id="newprod_table" class="display" cellspacing="0" width="100%">
	<thead>
	<tr>
		<th>id</th>
		<th>Категория</th>
		<th>Штрихкод</th>
		<th></th>
		<th></th>
	</tr>
	</thead>
	<tfoot>
	<tr>
		<th>id</th>
		<th class="searchable">Категория</th>
		<th class="searchable">Штрихкод</th>
		<th></th>
		<th></th>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</table>

<div class="dialog_edit_product" title="Создать продукт" hidden>
	<table style="width: 1000px;" border="0" cellspacing="2" cellpadding="2" align="center">
		<tbody>
		<td align="center" width="35%" valign="top">
			<table style="width: 100%;" border="0" cellspacing="0" cellpadding="5" align="center">
				<tbody>
				<tr>
					<td>
						<div><img class="upload_inputImg_1" id="largeImage_1"
								  style="height:100px; width:auto; max-width:150px;" onClick="swipe(this.id);"/></div>
					</td>
					<td>
						<div><img class="upload_inputImg_2" id="largeImage_2"
								  style="height:100px; width:auto; max-width:150px;" onClick="swipe(this.id);"/></div>
					</td>
					<td>
						<div><img class="upload_inputImg_3" id="largeImage_3"
								  style="height:100px; width:auto; max-width:150px;" onClick="swipe(this.id);"/></div>
					</td>
				</tr>
				<tr></tr>
				<td>
					<div><img class="upload_inputImg_4" id="largeImage_4"
							  style="height:100px; width:auto; max-width:150px;" onClick="swipe(this.id);"/></div>
				</td>
				<td>
					<div><img class="upload_inputImg_5" id="largeImage_5"
							  style="height:100px; width:auto; max-width:150px;" onClick="swipe(this.id);"/></div>
				</td>
				</tr>
				</tbody>
			</table>
		</td>
		<td align="center" width="25%" valign="top">
			<form action="" enctype="multipart/form-data" method="post" name="attachfileform">
				<table>
					<tbody>
					<tr>
						<td><img class="inputImg" id="edit_inputImg" style="max-width: 100%; height: 130px;" alt=""/>
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
					<td><input class="edit_prodCode" style="width: 80%;" maxlength="18" type="text"
							   placeholder="штрих-код"/>
						<button class="edit_checkBarcode actionButton" style="float: right;">&#x27f3;</button>
					</td>
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
					<td><input class="edit_prodType" style="width: 100%;" maxlength="155" type="text" placeholder="Тип"
							   list="edit_prodType"/>
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
					<button class="addComponentEdit actionButton" style="display:table-cell; width:36%">Добавить</button>
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