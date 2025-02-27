<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 현재 로그인한 사용자 정보
    String userid = (String) session.getAttribute("userId");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String nickname = request.getParameter("nickname");
    String password = request.getParameter("password");
    
    if (userid == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Class.forName("com.mysql.cj.jdbc.Driver");
    
    try (
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
        PreparedStatement checkEmailStmt = conn.prepareStatement("SELECT * FROM users WHERE email = ? AND userid != ?");
        PreparedStatement checkNicknameStmt = conn.prepareStatement("SELECT * FROM users WHERE nickname = ? AND userid != ?");
        PreparedStatement updateStmt = conn.prepareStatement("UPDATE users SET name=?, email=?, nickname=?, password=IFNULL(?, password) WHERE userid=?");
    ) {
        // 이메일 중복 확인
        checkEmailStmt.setString(1, email);
        checkEmailStmt.setString(2, userid);
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
        
        // 닉네임 중복 확인
        checkNicknameStmt.setString(1, nickname);
        checkNicknameStmt.setString(2, userid);
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
        
        // 회원정보 업데이트
        updateStmt.setString(1, name);
        updateStmt.setString(2, email);
        updateStmt.setString(3, nickname);
        updateStmt.setString(4, password.isEmpty() ? null : password);
        updateStmt.setString(5, userid);
        updateStmt.executeUpdate();
        
        // 세션 업데이트
        session.setAttribute("name", name);
        session.setAttribute("email", email);
        session.setAttribute("nickname", nickname);
%>
        <script>
            alert('회원정보가 수정되었습니다.');
            window.location.href = 'mypage.jsp';
        </script>
<%
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert('회원정보 수정 중 오류가 발생했습니다.');
            history.back();
        </script>
<%
    }
%>
