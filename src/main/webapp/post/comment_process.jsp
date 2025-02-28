<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인된 사용자 확인
    Integer userIdObj = (Integer) session.getAttribute("userId");
    if (userIdObj == null) {
%>
        <script>
            alert("로그인이 필요합니다.");
            history.back();
        </script>
<%
        return;
    }
    
    // post_id 가져오기 & 검증
    String postIdStr = request.getParameter("post_id");
    if (postIdStr == null || postIdStr.isEmpty()) {
%>
        <script>
            alert("잘못된 요청입니다. (post_id 없음)");
            history.back();
        </script>
<%
        return;
    }
    
    int postId = Integer.parseInt(postIdStr);
    String content = request.getParameter("content");

    if (content == null || content.trim().isEmpty()) {
%>
        <script>
            alert("댓글 내용을 입력하세요.");
            history.back();
        </script>
<%
        return;
    }

    // DB 연결 및 댓글 저장
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");

        PreparedStatement pstmt = conn.prepareStatement(
            "INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)");
        pstmt.setInt(1, postId);
        pstmt.setInt(2, userIdObj);
        pstmt.setString(3, content);
        pstmt.executeUpdate();

        response.sendRedirect("view.jsp?id=" + postId);
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert("댓글 작성 중 오류 발생!");
            history.back();
        </script>
<%
    }
%>
