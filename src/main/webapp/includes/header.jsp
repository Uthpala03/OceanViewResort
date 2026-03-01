<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String currentPage = request.getRequestURI();
%>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

<!-- Icons -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<div class="navbar">
  <div class="nav-inner">

    <!-- ✅ Logo + Text -->
    <a class="brand" href="<%=request.getContextPath()%>/dashboard.jsp">
        <img src="<%=request.getContextPath()%>/assets/img/logo.png"
             class="brand-img"
             alt="Ocean View Resort">
        <span class="brand-name">Ocean View Resort</span>
    </a>

    <div class="nav">

      <a href="<%=request.getContextPath()%>/dashboard.jsp"
         class="<%= currentPage.contains("dashboard.jsp") ? "active" : "" %>">
         Dashboard
      </a>

      <a href="<%=request.getContextPath()%>/addReservation.jsp"
         class="<%= currentPage.contains("addReservation.jsp") ? "active" : "" %>">
         Add
      </a>

      <a href="<%=request.getContextPath()%>/viewReservation.jsp"
         class="<%= currentPage.contains("viewReservation.jsp") ? "active" : "" %>">
         View
      </a>

      <a href="<%=request.getContextPath()%>/updateReservation.jsp"
         class="<%= currentPage.contains("updateReservation.jsp") ? "active" : "" %>">
         Update
      </a>

      <a href="<%=request.getContextPath()%>/deleteReservation.jsp"
         class="<%= currentPage.contains("deleteReservation.jsp") ? "active" : "" %>">
         Cancel
      </a>

      <a href="<%=request.getContextPath()%>/payments.jsp"
         class="<%= currentPage.contains("payments.jsp") ? "active" : "" %>">
         Payments
      </a>

      <a href="<%=request.getContextPath()%>/help.jsp"
         class="<%= currentPage.contains("help.jsp") ? "active" : "" %>">
         Help
      </a>

      <a href="<%=request.getContextPath()%>/logout" class="btn primary">
         Logout
      </a>

    </div>
  </div>
</div>