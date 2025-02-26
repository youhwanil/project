<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8"); // 요청 데이터 한글 깨짐 방지
%>


<!DOCTYPE html>
<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <script>
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            if (password !== confirmPassword) {
                alert("비밀번호가 일치하지 않습니다.");
                return false; // 폼 제출 차단
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="login-container">
        <h2>회원가입</h2>
        <form method="post" action="register_process.jsp" onsubmit="return validateForm()">
            <div class="form-group">
                <input type="text" name="userid" placeholder="아이디" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" id="password" placeholder="비밀번호" required>
            </div>
            <div class="form-group">
                <input type="password" id="confirmPassword" placeholder="비밀번호 확인" required>
            </div>
            <div class="form-group">
                <input type="text" name="name" placeholder="이름" required>
            </div>
            <div class="form-group">
                <input type="email" name="email" placeholder="이메일" required>
            </div>
            <div class="form-group">
                <input type="text" name="nickname" placeholder="닉네임" required>
            </div>
            <button type="submit">가입하기</button>
            <p class="login-link">이미 계정이 있으신가요? <a href="login.jsp">로그인</a></p>
        </form>
    </div>
</body>
</html>
