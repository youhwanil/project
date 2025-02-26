<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userId = (String) session.getAttribute("userId");
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM users WHERE userid = ?");
    pstmt.setString(1, userId);
    ResultSet rs = pstmt.executeQuery();
    if (rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css">
    <title>마이페이지</title>
</head>
<body>
    <h2>마이페이지</h2>
    <p>아이디: <%= rs.getString("userid") %></p>
    <a href="logout.jsp">로그아웃</a>
</body>
</html>
<%
    }
    rs.close();
    pstmt.close();
    conn.close();
%>
