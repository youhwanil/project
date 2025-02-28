<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 입력값 가져오기
    String postId = request.getParameter("postId");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    if (postId == null || postId.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    // DB 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");

    // 게시글 수정 쿼리 실행
    PreparedStatement pstmt = conn.prepareStatement("UPDATE posts SET title = ?, content = ? WHERE id = ?");
    pstmt.setString(1, title);
    pstmt.setString(2, content);
    pstmt.setInt(3, Integer.parseInt(postId));
    pstmt.executeUpdate();

    pstmt.close();
    conn.close();

    // 수정 후 게시글 상세 페이지로 이동
    response.sendRedirect("view.jsp?id=" + postId);
%>
