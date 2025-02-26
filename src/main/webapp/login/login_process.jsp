<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // 1. 한글 깨짐 방지를 위해 요청(request)의 인코딩을 UTF-8로 설정
    request.setCharacterEncoding("UTF-8");

    // 2. 사용자가 입력한 아이디와 비밀번호 가져오기
    String userid = request.getParameter("userid");
    String password = request.getParameter("password");

    // 3. DB 연결 및 로그인 처리
    try {
        // 3-1. MySQL JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 3-2. try-with-resources를 사용하여 Connection, PreparedStatement, ResultSet 자동 close 처리
        try (
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM users WHERE userid = ? AND password = ?");
        ) {
            // 3-3. SQL 쿼리에 사용자 입력값을 바인딩 (SQL 인젝션 방지)
            pstmt.setString(1, userid);
            pstmt.setString(2, password);

            // 3-4. 쿼리 실행 후 결과 가져오기
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) { // 3-5. 사용자가 존재하면 로그인 성공
                    session.setAttribute("userId", rs.getString("userid"));  // 세션에 사용자 아이디 저장
                    session.setAttribute("password", rs.getString("password")); // 세션에 사용자 이름 저장
                    response.sendRedirect("../index.jsp"); // 메인 페이지로 이동
                    return; // 이후 코드 실행 방지
                }
            }
        }
    } catch (Exception e) { // 4. 예외 발생 시 오류 출력 (DB 연결 실패, SQL 실행 오류 등)
        e.printStackTrace();
    }
%>

<!-- 5. 로그인 실패 시 경고 메시지 띄우고 로그인 페이지로 다시 이동 -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script>
        alert('아이디 또는 비밀번호가 틀립니다!'); // 경고창 표시
        history.back(); // 이전 페이지(로그인 페이지)로 돌아감
    </script>
</head>
<body>
</body>
</html>
