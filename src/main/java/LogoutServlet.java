import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        String message = "Вы успешно вышли.";

        HttpSession session = req.getSession(false);//getSession() То же что и getSession(true) возвращает новую сессию

        session.invalidate();

        RequestDispatcher rs = req.getRequestDispatcher("/jsp/index.jsp");
        req.setAttribute("message", message);
        rs.forward(req, resp);
    }
}
