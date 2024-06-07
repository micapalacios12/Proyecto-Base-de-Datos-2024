import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres?currentSchema=cines";
    private static final String USER = "nombre_usuario";
    private static final String PASSWORD = "su_contraseña";

    public static Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Conexión exitosa a la base de datos!");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return conn;
    }
}

