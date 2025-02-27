<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="../css/style.css">
    <title>로그인</title>
</head>
<body>
	<div class="login-container">
    <h2>로그인</h2>
    <div class="form-group">
    <form method="post" action="login_process.jsp">
        아이디: <input type="text" name="userid" required><br>
        비밀번호: <input type="password" name="password" required><br>
    </div>
        <button type="submit">로그인</button>
        <button onclick="location.href='../index.jsp'" style="margin-top: 20px; display: block; width: 100%;">뒤로 가기</button>
    </form>
    </div>
</body>
</html>