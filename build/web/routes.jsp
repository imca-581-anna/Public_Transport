
<%@ page import="java.sql.*" %>
<%@ page import="com.transport.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Bus Routes</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<header>
    <h1>Bus Routes</h1>
    <p>Find routes and their destinations</p>
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
    <h2>Available Routes</h2>

    <table border="1" cellpadding="10"
           cellspacing="0" width="100%">
        <tr>
            <th>Route ID</th>
            <th>Route Name</th>
            <th>Starting Point</th>
            <th>Destination</th>
            <th>Bus Stops</th>
        </tr>

        <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT r.route_id, r.route_name, r.start_point, " +
                "r.end_point, GROUP_CONCAT(s.stop_name " +
                "ORDER BY s.stop_id SEPARATOR ' -> ') AS stops " +
                "FROM routes r LEFT JOIN bus_stops s " +
                "ON r.route_id = s.route_id " +
                "GROUP BY r.route_id, r.route_name, " +
                "r.start_point, r.end_point ORDER BY r.route_id");
             ResultSet rs = ps.executeQuery()) {

            boolean found = false;

            while (rs.next()) {
                found = true;
        %>

        <tr>
            <td><%= rs.getInt("route_id") %></td>
            <td><%= rs.getString("route_name") %></td>
            <td><%= rs.getString("start_point") %></td>
            <td><%= rs.getString("end_point") %></td>
            <td><%= rs.getString("stops") == null
                    ? "No stops added" : rs.getString("stops") %></td>
        </tr>

        <%
            }

            if (!found) {
        %>
        <tr><td colspan="5">No routes available.</td></tr>
        <%
            }

        } catch (Exception e) {
        %>
        <tr>
            <td colspan="5">Unable to load route details.</td>
        </tr>
        <%
            application.log("Error loading routes", e);
        }
        %>
    </table>
</main>

</body>
</html>
