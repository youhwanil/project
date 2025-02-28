<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    int commentId = Integer.parseInt(request.getParameter("commentId"));
    int postId = Integer.parseInt(request.getParameter("postId"));
    String sessionUserId = (String) session.getAttribute("userId");

    if (sessionUserId == null) {
        response.sendRedirect("../user/login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
    PreparedStatement stmt = conn.prepareStatement("DELETE FROM comments WHERE id = ? AND userid = ?");
    stmt.setInt(1, commentId);
    stmt.setInt(2, Integer.parseInt(sessionUserId));
    stmt.executeUpdate();
    conn.close();

    response.sendRedirect("view.jsp?id=" + postId);
%>
