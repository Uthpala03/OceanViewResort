<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String u = (String) session.getAttribute("username");
    if (u == null) u = "User";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Ocean View Resort</title>
</head>
<body>

<jsp:include page="includes/header.jsp"/>

<div class="container">

    <div class="card">
        <div style="display:flex; align-items:flex-start; justify-content:space-between; gap:12px; flex-wrap:wrap;">
            <div>
                <h1 style="margin:0;">
                    <i class="fa-solid fa-gauge"></i> Dashboard
                </h1>
                <small>
                    Welcome, <b><%= u %></b>. Use the options below to manage reservations and billing.
                </small>
            </div>

            <a class="btn ghost" href="<%=request.getContextPath()%>/help.jsp">
                <i class="fa-solid fa-circle-question"></i> Help
            </a>
        </div>
    </div>

    <div style="height:14px;"></div>

    <div class="card">
        <h2 style="margin:0 0 6px;">
            <i class="fa-solid fa-bolt"></i> Quick Actions
        </h2>
        <small>Select an action to continue</small>

        <div class="tiles">

            <a class="tile" href="<%=request.getContextPath()%>/addReservation.jsp">
                <div class="tile-title">
                    <i class="fa-solid fa-calendar-plus"></i> Add Reservation
                </div>
                <p class="tile-desc">Create a new guest booking with check-in and check-out dates.</p>
            </a>

            <a class="tile" href="<%=request.getContextPath()%>/viewReservation.jsp">
                <div class="tile-title">
                    <i class="fa-solid fa-magnifying-glass"></i> View Reservation
                </div>
                <p class="tile-desc">Search and view reservation details by reservation number.</p>
            </a>

            <a class="tile" href="<%=request.getContextPath()%>/updateReservation.jsp">
                <div class="tile-title">
                    <i class="fa-solid fa-pen-to-square"></i> Update Reservation
                </div>
                <p class="tile-desc">Edit guest details, room type, or dates safely.</p>
            </a>

            <a class="tile" href="<%=request.getContextPath()%>/deleteReservation.jsp">
                <div class="tile-title">
                    <i class="fa-solid fa-ban"></i> Cancel Reservation
                </div>
                <p class="tile-desc">Cancel an existing reservation (if payment not done).</p>
            </a>

            <a class="tile" href="<%=request.getContextPath()%>/calculateBill.jsp">
                <div class="tile-title">
                    <i class="fa-solid fa-receipt"></i> Calculate Bill
                </div>
                <p class="tile-desc">Calculate total cost based on number of nights and room rate.</p>
            </a>

            <a class="tile" href="<%=request.getContextPath()%>/payments.jsp">
                <div class="tile-title">
                    <i class="fa-solid fa-money-bill-wave"></i> Payments
                </div>
                <p class="tile-desc">View all payment records saved in the system.</p>
            </a>

            <a class="tile" href="<%=request.getContextPath()%>/help.jsp">
                <div class="tile-title">
                    <i class="fa-solid fa-circle-question"></i> Help
                </div>
                <p class="tile-desc">Guidelines for staff on how to use the system.</p>
            </a>

            <a class="tile" href="<%=request.getContextPath()%>/logout">
                <div class="tile-title">
                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                </div>
                <p class="tile-desc">Safely end the session and return to login page.</p>
            </a>

        </div>
    </div>

</div>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>