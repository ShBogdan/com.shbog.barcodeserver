package model;

import com.mysql.fabric.jdbc.FabricMySQLDriver;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.PrintWriter;
import java.sql.*;
import java.sql.Connection;
import java.sql.Driver;
import java.util.*;

public class DbHelper {

    private  final String URL = "jdbc:mysql://localhost:3306/productsdb";
    private  final String NAME = "root";
    private  final String PASSWORD = "arisen13";
    private  Connection connection = null;

    public static void main(String[] args) throws SQLException {
//        new DbHelper().createCategory("Ежик");
        String s = "[1,2,3,4,4,5,6,6]";
        ArrayList<String> stringID = new ArrayList<String>(Arrays.asList(s.substring(1, s.length()-1).split(",")));
        ArrayList<Integer> intID = new ArrayList<>();
        for (String tempString : stringID) {
            int i = Integer.valueOf(tempString);
            if(!intID.contains(i)){
                intID.add(Integer.valueOf(i));
            }
        }
        System.out.println(intID);


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
            String statement = "INSERT INTO categories(cat_name, section_id_frk, components) VALUE (?,?,?)";
            PreparedStatement preparedStatement = connection.prepareStatement(statement);
            preparedStatement.setString(1, cat);
            preparedStatement.setString(2, sectionId);
            preparedStatement.setString(3, "");
            preparedStatement.execute();
            System.out.println("Запись:" + cat + " добавлена");
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
            System.out.println("Запись:" + section +" добавлена");
            if(connection!=null)
                connection.close();
        }
    }
    public void createProduct(String prodCategory_id, String prodProvider, String prodName, String prodCode, String componets_array_ID, String varButton) throws SQLException {
//        if(prod != null && !prod.trim().isEmpty()) {
        System.out.println(varButton);

        PreparedStatement prepSat;
        ResultSet resultSet;
        Statement stmt;
        Set<String> input_components_ID = new HashSet<String>(new ArrayList<String>(Arrays.asList(componets_array_ID.split(","))));
        Set<String> input_components_name = new HashSet<String>();
        if(varButton != null && !varButton.isEmpty()){
            input_components_name = new HashSet<String>(new ArrayList<String>(Arrays.asList(varButton.split(","))));
        }
        input_components_ID.remove("");

        //создаем новый компонент
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
        String statement = "INSERT INTO product(cat_id_frk, prod_maker, prod_name, prod_code, components) VALUE (?,?,?,?,?);";
        prepSat = connection.prepareStatement(statement);
        prepSat.setString(1, prodCategory_id);
        prepSat.setString(2, prodProvider);
        prepSat.setString(3, prodName);
        prepSat.setString(4, prodCode);
        prepSat.setString(5, input_components_ID.toString().substring(1, input_components_ID.toString().length()-1).replaceAll("\\s+",""));
        prepSat.execute();

        //получаем старый список компонентов группы
        String statement_get_cat_componentID = "SELECT components FROM categories WHERE cat_id=\""+prodCategory_id+"\"";
        stmt = connection.createStatement();
        resultSet = stmt.executeQuery(statement_get_cat_componentID);
        resultSet.next();
        List<String> list_cat_components_id = new ArrayList<String>(Arrays.asList(resultSet.getString("components").split(",")));
        for (String s : list_cat_components_id) {
            input_components_ID.add(s);
        }
        input_components_ID.remove("");
        String allComponentsId = input_components_ID.toString().substring(1, input_components_ID.toString().length()-1).replaceAll("\\s+","");
        System.out.println("Все компонентыЖ " + allComponentsId);
        //заменяем на новую группу компонентов
        String statement_add_cat_componentID = "UPDATE categories SET components =? WHERE cat_id=?";
        prepSat = connection.prepareStatement(statement_add_cat_componentID);
        prepSat.setString(1, allComponentsId);
        prepSat.setString(2, prodCategory_id);
        prepSat.execute();

        System.out.println("Запись:" + prodName + " добавлен");
        if(connection!=null)
            connection.close();
//        }
    }
    public void createAdditive(String additiveNamber, String additiveName, String additiveColor, String additiveInfo, String additivePermission, String additiveCBox, String additiveGroup) throws SQLException {
        String statement = "INSERT INTO component(comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_type) VALUE (?,?,?,?,?,?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, additiveName);
        preparedStatement.setString(2, additiveNamber);
        preparedStatement.setString(3, additiveInfo);
        preparedStatement.setString(4, additivePermission);
        preparedStatement.setString(5, additiveColor);
        preparedStatement.setString(6, additiveCBox);
        preparedStatement.setString(7, "1");
        preparedStatement.execute();
        //additiveGroup - все елементы для связи + новый елемент
        ArrayList<Integer> groupComponentsId = new ArrayList<>();
        ArrayList<Integer> groupComponentsId2 = new ArrayList<>();
        Set<String> groupComponentsName = new HashSet<String>();
        if(additiveGroup != null && !additiveGroup.isEmpty()){
            groupComponentsName = new HashSet<String>(new ArrayList<String>(Arrays.asList(additiveGroup.split(","))));
            groupComponentsName.add(additiveName);
        }
        //получаем id всех схожих компонентов
        for (String component : groupComponentsName) {
            String query = "SELECT comp_id FROM component WHERE comp_name = "+"\""+component+"\"";
            Statement stmt = connection.createStatement();
            ResultSet resultSet = stmt.executeQuery(query);
            resultSet.next();
            groupComponentsId.add(resultSet.getInt("comp_id"));
        }
        //собраем из всех схожих компонентов уникальные ссылки на другие компоненты
        ArrayList<Integer> groupComponentsIdToBase = new ArrayList<>();
        System.out.println("Id изменяемых продуктов"+groupComponentsId);

        for (Integer i : groupComponentsId){
            groupComponentsIdToBase.add(i);
            System.out.println("На входе groupComponentsIdToBase "+ groupComponentsIdToBase.toString());

            String query = "SELECT comp_group FROM component WHERE comp_id = "+"\""+i+"\"";
            Statement stmt = connection.createStatement();
            ResultSet resultSet = stmt.executeQuery(query);
            resultSet.next();
            System.out.println("Группа компонента " +i+">>>"+ resultSet.getString("comp_group"));
            if(null != resultSet.getString("comp_group")) {
                if(!resultSet.getString("comp_group").trim().equals("")) {
                    ArrayList<String> stringID = new ArrayList<String>(Arrays.asList(resultSet.getString("comp_group").substring(1, resultSet.getString("comp_group").length() - 1).split(",")));
                    System.out.println("Правратили строку в массив" + stringID.toString());
                    for (String tempString : stringID) {
                        int tempInt = Integer.parseInt(tempString.trim());
                        System.out.println("Добавляем " +tempInt + "в groupComponentsIdToBase");
                        if (!groupComponentsIdToBase.contains(tempInt)) {
                            System.out.println("добавили");
                            groupComponentsIdToBase.add(Integer.valueOf(tempInt));
                        }
                    }
                }
            }
            System.out.println("На выходе groupComponentsIdToBase "+ groupComponentsIdToBase.toString());
        }

        for (Integer componentID : groupComponentsIdToBase) {
            String query = "UPDATE component SET comp_group = "+"'"+groupComponentsIdToBase+"'"+"WHERE comp_id = "+"'"+componentID+"'";
            Statement stmt = connection.createStatement();
            stmt.executeUpdate(query);
        }
        System.out.println(groupComponentsName.toString());
        System.out.println(groupComponentsId.toString());
        System.out.println(groupComponentsIdToBase.toString());
        if(connection!=null)
            connection.close();
    }
    public void changeAdditive(String additiveId,String additiveNamber, String additiveName, String additiveColor, String additiveInfo, String additivePermission, String additiveCBox) throws SQLException {
        String statement = "UPDATE component SET comp_name = ?, comp_e_code = ?, comp_info = ?, comp_perm = ?, comp_color = ?, comp_cbox = ?, comp_type = ? WHERE comp_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, additiveName);
        preparedStatement.setString(2, additiveNamber);
        preparedStatement.setString(3, additiveInfo);
        preparedStatement.setString(4, additivePermission);
        preparedStatement.setString(5, additiveColor);
        preparedStatement.setString(6, additiveCBox);
        preparedStatement.setString(7, "1");
        preparedStatement.setString(8, additiveId);

        preparedStatement.execute();
        if(connection!=null)
            connection.close();
    }
    public void changeProduct(String prod_id, String prodCategory_id, String prodProvider, String prodName, String prodCode, String componets_array_ID, String varButton) throws SQLException {
//        if(prod != null && !prod.trim().isEmpty()) {
        System.out.println(varButton);

        PreparedStatement prepSat;
        ResultSet resultSet;
        Statement stmt;
        Set<String> input_components_ID = new HashSet<String>(new ArrayList<String>(Arrays.asList(componets_array_ID.split(","))));
        Set<String> input_components_name = input_components_name = new HashSet<String>();
        if(varButton != null && !varButton.isEmpty()){
            input_components_name = new HashSet<String>(new ArrayList<String>(Arrays.asList(varButton.split(","))));
        }
        input_components_ID.remove("");

        //создаем новый компонент
        for (String s : input_components_name) {
            String statement_add_component = "INSERT INTO component(comp_name) VALUE (?) ON DUPLICATE KEY UPDATE comp_name = ?";
            prepSat = connection.prepareStatement(statement_add_component);
            prepSat.setString(1, s);
            prepSat.setString(2, s);
            prepSat.execute();
        }
//        System.out.println("Список компонентов продукта до: " +input_components_ID);

        //получаем id добавленных компонентов
        for (String s : input_components_name) {
            String statement_get_componentID = "SELECT comp_id FROM component WHERE comp_name=\""+s+"\"";
            stmt = connection.createStatement();
            resultSet = stmt.executeQuery(statement_get_componentID);
            resultSet.next();
            input_components_ID.add(resultSet.getString("comp_id"));
        }
//        System.out.println("Список компонентов продукта после: " +input_components_ID);
        System.out.println("создаем продукт с индексом: " +prod_id);

        //создаем продукт до обновления input_components_ID
//        String statement = "INSERT INTO product(prod_id, cat_id_frk, prod_maker, prod_name, prod_code, components) VALUE (?,?,?,?,?,?) ON DUPLICATE KEY UPDATE prod_id = ?";
        String statement = "UPDATE product SET cat_id_frk = ?, prod_maker = ?, prod_name = ?, prod_code = ?, components = ? WHERE prod_id = ?";
        prepSat = connection.prepareStatement(statement);
        prepSat.setString(6, prod_id);
        prepSat.setString(1, prodCategory_id);
        prepSat.setString(2, prodProvider);
        prepSat.setString(3, prodName);
        prepSat.setString(4, prodCode);
        prepSat.setString(5, input_components_ID.toString().substring(1, input_components_ID.toString().length()-1).replaceAll("\\s+",""));
        prepSat.execute();

        //получаем старый список компонентов группы
        String statement_get_cat_componentID = "SELECT components FROM categories WHERE cat_id=\""+prodCategory_id+"\"";
        stmt = connection.createStatement();
        resultSet = stmt.executeQuery(statement_get_cat_componentID);
        resultSet.next();
        List<String> list_cat_components_id = new ArrayList<String>(Arrays.asList(resultSet.getString("components").split(",")));
        for (String s : list_cat_components_id) {
            input_components_ID.add(s);
        }
        input_components_ID.remove("");
        String allComponentsId = input_components_ID.toString().substring(1, input_components_ID.toString().length()-1).replaceAll("\\s+","");
        System.out.println("Все компонентыЖ " + allComponentsId);
        //заменяем на новую группу компонентов
        String statement_add_cat_componentID = "UPDATE categories SET components =? WHERE cat_id=?";
        prepSat = connection.prepareStatement(statement_add_cat_componentID);
        prepSat.setString(1, allComponentsId);
        prepSat.setString(2, prodCategory_id);
        prepSat.execute();


        System.out.println("Запись:" + prodName + " добавлен");
        if(connection!=null)
            connection.close();
//        }
    }
    public void createComponent(String comp) throws SQLException {
        String statement = "INSERT INTO component(comp_name) VALUE (?);";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, comp);
        preparedStatement.execute();
        System.out.println("Запись:" + comp +" добавлен");
        if(connection!=null)
            connection.close();
    }
    public void removeCategory(String cat_id) throws SQLException {
        String statement = "DELETE FROM categories WHERE cat_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, cat_id);
        preparedStatement.execute();
        System.out.println("Запись:" + cat_id +" удалена");
        if(connection!=null)
            connection.close();
    }
    public void removeSection(String sectionId) throws SQLException {
        String statement = "DELETE FROM section WHERE section_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, sectionId);
        preparedStatement.execute();
        System.out.println("Запись:" + sectionId +" удалена");
        if(connection!=null)
            connection.close();
    }
    public void removeProduct(String prod_id) throws SQLException {
        String statement = "DELETE FROM product WHERE prod_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, prod_id);
        preparedStatement.execute();
        System.out.println("Запись:" + prod_id +" удалена");
        if(connection!=null)
            connection.close();
    }
    public void removeAdditive(String additive_id) throws SQLException {
        String statement = "DELETE FROM component WHERE comp_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, additive_id);
        preparedStatement.execute();
        System.out.println("Запись:" + additive_id +" удалена");
        if(connection!=null)
            connection.close();
    }
    public void removeComponent(String comp) throws SQLException {
        String statement = "DELETE FROM component WHERE comp_name = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(statement);
        preparedStatement.setString(1, comp);
        preparedStatement.execute();
        System.out.println("Запись:" + comp +" удалена");
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
            System.out.println("out = [" + ja.toString() + "]");
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
    public PrintWriter getCompound(PrintWriter out, String compoundID) throws SQLException {
        String statement = "SELECT components FROM categories WHERE cat_id=" + compoundID;
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(statement);
        resultSet.next();
        String _statement = "SELECT * FROM component WHERE comp_id IN"+"("+resultSet.getString("components")+")";
        Statement _stmt = connection.createStatement();
        ResultSet _resultSet = _stmt.executeQuery(_statement);
        while (_resultSet.next()) {
            out.println("<button class=\"btnCompound\" id=\""+_resultSet.getString("comp_id")+"\">"+_resultSet.getString("comp_name")+"</button>");
//                System.out.println(_resultSet.getString("comp_name"));
        }

        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getProductCompound(PrintWriter out, String productID) throws SQLException {
        String statement = "SELECT components FROM product WHERE prod_id=" + productID;
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(statement);
        resultSet.next();
        String _statement = "SELECT * FROM component WHERE comp_id IN"+"("+resultSet.getString("components")+")";
        Statement _stmt = connection.createStatement();
        ResultSet _resultSet = _stmt.executeQuery(_statement);
        while (_resultSet.next()) {
            out.println("<button class=\"varButton\" id=\""+_resultSet.getString("comp_id")+"\">"+_resultSet.getString("comp_name")+"</button>");
//                System.out.println(_resultSet.getString("comp_name"));
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
    public PrintWriter getAdditive(PrintWriter out) throws SQLException{
        String query = "SELECT comp_id, comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox FROM component"; // WHERE comp_type = 1
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        while (resultSet.next()){
            JSONArray ja = new JSONArray();
            String id = String.valueOf(resultSet.getInt("comp_id"));
            String additive_name = resultSet.getString("comp_name");
            Integer additive_code = resultSet.getInt("comp_e_code");
            String additive_info = resultSet.getString("comp_info");
            String additive_perm = resultSet.getString("comp_perm");
            Integer additive_color = resultSet.getInt("comp_color");
            String additive_cbox = resultSet.getString("comp_cbox");
            ja.put(id);
            ja.put(additive_name);
            ja.put(additive_code);
            ja.put(additive_info);
            ja.put(additive_perm);
            ja.put(additive_color);
            ja.put(additive_cbox);
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
    public PrintWriter getProductID(PrintWriter out) throws SQLException{
        String query = "SELECT prod_id FROM product ORDER BY prod_id DESC LIMIT 1";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        resultSet.next();
        out.println(resultSet.getString("prod_id"));
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
    public PrintWriter getAdditiveID(PrintWriter out) throws SQLException{
        String query = "SELECT comp_id FROM component ORDER BY comp_id DESC LIMIT 1";
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);
        resultSet.next();
        out.println(resultSet.getString("comp_id"));
        out.flush();
        if(connection!=null)
            connection.close();
        return out;
    }
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

