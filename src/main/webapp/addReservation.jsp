<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Reservation - Ocean View Resort</title>
</head>
<body>

<jsp:include page="includes/header.jsp"/>

<div class="container">

    <div class="card">
        <h1 style="margin:0 0 6px;">Add New Reservation</h1>
        <small>Enter guest and booking details below</small>

        <% if (error != null) { %>
            <div class="alert bad"><%= error %></div>
        <% } %>

        <% if (success != null) { %>
            <div class="alert ok"><%= success %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/add-reservation"
              method="post"
              novalidate
              class="form-grid two"
              style="margin-top:14px;">

            <div>
                <small>Reservation No</small>
                <input type="text" name="reservationNo" placeholder="e.g. 1001" required>
            </div>

            <div>
                <small>Guest Name</small>
                <input type="text" name="guestName" placeholder="e.g. Nimal Perera" required>
            </div>

            <div>
                <small>Address</small>
                <input type="text" name="address" placeholder="e.g. Galle, Sri Lanka" required>
            </div>

            <div>
                <small>Contact Number</small>
                <input type="text" name="contactNumber" pattern="[0-9]{10}" title="Enter 10 digit number" required>
            </div>

            <div>
                <small>Room Type</small>
                <select name="roomType" required>
                    <option value="">-- Select --</option>
                    <option value="SINGLE">Single</option>
                    <option value="DOUBLE">Double</option>
                    <option value="DELUXE">Deluxe</option>
                    <option value="SUITE">Suite</option>
                </select>
            </div>

            <div></div>

            <div>
                <small>Check-in Date</small>
                <input type="date" name="checkIn" required>
            </div>

            <div>
                <small>Check-out Date</small>
                <input type="date" name="checkOut" required>
            </div>

            <div style="grid-column:1/-1; display:flex; gap:10px; flex-wrap:wrap; margin-top:6px;">
                <button type="submit" class="btn primary" formnovalidate>Save Reservation</button>
                <a href="dashboard.jsp" class="btn ghost">Back</a>
            </div>

        </form>
    </div>

</div>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>