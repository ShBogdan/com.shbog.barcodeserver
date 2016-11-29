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
            servletRequest.setAttribute("message", "Welcome");
            dispatcher.forward(servletRequest, servletResponse);
            return;
        }
        if (path.equals("/barcodeinfo")){
            RequestDispatcher dispatcher = servletRequest.getRequestDispatcher("/DbInterface");
            dispatcher.forward(servletRequest, servletResponse);
            return;
        }
        filterChain.doFilter(servletRequest,servletResponse);
    }
    public void destroy() {
    }
}
