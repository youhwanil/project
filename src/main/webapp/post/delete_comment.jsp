<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    Integer sessionUserId = (Integer) session.getAttribute("userId");
    if (sessionUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); history.back();</script>");
        return;
    }

    int commentId = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
         PreparedStatement pstmt = conn.prepareStatement("DELETE FROM comments WHERE id = ? AND user_id = ?")) {
        pstmt.setInt(1, commentId);
        pstmt.setInt(2, sessionUserId);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("view.jsp?id=" + request.getParameter("post_id"));
        } else {
            out.println("<script>alert('댓글 삭제 권한이 없습니다.'); history.back();</script>");
        }
    }
%>
