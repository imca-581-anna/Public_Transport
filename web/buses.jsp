
<%@ page import="java.sql.*" %>
<%@ page import="com.transport.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Track Buses</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<header>
    <h1>Bus Tracking</h1>
    <p>View available buses and their estimated arrival times</p>
</header>

<nav>
    <a href="index.jsp">Home</a>
    <a href="buses.jsp">Track Buses</a>
    <a href="routes.jsp">Routes</a>
    <a href="timetable.jsp">Timetable</a>
    <a href="delays.jsp">Delays</a>
    <a href="alternatives.jsp">Alternative Routes</a>
</nav>

<main>
    <h2>Available Buses</h2>

    <table border="1" cellpadding="10"
           cellspacing="0" width="100%">
        <tr>
            <th>Bus ID</th>
            <th>Bus Number</th>
            <th>Route</th>
            <th>Current Location</th>
            <th>Estimated Arrival</th>
            <th>Status</th>
        </tr>

        <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT b.bus_id, b.bus_number, r.route_name, " +
                "b.current_location, b.estimated_arrival, b.status " +
                "FROM buses b LEFT JOIN routes r " +
                "ON b.route_id = r.route_id ORDER BY b.bus_id");
             ResultSet rs = ps.executeQuery()) {

            boolean found = false;

            while (rs.next()) {
                found = true;
        %>

        <tr>
            <td><%= rs.getInt("bus_id") %></td>
            <td><%= rs.getString("bus_number") %></td>
            <td><%= rs.getString("route_name") == null
                    ? "Not assigned" : rs.getString("route_name") %></td>
            <td><%= rs.getString("current_location") == null
                    ? "Unknown" : rs.getString("current_location") %></td>
            <td><%= rs.getString("estimated_arrival") == null
                    ? "Not available" : rs.getString("estimated_arrival") %></td>
            <td><%= rs.getString("status") %></td>
        </tr>

        <%
            }

            if (!found) {
        %>
        <tr><td colspan="6">No buses available.</td></tr>
        <%
            }

        } catch (Exception e) {
        %>
        <tr>
            <td colspan="6">Unable to load bus details.
                Check the database connection.</td>
        </tr>
        <%
            application.log("Error loading buses", e);
        }
        %>
    </table>
</main>

</body>
</html>
