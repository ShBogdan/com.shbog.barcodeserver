package model;

import com.mysql.fabric.jdbc.FabricMySQLDriver;
import com.mysql.jdbc.StringUtils;
import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;
import java.util.logging.Logger;

public class DbHelper {

	private static final Logger LOGGER = Logger.getLogger(DbHelper.class.getSimpleName());

	private static final String APPLICATION_PROPERTIES_FILE_NAME = "application.properties";
	private static final Properties applicationProperties;
	private static final String DB_DRIVER;
	private static final String URL;
	private static final String NAME;
	private static final String PASSWORD;

	private Connection connection;

	static {
		applicationProperties = new Properties();
		InputStream in = DbHelper.class.getClassLoader().getResourceAsStream(APPLICATION_PROPERTIES_FILE_NAME);
		try {
			applicationProperties.load(in);
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		URL = applicationProperties.getProperty("URL");
		NAME = applicationProperties.getProperty("NAME");
		PASSWORD = applicationProperties.getProperty("PASSWORD");
		DB_DRIVER = applicationProperties.getProperty("dbDriver");
	}

	public DbHelper() {
		try {
			Class.forName(DB_DRIVER);
			Driver driver = new FabricMySQLDriver();
			DriverManager.registerDriver(driver);
			connection = DriverManager.getConnection(URL, NAME, PASSWORD);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	public void createCategory(String cat, String sectionId) throws SQLException {
		LOGGER.info("About to create category named " + cat);
		if (cat != null && !cat.trim().isEmpty()) {
			String statement = "INSERT INTO categories(cat_name, section_id_frk) VALUE (?,?)";
			PreparedStatement preparedStatement = connection.prepareStatement(statement);
			preparedStatement.setString(1, cat);
			preparedStatement.setString(2, sectionId);
			preparedStatement.execute();
			if (connection != null)
				connection.close();
		}
		LOGGER.info("Category created");
	}

	public void createSection(String section) throws SQLException {
		LOGGER.info("About to create section " + section);
		if (section != null && !section.trim().isEmpty()) {
			String statement = "INSERT INTO section(section_name) VALUE (?)";
			PreparedStatement preparedStatement = connection.prepareStatement(statement);
			preparedStatement.setString(1, section);
			preparedStatement.execute();
			if (connection != null)
				connection.close();
		}
		LOGGER.info("Section created");

	}

	// FIXME: 24.09.2017 add
	//ALTER TABLE product ADD creator VARCHAR(255) AFTER prod_type;
	public PrintWriter createProduct(String prodCategory_id, String prodProvider, String prodName, String prodCode, String componets_array_ID, String varButton, PrintWriter out, String prodType, String creator) {
		LOGGER.info("About to create product");
		Calendar calendar = Calendar.getInstance();
		Timestamp currentTimestamp = new Timestamp(calendar.getTime().getTime());
		PreparedStatement prepSat;
		ResultSet resultSet;
		Statement stmt;
		Set<String> input_components_ID = new HashSet<String>(new ArrayList<String>(Arrays.asList(componets_array_ID.split(","))));
		Set<String> input_components_name = new HashSet<String>();
		if (varButton != null && !varButton.isEmpty()) {
			org.json.simple.parser.JSONParser parser = new JSONParser();
			org.json.simple.JSONObject jsonObject = null;
			try {
				jsonObject = (org.json.simple.JSONObject) parser.parse(varButton);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			for (int i = 0; i < jsonObject.size(); i++) {
				input_components_name.add((String) jsonObject.get("name_" + i));
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
			//получаем id добавленных компонентов
			for (String s : input_components_name) {
				String statement_get_componentID = "SELECT comp_id FROM component WHERE comp_name=\"" + s + "\"";
				stmt = connection.createStatement();
				resultSet = stmt.executeQuery(statement_get_componentID);
				resultSet.next();
				input_components_ID.add(resultSet.getString("comp_id"));
			}
			//создать тип и получить id
			String prodTypeId = null;
			if (!prodType.trim().equals("")) {
				String statement_createProdType = "INSERT INTO prodtype (type_name, cat_id_frk) SELECT * FROM (SELECT ?, ?) AS tmp WHERE NOT EXISTS (SELECT type_name, cat_id_frk FROM prodtype WHERE type_name = ? AND cat_id_frk = ? ) LIMIT 1;";
				prepSat = connection.prepareStatement(statement_createProdType);
				prepSat.setString(1, prodType);
				prepSat.setString(2, prodCategory_id);
				prepSat.setString(3, prodType);
				prepSat.setString(4, prodCategory_id);
				prepSat.execute();
				String queryLastId = "SELECT id FROM prodtype WHERE type_name = ? AND cat_id_frk =?";
				prepSat = connection.prepareStatement(queryLastId);
				prepSat.setString(1, prodType);
				prepSat.setString(2, prodCategory_id);
				resultSet = prepSat.executeQuery();
				resultSet.next();
				prodTypeId = resultSet.getString("id");
			}
			//создаем продукт до обновления input_components_ID
			String statement = "INSERT INTO product(creator, cat_id_frk, prod_maker, prod_name, prod_code, prod_date, prod_type) SELECT user_id, ?, ? ,?, ? ,?, ?  FROM users WHERE user_name = ?";
			prepSat = connection.prepareStatement(statement);
			prepSat.setString(1, prodCategory_id);
			prepSat.setString(2, prodProvider);
			prepSat.setString(3, prodName);
			prepSat.setString(4, prodCode);
			prepSat.setTimestamp(5, currentTimestamp);
			prepSat.setString(6, prodTypeId);
			prepSat.setString(7, creator);
			prepSat.execute();
			System.out.println("insert end");

			String prodId;
			String query = "SELECT LAST_INSERT_ID() AS last_id FROM product;";
			stmt = connection.createStatement();
			resultSet = stmt.executeQuery(query);
			resultSet.next();
			prodId = resultSet.getString("last_id");
			out.println(prodId + "," + prodCode);
			out.flush();

			for (String s : input_components_ID) {
				String qInsertFrk = "INSERT INTO frkgroup(cat, prod, compon) VALUE (?,?,?)";
				prepSat = connection.prepareStatement(qInsertFrk);
				prepSat.setString(1, prodCategory_id);
				prepSat.setString(2, prodId);
				prepSat.setString(3, s);
				prepSat.execute();
			}
		} catch (MySQLIntegrityConstraintViolationException e) {
			out.println("-1");
			System.err.println("createProduct");
			e.printStackTrace();
			out.flush();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null)
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return out;
		}
	}

	public PrintWriter createComponent(String additiveNamber, String additiveName, String additiveColor, String additiveInfo, String additivePermission, String additiveCBox, String additiveFor, String additiveNotes, PrintWriter out, String additiveType, String additiveNameUa) throws SQLException {
		LOGGER.info("About to create component");
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
			names.add((String) jsonObject.get("name_" + i));
		}

		String statement = "INSERT INTO component(comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_for, comp_notes, comp_type, comp_name_ua) VALUE (?,?,?,?,?,?,?,?,?,?)";
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
		preparedStatement.setString(10, additiveNameUa);
		preparedStatement.execute();

		String query = "SELECT LAST_INSERT_ID() AS last_id FROM component;";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		resultSet.next();
		mainId = resultSet.getString("last_id");
		out.println(mainId);
		out.flush();

		for (int i = 1; i < names.size(); i++) {
			statement = "INSERT INTO component(comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_for, comp_notes, comp_type, comp_group, comp_name_ua) VALUE (?,?,?,?,?,?,?,?,?,?,?)";
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
			preparedStatement.setString(11, additiveNameUa);
			preparedStatement.execute();
		}

		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter createExclude(String excludeName, PrintWriter out) throws SQLException {
		LOGGER.info("About to create exclude");
		String statement = "INSERT INTO exclude(ogran_name) VALUE (?)";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, excludeName);
		preparedStatement.execute();

		String query = "SELECT LAST_INSERT_ID() AS last_id FROM exclude;";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		resultSet.next();
		out.println(resultSet.getString("last_id"));
		out.flush();

		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter createType(String prodType, String prodCategory_id, PrintWriter out) throws SQLException {
		LOGGER.info("About to create type");
		String statement;
		PreparedStatement prepSat;
		ResultSet resultSet;
		String queryLastId;
		if (prodCategory_id.equals("0")) {
			//если дубль возвращает 0
			//проверка на наличие повторений если нет то сразу вставляет
			statement = "INSERT INTO prodtype (type_name, cat_id_frk) SELECT * FROM (SELECT ?, NULL) AS tmp WHERE NOT EXISTS (SELECT type_name, cat_id_frk FROM prodtype WHERE type_name = ? AND cat_id_frk IS NULL ) LIMIT 1;";
			prepSat = connection.prepareStatement(statement);
			prepSat.setString(1, prodType);
			prepSat.setString(2, prodType);
			prepSat.execute();
			//последний потому что с NULL может быть сколько угодно
			String query = "SELECT LAST_INSERT_ID() AS last_id FROM component;";
			Statement stmt = connection.createStatement();
			resultSet = stmt.executeQuery(query);
			resultSet.next();
			out.println(resultSet.getString("last_id"));
			out.flush();
		} else {
			//если дубль возвращает 0
			statement = "INSERT INTO prodtype (type_name, cat_id_frk) SELECT * FROM (SELECT ?, ?) AS tmp WHERE NOT EXISTS (SELECT type_name, cat_id_frk FROM prodtype WHERE type_name = ? AND cat_id_frk = ? ) LIMIT 1;";
			prepSat = connection.prepareStatement(statement);
			prepSat.setString(1, prodType);
			prepSat.setString(2, prodCategory_id);
			prepSat.setString(3, prodType);
			prepSat.setString(4, prodCategory_id);
			prepSat.execute();
			queryLastId = "SELECT LAST_INSERT_ID() AS last_id FROM component;";
			prepSat = connection.prepareStatement(queryLastId);
			resultSet = prepSat.executeQuery();
			resultSet.next();
			String lastID = resultSet.getString("last_id");
			out.println(lastID);
			out.flush();
		}
		if (connection != null)
			connection.close();
		return out;
	}

	public void changeComponent(String additiveId, String additiveNamber, String additiveName, String additiveColor, String additiveInfo, String additivePermission, String additiveCBox, String additiveFor, String additiveNotes, String additiveType, String additiveNameUa) throws SQLException {
		LOGGER.info("About to change component");
		List<String> names = new ArrayList<String>();

		org.json.simple.parser.JSONParser parser = new JSONParser();
		org.json.simple.JSONObject jsonObject = null;
		try {
			jsonObject = (org.json.simple.JSONObject) parser.parse(additiveName);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		for (int i = 0; i < jsonObject.size(); i++) {
			names.add((String) jsonObject.get("name_" + i));
		}
		List<String> copyNames = new ArrayList<String>(names);
		copyNames.remove(0);

		String statement = "UPDATE component SET comp_name = ?, comp_e_code = ?, comp_info = ?, comp_perm = ?, comp_color = ?, comp_cbox = ?, comp_for = ?, comp_notes = ?, comp_type = ?, comp_name_ua = ? WHERE comp_id = ?";
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
		preparedStatement.setString(10, additiveNameUa);
		preparedStatement.setString(11, additiveId);
		preparedStatement.execute();
		//получаем id всех текущих названий
		statement = "SELECT comp_id, comp_name FROM component WHERE comp_group=" + additiveId;
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(statement);
		while (resultSet.next()) {
			if (names.contains(resultSet.getString("comp_name"))) {
				copyNames.remove(resultSet.getString("comp_name"));
				String _statement = "UPDATE component SET comp_name = ?, comp_e_code = ?, comp_info = ?, comp_perm = ?, comp_color = ?, comp_cbox = ?, comp_for = ?, comp_notes = ?, comp_type = ?, comp_group=?, comp_name_ua = ? WHERE comp_id = ?";
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
				_preparedStatement.setString(11, additiveNameUa);
				_preparedStatement.setString(12, resultSet.getString("comp_id"));
				_preparedStatement.execute();
			} else {
				String tempStatement = "DELETE FROM component WHERE comp_id = ?";
				PreparedStatement tempPreparedStatement = connection.prepareStatement(tempStatement);
				tempPreparedStatement.setString(1, resultSet.getString("comp_id"));
				tempPreparedStatement.execute();
			}
		}

		//Создаем новые
		for (int i = 0; i < copyNames.size(); i++) {
			statement = "INSERT INTO component(comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_for, comp_notes, comp_type, comp_group, comp_name_ua) VALUE (?,?,?,?,?,?,?,?,?,?,?)";
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
			preparedStatement.setString(11, additiveNameUa);
			preparedStatement.execute();
		}
		if (connection != null)
			connection.close();
	}

	public PrintWriter changeProduct(String prod_id, String prodCategory_id, String prodProvider, String prodName, String prodCode, String componets_array_ID, String varButton, PrintWriter out, String prodType, String creator) {
		LOGGER.info("About to change product");
		PreparedStatement prepSat;
		ResultSet resultSet;
		Statement stmt;
		Set<String> input_components_ID = new HashSet<String>(new ArrayList<String>(Arrays.asList(componets_array_ID.split(","))));
		Set<String> input_components_name = new HashSet<String>();
		if (varButton != null && !varButton.isEmpty()) {
			org.json.simple.parser.JSONParser parser = new JSONParser();
			org.json.simple.JSONObject jsonObject = null;
			try {
				jsonObject = (org.json.simple.JSONObject) parser.parse(varButton);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			for (int i = 0; i < jsonObject.size(); i++) {
				input_components_name.add((String) jsonObject.get("name_" + i));
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
				String statement_get_componentID = "SELECT comp_id FROM component WHERE comp_name=\"" + s + "\"";
				stmt = connection.createStatement();
				resultSet = stmt.executeQuery(statement_get_componentID);
				resultSet.next();
				input_components_ID.add(resultSet.getString("comp_id"));
			}

			String prodTypeId = null;
			if (!prodType.trim().equals("")) {
				String statement_createProdType = "INSERT INTO prodtype (type_name, cat_id_frk) SELECT * FROM (SELECT ?, ?) AS tmp WHERE NOT EXISTS (SELECT type_name, cat_id_frk FROM prodtype WHERE type_name = ? AND cat_id_frk = ? ) LIMIT 1;";
				prepSat = connection.prepareStatement(statement_createProdType);
				prepSat.setString(1, prodType);
				prepSat.setString(2, prodCategory_id);
				prepSat.setString(3, prodType);
				prepSat.setString(4, prodCategory_id);
				prepSat.execute();
				String queryLastId = "SELECT id FROM prodtype WHERE type_name = ? AND cat_id_frk =?";
				prepSat = connection.prepareStatement(queryLastId);
				prepSat.setString(1, prodType);
				prepSat.setString(2, prodCategory_id);
				resultSet = prepSat.executeQuery();
				resultSet.next();
				prodTypeId = resultSet.getString("id");
			}
			//создаем продукт до обновления input_components_ID
			String statement = "UPDATE product SET cat_id_frk = ?, prod_maker = ?, prod_name = ?, prod_code = ?, prod_type = ?, creator = (SELECT user_id FROM users WHERE user_name = ?) WHERE prod_id = ?";
			prepSat = connection.prepareStatement(statement);
			prepSat.setString(1, prodCategory_id);
			prepSat.setString(2, prodProvider);
			prepSat.setString(3, prodName);
			prepSat.setString(4, prodCode);
			prepSat.setString(5, prodTypeId);
			prepSat.setString(6, creator);
			prepSat.setString(7, prod_id);
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
		} catch (MySQLIntegrityConstraintViolationException e) {
			e.printStackTrace();
			out.println("-1");
			out.flush();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null)
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			return out;
		}
	}

	public void removeCategory(String cat_id) throws SQLException {
		LOGGER.info("About to remove category");
		String statement = "DELETE FROM categories WHERE cat_id = ?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, cat_id);
		preparedStatement.execute();
		if (connection != null)
			connection.close();
	}

	public void removeSection(String sectionId) throws SQLException {
		LOGGER.info("About to remove section");
		String statement = "DELETE FROM section WHERE section_id = ?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, sectionId);
		preparedStatement.execute();
		if (connection != null)
			connection.close();
	}

	public void removeProduct(String prod_id) throws SQLException {
		LOGGER.info("About to remove product");
		String statement = "DELETE FROM product WHERE prod_id = ?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, prod_id);
		preparedStatement.execute();

		statement = "DELETE FROM frkgroup WHERE prod = ?";
		preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, prod_id);
		preparedStatement.execute();

		if (connection != null)
			connection.close();
	}

	public void removeType(String type_id) throws SQLException {
		LOGGER.info("About to remove type");
		String _statement = "UPDATE product SET prod_type = NULL WHERE prod_type = ?";
		PreparedStatement _preparedStatement = connection.prepareStatement(_statement);
		_preparedStatement.setString(1, type_id);
		_preparedStatement.execute();

		String statement = "DELETE FROM prodtype WHERE id = ?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, type_id);
		preparedStatement.execute();

		if (connection != null)
			connection.close();
	}

	public void removeTempProducts(String prod_id) throws SQLException {
		LOGGER.info("About to remove temp product");
		String statement = "DELETE FROM newproducts WHERE prod_id = ?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, prod_id);
		preparedStatement.execute();
		if (connection != null)
			connection.close();
	}

	public void removeComponent(String additive_id) throws SQLException {
		LOGGER.info("About to remove component");
		String statement = "DELETE FROM component WHERE comp_id = ? OR comp_group = ?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, additive_id);
		preparedStatement.setString(2, additive_id);
		preparedStatement.execute();

		if (connection != null)
			connection.close();
	}

	public void removeExclude(String exclude_id) throws SQLException {
		LOGGER.info("About to remove exclude");
		String statement = "DELETE FROM exclude WHERE ogran_id = ?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, exclude_id);
		preparedStatement.execute();
		if (connection != null)
			connection.close();
	}

	public void renameCategory(String cat_id, String catName) throws SQLException {
		LOGGER.info("About to rename category");
		String statement = "UPDATE categories SET cat_name=? WHERE cat_id=?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, catName);
		preparedStatement.setString(2, cat_id);
		preparedStatement.execute();
		if (connection != null)
			connection.close();
	}

	public PrintWriter renameType(String type_id, String type_name, String prodCategory_id, String prodCategory_idOld, PrintWriter out) throws SQLException {
		LOGGER.info("About to rename type");
		//если совпадения то возвращаем 0
		String _statement = "SELECT EXISTS(SELECT * FROM prodtype WHERE type_name=? AND cat_id_frk=?)";
		PreparedStatement _preparedStatement = connection.prepareStatement(_statement);
		_preparedStatement.setString(1, type_name);
		if (prodCategory_id.equals("0")) {
			_preparedStatement.setNull(2, Types.NULL);
		} else {
			_preparedStatement.setString(2, prodCategory_id);
		}
		ResultSet resultSet = _preparedStatement.executeQuery();
		resultSet.next();
		if (resultSet.getInt(1) == 1) {
			out.println(0);
			out.flush();
			return out;
		}

		String statement = "UPDATE prodtype SET type_name=?, cat_id_frk=? WHERE id=?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, type_name);
		if (prodCategory_id.equals("0")) {
			preparedStatement.setNull(2, Types.NULL);
		} else {
			preparedStatement.setString(2, prodCategory_id);
		}
		preparedStatement.setString(3, type_id);
		preparedStatement.execute();
		//если тип переименован то удаляем его из продукта
		if (!prodCategory_idOld.equals(prodCategory_id)) {
			String stm = "UPDATE product SET prod_type = NULL WHERE cat_id_frk = ? AND prod_type = ?";
			PreparedStatement pStatement = connection.prepareStatement(stm);
			pStatement.setString(1, prodCategory_idOld);
			pStatement.setString(2, type_id);
			pStatement.execute();
		}

		if (connection != null)
			connection.close();
		return out;
	}

	public void renameExclude(String exclude_id, String excludeName) throws SQLException {
		LOGGER.info("About to rename exclude");
		String statement = "UPDATE exclude SET ogran_name=? WHERE ogran_id=?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, excludeName);
		preparedStatement.setString(2, exclude_id);
		preparedStatement.execute();
		if (connection != null)
			connection.close();
	}

	public void renameSection(String sectionId, String secName) throws SQLException {
		LOGGER.info("About to rename section");
		String statement = "UPDATE section SET section_name=? WHERE section_id=?";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, secName);
		preparedStatement.setString(2, sectionId);
		preparedStatement.execute();
		if (connection != null)
			connection.close();
	}

	public PrintWriter getCategory(PrintWriter out) throws SQLException {
		LOGGER.info("About to get category");
		String query = "SELECT cat_id, cat_name FROM categories ORDER BY cat_name";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
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
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	// FIXME: 21.05.2017 why do we need it?
	public PrintWriter getCategoryJSONobj(PrintWriter out) throws SQLException {
		String query = "SELECT cat_id, cat_name FROM categories ORDER BY cat_name";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
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
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getBarcodeInfo(PrintWriter out, String barcode) throws SQLException {
		LOGGER.info("About to get barcodeinfo");
		String prod_id;
		String cat_id_frk;
		String cat_name;
		String prod_name;
		String prod_maker;
		ArrayList<String> prod_components = new ArrayList<String>();
		JSONObject result = new JSONObject();

		String query = "SELECT prod_id, cat_id_frk, prod_name, prod_maker FROM product WHERE prod_code=" + barcode;
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		resultSet.next();
		prod_id = resultSet.getString("prod_id");
		cat_id_frk = resultSet.getString("cat_id_frk");
		prod_name = resultSet.getString("prod_name");
		prod_maker = resultSet.getString("prod_maker");

		query = "SELECT cat_name FROM categories WHERE cat_id=" + cat_id_frk;
		stmt = connection.createStatement();
		resultSet = stmt.executeQuery(query);
		resultSet.next();
		cat_name = resultSet.getString("cat_name");

		query = "SELECT compon FROM frkgroup WHERE prod=" + prod_id;
		stmt = connection.createStatement();
		resultSet = stmt.executeQuery(query);
		while (resultSet.next()) {
			prod_components.add(resultSet.getString("compon"));
		}
		JSONArray array = new JSONArray();
		for (int i = 0; i < prod_components.size(); i++) {
			try {
				query = "SELECT comp_id, comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_group FROM component WHERE comp_id=" + prod_components.get(i);
				stmt = connection.createStatement();
				resultSet = stmt.executeQuery(query);
				resultSet.next();
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
				array.put(ja);
			} catch (SQLException e) {
				System.err.println("getBarcodeInfo: Component not found");
			}
		}

		JSONArray ja = new JSONArray();
		ja.put(prod_id);
		ja.put(cat_name);
		ja.put(prod_name);
		ja.put(prod_maker);
		ja.put(prod_components.toString());
		try {
			result.put("component", array);
			result.put("barcode", ja);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getSection(PrintWriter out) throws SQLException {
		LOGGER.info("About to get section");
		String query = "SELECT section_id, section_name FROM section ORDER BY section_name";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		int count = 1;
		int _count = 1;
		while (resultSet.next()) {
			out.println("<tbody id=" + resultSet.getString("section_id") + ">");
			out.println("<tr class=\"par\">");
			out.println("<td class=\"parent\">&nbsp;&nbsp;&nbsp;&nbsp;" + count + ". " + resultSet.getString("section_name") + "</td>");
			out.println("<td class=\"remove-" + resultSet.getString("section_id") + "\"><button class='actionButton'>&#215;</button>&nbsp;&nbsp;</td>");
			out.println("<td class=\"rename-" + resultSet.getString("section_id") + "\"><button class='actionButton'>&#8601;</button>&nbsp;&nbsp;</td>");
			out.println("<td class=\"addCategory-" + resultSet.getString("section_id") + "\"><button class='actionButton'>&#43;</button>&nbsp;&nbsp;</td>");
			out.println("</tr>");
			String _query = "SELECT cat_id, cat_name, COUNT(cat_id) AS size FROM categories RIGHT JOIN product ON cat_id = cat_id_frk WHERE section_id_frk = " + resultSet.getString("section_id") + " GROUP BY cat_id ORDER BY cat_name;";
			Statement _stmt = connection.createStatement();
			ResultSet _resultSet = _stmt.executeQuery(_query);
			while (_resultSet.next()) {
				out.println("<tr class=\"child-" + resultSet.getString("section_id") + "\"  id = \"" + _resultSet.getString("cat_id") + "\">");
				out.println("<td>" + count + "." + _count + ". " + _resultSet.getString("cat_name") + "</td>");
				out.println("<td class=\"goToProduct\"><button class='actionButton'>" + _resultSet.getString("size") + "&nbsp;&#62;</button>&nbsp;&nbsp;</td>");
				out.println("<td class=\"removeCat\"><button class='actionButton'>&#215;</button>&nbsp;&nbsp;</td>");
				out.println("<td class=\"renameCat\"><button class='actionButton'>&#8601;</button>&nbsp;&nbsp;</td>");
				out.println("<td></td>");
				out.println("</tr>");
				_count++;
			}
			_count = 1;
			count++;
			out.println("</tbody>");
		}
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getCompound(PrintWriter out, String catId) throws SQLException {
		LOGGER.info("About to get compound");
		ArrayList<String> componArrId = new ArrayList<String>();
		String statement = "SELECT compon FROM frkgroup WHERE cat=" + catId;
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(statement);
		while (resultSet.next()) {
			componArrId.add(resultSet.getString("compon"));
		}
		if (componArrId.size() != 0) {
			String _statement = "SELECT * FROM component WHERE comp_id IN" + "(" + componArrId.toString().substring(1, componArrId.toString().length() - 1).replaceAll("\\s+", "") + ") ORDER BY comp_name";
			Statement _stmt = connection.createStatement();
			ResultSet _resultSet = _stmt.executeQuery(_statement);
			while (_resultSet.next()) {
				out.println("<button class=\"btnCompound\" id=\"" + _resultSet.getString("comp_id") + "\">" + _resultSet.getString("comp_name") + "</button>");
			}
		}
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getProductCompound(PrintWriter out, String productID) throws SQLException {
		LOGGER.info("About to get product compound");
		ArrayList<String> componArrId = new ArrayList<String>();
		String statement = "SELECT compon FROM frkgroup WHERE prod=" + productID;
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(statement);
		try {
			while (resultSet.next()) {
				componArrId.add(resultSet.getString("compon"));
			}
		} catch (SQLException e) {
			System.err.println("нет компонентов");
		}
		String listId = componArrId.toString().substring(1, componArrId.toString().length() - 1).replaceAll("\\s+", "");
		if (listId.length() > 0) {
			String _statement = "SELECT * FROM component WHERE comp_id IN " + "(" + listId + ")";
			Statement _stmt = connection.createStatement();
			ResultSet _resultSet = _stmt.executeQuery(_statement);
			while (_resultSet.next()) {
				out.println("<button class=\"varButton\" id=\"" + _resultSet.getString("comp_id") + "\">" + _resultSet.getString("comp_name") + "</button>");
			}
		}
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getProducts(PrintWriter out) throws SQLException {
		LOGGER.info("About to get products");
		String query = "SELECT prod_id, cat_name, prod_name, prod_maker, prod_code, type_name FROM product INNER JOIN categories ON cat_id_frk=cat_id LEFT JOIN prodtype ON prod_type=id";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			String id = String.valueOf(resultSet.getInt("prod_id"));
			String cat_name = resultSet.getString("cat_name");
			String prod_type = resultSet.getString("type_name");
			String prod_maker = resultSet.getString("prod_maker");
			String prod_name = resultSet.getString("prod_name");
			String prod_code = resultSet.getString("prod_code");
			ja.put(id);
			ja.put(cat_name);
			ja.put(prod_type);
			ja.put(prod_name);
			ja.put(prod_maker);
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
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getTypes(PrintWriter out) throws SQLException {
		LOGGER.info("About to get types");
		String query = "SELECT id, type_name, cat_name FROM prodtype LEFT JOIN categories ON cat_id_frk<=>categories.cat_id ORDER BY cat_name;";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			String id = String.valueOf(resultSet.getInt("id"));
			String cat_id_frk = resultSet.getString("cat_name");
			String type_name = resultSet.getString("type_name");

			ja.put(id);
			ja.put(cat_id_frk);
			ja.put(type_name);
			array.put(ja);
		}
		try {
			result.put("types", array);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getBarcodes(PrintWriter out) throws SQLException {
		LOGGER.info("About to get barcodes");
		String query = "SELECT prod_code FROM product";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			String prod_code = resultSet.getString("prod_code");
			ja.put(prod_code);
			array.put(ja);
		}
		try {
			result.put("barcodes", array);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	// FIXME: 11.05.2017 Изменить базу.
	//ALTER TABLE productsdb.newproducts ADD prod_date VARCHAR(100) NOT NULL;
	//UPDATE productsdb.newproducts SET prod_date = '2017-05-11 08:28:12.274391';

	/**
	 * @param out       PrintWriter
	 * @param startDate dateFormat: "yy-mm-dd"
	 * @param endDate   dateFormat: "yy-mm-dd"
	 * @return json array {"newproducts":[[],[]]}
	 */
	public PrintWriter getNewProducts(PrintWriter out, String startDate, String endDate) throws SQLException {
		LOGGER.info("About to get new products");
		endDate = endDate + " 23:59:59";
		String query = "SELECT prod_id, cat_name, prod_code, prod_date FROM newproducts INNER JOIN categories ON cat_id_frk=cat_id WHERE prod_date BETWEEN '" + startDate + "' AND '" + endDate + "'";

		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);

		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			String id = String.valueOf(resultSet.getInt("prod_id"));
			String cat_name = resultSet.getString("cat_name");
			String prod_code = resultSet.getString("prod_code");
			String prod_date = resultSet.getString("prod_date");
			ja.put(id);
			ja.put(cat_name);
			ja.put(prod_code);
			ja.put(prod_date);
			array.put(ja);
		}
		try {
			result.put("newproducts", array);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getExclude(PrintWriter out) throws SQLException {
		LOGGER.info("About to get exclude");
		String query = "SELECT ogran_id, ogran_name FROM exclude";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			String id = String.valueOf(resultSet.getInt("ogran_id"));
			String ogran_name = resultSet.getString("ogran_name");
			ja.put(id);
			ja.put(ogran_name);
			array.put(ja);
		}
		try {
			result.put("exclude", array);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getComponentNames(PrintWriter out) throws SQLException {
		LOGGER.info("About to get component names");
		String query = "SELECT comp_id, comp_for, comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_notes, comp_group, comp_type FROM component"; //  WHERE COALESCE(comp_group, '') = ''
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
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
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getProdType(PrintWriter out, String catId) throws SQLException {
		LOGGER.info("About to get prod type");
		String query = "SELECT * FROM prodtype WHERE cat_id_frk =  ?";
		PreparedStatement preparedStatement = connection.prepareStatement(query);
		preparedStatement.setString(1, catId);
		ResultSet resultSet = preparedStatement.executeQuery();
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();

		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			String type_name = resultSet.getString("type_name");
			ja.put(type_name);
			array.put(ja);
		}
		try {
			result.put("prodtype", array);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getComponents(PrintWriter out) throws SQLException {
		LOGGER.info("About to get components");
		String query = "SELECT comp_id, comp_for, comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_notes, comp_group, comp_type, comp_name_ua FROM component WHERE COALESCE(comp_group, '') = ''";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
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
			String additive_name_ua = resultSet.getString("comp_name_ua");
			ja.put(id);
			ja.put(additive_type);
			ja.put(additive_for);
			ja.put(additive_code);
			ja.put(additive_name);
			ja.put(additive_name_ua);
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
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getCBox(PrintWriter out) throws SQLException {
		LOGGER.info("About to get cBox");
		String query = "SELECT ogran_id, ogran_name FROM exclude"; // WHERE comp_type = 1
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
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
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter isBarcodeExist(PrintWriter out, String barcode) throws SQLException {
		LOGGER.info("About to check barcode");
		String query = "SELECT prod_code FROM product WHERE prod_code = '" + barcode + "'";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			String id = String.valueOf(resultSet.getString("prod_code"));
			ja.put(id);
			array.put(ja);
		}
		try {
			result.put("barcode", array);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getAdditiveByID(PrintWriter out, String compId) throws SQLException {
		LOGGER.info("About to get additive by id");
		String query = "SELECT comp_id, comp_name, comp_e_code, comp_info, comp_perm, comp_color, comp_cbox, comp_group FROM component WHERE comp_id=" + compId;
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
			result.put("component", ja);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	// FIXME: 11.05.2017 Изменить базу.
	//ALTER TABLE productsdb.product MODIFY prod_date VARCHAR(100) NOT NULL;
	//UPDATE productsdb.product SET prod_date = '2017-05-11 08:28:12.274391';
	//ALTER TABLE productsdb.product MODIFY prod_date TIMESTAMP NOT NULL;

	/**
	 * @param out       PrintWriter
	 * @param startDate dateFormat: "yy-mm-dd"
	 * @param endDate   dateFormat: "yy-mm-dd"
	 * @return json array {"products":[[],[]]}
	 */
	public PrintWriter getProdGroupByDate(PrintWriter out, String startDate, String endDate, String creator) throws SQLException {
		LOGGER.info("About to get product group by id");
		creator = StringUtils.isNullOrEmpty(creator) ?
				"" : "creator = (SELECT user_id FROM users WHERE user_name = '" + creator + "') AND";
		endDate = endDate + " 23:59:59";
		String query = "SELECT cat_id, cat_name, prod_date, COUNT(*) as count FROM product INNER JOIN categories ON cat_id_frk=cat_id WHERE " + creator + " prod_date BETWEEN '" + startDate + "' AND '" + endDate + "' GROUP BY cat_id_frk;";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);

		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			ja.put(resultSet.getString("cat_id"));
			ja.put(resultSet.getString("cat_name"));
			ja.put(resultSet.getString("prod_date"));
			ja.put(resultSet.getString("count"));
			array.put(ja);
		}

		try {
			result.put("prodGroupByDate", array);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (connection != null)
			connection.close();

		out.println(result);
		out.flush();
		return out;
	}

	public ArrayList getUsersForPermition() throws SQLException {
		LOGGER.info("About to get user");
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
		if (connection != null)
			connection.close();
		return userArray;
	}

	public PrintWriter getCreators(PrintWriter out) throws SQLException {
		LOGGER.info("About to get creators");
		String query = "SELECT user_id, user_name FROM users ORDER BY user_name";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			String id = String.valueOf(resultSet.getInt("user_id"));
			String user_name = resultSet.getString("user_name");
			ja.put(id);
			ja.put(user_name);
			array.put(ja);
		}
		try {
			result.put("creators", array);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(array);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter getUsers(PrintWriter out) throws SQLException {
		LOGGER.info("About to get users");
		String query = "SELECT user_id, user_name FROM users ORDER BY user_id";
		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(query);
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		while (resultSet.next()) {
			JSONArray ja = new JSONArray();
			String user_id = String.valueOf(resultSet.getInt("user_id"));
			String userName = resultSet.getString("user_name");
			ja.put(user_id);
			ja.put(userName);
			array.put(ja);
		}
		try {
			result.put("users", array);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.println(result);
		out.flush();
		if (connection != null)
			connection.close();
		return out;
	}

	public PrintWriter removeUser(String id, PrintWriter out) throws SQLException {
		LOGGER.info("About to remove user");
		String statement = "DELETE FROM users WHERE user_id = ? AND user_permit != '1'";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, id);
		preparedStatement.execute();
		if (connection != null)
			connection.close();
		return out;
	}

	// FIXME: 24.09.2017  add
	//	ALTER TABLE users MODIFY user_name VARCHAR(25) NOT NULL UNIQUE;
	//	ALTER TABLE users MODIFY user_permit VARCHAR(1) DEFAULT '0';
	public PrintWriter createUser(String userName, String userPassword, PrintWriter out) throws SQLException {
		LOGGER.info("About to create user");
		String statement;
		PreparedStatement prepSat;
		ResultSet resultSet;
		String queryLastId;
		statement = "INSERT INTO users (user_name, user_pass) VALUE (?,?)";
		prepSat = connection.prepareStatement(statement);
		prepSat.setString(1, userName);
		prepSat.setString(2, userPassword);
		try {
			prepSat.execute();
			String query = "SELECT LAST_INSERT_ID() AS last_id FROM users;";
			Statement stmt = connection.createStatement();
			resultSet = stmt.executeQuery(query);
			resultSet.next();
			out.println(resultSet.getString("last_id"));
			out.flush();
		} catch (MySQLIntegrityConstraintViolationException e) {
			out.println("0");
		} finally {
			if (connection != null)
				connection.close();
			return out;
		}
	}

	public PrintWriter changeUser(String id, String user_name, String user_pass, PrintWriter out) throws SQLException {
		LOGGER.info("About to change user");
		String query = "UPDATE users SET user_name=?, user_pass=? WHERE user_id=?";
		PreparedStatement preparedStatement = connection.prepareStatement(query);
		preparedStatement.setString(1, user_name);
		preparedStatement.setString(2, user_pass);
		preparedStatement.setString(3, id);
		try {
			preparedStatement.execute();
		} catch (
				MySQLIntegrityConstraintViolationException e) {
			out.println("0");
		} finally

		{
			if (connection != null)
				connection.close();
			return out;
		}

	}

	public void createProdPhone(String cat, String code) throws SQLException {
		LOGGER.info("About to create product by android app");
		String statement = "INSERT INTO newproducts(cat_id_frk, prod_code) VALUE (?,?)";
		PreparedStatement preparedStatement = connection.prepareStatement(statement);
		preparedStatement.setString(1, cat);
		preparedStatement.setString(2, code);
		preparedStatement.execute();
		if (connection != null)
			connection.close();
	}

}
