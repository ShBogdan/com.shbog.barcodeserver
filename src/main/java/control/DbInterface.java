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
			if (null != req.getParameter("getBarcodes")) {
//                resp.setContentType("application/json;charset=UTF-8"); //будет глючит success
				db.getBarcodes(out);
				return;
			}
			if (null != req.getParameter("getCategory")) {
				db.getCategory(out);
				return;
			}
			if (null != req.getParameter("getCategoryJSONobj")) {
				db.getCategoryJSONobj(out);
				return;
			}
			if (null != req.getParameter("getSection")) {
				db.getSection(out);
				return;
			}
			if (null != req.getParameter("addCategory")) {
				db.createCategory(req.getParameter("catName"), req.getParameter("sectionId"));
				return;
			}
			if (null != req.getParameter("createType")) {
				db.createType(req.getParameter("typeName"),
						req.getParameter("catName"), out);
				return;
			}
			if (null != req.getParameter("renameType")) {
				db.renameType(
						req.getParameter("type_id"),
						req.getParameter("type_name"),
						req.getParameter("prodCategory_id"),
						req.getParameter("prodCategory_idOld"),
						out);
				return;
			}
			if (null != req.getParameter("createProduct")) {
				db.createProduct(req.getParameter("prodCategory"),
						req.getParameter("prodProvider"),
						req.getParameter("prodName"),
						req.getParameter("prodCode"),
						req.getParameter("componets_array_ID"),
						req.getParameter("varButton"),
						out,
						req.getParameter("prodType")
				);
				return;
			}
			if (null != req.getParameter("createComponent")) {
				System.out.println("createComponent");
				db.createComponent(req.getParameter("additiveNamber"),
						req.getParameter("additiveName"),
						req.getParameter("additiveColor"),
						req.getParameter("additiveInfo"),
						req.getParameter("additivePermission"),
						req.getParameter("additiveCBox"),
						req.getParameter("additiveNotes"),
						req.getParameter("additiveFor"),
						out,
						req.getParameter("additiveType"));
				return;
			}
			if (null != req.getParameter("addExclude")) {
				System.out.println("addExclude");
				db.createExclude(req.getParameter("excludeName"), out);
				return;
			}
			if (null != req.getParameter("changeComponent")) {
				db.changeComponent(req.getParameter("additiveId"),
						req.getParameter("additiveNamber"),
						req.getParameter("additiveName"),
						req.getParameter("additiveColor"),
						req.getParameter("additiveInfo"),
						req.getParameter("additivePermission"),
						req.getParameter("additiveCBox"),
						req.getParameter("additiveFor"),
						req.getParameter("additiveNotes"),
						req.getParameter("additiveType")
				);
				return;
			}
			if (null != req.getParameter("getCBox")) {
				db.getCBox(out);
				return;
			}
			if (null != req.getParameter("changeProduct")) {
				db.changeProduct(req.getParameter("prod_id"),
						req.getParameter("prodCategory"),
						req.getParameter("prodProvider"),
						req.getParameter("prodName"),
						req.getParameter("prodCode"),
						req.getParameter("componets_array_ID"),
						req.getParameter("varButton"),
						out,
						req.getParameter("prodType"));
				return;
			}
			if (null != req.getParameter("addSection")) {
				db.createSection(req.getParameter("sectionName"));
			}
			if (null != req.getParameter("changeUserPass")) {
				db.changeUserPass(req.getParameter("userID"),
						req.getParameter("username"),
						req.getParameter("userPass"));
				return;
			}
			if (null != req.getParameter("getAdditiveByID")) {
				db.getAdditiveByID(out, req.getParameter("additiveID"));
				return;
			}
			if (null != req.getParameter("getBarcodeInfo")) {
				db.getBarcodeInfo(out, req.getParameter("barcode"));
				return;
			}
			if (null != req.getParameter("removeSection")) {
				db.removeSection(req.getParameter("sectionId"));
				return;
			}
			if (null != req.getParameter("removeCat")) {
				db.removeCategory(req.getParameter("catId"));
				return;
			}
			if (null != req.getParameter("renameCat")) {
				db.renameCategory(req.getParameter("catId"), req.getParameter("newName"));
				return;
			}
			if (null != req.getParameter("renameExclude")) {
				db.renameExclude(req.getParameter("excludeId"), req.getParameter("excludeName"));
				return;
			}
			if (null != req.getParameter("renameSection")) {
				db.renameSection(req.getParameter("sectionId"), req.getParameter("newName"));
				return;
			}
			if (null != req.getParameter("getCategory")) {
				db.getCategory(out);
				return;
			}
			if (null != req.getParameter("getExclude")) {
				db.getExclude(out);
				return;
			}
			if (null != req.getParameter("getCompound")) {
				db.getCompound(out, req.getParameter("catId"));
				return;
			}
			if (null != req.getParameter("getProductCompound")) {
				db.getProductCompound(out, req.getParameter("compoundProductID"));
				return;
			}
			if (null != req.getParameter("getProducts")) {
				db.getProducts(out);
				return;
			}
			if (null != req.getParameter("getTypes")) {
				db.getTypes(out);
				return;
			}
			if (null != req.getParameter("getNewProducts")) {
				db.getNewProducts(out);
				return;
			}
			if (null != req.getParameter("getComponents")) {
				db.getComponents(out);
				return;
			}
			if (null != req.getParameter("getComponenNames")) {
				db.getComponenNames(out);
				return;
			}
			if (null != req.getParameter("getProdType")) {
				db.getProdType(out, req.getParameter("setCategory"));
				return;
			}
			if (null != req.getParameter("removeProduct")) {
				String prod_id = req.getParameter("prod_id");
				db.removeProduct(prod_id);
				return;
			}
			if (null != req.getParameter("removeType")) {
				String type_id = req.getParameter("type_id");
				db.removeType(type_id);
				return;
			}
			if (null != req.getParameter("removeTempProducts")) {
				String prod_id = req.getParameter("prod_id");
				db.removeTempProducts(prod_id);
				return;
			}
			if (null != req.getParameter("removeComponent")) {
				String additive_id = req.getParameter("additive_id");
				db.removeComponent(additive_id);
				return;
			}
			if (null != req.getParameter("removeExclude")) {
				String exclude_id = req.getParameter("exclude_id");
				db.removeExclude(exclude_id);
				return;
			}
			if (null != req.getParameter("getProdGroupByDate")) {
				db.getProdGroupByDate(out, req.getParameter("startDate"), req.getParameter("endDate"));
				return;
			}
			if (null != req.getParameter("createProdPhone")) {
				if (req.getParameter("pass").equals("androidapppass")) {
					db.createProdPhone(req.getParameter("cat"), req.getParameter("code"));
				}
				return;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/html;charset=UTF-8");
		doPost(req, resp);
	}

}
