<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    Integer reservationNo = (Integer) request.getAttribute("reservation_no");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Reservation - Ocean View Resort</title>
</head>
<body>

<jsp:include page="includes/header.jsp"/>

<div class="container">

    <div class="card">
        <h1 style="margin:0 0 6px;">Update Reservation</h1>
        <small>Search by reservation number to load details and update</small>

        <% if (error != null) { %>
            <div class="alert bad"><%= error %></div>
        <% } %>

        <% if (message != null) { %>
            <div class="alert ok"><%= message %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/update-reservation" method="get"
              style="margin-top:14px; display:flex; gap:10px; flex-wrap:wrap; align-items:end;">

            <div style="flex:1; min-width:220px;">
                <small>Reservation No</small>
                <input type="number" name="reservationNo" placeholder="e.g. 1001" required>
            </div>

            <button class="btn primary" type="submit">Search</button>
            <a class="btn ghost" href="<%=request.getContextPath()%>/updateReservation.jsp">Clear</a>
        </form>
    </div>

    <div style="height:14px;"></div>

    <% if (reservationNo != null) { %>
    <div class="card">
        <h2 style="margin:0 0 10px;">Edit Details</h2>

        <form action="<%=request.getContextPath()%>/update-reservation" method="post" class="form-grid two">

            <input type="hidden" name="reservationNo" value="<%= reservationNo %>">

            <div>
                <small>Guest Name</small>
                <input type="text" name="guestName" value="<%= request.getAttribute("guest_name") %>" required>
            </div>

            <div>
                <small>Contact Number</small>
                <input type="text" name="contact" value="<%= request.getAttribute("contact_number") %>"
                       pattern="[0-9]{10}" title="Enter 10 digit number" required>
            </div>

            <div style="grid-column:1/-1;">
                <small>Address</small>
                <input type="text" name="address" value="<%= request.getAttribute("address") %>" required>
            </div>

            <div>
                <small>Room Type</small>
                <%
                    String roomType = (String) request.getAttribute("room_type");
                %>
                <select name="roomType" required>
                    <option value="SINGLE" <%= "SINGLE".equalsIgnoreCase(roomType) ? "selected" : "" %>>Single</option>
                    <option value="DOUBLE" <%= "DOUBLE".equalsIgnoreCase(roomType) ? "selected" : "" %>>Double</option>
                    <option value="DELUXE" <%= "DELUXE".equalsIgnoreCase(roomType) ? "selected" : "" %>>Deluxe</option>
                    <option value="SUITE"  <%= "SUITE".equalsIgnoreCase(roomType) ? "selected" : "" %>>Suite</option>
                </select>
            </div>

            <div></div>

            <div>
                <small>Check-in Date</small>
                <input type="date" name="checkIn" value="<%= request.getAttribute("check_in") %>" required>
            </div>

            <div>
                <small>Check-out Date</small>
                <input type="date" name="checkOut" value="<%= request.getAttribute("check_out") %>" required>
            </div>

            <div style="grid-column:1/-1; display:flex; gap:10px; flex-wrap:wrap;">
                <button class="btn primary" type="submit">Update Reservation</button>
                <a class="btn ghost" href="dashboard.jsp">Back</a>
            </div>
        </form>

        <%
            Integer updatedNo = (Integer) request.getAttribute("updatedReservationNo");
            if (updatedNo != null) {
        %>
        <div style="margin-top:12px;">
            <form action="calculate-bill" method="get" style="display:inline;">
                <input type="hidden" name="reservationNo" value="<%= updatedNo %>">
                <button class="btn ghost" type="submit">Recalculate Bill</button>
            </form>
        </div>
        <% } %>

    </div>
    <% } %>

</div>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>