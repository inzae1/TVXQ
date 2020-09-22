<%@page import="DAO.UserDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="DAO.UserVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="user" class="DAO.UserVO" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" /> 
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	
	<body>
		<%
			String userID = null;
			if(session.getAttribute("userID") != null){
				userID = (String)session.getAttribute("userID");
			}
			if(userID != null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alter('이미 로그인 되어 있습니다.')");
				script.println("history.href='main.jsp'");
				script.println("</script>");
			}
		
			if(user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null
					|| user.getUserGender() == null || user.getUserEmail() == null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alter('모두 입력이 되었는지 확인해 주세요.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				UserDAO userDAO = new UserDAO();
				int result = userDAO.addUser(user);
				if(result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alter('아이디가 이미 존재합니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else {
					session.setAttribute("userID", user.getUserID());
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='main.jsp'");
					script.println("</script>");
				}
			}
		%>
	</body>
</html>