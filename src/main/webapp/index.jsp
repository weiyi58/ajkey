<%--
  Created by IntelliJ IDEA.
  User: 闫
  Date: 2020/12/30
  Time: 18:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <title>Title</title>
    <base href="<%=basePath%>" />
</head>
<body>

<table>
    <tr>
        <td><a href="WEB-INF/jsp/index.jsp">注册</a> </td>
    </tr>
    <tr>
        <td>浏览1</td>
    </tr>
</table>
</body>
</html>
