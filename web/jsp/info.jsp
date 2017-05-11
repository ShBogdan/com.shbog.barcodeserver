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
		var urlDb = "${pageContext.request.contextPath}/DbInterface";
		$(document).on('click', '#getProducts', function () {
			document.getElementsByClassName("catTab")[0].innerHTML = "";
			$("#startDate").datepicker('getDate', '+1d');
			var startDate = $("#startDate").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			var endDate = $("#endDate").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			$.ajax({
				url: urlDb,
				data: {
					getProdGroupByDate: "getProdGroupByDate",
					startDate: startDate,
					endDate: endDate
				},
				type: 'POST',
				success: function (data) {
					var obj = JSON.parse(data).prodGroupByDate;
					$('.catTab').append("<table class=\"main_section\" style=\"width: 100%\" border=\"0\" ></table>")
					for (var i = 0; obj.length > i; i++) {
						$('.main_section').append('<tr><td>' + obj[i][0] + '</td><td>' + obj[i][2] + '</td></tr>');
					}
				}
			})
		});
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
			<button id="getProducts">Выбрать</button>
		</td>
	</tr>
</table>
<div class="catTab" style="width: 50%">
</div>
</body>
</html>

