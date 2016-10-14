import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class LoginFilter implements javax.servlet.Filter {

    public void init(FilterConfig filterConfig) throws ServletException {
    }

    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        servletResponse.setContentType("text/html;charset=UTF-8");
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (path.equals("/") || path.equals("/index.jsp")){
            RequestDispatcher dispatcher = servletRequest.getRequestDispatcher("/jsp/index.jsp");
            servletRequest.setAttribute("message", "Добро пожаловать");
            dispatcher.forward(servletRequest, servletResponse);
            System.out.println("выполняеется");
            return;
        }
//        } else if (path.equals("/success.jsp")
//                ||path.equals("/info.jsp")
//                ||path.equals("/catalog.jsp")
//                ||path.equals("/products.jsp")
//                ||path.equals("/additive.jsp")
//                ||path.equals("/limitations.jsp")
//                ||path.equals("/menu.jsp")
//                ||path.equals("/info.jsp")
//                ) {
//            RequestDispatcher dispatcher = servletRequest.getRequestDispatcher("/jsp/"+path);
//            dispatcher.forward(servletRequest, servletResponse);
//        }else if (path.equals("/LoginServlet")){
//            RequestDispatcher dispatcher = servletRequest.getRequestDispatcher("/LoginServlet");
//            dispatcher.forward(servletRequest, servletResponse);
//        }else if (path.equals("/ProfileServlet")) {
//            RequestDispatcher dispatcher = servletRequest.getRequestDispatcher("/ProfileServlet");
//            dispatcher.forward(servletRequest, servletResponse);
//        }else if (path.equals("/LogoutServlet")) {
//            RequestDispatcher dispatcher = servletRequest.getRequestDispatcher("/LogoutServlet");
//            dispatcher.forward(servletRequest, servletResponse);
//        }else if (path.equals("/DbInterface")) {
//            RequestDispatcher dispatcher = servletRequest.getRequestDispatcher("/DbInterface");
//            dispatcher.forward(servletRequest, servletResponse);
//        } else {
//            filterChain.doFilter(servletRequest,servletResponse);
//
//        }
        filterChain.doFilter(servletRequest,servletResponse);
    }

    public void destroy() {
    }
}
