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

    // 게시글 정보 가져오기
    String postIdStr = request.getParameter("id");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    if (postIdStr == null || title == null || content == null || title.trim().isEmpty() || content.trim().isEmpty()) {
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

    // 게시글 작성자 확인
    PreparedStatement checkStmt = conn.prepareStatement("SELECT userid FROM posts WHERE id = ?");
    checkStmt.setInt(1, postId);
    ResultSet rs = checkStmt.executeQuery();

    if (!rs.next() || rs.getInt("userid") != sessionUserId) {
%>
        <script>
            alert("본인의 게시글만 수정할 수 있습니다.");
            history.back();
        </script>
<%
        return;
    }

    // 게시글 수정
    PreparedStatement updateStmt = conn.prepareStatement("UPDATE posts SET title = ?, content = ? WHERE id = ?");
    updateStmt.setString(1, title);
    updateStmt.setString(2, content);
    updateStmt.setInt(3, postId);
    updateStmt.executeUpdate();

    response.sendRedirect("view.jsp?id=" + postId);
%>
