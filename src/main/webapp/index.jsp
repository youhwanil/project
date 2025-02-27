<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String jdbcUrl = "jdbc:mysql://localhost:3309/blog";
    String dbUser = "root";
    String dbPass = "1234";
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT id, title, author, created_at FROM posts ORDER BY created_at DESC");
%>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <title>Mini Blog</title>
</head>
<body>
    <h1>Mini Blog</h1>
    <nav>
        <a href="index.jsp">홈</a>
        <% if(session.getAttribute("userId") == null) { %>
            <a href="login/login.jsp">로그인</a>
            <a href="login/register.jsp">회원가입</a>
        <% } else { %>
            <a href="post/write.jsp">글쓰기</a>
            <a href="user/mypage.jsp">마이페이지</a>
            <a href="login/logout.jsp">로그아웃</a>
        <% } %>
    </nav>
    
    <h2>최신 글</h2>
    <ul>
        <% while(rs.next()) { %>
            <li>
                <a href="post/view.jsp?id=<%= rs.getInt("id") %>"><%= rs.getString("title") %></a>
                <span> - <%= rs.getString("author") %> (<%= rs.getString("created_at") %>)</span>
            </li>
        <% } %>
    </ul>

<%
    rs.close();
    stmt.close();
    conn.close();
%>

</body>
</html>
