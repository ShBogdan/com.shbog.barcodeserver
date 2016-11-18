package model;

import com.mysql.fabric.jdbc.FabricMySQLDriver;
import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.*;
import java.sql.*;
import java.sql.Connection;
import java.sql.Driver;
import java.util.*;



//
//import org.apache.poi.hssf.usermodel.HSSFWorkbook;
//import org.apache.poi.ss.usermodel.Cell;
//import org.apache.poi.ss.usermodel.Row;
//import org.apache.poi.ss.usermodel.Sheet;

import java.util.Iterator;
import java.util.ArrayList;


import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;



public class DbHelper {

    private  final String URL = "jdbc:mysql://localhost:3306/productsdb";
    private  final String NAME = "root";
    private  final String PASSWORD = "arisen13";
    private  Connection connection = null;
//    private  final String URL = "jdbc:mysql://mysql313.1gb.ua/gbua_productsdb";
//    private  final String NAME = "gbua_productsdb";
//    private  final String PASSWORD = "df14a9c2xvn";
//    private  Connection connection = null;

    public static void main(String[] args) throws SQLException, ParseException, JSONException, IOException {
        DbHelper db = new DbHelper();
//
//        org.json.simple.parser.JSONParser parser = new JSONParser();
//        String json = "{\"name_0:\" \"131,13\", \"name_1:\" \"12,223\"}";
//        org.json.simple.JSONObject jsonObject = null;
//        jsonObject = (org.json.simple.JSONObject) parser.parse(json);
//        for (int i = 0; i < jsonObject.size(); i++) {
//            System.out.println(jsonObject.get("name_"+i+":"));
//        }

//        db.parse("C:\\test2.xls");

//        FileReader input = new FileReader("C:\\\\cat.txt");
//        BufferedReader bufRead = new BufferedReader(input);
//        String myLine = null;
//        String count = "";
//        while ( (myLine = bufRead.readLine()) != null)
//        {
//            if(!myLine.contains("\t")){
//                db.createSection(myLine.trim());
//                System.out.println(myLine.trim());
//                String query = "SELECT LAST_INSERT_ID() as last_id from section;";
//                Statement stmt = db.connection.createStatement();
//                ResultSet resultSet = stmt.executeQuery(query);
//                resultSet.next();
//                count = resultSet.getString("last_id");
//            }else{
//                db.createCategory(myLine.trim(), count);
//                System.out.println(myLine.trim());
//            }
//
//        }

    }

    public DbHelper() {
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Driver driver = new FabricMySQLDriver();
            DriverManager.registerDriver(driver);
            connection = DriverManager.getConnection(URL, NAME, PASSWORD);
        } catch (SQLException e) {
//            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            return;
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        if (connection != null) {
//            System.out.println("You made it, take model your database now!");
        } else {
            System.out.println("Failed to make connection!");
        }
    }

