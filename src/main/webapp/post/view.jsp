<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // 요청된 게시글 ID 가져오기
    String postId = request.getParameter("id");

    if (postId == null || postId.trim().isEmpty()) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String jdbcUrl = "jdbc:mysql://localhost:3309/blog";
    String dbUser = "root";
    String dbPass = "1234";
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM posts WHERE id = ?");
    stmt.setInt(1, Integer.parseInt(postId));
    ResultSet rs = stmt.executeQuery();

    if (!rs.next()) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String title = rs.getString("title");
    String content = rs.getString("content");
    String author = rs.getString("author");
    String createdAt = rs.getString("created_at");

    rs.close();
    stmt.close();
    conn.close();
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= title %></title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <div class="post-container">
        <h1><%= title %></h1>
        <p><strong>작성자:</strong> <%= author %></p>
        <p><strong>작성일:</strong> <%= createdAt %></p>
        <hr>
        <p><%= content.replace("\n", "<br>") %></p>
        
        <button onclick="location.href='../index.jsp'" class="btn">뒤로 가기</button>
    </div>
</body>
</html>
