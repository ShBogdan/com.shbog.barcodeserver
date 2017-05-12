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
</head>
<body>
<table>
	<tr>
		<td><p>Начальная дата: <input type="text" id="startDate"></p></td>
		<td><p>Конечная дата: <input type="text" id="endDate"></p></td>
		<td>
			<button id="getProductsByDate">Выбрать</button>
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
		<th class="searchable">Количество</th>
		<th></th>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</table>
</body>
</html>

