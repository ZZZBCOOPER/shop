<%@ page contentType="text/html;charset=gb2312" %>
<%@ page language="java" import="java.util.*,java.sql.*" pageEncoding="gb2312"%>
<%@ page import="mybean.data.DataByPage" %>
<%@ page import="com.sun.rowset.*" %>
<jsp:useBean id="dataBean" class="mybean.data.DataByPage" scope="session" />
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>浏览页面</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
  </head>
  <body  style="background-color:#FAFAD2">
  <jsp:include page="head.txt"></jsp:include>
  <div align="center">
   <br>当前显示的内容是:
   <table border=2>
   <tr>
    <th>化妆品标识号</th>
    <th>化妆品名称</th>
    <th>化妆品制造商</th>
    <th>化妆品价格</th>
    <th>查看详情</th>
    <td><font color=blue>添加到购物车</font></td>
   </tr>
   <jsp:setProperty property="pageSize" name="dataBean" param="pageSize"/>
   <jsp:setProperty property="currentPage" name="dataBean" param="currentPage"/>
   <%
   try{
   CachedRowSetImpl rowSet = dataBean.getRowSet();
   if(rowSet == null)
   {
     out.print("没有任何查询信息，无法浏览"); 
     return;
   }
   rowSet.last();
   int totalRecord = rowSet.getRow();
   out.print("全部记录数:"+totalRecord);
   int pageSize = dataBean.getPageSize();//每页显示的记录数
   int totalPages = dataBean.getTotalPages();
   if(totalRecord%pageSize ==0)
     totalPages = totalRecord/pageSize;
   else 
     totalPages = totalRecord/pageSize+1;
   dataBean.setPageSize(pageSize);
   dataBean.setTotalPages(totalPages);
   if(totalPages>=1)
   {
      if(dataBean.getCurrentPage()<1)
       dataBean.setCurrentPage(dataBean.getTotalPages());
      if(dataBean.getCurrentPage()>dataBean.getTotalPages())
        dataBean.setCurrentPage(1); 
   }
   int index = (dataBean.getCurrentPage()-1)*pageSize+1;
   rowSet.absolute(index);
   boolean boo = true;
   for(int i=1;i<=pageSize&&boo;i++)
   {
     String number=rowSet.getString(1);
     String name = rowSet.getString(2);
     String maker = rowSet.getString(3);
     String price = rowSet.getString(4);
     String goods = "("+number+","+name+","+maker+","+price+")#"+price;//计算价格
     goods = goods.replaceAll("\\p{Blank}","");
     String button = "<form action='putGoodsServlet' method='post' >"+"<input type='hidden' name='java' value="+goods+">"+"<input type='submit' value='放入购物车'></form>";
     String detail = "<form action ='showDetail.jsp' method='post'>"+"<input type='hidden' name='xijie'value="+number+">"+"<input type='submit' value='查看细节'></form>";
     out.print("<tr>");    
     out.print("<td>"+number+"</td>");
     out.print("<td>"+name+"</td>");
     out.print("<td>"+maker+"</td>");
     out.print("<td>"+price+"</td>");
     out.print("<td>"+detail+"</td>");
     out.print("<td>"+button+"</td>");
    }
   }catch(Exception e)
   {
      out.print("<font color=red>&nbsp;&nbsp;&nbsp;上下查询信息不匹配</font>");
   }
    %>
   </table>
   <br>每页显示<jsp:getProperty property="pageSize" name="dataBean"/>条信息
   <br>当前显示<font color=blue><jsp:getProperty property="currentPage" name="dataBean"/></font>页,共有
   <font color=blue>
   <jsp:getProperty property="totalPages" name="dataBean"/> 
   </font>页
   <table>
   <tr>
   <td>
   <form action="" method="post">
   <input type="hidden" name="currentPage" value="<%= dataBean.getCurrentPage()-1 %>">
   <input type="submit" name="g" value="上一页">
   </form>
   </td>
   <td>
   <form action="" method="post">
   <input type="hidden" name="currentPage" value="<%= dataBean.getCurrentPage()+1 %>">
   <input type="submit" name="g" value="下一页">
   </form>
   </td>  
   </tr>
   <tr>
   <td>
   <form action="" method="post">
   每页显示<input type="text" name="pageSzie" value=1 size=3>条记录
   <input type="submit" name="g" value="确定">
   </form>
   </td>
   <td>
   <form action="" method="post">
   输入页码<input type="text" name="currentPage" size=2>
   <input type="submit" name="g" value="提交">
   </form>
   </td>
   </tr>
   </table>
  </div>
  </body>
</html>
