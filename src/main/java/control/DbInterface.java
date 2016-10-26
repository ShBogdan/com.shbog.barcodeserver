package control;


import model.DbHelper;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;


public class DbInterface extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        DbHelper db = new DbHelper();
        try {
            if (null != req.getParameter("getSection")) {
                db.getSection(out);
            }
            if (null != req.getParameter("addCategory")) {
                db.createCategory(req.getParameter("catName"), req.getParameter("sectionId"));
                System.out.println("addCategory");
            }
            if (null != req.getParameter("createProduct")) {
                db.createProduct(req.getParameter("prodCategory"),
                                 req.getParameter("prodProvider"),
                                 req.getParameter("prodName"),
                                 req.getParameter("prodCode"),
                                 req.getParameter("componets_array_ID"),
                                 req.getParameter("varButton")
                );
            }
            if (null != req.getParameter("createAdditive")) {
                System.out.println("createAdditive");
                db.createAdditive(req.getParameter("additiveNamber"),
                                  req.getParameter("additiveName"),
                                  req.getParameter("additiveColor"),
                                  req.getParameter("additiveInfo"),
                                  req.getParameter("additivePermission"),
                                  req.getParameter("additiveCBox"),
                                  req.getParameter("additiveGroup"),
                                  out
                );
            }
            if (null != req.getParameter("changeAdditive")) {
                db.changeAdditive(req.getParameter("additiveId"),
                                  req.getParameter("additiveNamber"),
                                  req.getParameter("additiveName"),
                                  req.getParameter("additiveColor"),
                                  req.getParameter("additiveInfo"),
                                  req.getParameter("additivePermission"),
                                  req.getParameter("additiveCBox"),
                                  req.getParameter("additiveGroup")
                );
            }
            if (null != req.getParameter("changeProduct")) {
                db.changeProduct(req.getParameter("prod_id"),
                                 req.getParameter("prodCategory"),
                                 req.getParameter("prodProvider"),
                                 req.getParameter("prodName"),
                                 req.getParameter("prodCode"),
                                 req.getParameter("componets_array_ID"),
                                 req.getParameter("varButton")
                );
            }
            if (null != req.getParameter("addSection")) {
                db.createSection(req.getParameter("sectionName"));
            }
            if (null != req.getParameter("getProductID")) {
                db.getProductID(out);
            }
            if (null != req.getParameter("getAdditiveByID")) {
                db.getAdditiveByID(out, req.getParameter("additiveID"));
            }
            if (null != req.getParameter("removeSection")) {
                db.removeSection(req.getParameter("sectionId"));
            }
            if (null != req.getParameter("removeCat")) {
                db.removeCategory(req.getParameter("catId"));
            }
            if (null != req.getParameter("renameCat")) {
                db.renameCategory(req.getParameter("catId"), req.getParameter("newName"));
            }
            if (null != req.getParameter("renameSection")) {
                db.renameSection(req.getParameter("sectionId"), req.getParameter("newName"));
            }
            if (null != req.getParameter("getCategory")) {
                db.getCategory(out);
            }
            if (null != req.getParameter("getCompound")) {
                db.getCompound(out, req.getParameter("compoundID"));
            }
            if (null != req.getParameter("getProductCompound")) {
                db.getProductCompound(out, req.getParameter("compoundProductID"));
            }
            if (null != req.getParameter("getProducts")) {
                db.getProducts(out);
            }
            if (null != req.getParameter("getAdditive")) {
                System.out.println("0");
                db.getAdditive(out);
            }
            if (null != req.getParameter("removeProduct")) {
                String prod_id = req.getParameter("prod_id");
                db.removeProduct(prod_id);
            }
            if (null != req.getParameter("removeAdditive")) {
                String additive_id = req.getParameter("additive_id");
                db.removeAdditive(additive_id);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
//        out.print("Hello, GET");
        out.close();
    }
}
