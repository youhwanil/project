<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>글쓰기</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <div class="write-container">
        <h2>글 작성</h2>
        <form action="write_process.jsp" method="post">
            <input type="text" name="title" class="input-field" placeholder="제목" required><br>
            <textarea name="content" class="textarea-field" placeholder="내용을 입력하세요" required></textarea><br>
            <button type="submit" class="submit-btn">작성</button>
        </form>
        <button onclick="location.href='../index.jsp'" style="margin-top: 20px; display: block; width: 100%;">뒤로 가기</button>
    </div>
</body>
</html>
