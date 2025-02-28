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

    // 댓글 소유자 확인
    PreparedStatement checkStmt = conn.prepareStatement("SELECT post_id, user_id FROM comments WHERE id = ?");
    checkStmt.setInt(1, commentId);
    ResultSet rs = checkStmt.executeQuery();

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

    if (sessionUserId != commentUserId) {
%>
        <script>
            alert("본인의 댓글만 삭제할 수 있습니다.");
            history.back();
        </script>
<%
        return;
    }

    // 댓글 삭제
    PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM comments WHERE id = ?");
    deleteStmt.setInt(1, commentId);
    deleteStmt.executeUpdate();

    response.sendRedirect("view.jsp?id=" + postId);
%>
