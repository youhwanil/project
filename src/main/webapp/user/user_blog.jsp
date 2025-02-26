<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String searchUser = request.getParameter("searchUser");

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM posts WHERE userid='" + searchUser + "'");
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= searchUser %>의 블로그</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <h2><%= searchUser %>의 블로그</h2>
    <ul>
        <% while (rs.next()) { %>
            <li><a href="post.jsp?id=<%= rs.getInt("id") %>"><%= rs.getString("title") %></a></li>
        <% } %>
    </ul>
</body>
</html>
