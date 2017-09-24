import model.DbHelper;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        String url = req.getContextPath();
        String user = req.getParameter("username");
        String pass = req.getParameter("password");
        String perm = "0";
        boolean isIn = false;

        DbHelper db = new DbHelper();
        ArrayList<String[]> usersArray = new ArrayList<String[]>();
        try {
            usersArray = db.getUsersForPermition();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        for (String[] anUsersArray : usersArray) {
            String user_name = anUsersArray[1];
            String user_pass = anUsersArray[2];
            perm = anUsersArray[3];
            if (user.equals(user_name) && pass.equals(user_pass)) {
                isIn = true;
                break;
            }
        }

        try {
            if (isIn) {
                req.getSession().setAttribute("username", user);
                req.getSession().setAttribute("password", pass);
                req.getSession().setAttribute("permission", perm);
                resp.sendRedirect(url+"/jsp/success.jsp");
            } else {
                RequestDispatcher rs = req.getRequestDispatcher("/jsp/index.jsp");
                req.setAttribute("message", "Не верный пароль");
                rs.forward(req, resp);
                System.out.println("Не верный пароль");
            }
        } catch (Exception e) {
            RequestDispatcher rs = req.getRequestDispatcher("/jsp/index.jsp");
            req.setAttribute("message", "Авторизируйтесь");
            rs.forward(req, resp);
            System.out.println("Не верный пароль catch");
        }
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }
}