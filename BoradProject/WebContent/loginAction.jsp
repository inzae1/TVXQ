<%@page import="java.io.PrintWriter"%>
<%@page import="DAO.UserDAO"%>
<%@page import="DAO.UserVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="user" class="DAO.UserVO" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" /> 

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Login page</title>
	</head>
	
	<body>
		<%
			// 로그인 한 사람은 회원가입 페이지에 접근할 수 없도록
			String userID = null;
			if(session.getAttribute("userID") != null){
				userID = (String)session.getAttribute("userID");
			}
			if(userID != null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alter('이미 로그인이 되어있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			
			// login.jsp에서 id와 password를 받아옵니다.
			UserDAO userDAO = new UserDAO();
	
			int result = userDAO.getUser(user.getUserID(), user.getUserPassword());
			
			if(result == 1){
				session.setAttribute("userID", user.getUserID());
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href='main.jsp'");
				script.println("</script>");
			}
			else if(result == 0){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alter('비밀번호가 틀립니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else if(result == -1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alter('아이디가 존재하지 않습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else if(result == -2){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alter('Database에 오류가 발생하였습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
		%>
	</body>
</html>