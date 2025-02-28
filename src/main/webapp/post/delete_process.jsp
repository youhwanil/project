<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 여부 확인
    Integer sessionUserId = (Integer) session.getAttribute("userId");
    if (sessionUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); history.back();</script>");
        return;
    }

    // 게시글 ID 가져오기
    int postId = Integer.parseInt(request.getParameter("id"));

    // DB 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234")) {
        
        // 게시글 작성자 확인
        PreparedStatement checkStmt = conn.prepareStatement("SELECT userid FROM posts WHERE id = ?");
        checkStmt.setInt(1, postId);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            int postOwnerId = rs.getInt("userid");
            if (sessionUserId != postOwnerId) {
                out.println("<script>alert('게시글 삭제 권한이 없습니다.'); history.back();</script>");
                return;
            }

            // 게시글 삭제 (댓글도 함께 삭제)
            PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM posts WHERE id = ?");
            deleteStmt.setInt(1, postId);
            deleteStmt.executeUpdate();
            
            response.sendRedirect("../index.jsp");
        } else {
            out.println("<script>alert('게시글을 찾을 수 없습니다.'); history.back();</script>");
        }
    }
%>
