<%@ page import = "java.sql.*" %>
<%
int classification;
String user_name = "";
try {
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/final_project?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", "root", "root");
	PreparedStatement pst = conn.prepareStatement("Select id, password, classification from user_info where id=? and password=?");
	pst.setString(1, id);
	pst.setString(2, password);
	// user_info table schema (user_number(PK), id, password, name, email, classification)
	ResultSet rs = pst.executeQuery();
	// If there's such a user, then move to another website
	if (rs.next()) {
		classification = rs.getInt("classification");
		id = rs.getString("id");
		session.setAttribute("id", id);
		session.setAttribute("classification", classification);
		// classification: 0(admin) / 1(normal user)
		if (classification == 0) {
			response.sendRedirect("member_list.jsp");
		}
		else {
			// If user is only a buyer, then go to buyer page
			if (classification == 1) {
				response.sendRedirect("product_list_buyer.jsp");
			}
			// If user is a seller, then go to seller page
			else {
				response.sendRedirect("product_list_seller.jsp");
			}
		}
	}
	// There's no matching user. Back to log-in site
	else {
		response.sendRedirect("login.jsp?lErr=There's no matching ID or PASSWORD. Please try agian.");
	}
} catch(Exception e) {
	out.println("Something went wrong !! Please try again");
}
%>