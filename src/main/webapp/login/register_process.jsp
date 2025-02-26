<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // 요청 데이터 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    // 입력값 가져오기
    String userid = request.getParameter("userid");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String nickname = request.getParameter("nickname");

    // 입력값 검증
    if (userid == null || userid.trim().isEmpty()) {
        out.println("<script>alert('아이디가 입력되지 않았습니다.'); history.back();</script>");
        return;
    }

    // MySQL JDBC 드라이버 로드
    Class.forName("com.mysql.cj.jdbc.Driver");

    // DB 연결 (blog 데이터베이스, root 계정 사용)
    try (
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
        PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM users WHERE userid = ?");
        PreparedStatement checkNicknameStmt = conn.prepareStatement("SELECT * FROM users WHERE nickname = ?");
        PreparedStatement checkEmailStmt = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
        PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO users (userid, password, name, email, nickname) VALUES (?, ?, ?, ?, ?)");
    ) {
        // 아이디 중복 확인
        checkStmt.setString(1, userid);
        ResultSet rs = checkStmt.executeQuery();
        if (rs.next()) {
%>
            <script>
                alert('이미 등록된 아이디입니다.');
                history.back();
            </script>
<%
            return;
        }

        // 닉네임 중복 확인
        checkNicknameStmt.setString(1, nickname);
        ResultSet nicknameRs = checkNicknameStmt.executeQuery();
        if (nicknameRs.next()) {
%>
            <script>
                alert('이미 사용 중인 닉네임입니다.');
                history.back();
            </script>
<%
            return;
        }

        // 이메일 중복 확인
        checkEmailStmt.setString(1, email);
        ResultSet emailRs = checkEmailStmt.executeQuery();
        if (emailRs.next()) {
%>
            <script>
                alert('이미 사용 중인 이메일입니다.');
                history.back();
            </script>
<%
            return;
        }

        // 신규 회원 가입 처리
        insertStmt.setString(1, userid);
        insertStmt.setString(2, password); // 실제 운영 시 비밀번호 해싱 필요
        insertStmt.setString(3, name);
        insertStmt.setString(4, email);
        insertStmt.setString(5, nickname);
        insertStmt.executeUpdate();
%>
        <script>
            alert('가입이 완료되었습니다.');
            window.location.href = 'index.jsp';
        </script>
<%
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert('회원가입 중 오류가 발생했습니다.');
            history.back();
        </script>
<%
    }
%>
