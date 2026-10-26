
<%@ page contentType="text/html;charset=UTF-8"
         language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Public Transport Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<header>
    <h1>Public Transport Management System</h1>
    <p>Your journey, made easier</p>
</header>

<nav>
    <a href="index.jsp">Home</a>
    <a href="buses.jsp">Track Buses</a>
    <a href="routes.jsp">Routes</a>
    <a href="timetable.jsp">Timetable</a>
    <a href="delays.jsp">Bus Delays</a>
    <a href="alternatives.jsp">Alternative Routes</a>
</nav>

<main>
    <h2>Welcome to Public Transport</h2>
    <p>
        Find bus routes, check arrival times,
        and receive service updates.
    </p>

    <div class="cards">
        <div class="card">
            <h3>Bus Tracking</h3>
            <p>View bus location information.</p>
            <a href="buses.jsp">View Buses</a>
        </div>

        <div class="card">
            <h3>Bus Timetable</h3>
            <p>Check scheduled arrival times.</p>
            <a href="timetable.jsp">View Timetable</a>
        </div>

        <div class="card">
            <h3>Service Alerts</h3>
            <p>Check delays and disruptions.</p>
            <a href="delays.jsp">View Alerts</a>
        </div>
    </div>
</main>

<footer>
    <p>Public Transport Management System</p>
</footer>

</body>
</html>
