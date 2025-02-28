<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 확인
    Integer sessionUserId = (Integer) session.getAttribute("userId");
    if (sessionUserId == null) {
%>
        <script>
            alert("로그인이 필요합니다.");
            history.back();
        </script>
<%
        return;
    }

    // 댓글 ID 가져오기
    String commentIdStr = request.getParameter("id");
    if (commentIdStr == null || commentIdStr.isEmpty()) {
%>
        <script>
            alert("잘못된 요청입니다.");
            history.back();
        </script>
<%
        return;
    }

    int commentId = Integer.parseInt(commentIdStr);

    // DB 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");

    // 댓글 조회 (현재 로그인한 사용자만 수정 가능하도록)
    PreparedStatement pstmt = conn.prepareStatement(
        "SELECT post_id, content, user_id FROM comments WHERE id = ?"
    );
    pstmt.setInt(1, commentId);
    ResultSet rs = pstmt.executeQuery();

    if (!rs.next()) {
%>
        <script>
            alert("존재하지 않는 댓글입니다.");
            history.back();
        </script>
<%
        return;
    }

    int commentUserId = rs.getInt("user_id");
    int postId = rs.getInt("post_id");
    String content = rs.getString("content");

    if (sessionUserId != commentUserId) {
%>
        <script>
            alert("본인의 댓글만 수정할 수 있습니다.");
            history.back();
        </script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>댓글 수정</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2>댓글 수정</h2>
        <form action="update_comment_process.jsp" method="post">
            <input type="hidden" name="id" value="<%= commentId %>">
            <input type="hidden" name="post_id" value="<%= postId %>">
            <textarea name="content" required><%= content %></textarea>
            <button type="submit">수정</button>
        </form>
        <button onclick="history.back();" class="back-btn">취소</button>
    </div>
</body>
</html>

<%
    rs.close();
    pstmt.close();
    conn.close();
%>
