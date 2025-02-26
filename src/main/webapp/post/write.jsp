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
        <form action="write_process.jsp" method="post" enctype="multipart/form-data">
            <input type="text" name="title" placeholder="제목" required><br>
            <textarea name="content" placeholder="내용을 입력하세요" required></textarea><br>
            <input type="file" name="image"><br>
            <button type="submit">작성</button>
        </form>
    </div>
</body>
</html>
