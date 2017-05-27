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

		tfoot {
			display: table-header-group;
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

		.placeholder_addExclude, .placeholder_renameExclude {
			display: inline-block;
			width: 100%;
			margin-bottom: 10px;
		}

	</style>
</head>
<body>
<button id="button" class="remove actionButton">Удалить выделенное</button>
<button id="button_create_exclude" class="button_create_exclude actionButton">Добавить ограничение</button>
<hr>
<table id="exclude_table" class="display" cellspacing="0" width="100%">
	<thead>
	<tr>
		<th>id</th>
		<th>Название</th>
		<th></th>
		<th></th>
	</tr>
	</thead>
	<tfoot>
	<tr>
		<th>id</th>
		<th class="searchable">Название</th>
		<th></th>
		<th></th>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</table>
<div class="addExclude" title="Добавить" hidden><input class="placeholder_addExclude" placeholder="название ограничение"
													   type="text"></div>
<div class="renameExclude" title="Переименовать" hidden><input class="placeholder_renameExclude"
															   placeholder="название ограничение" type="text"></div>
</body>
</html>
