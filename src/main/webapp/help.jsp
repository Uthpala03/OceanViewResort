<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Help - Ocean View Resort</title>
</head>
<body>

<jsp:include page="includes/header.jsp"/>

<div class="container">

    <div class="card">
        <h1 style="margin:0 0 6px;">
            <i class="fa-solid fa-circle-question"></i> Help & User Guide
        </h1>
        <small>Step-by-step guide for staff to use the Ocean View Resort Reservation System</small>
    </div>

    <div style="height:14px;"></div>

    <!-- ✅ Quick tips card -->
    <div class="card">
        <h2 style="margin:0 0 10px;">
            <i class="fa-solid fa-lightbulb"></i> Quick Tips
        </h2>

        <ul style="margin:0; padding-left:18px; line-height:1.9;">
            <li>Always <b>Login</b> first before using the system.</li>
            <li>Use <b>Reservation No</b> as a unique number for each guest.</li>
            <li>Use <b>Calculate Bill</b> before printing or saving payment.</li>
            <li>After customer pays, click <b>Save Payment</b> → status becomes <b>PAID</b>.</li>
        </ul>
    </div>

    <div style="height:14px;"></div>

    <!-- ✅ Step-by-step cards -->
    <div class="card">
        <h2 style="margin:0 0 10px;">
            <i class="fa-solid fa-list-check"></i> Step-by-Step Guide
        </h2>
        <small>Follow these steps in order</small>

        <div style="height:12px;"></div>

        <!-- simple grid using existing form-grid -->
        <div class="form-grid two">

            <div class="card" style="box-shadow:none;">
                <h3 style="margin:0 0 8px;"><i class="fa-solid fa-right-to-bracket"></i> 1) Login</h3>
                <small>Enter username + password, then click Login.</small>
            </div>

            <div class="card" style="box-shadow:none;">
                <h3 style="margin:0 0 8px;"><i class="fa-solid fa-calendar-plus"></i> 2) Add Reservation</h3>
                <small>Fill guest details + room type + dates, then click Save.</small>
            </div>

            <div class="card" style="box-shadow:none;">
                <h3 style="margin:0 0 8px;"><i class="fa-solid fa-magnifying-glass"></i> 3) View Reservation</h3>
                <small>Search by reservation number or click Show All.</small>
            </div>

            <div class="card" style="box-shadow:none;">
                <h3 style="margin:0 0 8px;"><i class="fa-solid fa-pen-to-square"></i> 4) Update Reservation</h3>
                <small>Search reservation → edit details → click Update.</small>
            </div>

            <div class="card" style="box-shadow:none;">
                <h3 style="margin:0 0 8px;"><i class="fa-solid fa-ban"></i> 5) Cancel Reservation</h3>
                <small>Enter reservation number and confirm cancellation. (Blocked if already paid.)</small>
            </div>

            <div class="card" style="box-shadow:none;">
                <h3 style="margin:0 0 8px;"><i class="fa-solid fa-receipt"></i> 6) Calculate / Print Bill</h3>
                <small>Calculate bill → Save Payment (if paid) → Print Bill.</small>
            </div>

        </div>
    </div>

    <div style="height:14px;"></div>

    <!-- ✅ Status meanings (creative + clear) -->
    <div class="card">
        <h2 style="margin:0 0 10px;">
            <i class="fa-solid fa-tags"></i> Reservation Status Meanings
        </h2>

        <div style="display:flex; gap:10px; flex-wrap:wrap; margin-top:10px;">
            <span class="badge active"><i class="fa-solid fa-clock"></i> ACTIVE</span>
            <span class="badge paid"><i class="fa-solid fa-circle-check"></i> PAID</span>
            <span class="badge cancelled"><i class="fa-solid fa-circle-xmark"></i> CANCELLED</span>
        </div>

        <div style="margin-top:12px; line-height:1.8;">
            <div><b>ACTIVE</b> — Reservation is saved, but payment is not recorded yet.</div>
            <div><b>PAID</b> — Payment is saved. Reservation is completed.</div>
            <div><b>CANCELLED</b> — Reservation is cancelled (soft delete). Cannot calculate bill for cancelled reservations.</div>
        </div>
    </div>

    <div style="height:14px;"></div>

    <!-- ✅ Safety / Exit -->
    <div class="card">
        <h2 style="margin:0 0 10px;">
            <i class="fa-solid fa-shield-halved"></i> Safe Exit
        </h2>
        <small>Always logout when finished to protect hotel data.</small>

        <div style="margin-top:12px; display:flex; gap:10px; flex-wrap:wrap;">
            <a class="btn danger" href="<%=request.getContextPath()%>/logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout Now
            </a>

            <a class="btn ghost" href="<%=request.getContextPath()%>/dashboard.jsp">
                <i class="fa-solid fa-house"></i> Back to Dashboard
            </a>
        </div>
    </div>

</div>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>