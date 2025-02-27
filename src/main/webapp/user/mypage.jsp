<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 현재 로그인한 사용자 정보
    String userid = String.valueOf(session.getAttribute("userId")); // 🔥 Integer → String 변환
    String name = "";
    String email = "";
    String nickname = "";

    if (userid == null || userid.equals("null")) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");

    try (
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
        PreparedStatement userStmt = conn.prepareStatement("SELECT name, email, nickname FROM users WHERE id = ?");
    ) {
        userStmt.setInt(1, Integer.parseInt(userid));
        ResultSet rs = userStmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            nickname = rs.getString("nickname");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>마이페이지</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <div class="login-container">
        <h2>마이페이지</h2>
        <div id="infoDisplay">
            <p><strong>아이디:</strong> <%= userid %></p>
            <p><strong>이름:</strong> <%= name %></p>
            <p><strong>이메일:</strong> <%= email %></p>
            <p><strong>닉네임:</strong> <%= nickname %></p>
            <button onclick="document.getElementById('infoDisplay').style.display='none'; document.getElementById('editForm').style.display='block';">
                정보 수정
            </button>
        </div>

        <form id="editForm" method="post" action="mypage_process.jsp" style="display:none;">
            <div class="form-group">
                <input type="text" name="name" value="<%= name %>" required>
            </div>
            <div class="form-group">
                <input type="email" name="email" value="<%= email %>" required>
            </div>
            <div class="form-group">
                <input type="text" name="nickname" value="<%= nickname %>" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="새 비밀번호 (변경 시 입력)">
            </div>
            <button type="submit">정보 수정 완료</button>
        </form>

        <!-- 뒤로 가기 버튼 추가 -->
        <button onclick="location.href='../index.jsp'" style="margin-top: 20px; display: block; width: 100%;">뒤로 가기</button>
    </div>
</body>
</html>
