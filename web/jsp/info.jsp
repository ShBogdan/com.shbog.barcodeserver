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
</head>
<body>
<h1>Info</h1>
<script>
    var fd;
    var fileInput;
    function dynamicUpload(){
        fd = new FormData();
        fileInput = $("#attachfile")[0];
        fd.append('file', fileInput.files[0] );
        fd.append('myname', 99 ); //how to read value?

        $.ajax({
            url: '../FileUploadServlet',
            data: fd,
            processData: false,
            contentType: false,
            type: 'POST',
            success: function(data){
                console.log(data);
            }
        });
    }
</script>
<form enctype="multipart/form-data" method="post" action="" id="attachfileform" name="attachfileform" >
    <input type="file" id="attachfile" class="regi_textbox"/>
    <input type="button" class="update_but"  value="Upload File" onclick="dynamicUpload()"/>
</form>


<%--<form method="POST" action="../FileUploadServlet" enctype="multipart/form-data" class="myform" name = "myform">--%>
    <%--<input type="file" name="file"/> <br/>--%>
    <%--<button class="upload">go</button>--%>
    <%--&lt;%&ndash;<input type="submit" value="Upload" />&ndash;%&gt;--%>
<%--</form>--%>
</body>
</html>

