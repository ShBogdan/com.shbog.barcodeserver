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

<div class="temp">
	<button id="button" class="remove actionButton">Удалить выделенное</button>
	<button id="button_create_type" class="button_create_type actionButton">Добавить тип</button>
</div>
<hr>
<table id="type_table" class="display" cellspacing="0" width="100%">
	<thead>
	<tr>
		<th>id</th>
		<th>Категория</th>
		<th>Тип</th>
		<th></th>
		<th></th>
	</tr>
	</thead>
	<tfoot>
	<tr>
		<th>id</th>
		<th class="searchable">Категория</th>
		<th class="searchable">Тип</th>
		<th></th>
		<th></th>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</table>

<div class="dialog_create_type" title="Добавить тип" hidden>
	<table style="width: 550px;" border="0" cellspacing="2" cellpadding="2" align="center">
		<tbody>
		<tr>
			<td>
				<select class="selectCategoryForType" style="width: 100%">
				</select>
			</td>
		</tr>
		<tr>
			<td><input class="typeName" placeholder="название типа" type="text" style="width: 100%"></td>
		</tr>
		</tbody>
	</table>
</div>
<div class="dialog_edit_type " title="Изменить тип" hidden>
	<table style="width: 550px;" border="0" cellspacing="2" cellpadding="2" align="center">
		<tbody>
		<tr>
			<td>
				<select name="editType" class="edit_selectCategoryForType" style="width: 100%">
				</select>
			</td>
		</tr>
		<tr>
			<td><input class="edit_typeName" placeholder="название типа" type="text" style="width: 100%"></td>
		</tr>
		</tbody>
	</table>
</div>
</body>
</html>