    public void createCategory(String cat, String sectionId) throws SQLException {
        if(cat != null && !cat.trim().isEmpty()) {
//            String statement = "INSERT INTO categories(cat_name, section_id_frk, components) VALUE (?,?,?)";
            String statement = "INSERT INTO categories(cat_name, section_id_frk) VALUE (?,?)";
            PreparedStatement preparedStatement = connection.prepareStatement(statement);
            preparedStatement.setString(1, cat);
            preparedStatement.setString(2, sectionId);
//            preparedStatement.setString(3, "");
            preparedStatement.execute();
            if(connection!=null)
                connection.close();
        }
    }
    public void createSection(String section) throws SQLException {
        if(section != null && !section.trim().isEmpty()){
            String statement = "INSERT INTO section(section_name) VALUE (?)";
            PreparedStatement preparedStatement = connection.prepareStatement(statement);
            preparedStatement.setString(1, section);
            preparedStatement.execute();
            if(connection!=null)
                connection.close();
        }
    }
    public PrintWriter createProduct(String prodCategory_id, String prodProvider, String prodName, String prodCode, String componets_array_ID, String varButton, PrintWriter out) {

        PreparedStatement prepSat;
        ResultSet resultSet;
        Statement stmt;
        Set<String> input_components_ID = new HashSet<String>(new ArrayList<String>(Arrays.asList(componets_array_ID.split(","))));
        Set<String> input_components_name = new HashSet<String>();
        if(varButton != null && !varButton.isEmpty()){
            org.json.simple.parser.JSONParser parser = new JSONParser();
            org.json.simple.JSONObject jsonObject = null;
            try {
                jsonObject = (org.json.simple.JSONObject) parser.parse(varButton);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            for (int i = 0; i < jsonObject.size(); i++) {
                input_components_name.add((String) jsonObject.get("name_"+i));
            }
        }
        input_components_ID.remove("");
        try {
            //создаем новый компонент или обновляем старый
            for (String s : input_components_name) {
                String statement_add_component = "INSERT INTO component(comp_name) VALUE (?) ON DUPLICATE KEY UPDATE comp_name = ?";
                prepSat = connection.prepareStatement(statement_add_component);
                prepSat.setString(1, s);
                prepSat.setString(2, s);
                prepSat.execute();
            }
            System.out.println("Список компонентов продукта до: " +input_components_ID);

            //получаем id добавленных компонентов
            for (String s : input_components_name) {
                String statement_get_componentID = "SELECT comp_id FROM component WHERE comp_name=\""+s+"\"";
                stmt = connection.createStatement();
                resultSet = stmt.executeQuery(statement_get_componentID);
                resultSet.next();
                input_components_ID.add(resultSet.getString("comp_id"));
            }
            System.out.println("Список компонентов продукта после: " +input_components_ID);

            //создаем продукт до обновления input_components_ID
            String statement = "INSERT INTO product(cat_id_frk, prod_maker, prod_name, prod_code) VALUE (?,?,?,?);";
            prepSat = connection.prepareStatement(statement);
            prepSat.setString(1, prodCategory_id);
            prepSat.setString(2, prodProvider);
            prepSat.setString(3, prodName);
            prepSat.setString(4, prodCode);
            prepSat.execute();

            String prodId;
            String query = "SELECT LAST_INSERT_ID() as last_id from product;";
            stmt = connection.createStatement();
            resultSet = stmt.executeQuery(query);
            resultSet.next();
            prodId = resultSet.getString("last_id");
            out.println(prodId);
            out.flush();

            for (String s : input_components_ID) {
                String qInsertFrk = "INSERT INTO frkgroup(cat, prod, compon) VALUE (?,?,?)";
                prepSat = connection.prepareStatement(qInsertFrk);
                prepSat.setString(1, prodCategory_id);
                prepSat.setString(2, prodId);
                prepSat.setString(3, s);
                prepSat.execute();
            }
        } catch (MySQLIntegrityConstraintViolationException e){
            out.println("-1");
            out.flush();
        } catch (SQLException   e) {
            e.printStackTrace();
        } finally {
            System.out.println("Запись:" + prodName + " добавлен");
            if(connection!=null)
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            return out;
        }
    }
    public PrintWriter createComponent(String additiveNamber, String additiveName, String additiveColor, String additiveInfo, String additivePermission, String additiveCBox, String additiveFor, String additiveNotes, PrintWriter out, String additiveType) throws SQLException {
        //создаем ключевой компонет, дополнительные имена добавляются как компоненты с пустыми полями.
        List<String> names = new ArrayList<String>();
        String mainId;

        org.json.simple.parser.JSONParser parser = new JSONParser();
        org.json.simple.JSONObject jsonObject = null;
        try {
            jsonObject = (org.json.simple.JSONObject) parser.parse(additiveName);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        for (int i = 0; i < jsonObject.size(); i++) {
            names.add((String) jsonObject.get("name_"+i));
        }

        String statement = "INSERT INTO component(comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_for, comp_notes, comp_type) VALUE (?,?,?,?,?,?,?,?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, names.get(0));
        preparedStatement.setString(2, additiveNamber);
        preparedStatement.setString(3, additiveInfo);
        preparedStatement.setString(4, additivePermission);
        preparedStatement.setString(5, additiveColor);
        preparedStatement.setString(6, additiveCBox);
        preparedStatement.setString(7, additiveFor);
        preparedStatement.setString(8, additiveNotes);
        preparedStatement.setString(9, additiveType);
        preparedStatement.execute();

        String query = "SELECT LAST_INSERT_ID() as last_id from component;";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        resultSet.next();
        mainId = resultSet.getString("last_id");
        out.println(mainId);
        out.flush();

        for (int i = 1; i < names.size(); i++) {
            statement = "INSERT INTO component(comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_for, comp_notes, comp_type, comp_group) VALUE (?,?,?,?,?,?,?,?,?,?)";
            preparedStatement = connection.prepareStatement(statement);
            preparedStatement.setString(1, names.get(i));
            preparedStatement.setString(2, additiveNamber);
            preparedStatement.setString(3, additiveInfo);
            preparedStatement.setString(4, additivePermission);
            preparedStatement.setString(5, additiveColor);
            preparedStatement.setString(6, additiveCBox);
            preparedStatement.setString(7, additiveFor);
            preparedStatement.setString(8, additiveNotes);
            preparedStatement.setString(9, additiveType);
            preparedStatement.setString(10, mainId);
            preparedStatement.execute();
         }

        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter createExclude(String excludeName, PrintWriter out) throws SQLException {

        String statement = "INSERT INTO exclude(ogran_name) VALUE (?)";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, excludeName);
        preparedStatement.execute();

        String query = "SELECT LAST_INSERT_ID() as last_id from exclude;";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        resultSet.next();
        out.println(resultSet.getString("last_id"));
        out.flush();

        if(connection!=null)
            connection.close();
        return out;
    }
    public void changeComponent(String additiveId,String additiveNamber, String additiveName, String additiveColor, String additiveInfo, String additivePermission, String additiveCBox, String additiveFor, String additiveNotes, String additiveType) throws SQLException {
        List<String> names = new ArrayList<String>();

        org.json.simple.parser.JSONParser parser = new JSONParser();
        org.json.simple.JSONObject jsonObject = null;
        try {
            jsonObject = (org.json.simple.JSONObject) parser.parse(additiveName);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        for (int i = 0; i < jsonObject.size(); i++) {
            names.add((String) jsonObject.get("name_"+i));
        }
        List<String> copyNames = new ArrayList<String>(names);
        copyNames.remove(0);

        String statement = "UPDATE component SET comp_name = ?, comp_e_code = ?, comp_info = ?, comp_perm = ?, comp_color = ?, comp_cbox = ?, comp_for = ?, comp_notes = ?, comp_type = ? WHERE comp_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, names.get(0));
        preparedStatement.setString(2, additiveNamber);
        preparedStatement.setString(3, additiveInfo);
        preparedStatement.setString(4, additivePermission);
        preparedStatement.setString(5, additiveColor);
        preparedStatement.setString(6, additiveCBox);
        preparedStatement.setString(7, additiveFor);
        preparedStatement.setString(8, additiveNotes);
        preparedStatement.setString(9, additiveType);
        preparedStatement.setString(10, additiveId);
        preparedStatement.execute();
        //получаем id всех текущих названий
        statement = "SELECT comp_id, comp_name FROM component WHERE comp_group=" + additiveId;
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(statement);
        while (resultSet.next()){
            if(names.contains(resultSet.getString("comp_name"))){
                copyNames.remove(resultSet.getString("comp_name"));
                String _statement = "UPDATE component SET comp_name = ?, comp_e_code = ?, comp_info = ?, comp_perm = ?, comp_color = ?, comp_cbox = ?, comp_for = ?, comp_notes = ?, comp_type = ?, comp_group=? WHERE comp_id = ?";
                PreparedStatement _preparedStatement = connection.prepareStatement(_statement);
                _preparedStatement.setString(1, resultSet.getString("comp_name"));
                _preparedStatement.setString(2, additiveNamber);
                _preparedStatement.setString(3, additiveInfo);
                _preparedStatement.setString(4, additivePermission);
                _preparedStatement.setString(5, additiveColor);
                _preparedStatement.setString(6, additiveCBox);
                _preparedStatement.setString(7, additiveFor);
                _preparedStatement.setString(8, additiveNotes);
                _preparedStatement.setString(9, additiveType);
                _preparedStatement.setString(10, additiveId);
                _preparedStatement.setString(11, resultSet.getString("comp_id"));
                _preparedStatement.execute();
                System.out.println("Изменяем");
            } else {
                String tempStatement = "DELETE FROM component WHERE comp_id = ?";
                PreparedStatement tempPreparedStatement = connection.prepareStatement(tempStatement);
                tempPreparedStatement.setString(1, resultSet.getString("comp_id"));
                tempPreparedStatement.execute();
            }
        }
        System.out.println(names.toString());
        System.out.println(copyNames.toString());

        //Создаем новые
        for (int i = 0; i < copyNames.size(); i++) {
            statement = "INSERT INTO component(comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_for, comp_notes, comp_type, comp_group) VALUE (?,?,?,?,?,?,?,?,?,?)";
            preparedStatement = connection.prepareStatement(statement);
            preparedStatement.setString(1, copyNames.get(i));
            preparedStatement.setString(2, additiveNamber);
            preparedStatement.setString(3, additiveInfo);
            preparedStatement.setString(4, additivePermission);
            preparedStatement.setString(5, additiveColor);
            preparedStatement.setString(6, additiveCBox);
            preparedStatement.setString(7, additiveFor);
            preparedStatement.setString(8, additiveNotes);
            preparedStatement.setString(9, additiveType);
            preparedStatement.setString(10, additiveId);
            preparedStatement.execute();
        }
        if(connection!=null)
            connection.close();
    }
    public PrintWriter changeProduct(String prod_id, String prodCategory_id, String prodProvider, String prodName, String prodCode, String componets_array_ID, String varButton, PrintWriter out) {
        PreparedStatement prepSat;
        ResultSet resultSet;
        Statement stmt;
        Set<String> input_components_ID = new HashSet<String>(new ArrayList<String>(Arrays.asList(componets_array_ID.split(","))));
        Set<String> input_components_name = new HashSet<String>();
        if(varButton != null && !varButton.isEmpty()){
            org.json.simple.parser.JSONParser parser = new JSONParser();
            org.json.simple.JSONObject jsonObject = null;
            try {
                jsonObject = (org.json.simple.JSONObject) parser.parse(varButton);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            for (int i = 0; i < jsonObject.size(); i++) {
                input_components_name.add((String) jsonObject.get("name_"+i));
            }
        }
        input_components_ID.remove("");
        try {
            //создаем новый компонент
            for (String s : input_components_name) {
                String statement_add_component = "INSERT INTO component(comp_name) VALUE (?) ON DUPLICATE KEY UPDATE comp_name = ?";
                prepSat = connection.prepareStatement(statement_add_component);
                prepSat.setString(1, s);
                prepSat.setString(2, s);
                prepSat.execute();
            }

            //получаем id добавленных компонентов
            for (String s : input_components_name) {
                String statement_get_componentID = "SELECT comp_id FROM component WHERE comp_name=\""+s+"\"";
                stmt = connection.createStatement();
                resultSet = stmt.executeQuery(statement_get_componentID);
                resultSet.next();
                input_components_ID.add(resultSet.getString("comp_id"));
            }

            //создаем продукт до обновления input_components_ID
//        String statement = "UPDATE product SET cat_id_frk = ?, prod_maker = ?, prod_name = ?, prod_code = ?, components = ? WHERE prod_id = ?";
            String statement = "UPDATE product SET cat_id_frk = ?, prod_maker = ?, prod_name = ?, prod_code = ? WHERE prod_id = ?";
            prepSat = connection.prepareStatement(statement);
            prepSat.setString(5, prod_id);
            prepSat.setString(1, prodCategory_id);
            prepSat.setString(2, prodProvider);
            prepSat.setString(3, prodName);
            prepSat.setString(4, prodCode);
            prepSat.execute();


            statement = "DELETE FROM frkgroup WHERE prod = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(statement);
            preparedStatement.setString(1, prod_id);
            preparedStatement.execute();


            for (String s : input_components_ID) {
                String qInsertFrk = "INSERT INTO frkgroup(cat, prod, compon) VALUE (?,?,?)";
                prepSat = connection.prepareStatement(qInsertFrk);
                prepSat.setString(1, prodCategory_id);
                prepSat.setString(2, prod_id);
                prepSat.setString(3, s);
                prepSat.execute();
            }
        } catch (MySQLIntegrityConstraintViolationException e){
            out.println("-1");
            out.flush();
        } catch (SQLException   e) {
            e.printStackTrace();
        } finally {
            if(connection!=null)
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            return out;
        }
    }
    public void removeCategory(String cat_id) throws SQLException {
        String statement = "DELETE FROM categories WHERE cat_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, cat_id);
        preparedStatement.execute();
        if(connection!=null)
            connection.close();
    }
    public void removeSection(String sectionId) throws SQLException {
        String statement = "DELETE FROM section WHERE section_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, sectionId);
        preparedStatement.execute();
        if(connection!=null)
            connection.close();
    }
    public void removeProduct(String prod_id) throws SQLException {
        String statement = "DELETE FROM product WHERE prod_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, prod_id);
        preparedStatement.execute();

        statement = "DELETE FROM frkgroup WHERE prod = ?";
        preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, prod_id);
        preparedStatement.execute();

        if(connection!=null)
            connection.close();
    }
    public void removeTempProducts(String prod_id) throws SQLException {
        String statement = "DELETE FROM newproducts WHERE prod_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, prod_id);
        preparedStatement.execute();
        if(connection!=null)
            connection.close();
    }
    public void removeComponent(String additive_id) throws SQLException {
        String statement = "DELETE FROM component WHERE comp_id = ? or comp_group = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, additive_id);
        preparedStatement.setString(2, additive_id);
        preparedStatement.execute();

        if(connection!=null)
            connection.close();
    }
    public void removeExclude(String exclude_id) throws SQLException {
        String statement = "DELETE FROM exclude WHERE ogran_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, exclude_id);
        preparedStatement.execute();
        System.out.println("Запись:" + exclude_id +" удалена");
        if(connection!=null)
            connection.close();
    }
    public void renameCategory(String cat_id, String catName) throws SQLException {
        String statement = "UPDATE categories SET cat_name=? WHERE cat_id=?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, catName);
        preparedStatement.setString(2, cat_id);
        preparedStatement.execute();
        System.out.println("Запись:" + catName +" переименована");
        if(connection!=null)
            connection.close();
    }
    public void renameExclude(String exclude_id, String excludeName) throws SQLException {
        String statement = "UPDATE exclude SET ogran_name=? WHERE ogran_id=?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, excludeName);
        preparedStatement.setString(2, exclude_id);
        preparedStatement.execute();
        if(connection!=null)
            connection.close();
    }
    public void renameSection(String sectionId, String secName) throws SQLException {
        String statement = "UPDATE section SET section_name=? WHERE section_id=?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, secName);
        preparedStatement.setString(2, sectionId);
        preparedStatement.execute();
        System.out.println("Запись:" + secName +" переименована");
        if(connection!=null)
            connection.close();
    }
    public PrintWriter getCategory(PrintWriter out) throws SQLException {
        String query = "SELECT cat_id, cat_name FROM categories ORDER BY cat_name";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        while (resultSet.next()){
            JSONArray ja = new JSONArray();
            String id = String.valueOf(resultSet.getInt("cat_id"));
            String cat_name = resultSet.getString("cat_name");
            ja.put(id);
            ja.put(cat_name);
            array.put(ja);
        }
        try {
            result.put("category", array);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        out.println(array);
//        out.println(result);
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getBarcodeInfo(PrintWriter out, String barcode) throws SQLException {
        String prod_id;
        String cat_id_frk;
        String cat_name;
        String prod_name;
        String prod_maker;
        String prod_components;

        String query = "SELECT prod_id, cat_id_frk, prod_name, prod_maker, components FROM product WHERE prod_code="+barcode;
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        resultSet.next();
        prod_id = resultSet.getString("prod_id");
        cat_id_frk = resultSet.getString("cat_id_frk");
        prod_name = resultSet.getString("prod_name");
        prod_maker = resultSet.getString("prod_maker");
        prod_components = resultSet.getString("components");

        query = "SELECT cat_name FROM categories WHERE cat_id="+cat_id_frk;
        stmt = connection.createStatement();
        resultSet = stmt.executeQuery(query);
        resultSet.next();
        cat_name = resultSet.getString("cat_name");


        JSONObject result = new JSONObject();
        JSONArray ja = new JSONArray();
        ja.put(prod_id);
        ja.put(cat_name);
        ja.put(prod_name);
        ja.put(prod_maker);
        ja.put(prod_components);
        try {
            result.put("barcode",ja);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        out.println(result);
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getSection(PrintWriter out) throws SQLException {
        String query = "SELECT section_id, section_name FROM section ORDER BY section_name";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        int count = 1;
        int _count = 1;
        while (resultSet.next()){
            out.println("<tbody id="+resultSet.getString("section_id")+">");
            out.println("<tr class=\"par\">");
            out.println("<td class=\"parent\">&nbsp;&nbsp;"+count+". "+resultSet.getString("section_name")+"</td>");
            out.println("<td class=\"remove-"+resultSet.getString("section_id")+"\"><button>&#215;</button>&nbsp;&nbsp;</td>");
            out.println("<td class=\"rename-"+resultSet.getString("section_id")+"\"><button>&#8601;</button>&nbsp;&nbsp;</td>");
            out.println("<td class=\"addCategory-"+resultSet.getString("section_id")+"\"><button>&#43;</button>&nbsp;&nbsp;</td>");
            out.println("</tr>");
            String _query = "SELECT cat_id, cat_name FROM categories WHERE section_id_frk = " + resultSet.getString("section_id");
            Statement _stmt = connection.createStatement();
            ResultSet _resultSet = _stmt.executeQuery(_query);
            while (_resultSet.next()){
                out.println("<tr class=\"child-"+ resultSet.getString("section_id")+"\"  id = \""+_resultSet.getString("cat_id")+"\">"); //style="display:none"
                out.println("<td>"+"&nbsp;&nbsp;&nbsp;&nbsp;"+count+"."+_count+". "+_resultSet.getString("cat_name") +"</td>");
                out.println("<td class=\"removeCat\"><button>&#215;</button>&nbsp;&nbsp;</td>");
                out.println("<td class=\"renameCat\"><button >&#8601;</button>&nbsp;&nbsp;</td>");
                out.println("<td></td>");
                out.println("</tr>");
                _count++;
            }
            _count = 1;
            count++;
            out.println("</tbody>");
        }
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getCompound(PrintWriter out, String catId) throws SQLException {
        ArrayList<String> componArrId = new ArrayList<String>();
        String statement = "SELECT compon FROM frkgroup WHERE cat=" + catId;
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(statement);
        while (resultSet.next()){
            componArrId.add(resultSet.getString("compon"));
        }
        if(componArrId.size()!=0){
            String _statement = "SELECT * FROM component WHERE comp_id IN"+"(" +componArrId.toString().substring(1, componArrId.toString().length()-1).replaceAll("\\s+","")+")";
            Statement _stmt = connection.createStatement();
            ResultSet _resultSet = _stmt.executeQuery(_statement);
            while (_resultSet.next()) {
                out.println("<button class=\"btnCompound\" id=\""+_resultSet.getString("comp_id")+"\">"+_resultSet.getString("comp_name")+"</button>");
            }
        }
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getProductCompound(PrintWriter out, String productID) throws SQLException {
        ArrayList<String> componArrId = new ArrayList<String>();
        String statement = "SELECT compon FROM frkgroup WHERE prod=" + productID;
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(statement);
        try {
            while (resultSet.next()){
                componArrId.add(resultSet.getString("compon"));
            }
        } catch (SQLException e) {
            System.out.println("нет компонентов");
        }
        String listId = componArrId.toString().substring(1, componArrId.toString().length()-1).replaceAll("\\s+","");
        if(listId.length()>0){
            String _statement = "SELECT * FROM component WHERE comp_id IN "+"(" + listId +")";
            Statement _stmt = connection.createStatement();
            ResultSet _resultSet = _stmt.executeQuery(_statement);
            while (_resultSet.next()) {
                out.println("<button class=\"varButton\" id=\""+_resultSet.getString("comp_id")+"\">"+_resultSet.getString("comp_name")+"</button>");
            }
        }
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getProducts(PrintWriter out) throws SQLException{
        String query = "SELECT prod_id, cat_name, prod_name, prod_maker, prod_code FROM product INNER JOIN categories ON cat_id_frk=cat_id";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        while (resultSet.next()){
            JSONArray ja = new JSONArray();
            String id = String.valueOf(resultSet.getInt("prod_id"));
            String cat_name = resultSet.getString("cat_name");
            String prod_maker = resultSet.getString("prod_maker");
            String prod_name = resultSet.getString("prod_name");
            String prod_code = resultSet.getString("prod_code");
            ja.put(id);
            ja.put(cat_name);
            ja.put(prod_maker);
            ja.put(prod_name);
            ja.put(prod_code);
            array.put(ja);
        }
        try {
            result.put("products", array);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        out.println(result);
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getNewProducts(PrintWriter out) throws SQLException{
        String query = "SELECT prod_id, cat_name,  prod_code FROM newproducts INNER JOIN categories ON cat_id_frk=cat_id";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        while (resultSet.next()){
            JSONArray ja = new JSONArray();
            String id = String.valueOf(resultSet.getInt("prod_id"));
            String cat_name = resultSet.getString("cat_name");
            String prod_code = resultSet.getString("prod_code");
            ja.put(id);
            ja.put(cat_name);
            ja.put(prod_code);
            array.put(ja);
        }
        try {
            result.put("newproducts", array);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        out.println(result);
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getExclude(PrintWriter out) throws SQLException{
        String query = "SELECT ogran_id, ogran_name FROM exclude";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        while (resultSet.next()){
            JSONArray ja = new JSONArray();
            String id = String.valueOf(resultSet.getInt("ogran_id"));
            String ogran_name = resultSet.getString("ogran_name");
            ja.put(id);
            ja.put(ogran_name);
            ja.put("free");
            array.put(ja);
        }
        try {
            result.put("exclude", array);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        out.println(result);
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getComponenNames(PrintWriter out) throws SQLException{
        String query = "SELECT comp_id, comp_for, comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_notes, comp_group, comp_type FROM component"; //  WHERE COALESCE(comp_group, '') = ''
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        while (resultSet.next()){
            JSONArray ja = new JSONArray();
            String id = String.valueOf(resultSet.getInt("comp_id"));
            String additive_for = resultSet.getString("comp_for");
            String additive_name = resultSet.getString("comp_name");
            String additive_code = resultSet.getString("comp_e_code");
            String additive_info = resultSet.getString("comp_info");
            String additive_perm = resultSet.getString("comp_perm");
            Integer additive_color = resultSet.getInt("comp_color");
            String additive_cbox = resultSet.getString("comp_cbox");
            String additive_notes = resultSet.getString("comp_notes");
            String additive_group = resultSet.getString("comp_group");
            String additive_type = resultSet.getString("comp_type");
            ja.put(id);
            ja.put(additive_for);
            ja.put(additive_code);
            ja.put(additive_name);
            ja.put(additive_info);
            ja.put(additive_perm);
            ja.put(additive_notes);
            ja.put(additive_color);
            ja.put(additive_cbox);
            ja.put(additive_group);
            ja.put(additive_type);
            array.put(ja);
        }
        try {
            result.put("additive", array);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        out.println(result);
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getComponents(PrintWriter out) throws SQLException{
        String query = "SELECT comp_id, comp_for, comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_notes, comp_group, comp_type FROM component WHERE COALESCE(comp_group, '') = ''";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        while (resultSet.next()){
            JSONArray ja = new JSONArray();
            String id = String.valueOf(resultSet.getInt("comp_id"));
            String additive_for = resultSet.getString("comp_for");
            String additive_name = resultSet.getString("comp_name");
            String additive_code = resultSet.getString("comp_e_code");
            String additive_info = resultSet.getString("comp_info");
            String additive_perm = resultSet.getString("comp_perm");
            Integer additive_color = resultSet.getInt("comp_color");
            String additive_cbox = resultSet.getString("comp_cbox");
            String additive_notes = resultSet.getString("comp_notes");
            String additive_group = resultSet.getString("comp_group");
            String additive_type = resultSet.getString("comp_type");
            ja.put(id);
            ja.put(additive_type);
            ja.put(additive_for);
            ja.put(additive_code);
            ja.put(additive_name);
            ja.put(additive_info);
            ja.put(additive_perm);
            ja.put(additive_notes);
            ja.put(additive_color);
            ja.put(additive_cbox);
            ja.put(additive_group);
            array.put(ja);
        }
        try {
            result.put("additive", array);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        out.println(result);
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getCBox(PrintWriter out) throws SQLException{
        String query = "SELECT ogran_id, ogran_name FROM exclude"; // WHERE comp_type = 1
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        while (resultSet.next()){
            JSONArray ja = new JSONArray();
            String id = String.valueOf(resultSet.getInt("ogran_id"));
            String additive_name = resultSet.getString("ogran_name");
            ja.put(id);
            ja.put(additive_name);
            array.put(ja);
        }
        try {
            result.put("exclude", array);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        out.println(result);
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getAdditiveByID(PrintWriter out, String compId) throws SQLException{
        String query = "SELECT comp_id, comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_group FROM component WHERE comp_id="+compId;
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        resultSet.next();
        JSONObject result = new JSONObject();
        JSONArray ja = new JSONArray();
        String id = String.valueOf(resultSet.getInt("comp_id"));
        String additive_name = resultSet.getString("comp_name");
        String additive_code = resultSet.getString("comp_e_code");
        String additive_info = resultSet.getString("comp_info");
        String additive_perm = resultSet.getString("comp_perm");
        Integer additive_color = resultSet.getInt("comp_color");
        String additive_cbox = resultSet.getString("comp_cbox");
        String additive_group = resultSet.getString("comp_group");
        ja.put(id);
        ja.put(additive_name);
        ja.put(additive_code);
        ja.put(additive_info);
        ja.put(additive_perm);
        ja.put(additive_color);
        ja.put(additive_cbox);
        ja.put(additive_group);
        try {
            result.put("component",ja);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        out.println(result);
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public ArrayList getUsers() throws SQLException{
        String query = "SELECT user_id, user_name, user_permit, user_pass FROM users";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        ArrayList<String[]> userArray = new ArrayList<String[]>();
        while (resultSet.next()) {
            String id = String.valueOf(resultSet.getInt("user_id"));
            String user_name = resultSet.getString("user_name");
            String user_pass = resultSet.getString("user_pass");
            String user_permit = String.valueOf(resultSet.getInt("user_permit"));
            String[] user = {id, user_name, user_pass, user_permit};
            userArray.add(user);
        }
        if(connection!=null)
            connection.close();
        return userArray;
    }
    public void changeUserPass(String id, String user_name, String user_pass) throws SQLException {
        System.out.println("changeUserPass");
        String query = "UPDATE users SET user_name=?, user_pass=? WHERE user_id=?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setString(1, user_name);
        preparedStatement.setString(2, user_pass);
        preparedStatement.setString(3, id);
        preparedStatement.execute();
        if(connection!=null)
            connection.close();
    }
    public void addFile(PrintWriter out){System.out.println("addFile");}



//    public void createComponent(String additiveNamber, String additiveName, String additiveColor, String additiveInfo, String additivePermission, String additiveCBox, String additiveFor, String additiveNotes, String type) throws SQLException {
//        //создаем ключевой компонет, дополнительные имена добавляются как компоненты с пустыми полями.
//        List<String> names = Arrays.asList(additiveName.split(";"));
//        String mainId;
//
//        String statement = "INSERT INTO component(comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_for, comp_notes, comp_type) VALUE (?,?,?,?,?,?,?,?,?)";
//        PreparedStatement preparedStatement = connection.prepareStatement(statement);
//        preparedStatement.setString(1, names.get(0));
//        preparedStatement.setString(2, additiveNamber);
//        preparedStatement.setString(3, additiveInfo);
//        preparedStatement.setString(4, additivePermission);
//        preparedStatement.setString(5, additiveColor);
//        preparedStatement.setString(6, additiveCBox);
//        preparedStatement.setString(7, additiveFor);
//        preparedStatement.setString(8, additiveNotes);
//        preparedStatement.setString(9, type);
//        preparedStatement.execute();
//
//        String query = "SELECT LAST_INSERT_ID() as last_id from component;";
//        Statement stmt = connection.createStatement();
//        ResultSet resultSet = stmt.executeQuery(query);
//        resultSet.next();
//        mainId = resultSet.getString("last_id");
//
//        for (int i = 1; i < names.size(); i++) {
//            statement = "INSERT INTO component(comp_name, comp_group, comp_cbox, comp_e_code, comp_color) VALUE (?,?,?,?,?)";
//            preparedStatement = connection.prepareStatement(statement);
//            preparedStatement.setString(1, names.get(i).trim());
//            preparedStatement.setString(2, mainId);
//            preparedStatement.setString(3, additiveCBox);
//            preparedStatement.setString(4, additiveNamber);
//            preparedStatement.setString(5, additiveColor);
//            preparedStatement.execute();
//        }
////
////        if(connection!=null)
////            connection.close();
//    }
//
//    public void parse(String name) throws SQLException {
//
//        InputStream in = null;
//        HSSFWorkbook wb = null;
//        try {
//            in = new FileInputStream(name);
//            wb = new HSSFWorkbook(in);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//
//        Sheet sheet = wb.getSheetAt(0);
//        Iterator<Row> it = sheet.iterator();
//        while (it.hasNext()) {
//            Row row = it.next();
//            Iterator<Cell> cells = row.iterator();
//            int count = 0;
//            Dobavka d = new Dobavka();
//            while (cells.hasNext()) {
//                String result;
//                ++count;
//                Cell cell = cells.next();
//                int cellType = cell.getCellType();
//                switch (cellType) {
//                    case Cell.CELL_TYPE_STRING:
//                        result = cell.getStringCellValue();
//                        break;
//                    case Cell.CELL_TYPE_NUMERIC:
//                        result = String.valueOf(cell.getNumericCellValue());
//                        break;
//
//                    case Cell.CELL_TYPE_FORMULA:
//                        result = String.valueOf(cell.getNumericCellValue());
//                        break;
//                    default:
//                        result = "space";
//                        break;
//                }
////                System.out.println(result);
//                switch (count){
//                    case 1: d.type = result.trim();
//                        break;
//                    case 2: d.naznac = result.trim();
//                        break;
//                    case 3: d.nomerE = result.trim();
//                        break;
//                    case 4: d.nazvRu = result.trim();
//                        break;
//                    case 5: d.nazvEN = result.trim();
//                        break;
//                    case 6: d.forWhat = result.trim();
//                        break;
//                    case 7: d.zaProtiv = result.trim();
//                        break;
//                    case 8: d.primecanie = result.trim();
//                        break;
//                    case 9:  if(result.equals("1.0")) d.ogran.add("1");
//                        break;
//                    case 10: if(result.equals("1.0")) d.ogran.add("2");
//                        break;
//                    case 11: if(result.equals("1.0")) d.ogran.add("3");
//                        break;
//                    case 12: if(result.equals("1.0")) d.ogran.add("4");
//                        break;
//                    case 13: if(result.equals("1.0")) d.ogran.add("5");
//                        break;
//                    case 14: if(result.equals("1.0")) d.ogran.add("6");
//                        break;
//                    case 15: if(result.equals("1.0")) d.ogran.add("7");
//                        break;
//                    case 16: if(result.equals("1.0")) d.ogran.add("8");
//                        break;
//                    case 17:
//                        if(result.equals("З")){d.color="0";};
//                        if(result.equals("Ж")){d.color="1";};
//                        if(result.equals("К")){d.color="2";};
//                        break;
//                }
//            }
//            if( null!=d.nazvRu &&  !d.nazvRu.equals("")){
////                System.out.println(d);
//                String ogran = d.ogran.toString().substring(1, d.ogran.toString().length()-1).replace(" ", "");
//                String names = d.nazvRu+"; "+d.nomerE+"; "+d.nazvEN;
//                System.out.println(ogran);
//                createComponent(d.nomerE, names, d.color, d.forWhat, d.zaProtiv, ogran, d.naznac, d.primecanie, d.type);
//            }
//            count = 0;
//        }
//        System.out.println("in end");
//    }
//    class Dobavka{
//        String type;
//        String naznac;
//        String nomerE;
//        String nazvRu;
//        String nazvEN;
//        String forWhat;
//        String zaProtiv;
//        String primecanie;
//        ArrayList<String> ogran = new ArrayList<String>();
//        String color;
//
//        String getOgranicenie(){
//
//            String s = ogran.toString().replace(" ", "");
//            String ogranicenie = s.substring(1, s.length()-1);
//            return ogranicenie;
//        }
//
//        @Override
//        public String toString() {
//            return "Dobavka{" +
//                    "type='" + type + '\'' +
//                    ", naznac='" + naznac + '\'' +
//                    ", nomerE='" + nomerE + '\'' +
//                    ", nazvRu='" + nazvRu + '\'' +
//                    ", nazvEN='" + nazvEN + '\'' +
//                    ", forWhat='" + forWhat + '\'' +
//                    ", zaProtiv='" + zaProtiv + '\'' +
//                    ", primecanie='" + primecanie + '\'' +
//                    ", ogran='" + ogran + '\'' +
////                    ", ogranicenie=" + getOgranicenie() +
//                    ", color='" + color + '\'' +
//                    '}';
//        }
//    }
//
}
//****************************************************Additive==Component
//    public void createForeigners(int cat, int prod, int comp) throws SQLException {
//        String statement = "INSERT INTO foreigners(cat_frk, prod_frk, com_frk) VALUE (?, ?, ?)";
//        PreparedStatement preparedStatement = connection.prepareStatement(statement);
//        preparedStatement.setInt(1, cat);
//        preparedStatement.setInt(2, prod);
//        preparedStatement.setInt(3, comp);
//        preparedStatement.execute();
//        System.out.println("Запись ключи добавлена");
//    }
//
//    public void removeForeigners(int cat, int prod, int comp) throws SQLException {
//        String statement = "DELETE FROM foreigners WHERE cat_frk = ? AND prod_frk = ? AND com_frk = ?";
//        PreparedStatement preparedStatement = connection.prepareStatement(statement);
//        preparedStatement.setInt(1, cat);
//        preparedStatement.setInt(2, prod);
//        preparedStatement.setInt(3, comp);
//        preparedStatement.execute();
//        System.out.println("Запись ключи удалена ");
//    }
////////////////help

//        Statement statement = connection.createStatement();
//        statement.execute("DELETE FROM categories WHERE cat_name = " + cat);

//            ResultSet resultSet = statement.executeQuery();//select
//            while (resultSet.next()){
// первая строчка и дальше
//                resultSet.get...(1); //вернет первую колонку не строку! можно гет стринг и имя колонки
//                resultSet.get...(2); //вернет первую колонку не строку!
//            }

//           int i = statement.executeUpdate(); //insert update delete

//            statement.addBatch(); // несколько запросов по очереди ->
//            statement.executeBatch()
//            statement.clearBatch();//почистить запросы потом добавить новые

//            final String PREPARE_STAT = "INSERT INTO mytab VALUE (?,?,?,?)";
//            PreparedStatement preparedStatement = connection.prepareStatement(PREPARE_STAT);
//            preparedStatement.setInt("Номер/имя столбика", "значение");
//            preparedStatement.setBlob(1, new FileInputStream("имя файла png")); //в бвзе поле longblob
//            preparedStatement.execute();

