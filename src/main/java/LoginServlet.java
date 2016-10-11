import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        try {
            if ((user.equals("1")) && (pass.equals("1"))) {

                req.getSession().setAttribute("username", user);
                req.getSession().setAttribute("password", pass);
//                req.setAttribute("username", user);
                resp.sendRedirect("/jsp/success.jsp");
            } else {

                RequestDispatcher rs = req.getRequestDispatcher("/index.jsp");
                req.setAttribute("message", "Не верный пароль");
                rs.forward(req, resp);
            }
        } catch (Exception e) {
            RequestDispatcher rs = req.getRequestDispatcher("/index.jsp");
            req.setAttribute("message", "Авторизируйтесь");
            rs.forward(req, resp);
        }

    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }
}