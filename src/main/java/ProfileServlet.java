import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
public class ProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out=response.getWriter();
        HttpSession session=request.getSession(false);

        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0, post-check=0, pre-check=0");
        response.setHeader("Pragma", "no-cache");

        try {
            if ((session.getAttribute("username")).toString() == null || (session.getAttribute("password")).toString() == null) {
                response.sendRedirect("index.jsp");
                return;
            }
        } catch (Exception e) {
            response.sendRedirect("index.jsp");
            return;
        }

        String name=(String)session.getAttribute("username");
        out.print("Hello, "+name+" Welcome to Profile!");

        out.close();
    }
}