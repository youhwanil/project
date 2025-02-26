<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String id = request.getParameter("userid");
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM posts WHERE id = ?");
    pstmt.setInt(1, Integer.parseInt(id));
    ResultSet rs = pstmt.executeQuery();
    if (rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../css/style.css">
    <title><%= rs.getString("title") %></title>
</head>
<body>
    <h2><%= rs.getString("title") %></h2>
    <p><%= rs.getString("content") %></p>
    <p>작성자: <%= rs.getString("author") %> | 날짜: <%= rs.getString("created_at") %></p>
</body>
</html>
<%
    }
    rs.close();
    pstmt.close();
    conn.close();
%>
