import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Connection conn = Database.connect();
        if (conn != null) {
            Scanner scanner = new Scanner(System.in);
            int opcion;
            do {
                System.out.println("Selecciona una opción:");
                System.out.println("1. Insertar un cine");
                System.out.println("2. Insertar una sala en un cine");
                System.out.println("3. Listar todos los cines con la información de sus salas");
                System.out.println("4. Salir");
                opcion = scanner.nextInt();

                switch (opcion) {
                    case 1:
                        insertarCineDesdeConsola(conn, scanner);
                        break;
                    case 2:
                        insertarSalaDesdeConsola(conn, scanner);
                        break;
                    case 3:
                        listarCinesYSala(conn);
                        break;
                    case 4:
                        System.out.println("Saliendo del programa...");
                        break;
                    default:
                        System.out.println("Opción no válida");
                }
            } while (opcion != 4);
            scanner.close();
        }
    }

    private static void insertarCineDesdeConsola(Connection conn, Scanner scanner) {
        System.out.println("Introduce el nombre del cine:");
        String nombre = scanner.next();
        System.out.println("Introduce el teléfono del cine:");
        String telefono = scanner.next();
        System.out.println("Introduce la dirección del cine:");
        String direccion = scanner.next();
        Cine cine = new Cine(nombre, telefono, direccion);
        insertarCine(conn, cine);
    }

    private static void insertarSalaDesdeConsola(Connection conn, Scanner scanner) {
        System.out.println("Introduce el nombre del cine:");
        String nombreCine = scanner.next();
        System.out.println("Introduce la cantidad de butacas de la sala:");
        int cantButaca = scanner.nextInt();
        Sala sala = new Sala(cantButaca, nombreCine);
        insertarSala(conn, sala);
    }
    private static void insertarCine(Connection conn, Cine cine) {
        String sql = "INSERT INTO CINE (NOMBRE_CINE, TELEFONO, DIRECCION) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, cine.getNombre());
            pstmt.setString(2, cine.getTelefono());
            pstmt.setString(3, cine.getDireccion());
            pstmt.executeUpdate();
            System.out.println("Cine insertado correctamente!");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    private static void insertarSala(Connection conn, Sala sala) {
        String sql = "INSERT INTO SALA (CANT_BUTACA, NOMBRE_CINE) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, sala.getCantButaca());
            pstmt.setString(2, sala.getNombreCine());
            pstmt.executeUpdate();
            System.out.println("Sala insertada correctamente!");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    private static void listarCinesYSala(Connection conn) {
        String sql = "SELECT CINE.NOMBRE_CINE, CINE.TELEFONO, CINE.DIRECCION, SALA.ID_SALA, SALA.CANT_BUTACA " +
                     "FROM CINE LEFT JOIN SALA ON CINE.NOMBRE_CINE = SALA.NOMBRE_CINE";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                String nombreCine = rs.getString("NOMBRE_CINE");
                String telefono = rs.getString("TELEFONO");
                String direccion = rs.getString("DIRECCION");
                int idSala = rs.getInt("ID_SALA");
                int cantButaca = rs.getInt("CANT_BUTACA");

                System.out.println("Cine: " + nombreCine + ", Teléfono: " + telefono + ", Dirección: " + direccion);
                if (idSala != 0) {
                    System.out.println("    Sala ID: " + idSala + ", Cantidad de Butacas: " + cantButaca);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
