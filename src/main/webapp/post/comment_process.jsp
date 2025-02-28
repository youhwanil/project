<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 여부 확인
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    // 입력값 가져오기
    int postId = Integer.parseInt(request.getParameter("post_id"));
    String content = request.getParameter("content");

    // DB 연결
    String jdbcUrl = "jdbc:mysql://localhost:3309/blog";
    String dbUser = "root";
    String dbPass = "1234";
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);

    // 댓글 저장
    PreparedStatement pstmt = conn.prepareStatement("INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)");
    pstmt.setInt(1, postId);
    pstmt.setInt(2, userId);
    pstmt.setString(3, content);
    pstmt.executeUpdate();

    pstmt.close();
    conn.close();

    response.sendRedirect("view.jsp?id=" + postId);
%>
