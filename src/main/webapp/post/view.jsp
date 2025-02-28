<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 현재 로그인한 사용자 정보
    Integer sessionUserId = (Integer) session.getAttribute("userId");
    String sessionUserNickname = (String) session.getAttribute("nickname");

    // 요청된 게시글 ID 가져오기
    String postIdStr = request.getParameter("id");

    if (postIdStr == null || postIdStr.isEmpty()) {
%>
        <script>
            alert("잘못된 접근입니다.");
            history.back();
        </script>
<%
        return;
    }

    int postId = Integer.parseInt(postIdStr);

    // DB 연결 및 게시글 조회
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");

    PreparedStatement postStmt = conn.prepareStatement(
        "SELECT posts.id, posts.title, posts.content, users.nickname, posts.created_at, posts.userid FROM posts " +
        "JOIN users ON posts.userid = users.id WHERE posts.id = ?"
    );
    postStmt.setInt(1, postId);
    ResultSet postRs = postStmt.executeQuery();

    if (!postRs.next()) {
%>
        <script>
            alert("존재하지 않는 게시글입니다.");
            history.back();
        </script>
<%
        return;
    }

    String title = postRs.getString("title");
    String content = postRs.getString("content");
    String author = postRs.getString("nickname");
    int authorId = postRs.getInt("userid");
    String createdAt = postRs.getString("created_at");
%>

<!DOCTYPE html>
<html>
<head>
    <title>게시글 보기</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2><%= title %></h2>
        <p><strong>작성자:</strong> <%= author %></p>
        <p><strong>작성일:</strong> <%= createdAt %></p>
        <p><%= content %></p>

        <% if (sessionUserId != null && sessionUserId == authorId) { %>
            <a href="edit_post.jsp?id=<%= postId %>">수정</a>
            <a href="delete_process.jsp?id=<%= postId %>" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        <% } %>

        <hr>
        <h3>댓글</h3>

        <!-- 댓글 목록 -->
        <ul>
        <%
            PreparedStatement commentStmt = conn.prepareStatement(
                "SELECT comments.id, comments.content, users.nickname, comments.created_at, comments.user_id " +
                "FROM comments JOIN users ON comments.user_id = users.id WHERE comments.post_id = ? ORDER BY comments.created_at DESC"
            );
            commentStmt.setInt(1, postId);
            ResultSet commentRs = commentStmt.executeQuery();

            while (commentRs.next()) {
                int commentId = commentRs.getInt("id");
                String commentContent = commentRs.getString("content");
                String commentAuthor = commentRs.getString("nickname");
                int commentAuthorId = commentRs.getInt("user_id");
                String commentCreatedAt = commentRs.getString("created_at");
        %>
            <li>
                <strong><%= commentAuthor %></strong> (<%= commentCreatedAt %>)<br>
                <%= commentContent %>
                
                <% if (sessionUserId != null && sessionUserId == commentAuthorId) { %>
                    <a href="edit_comment.jsp?id=<%= commentId %>">수정</a>
                    <a href="delete_comment_process.jsp?id=<%= commentId %>" onclick="return confirm('댓글을 삭제하시겠습니까?');">삭제</a>
                <% } %>
            </li>
        <%
            }
            commentRs.close();
            commentStmt.close();
        %>
        </ul>

        <hr>
        <!-- 댓글 작성 폼 -->
        <% if (sessionUserId != null) { %>
            <form action="comment_process.jsp" method="post">
                <input type="hidden" name="post_id" value="<%= postId %>">
                <textarea name="content" required></textarea>
                <button type="submit">댓글 작성</button>
            </form>
        <% } else { %>
            <p>댓글을 작성하려면 <a href="../login/login.jsp">로그인</a>하세요.</p>
        <% } %>

        <br>
        <button onclick="location.href='../index.jsp'" class="back-btn">뒤로 가기</button>
    </div>
</body>
</html>

<%
    postRs.close();
    postStmt.close();
    conn.close();
%>
