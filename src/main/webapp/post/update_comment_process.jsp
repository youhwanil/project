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

    // 댓글 정보 가져오기
    String commentIdStr = request.getParameter("id");
    String postIdStr = request.getParameter("post_id");
    String content = request.getParameter("content");

    if (commentIdStr == null || postIdStr == null || content == null || content.trim().isEmpty()) {
%>
        <script>
            alert("잘못된 요청입니다.");
            history.back();
        </script>
<%
        return;
    }

    int commentId = Integer.parseInt(commentIdStr);
    int postId = Integer.parseInt(postIdStr);

    // DB 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");

    // 댓글 소유자 확인
    PreparedStatement checkStmt = conn.prepareStatement("SELECT user_id FROM comments WHERE id = ?");
    checkStmt.setInt(1, commentId);
    ResultSet rs = checkStmt.executeQuery();

    if (!rs.next() || rs.getInt("user_id") != sessionUserId) {
%>
        <script>
            alert("본인의 댓글만 수정할 수 있습니다.");
            history.back();
        </script>
<%
        return;
    }

    // 댓글 업데이트
    PreparedStatement updateStmt = conn.prepareStatement("UPDATE comments SET content = ? WHERE id = ?");
    updateStmt.setString(1, content);
    updateStmt.setInt(2, commentId);
    updateStmt.executeUpdate();

    response.sendRedirect("view.jsp?id=" + postId);
%>
