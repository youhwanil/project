<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userid = request.getParameter("userid");
    String password = request.getParameter("password");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
            PreparedStatement pstmt = conn.prepareStatement("SELECT id, userid, nickname FROM users WHERE userid = ? AND password = ?");
        ) {
            pstmt.setString(1, userid);
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    // ✅ `id`를 세션에 저장 (정수형 PK)
                    session.setAttribute("userId", rs.getInt("id"));  
                    session.setAttribute("userid", rs.getString("userid")); // 아이디도 저장 (필요할 경우)
                    session.setAttribute("nickname", rs.getString("nickname")); // 닉네임 저장

                    response.sendRedirect("../index.jsp");
                    return;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!-- 로그인 실패 처리 -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script>
        alert('아이디 또는 비밀번호가 틀립니다!');
        history.back();
    </script>
</head>
<body>
</body>
</html>
