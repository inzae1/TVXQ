<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="tvxq.borad.dao.BoardDAO" %>
<%@ page import="tvxq.borad.vo.BoardVO" %>
<%@ page import="tvxq.borad.vo.RepleVO" %>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width", initial-scale="1">
		<link rel="stylesheet" href="css/bootstrap.css">
	    <link href="https://fonts.googleapis.com/css?family=Nunito+Sans:200,300,400,600,700,800,900&display=swap" rel="stylesheet">
	    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
	    <link rel="stylesheet" href="css/animate.css">
	    <link rel="stylesheet" href="css/owl.carousel.min.css">
	    <link rel="stylesheet" href="css/owl.theme.default.min.css">
	    <link rel="stylesheet" href="css/magnific-popup.css"> 
	    <link rel="stylesheet" href="css/flaticon.css">
	    <link rel="stylesheet" href="css/style.css">
	<title>전체 게시글</title>
    
    <style type="text/css">
        #wrap {
            width: 800px;
            margin: 0 auto 0 auto;
        }
        #topForm{
            text-align :right;
        }
        #board, #pageForm, #searchForm{
            text-align :center;
        }
        
        #bList{
            text-align :center;
        }
        a, a:hover{
			color: #000000;
			text-decoration: none;}
    </style>
	
	<body>
		<%
			String userID = null;
			if(session.getAttribute("id") != null){
				userID = (String)session.getAttribute("id");
			} 
			
			
			/* int board_no = 0;
			if(request.getParameter("board_no") != null){
				board_no = Integer.parseInt(request.getParameter("board_no"));
			}
			 */
			BoardVO boardVO = (BoardVO) request.getAttribute("boardVO"); 
			
			int board_no = boardVO.getBoard_no();
			
			if(board_no == 0){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href='boardForm.jsp'");
				script.println("</script>");
			}
			
			List<RepleVO> repleList = (List<RepleVO>) request.getAttribute("repleList");
			
			
		%>
		
		<%
		// 저장된 쿠키 불러오기
		Cookie[] cookieFromRequest = request.getCookies();
		String cookieValue = null;
		for(int i = 0 ; i<cookieFromRequest.length; i++) {
		// 요청정보로부터 쿠키를 가져온다.
			cookieValue = cookieFromRequest[0].getValue();	
		}
	
 		/* board_no = Integer.parseInt(request.getParameter("board_no")); */

		if (session.getAttribute(board_no+":cookie") == null) {
		 	session.setAttribute(board_no+":cookie", board_no + ":" + cookieValue);
		} else {
			session.setAttribute(board_no+":cookie ex", session.getAttribute(board_no+":cookie"));
			if (!session.getAttribute(board_no+":cookie").equals(board_no + ":" + cookieValue)) {
			 	session.setAttribute(board_no+":cookie", board_no + ":" + cookieValue);
			}
		}
 		BoardDAO boardDAO = new BoardDAO();
 		BoardVO  board = boardDAO.getBoard(board_no);

 		// 조회수 카운트
 		if (!session.getAttribute(board_no+":cookie").equals(session.getAttribute(board_no+":cookie ex"))) {
 			boardDAO.updateCount(board);
 	}
 	
 %> 
		<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
		    <div class="container-fluid">
		    	<a class="navbar-brand" href="main.jsp">Play Data</a>
		    	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
		        	<span class="oi oi-menu"></span> Menu
		      	</button>
	
		      <div class="collapse navbar-collapse" id="ftco-nav">
		      	<ul class="navbar-nav ml-auto">
		          <li class="nav-item"><a href="main.jsp" class="nav-link">메인</a></li>
		          <li class="nav-item"><a href="boardForm.jsp" class="nav-link">게시판</a></li>
		          <li class="nav-item"><a href="map.jsp" class="nav-link">지도</a></li>
		          <%
					// 로그인이 되어 있지 않다면
					if(userID == null){
				  %>
				<div class="dropdown">
					  <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					    접속
					  </button>
					<ul class="dropdown-menu">
						<li><a class="dropdown-item" href="login.jsp">로그인</a></li>
						<li><a class="dropdown-item" href="join.jsp">회원가입</a></li>
					</ul>
				</li>
				</div>
				<%
					} else {
				%>
				<div class="dropdown">
					  <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					    회원관리
					  </button>
					<ul class="dropdown-menu">
						<li><a class="dropdown-item" href="logoutAction.jsp">로그아웃</a></li>
						<li><a class="dropdown-item" href="updateUserForm.jsp">정보수정</a></li>
						<li><a class="dropdown-item" href="deleteUser.jsp">회원탈퇴</a></li>
					</ul>
				</li>
				</div>
				<%
					}
				%>
		        </ul>
		      </div>
		    </div>
	 	</nav>
		
		
		
		<div class="container">
			<div class="row">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
						</tr>		
					</thead>
					<tbody>
						<tr>
							<td style="width: 20%;">글 제목</td>
							<td colspan="2"><%=boardVO.getTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replace(">","&gt;").replaceAll("\n","<br>") %></td>
						</tr>
						<tr>
							<td>작성자</td>
							<td colspan="2"><%=boardVO.getUserID() %></td>
						</tr>
						<tr>
							<td>작성일자</td>
							<td><%=boardVO.getReg_date() %></td>
						</tr>
						<tr>
							<td>내용</td>
							<td colspan="2" style="min-height: 200px; text-align: left;"><%=boardVO.getContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replace(">","&gt;").replaceAll("\n","<br>") %></td>
						</tr>
						<tr>
							<td>조회수</td>
							<td><%=boardVO.getViews() %></td>
						</tr>
						<tr>
							<td>추천수</td>
							<td><%=boardVO.getLikes() %></td>
						</tr>
					</tbody>
				</table>
				
				<div class="container">
					<div class="row">
					<%
					if(repleList != null) {
					%>
						<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
							<thead style="background-color: #eeeeee;">
								<tr>
									<th colspan="2" style="background-color: #eeeeee; text-align: center;">댓글</th>
								</tr>
								<tr>
									<th style="width: 20%; text-align: center;">작성자</td>
									<th colspan="2" style="text-align: center;">댓글 내용</td>		
								</tr>
							</thead>
							<tbody>
								
					<%
						for(RepleVO repleVO : repleList) {
					%>
								<tr>
									<td style="width: 20%;"><%=repleVO.getUserId() %></td>
									<td colspan="2"><%=repleVO.getContent() %></td>
								</tr>
					<%		
						}
					}
					%>
							</tbody>
						</table>
						<% if(userID != null){
							%>
					
						<form action="writeReple" method="post">
							<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
								<tbody>
									<tr>
										<input hidden name="boardNo" value=<%=boardVO.getBoard_no() %>>
										<input hidden name="userId" value=<%=userID %>>
										<td><textarea type="text" class="form-control"  placeholder="댓글 내용" name="reple" maxlength="2048" style="height: 50px;"></textarea></td>
									</tr>
								</tbody>
							</table>
							<input type="submit" class="btn btn-primary pull-right" value="댓글 입력">
						</form>
						<% } else{ %>
						<form action="login.jsp" method="post">
						<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
								<tbody>
									<tr>
										<input hidden name="boardNo" value=<%=boardVO.getBoard_no() %>>
										<input hidden name="userId" value=<%=userID %>>
										<td><textarea type="text" class="form-control" readonly placeholder="댓글을 입력하려면 로그인을 하세요" name="reple" maxlength="2048" style="height: 50px;"></textarea></td>
									</tr>
								</tbody>
							</table>
							<input type="submit" class="btn btn-primary pull-right" value="로그인">
							<%} %>
					</div>
				</div>
				
				
				<a href="boardForm.jsp" class="btn btn-primary">목록</a>
				<%
					if(userID != null && userID.equals(boardVO.getUserID())){
				%>
					<a href="update.jsp?board_no=<%=board_no %>" class="btn btn-primary">수정</a>
					<a href="deleteAction.jsp?board_no=<%=board_no %>" class="btn btn-primary">삭제</a>
				<%
					}else{
				%>
					<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?board_no=<%=board_no %>" class="btn btn-danger">추천</a>
				<%
					}
				%>
			</div>
		</div>
		
		<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
 		<script src="js/bootstrap.js"></script>
 	    <script src="js/jquery.min.js"></script>
	    <script src="js/jquery-migrate-3.0.1.min.js"></script>
   	    <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/jquery.easing.1.3.js"></script>
		<script src="js/jquery.waypoints.min.js"></script>
		<script src="js/jquery.stellar.min.js"></script>
		<script src="js/owl.carousel.min.js"></script>
		<script src="js/jquery.magnific-popup.min.js"></script>
		<script src="js/jquery.animateNumber.min.js"></script>
		<script src="js/scrollax.min.js"></script>
		<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
		<script src="js/google-map.js"></script>
		<script src="js/main.js"></script>
		<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
 		<script src="js/bootstrap.js"></script>
	</body>
</html>