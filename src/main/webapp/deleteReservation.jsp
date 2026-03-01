<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String msg = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Cancel Reservation - Ocean View Resort</title>

    <script>
        function confirmCancel() {
            var resNo = document.getElementById("reservationNo").value;
            if (resNo === "") {
                alert("Please enter Reservation Number!");
                return false;
            }
            return confirm("Are you sure you want to cancel Reservation No: " + resNo + " ?");
        }
    </script>
</head>
<body>

<jsp:include page="includes/header.jsp"/>

<div class="container">

    <div class="card">
        <h1 style="margin:0 0 6px;">Cancel Reservation</h1>
        <small>Enter reservation number to cancel (soft delete)</small>

        <% if (error != null) { %>
            <div class="alert bad"><%= error %></div>
        <% } %>

        <% if (msg != null) { %>
            <div class="alert ok"><%= msg %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/delete-reservation" method="post"
              onsubmit="return confirmCancel();"
              style="margin-top:14px; display:flex; gap:10px; flex-wrap:wrap; align-items:end;">

            <div style="flex:1; min-width:220px;">
                <small>Reservation No</small>
                <input type="number" name="reservationNo" id="reservationNo" placeholder="e.g. 1001" required>
            </div>

            <button class="btn danger" type="submit">Cancel Reservation</button>
            <a class="btn ghost" href="dashboard.jsp">Back</a>
        </form>
    </div>

</div>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>