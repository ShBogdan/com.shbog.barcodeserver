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

		.ui-widget-content {
			background: #F9F9F9;

		}

		.ui-widget-header {
			background: #e7e7e7;
			border: 1px solid #bcbcbc;
			color: black;
			font-weight: bold;
		}

		tfoot {
			display: table-header-group;
		}

	</style>
</head>

<body class="additive">
<button id="button" class="remove actionButton">Удалить выделенное</button>
<button id="button_create_additive" class="button_create_additive actionButton">Добавить добавку</button>
<hr>
<table id="additive_table" class="display" cellspacing="0" width="100%">
	<thead>
	<tr>
		<th>id</th>
		<th>Тип добавки</th>
		<th>Назначение</th>
		<th>Номер</th>
		<th>Название</th>
		<th>Описание</th>
		<th>Запрет</th>
		<th>Примечание</th>
		<th>Цвет</th>
		<th>cbox</th>
		<th></th>
		<th></th>
	</tr>
	</thead>
	<tfoot>
	<tr>
		<th>id</th>
		<th class="searchable">Тип добавки</th>
		<th class="searchable">Назначени</th>
		<th class="searchable">Номер</th>
		<th class="searchable">Название</th>
		<th class="searchable">Описание</th>
		<th class="searchable">Запрет</th>
		<th class="searchable">Примечание</th>
		<th></th>
		<th></th>
		<th></th>
		<th></th>
	</tr>
	</tfoot>
	<tbody>
	</tbody>
</table>

<div class="dialog_create_additive" hidden title="Создать добавку">
	<table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 940px">
		<tbody>
		<tr>
			<td align="center" width="50%">
			</td>
			<td align="center" width="50%"><b>Запрет/разрешение</b>
				<hr/>
			</td>
		</tr>
		<tr>
			<td align="center" width="50%" valign="top">
				<input class="e_namber" placeholder="Номер" style="width: 100%" type="text"/>
				<input class="e_name" placeholder="Название" style="width: 100%" type="text"/>
				<input class="e_for" placeholder="Назначение" style="width: 100%" type="text"/>
				<input class="e_type" placeholder="Тип добавки" style="width: 100%" type="text"/>
				<select class="e_color" style="width: 100%">
					<option value="0">Зеленый</option>
					<option value="1">Желтый</option>
					<option value="2">Крассный</option>
				</select>
			</td>
			<td align="center" width="50%">
				<textarea class="permission" cols="40" rows="7" style="width: 460px"></textarea>
			</td>
		</tr>
		</tbody>
	</table>

	<table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 940px">
		<tbody>
		<tr>
			<td align="center" width="50%"><b>Описание</b>

				<hr/>
			</td>
			<td align="center" width="50%"><b>Примечание</b>
				<hr/>
			</td>
		</tr>
		<tr>
			<td valign="top"><textarea class="info" cols="40" rows="10" style="width: 460px"></textarea></td>
			<td valign="top"><textarea class="e_notes" cols="40" rows="10" style="width: 460px"></textarea></td>
		</tr>
		</tbody>
	</table>

	<table align="center" border="0" cellpadding="2" cellspacing="2" style="width: 940px">
		<tbody>
		<tr>
			<td align="center" width="50%"><b>Другие Названия</b>

				<hr/>
			</td>
			<td align="center" width="50%"><b>Ограничение</b>
				<hr/>
			</td>
		</tr>
		<tr>
			<td class="components" height="300px" valign="top">&nbsp;</td>
			<td class="exclude" height="300px" valign="top">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" width="50%">
				<div align="center" class="divInput"><input class="getInputComponent" list="components"
															placeholder="Новый компонент"
															style="display:table-cell; width:60%" type="text"/>
					<button class="addComponent actionButton" style="display:table-cell; width:36%">Добавить</button>
					<datalist id="components"></datalist>
				</div>
			</td>
		</tr>
		</tbody>
	</table>
</div>
</body>
</html>