<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 입력값 가져오기
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    // 세션에서 사용자 ID 가져오기
    Object userIdObj = session.getAttribute("userId");

    // userId가 없거나 정수가 아닌 경우 로그인 페이지로 이동
    if (userIdObj == null) {
%>
        <script>
            alert("로그인이 필요합니다.");
            location.href = "../login/login.jsp";
        </script>
<%
        return;
    }

    int userId = (Integer) userIdObj; // 🔥 세션에서 가져온 userId를 정수로 변환

    // DB 연결 및 글 저장
    Class.forName("com.mysql.cj.jdbc.Driver");

    try (
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
        PreparedStatement getUserStmt = conn.prepareStatement("SELECT nickname FROM users WHERE id = ?");
        PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO posts (userid, title, content, author) VALUES (?, ?, ?, ?)");
    ) {
        // 🔥 사용자 닉네임 가져오기
        getUserStmt.setInt(1, userId);
        ResultSet userRs = getUserStmt.executeQuery();
        String author = "익명";
        if (userRs.next()) {
            author = userRs.getString("nickname");
        }

        // 🔥 posts 테이블에 데이터 삽입
        insertStmt.setInt(1, userId);
        insertStmt.setString(2, title);
        insertStmt.setString(3, content);
        insertStmt.setString(4, author);
        insertStmt.executeUpdate();
%>
        <script>
            alert("글 작성이 완료되었습니다.");
            location.href = "../index.jsp";
        </script>
<%
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert('글 작성 중 오류가 발생했습니다.');
            history.back();
        </script>
<%
    }
%>
