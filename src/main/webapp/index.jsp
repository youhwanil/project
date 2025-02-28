<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String jdbcUrl = "jdbc:mysql://localhost:3309/blog";
    String dbUser = "root";
    String dbPass = "1234";
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);

    // 세션에서 로그인한 사용자 ID 가져오기
    Integer userIdObj = (Integer) session.getAttribute("userId"); 
    String loggedInUser = (userIdObj != null) ? String.valueOf(userIdObj) : null;

    // 검색할 닉네임 가져오기
    String searchNickname = request.getParameter("searchNickname");

    // SQL 실행
    PreparedStatement pstmt;
    if (searchNickname != null && !searchNickname.trim().isEmpty()) {
        // 닉네임으로 검색
        pstmt = conn.prepareStatement("SELECT id, title, author, created_at FROM posts WHERE author = ? ORDER BY created_at DESC");
        pstmt.setString(1, searchNickname);
    } else if (loggedInUser != null) {
        // 로그인한 사용자의 글만 조회
        pstmt = conn.prepareStatement("SELECT id, title, author, created_at FROM posts WHERE userid = ? ORDER BY created_at DESC");
        pstmt.setString(1, loggedInUser);
    } else {
        // 전체 글 조회
        pstmt = conn.prepareStatement("SELECT id, title, author, created_at FROM posts ORDER BY created_at DESC");
    }

    ResultSet rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <title>Mini Blog</title>
    <style>
        .search-container {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-container input {
            width: 200px;
            padding: 5px;
        }

        .search-container button {
            padding: 5px 10px;
            font-size: 14px;
            cursor: pointer;
        }

        .top-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
        }
    </style>
</head>
<body>
    <h1>Mini Blog</h1>
    <nav>
        <a href="index.jsp">홈</a>
        <% if(session.getAttribute("userId") == null) { %>
            <a href="login/login.jsp">로그인</a>
            <a href="login/register.jsp">회원가입</a>
        <% } else { %>
            <a href="post/write.jsp">글쓰기</a>
            <a href="user/mypage.jsp">마이페이지</a>
            <a href="login/logout.jsp">로그아웃</a>
        <% } %>
    </nav>

    <!-- 🔹 최신 글 + 검색 기능을 같은 위치에 배치 -->
    <div class="top-section">
        <h2>최신 글</h2>
        <div class="search-container">
            <form method="get" action="index.jsp">
                <input type="text" name="searchNickname" placeholder="닉네임 검색" value="<%= (searchNickname != null) ? searchNickname : "" %>">
                <button type="submit">🔍</button>
            </form>
        </div>
    </div>

    <ul>
        <% while(rs.next()) { %>
            <li>
                <a href="post/view.jsp?id=<%= rs.getInt("id") %>"><%= rs.getString("title") %></a>
                <span> - <%= rs.getString("author") %> (<%= rs.getString("created_at") %>)</span>
            </li>
        <% } %>
    </ul>

<%
    rs.close();
    pstmt.close();
    conn.close();
%>
</body>
</html>
