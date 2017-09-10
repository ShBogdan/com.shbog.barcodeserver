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
	<script>
		$(function () {
			$("#startDate").datepicker({dateFormat: "yy-mm-dd"});
			$("#endDate").datepicker({dateFormat: "yy-mm-dd"});
		});
	</script>
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
	</style>
</head>
<body>
<table>
	<tr>
		<td><p>Начальная дата: <input type="text" id="startDate"></p></td>
		<td><p>Конечная дата: <input type="text" id="endDate"></p></td>
		<td>
			<p>Создатель: <input class="selectCreator" type="text" list="selectCreator"/>
				<datalist id="selectCreator"></datalist>
			</p>
		</td>
		<td>
			<button id="getProdGroupByDate" class="actionButton">Выбрать</button>
		</td>
	</tr>
</table>
<div class="catTab" style="width: 50%">

</div>
<table id="cat_info_table" class="display" cellspacing="0" width="100%">
	<thead>
	<tr>
		<th>id</th>
		<th>Категория</th>
		<th>Дата</th>
		<th>Количество</th>
		<th></th>
	</tr>
	</thead>
	<tfoot>
	<tr>
		<th>id</th>
		<th class="searchable">Категория</th>
		<th class="searchable">Дата</th>
		<th style="text-align:left">Total:</th>
		<th></th>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</table>
</body>
</html>

