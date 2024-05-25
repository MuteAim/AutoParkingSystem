<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DriverManager" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AVS-Reservation Success</title>
</head>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f2f2f2;
        margin: 0;
        padding: 0;
    }

    #confirmCard {
        width: 400px;
        margin: 50px auto;
        background-color: #fff;
        padding: 20px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        text-align: center;
    }

    h2 {
        margin-bottom: 20px;
    }

    a {
        text-decoration: none;
        color: #4CAF50;
        font-weight: bold;
    }

    a:hover {
        text-decoration: underline;
    }

    div {
        margin-top: 10px;
    }
</style>

<body>
<%
	request.setCharacterEncoding("utf-8");
	String rCellNum = request.getParameter("cellnum");
	String rCarNum = request.getParameter("carnum");
	String rUserIdx = session.getAttribute("idx").toString();
	
	Connection MyConn = null;
	String sUrl = "jdbc:mariadb://localhost:3306/parking";
	String sUser = "yeetpi";
	String sPwd = "a123123123";
	Class.forName("org.mariadb.jdbc.Driver");	
	PreparedStatement stmt = null;
	//reservnum cellnum carnum useridx
	try {
		MyConn = DriverManager.getConnection(sUrl, sUser, sPwd);
	    String sql = "INSERT INTO reservation (cellnum, carnum, useridx, regdate) VALUES (?,?,?,now());";
	    stmt = MyConn.prepareStatement(sql);
	
        stmt.setString(1, rCellNum);
        stmt.setString(2, rCarNum);
        stmt.setString(3, rUserIdx);
        stmt.executeUpdate();
        
        sql = "UPDATE pavailable SET occupied=1 WHERE cellnum=?;";
	    stmt = MyConn.prepareStatement(sql);
	
        stmt.setString(1, rCellNum);
        stmt.executeUpdate();
%>
<div id="confirmCard">
<h2>예약이 완료되었습니다.</h2>
<a href="./Index.jsp"><div id="button">확인</div></a>
</div>
<%
        
	 } catch (Exception e) {
	    e.printStackTrace();
%>
<div id="confirmCard">
<h2>문제가 발생했습니다. 다시 시도하여 주십시오.</h2>
<a href="./Index.jsp"><div id="button">돌아가기</div></a>
</div>
<%
	 } finally {
	    if (stmt != null) { try { stmt.close(); } catch (SQLException e2) { e2.printStackTrace();}
	    }
	    if (MyConn != null) { try { MyConn.close(); } catch (SQLException e2) { e2.printStackTrace();}
	    }
	 }
%>
</body>
</html>