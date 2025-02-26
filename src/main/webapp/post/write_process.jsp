<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.annotation.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    Part filePart = request.getPart("image"); // 이미지 파일
    String fileName = filePart.getSubmittedFileName();
    String uploadPath = application.getRealPath("/") + "uploads/" + fileName;

    // 파일 저장
    InputStream fileContent = filePart.getInputStream();
    FileOutputStream fos = new FileOutputStream(uploadPath);
    byte[] buffer = new byte[1024];
    int bytesRead;
    while ((bytesRead = fileContent.read(buffer)) != -1) {
        fos.write(buffer, 0, bytesRead);
    }
    fos.close();
    fileContent.close();

    // DB에 저장
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String userId = (String) session.getAttribute("userid");

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3309/blog", "root", "1234");
    PreparedStatement pstmt = conn.prepareStatement("INSERT INTO posts (userid, title, content, image) VALUES (?, ?, ?, ?)");
    pstmt.setString(1, userId);
    pstmt.setString(2, title);
    pstmt.setString(3, content);
    pstmt.setString(4, fileName);
    pstmt.executeUpdate();

    response.sendRedirect("index.jsp");
%>
