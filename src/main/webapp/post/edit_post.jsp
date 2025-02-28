<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 수정할 게시글 ID 가져오기
    String postId = request.getParameter("id");

    if (postId == null || postId.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    // DB 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");

    // 게시글 정보 가져오기
    PreparedStatement pstmt = conn.prepareStatement("SELECT title, content FROM posts WHERE id = ?");
    pstmt.setInt(1, Integer.parseInt(postId));
    ResultSet rs = pstmt.executeQuery();

    String title = "";
    String content = "";

    if (rs.next()) {
        title = rs.getString("title");  // 기존 제목
        content = rs.getString("content");  // 기존 내용
    } else {
        response.sendRedirect("index.jsp"); // 게시글이 없을 경우 홈으로 이동
        return;
    }

    rs.close();
    pstmt.close();
    conn.close();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <div class="write-container">
        <h2>게시글 수정</h2>
        <form action="update_post_process.jsp" method="post">
            <!-- 수정할 게시글 ID (숨김 필드) -->
            <input type="hidden" name="postId" value="<%= postId %>">

            <!-- 기존 제목 입력 -->
            <input type="text" name="title" placeholder="제목" value="<%= title %>" required><br>

            <!-- 기존 내용 입력 -->
            <textarea name="content" placeholder="내용을 입력하세요" required><%= content %></textarea><br>

            <!-- 수정 버튼 -->
            <button type="submit">수정 완료</button>

            <!-- 뒤로 가기 버튼 -->
            <button type="button" class="back-btn" onclick="location.href='view.jsp?id=<%= postId %>'">뒤로 가기</button>
        </form>
    </div>
</body>
</html>
