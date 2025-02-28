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

    // 수정할 게시글 ID 가져오기
    String postIdStr = request.getParameter("id");
    if (postIdStr == null || postIdStr.isEmpty()) {
%>
        <script>
            alert("잘못된 요청입니다.");
            history.back();
        </script>
<%
        return;
    }

    int postId = Integer.parseInt(postIdStr);

    // DB 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");

    // 게시글 정보 가져오기
    PreparedStatement pstmt = conn.prepareStatement(
        "SELECT title, content, userid FROM posts WHERE id = ?"
    );
    pstmt.setInt(1, postId);
    ResultSet rs = pstmt.executeQuery();

    if (!rs.next()) {
%>
        <script>
            alert("존재하지 않는 게시글입니다.");
            history.back();
        </script>
<%
        return;
    }

    int postUserId = rs.getInt("userid");
    String title = rs.getString("title");
    String content = rs.getString("content");

    // 게시글 작성자만 수정 가능
    if (sessionUserId != postUserId) {
%>
        <script>
            alert("본인의 게시글만 수정할 수 있습니다.");
            history.back();
        </script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>게시글 수정</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2>게시글 수정</h2>
        <form action="update_post_process.jsp" method="post">
            <input type="hidden" name="id" value="<%= postId %>">
            <input type="text" name="title" value="<%= title %>" required>
            <textarea name="content" required><%= content %></textarea>
            <button type="submit">수정 완료</button>
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
