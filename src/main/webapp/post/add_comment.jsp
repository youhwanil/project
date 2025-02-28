<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String content = request.getParameter("content");
    int postId = Integer.parseInt(request.getParameter("postid"));
    String sessionUserId = (String) session.getAttribute("userId");

    if (sessionUserId == null) {
        response.sendRedirect("../user/login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
    PreparedStatement stmt = conn.prepareStatement("INSERT INTO comments (postid, userid, content) VALUES (?, ?, ?)");
    stmt.setInt(1, postId);
    stmt.setInt(2, Integer.parseInt(sessionUserId));
    stmt.setString(3, content);
    stmt.executeUpdate();
    conn.close();

    response.sendRedirect("view.jsp?id=" + postId);
%>
