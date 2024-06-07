import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        // Establece la conexión con la base de datos al iniciar el programa
        Connection conn = Database.connect();
        if (conn != null) { // Verifica si la conexión fue exitosa
            Scanner scanner = new Scanner(System.in);
            int opcion;
            do {
                // Menú de opciones
                System.out.println("Selecciona una opción:");
                System.out.println("1. Insertar un cine");
                System.out.println("2. Insertar una sala en un cine");
                System.out.println("3. Listar todos los cines con la información de sus salas");
                System.out.println("4. Salir");
                opcion = scanner.nextInt(); // Lee la opción seleccionada por el usuario

                switch (opcion) {
                    case 1:
                        insertarCineDesdeConsola(conn, scanner); // Llama al método para insertar un cine
                        break;
                    case 2:
                        insertarSalaDesdeConsola(conn, scanner); // Llama al método para insertar una sala
                        break;
                    case 3:
                        listarCinesYSala(conn); // Llama al método para listar cines y salas
                        break;
                    case 4:
                        System.out.println("Saliendo del programa..."); // Mensaje de salida
                        break;
                    default:
                        System.out.println("Opción no válida"); // Mensaje para opciones inválidas
                }
            } while (opcion != 4); // El bucle se repite hasta que se selecciona la opción de salida
            scanner.close(); // Cierra el scanner al salir del bucle
        }
    }

    private static void insertarCineDesdeConsola(Connection conn, Scanner scanner) {
        Scanner scanner1 = new Scanner(System.in);

        System.out.println("Introduce el nombre del cine:");
        String nombre = scanner1.nextLine(); // Lee el nombre del cine

        System.out.println("Introduce el teléfono del cine:");
        String telefono = scanner1.nextLine(); // Lee el teléfono del cine

        System.out.println("Introduce la dirección del cine:");
        String direccion = scanner1.nextLine(); // Lee la dirección del cine

        Cine cine = new Cine(nombre, telefono, direccion); // Crea un objeto Cine con los datos ingresados
        insertarCine(conn, cine); // Llama al método para insertar el cine en la base de datos
    }

    private static void insertarSalaDesdeConsola(Connection conn, Scanner scanner) {
        // Crea un nuevo scanner para evitar problemas con nextLine()
        Scanner scanner2 = new Scanner(System.in);

        System.out.println("Introduce el nombre del cine:");
        String nombreCine = scanner2.nextLine(); // Lee el nombre del cine

        System.out.println("Introduce la cantidad de butacas de la sala:");
        int cantButaca = scanner2.nextInt(); // Lee la cantidad de butacas de la sala
        scanner.nextLine(); // Consume el newline restante después de nextInt()

        Sala sala = new Sala(cantButaca, nombreCine); // Crea un objeto Sala con los datos ingresados
        insertarSala(conn, sala); // Llama al método para insertar la sala en la base de datos
    }

    private static void insertarCine(Connection conn, Cine cine) {
        // Consulta SQL para insertar un cine en la base de datos
        String sql = "INSERT INTO CINE (NOMBRE_CINE, TELEFONO, DIRECCION) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, cine.getNombre()); // Establece el nombre del cine en la consulta
            pstmt.setString(2, cine.getTelefono()); // Establece el teléfono del cine en la consulta
            pstmt.setString(3, cine.getDireccion()); // Establece la dirección del cine en la consulta
            pstmt.executeUpdate(); // Ejecuta la consulta de inserción
            System.out.println("Cine insertado correctamente!"); // Mensaje de éxito
        } catch (SQLException e) { // Captura cualquier excepción SQL que pueda ocurrir
            if (e.getSQLState().equals("23505")) { // Verifica si se produjo un error de clave duplicada
                System.out.println("Error: El cine ya existe en la base de datos."); // Mensaje de error específico
            } else {
                System.out.println(e.getMessage()); // Muestra el mensaje de error SQL general
            }
        }
    }

    private static void insertarSala(Connection conn, Sala sala) {
        // Consulta SQL para insertar una sala en la base de datos
        String sql = "INSERT INTO SALA (CANT_BUTACA, NOMBRE_CINE) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, sala.getCantButaca()); // Establece la cantidad de butacas en la consulta
            pstmt.setString(2, sala.getNombreCine()); // Establece el nombre del cine en la consulta
            pstmt.executeUpdate(); // Ejecuta la consulta de inserción
            System.out.println("Sala insertada correctamente!"); // Mensaje de éxito
        } catch (SQLException e) { // Captura cualquier excepción SQL que pueda ocurrir
            System.out.println(e.getMessage()); // Muestra el mensaje de error SQL
        }
    }

    private static void listarCinesYSala(Connection conn) {
        // Consulta SQL para obtener la información de cines y salas
        String sql = "SELECT CINE.NOMBRE_CINE, CINE.TELEFONO, CINE.DIRECCION, SALA.ID_SALA, SALA.CANT_BUTACA " +
                     "FROM CINE LEFT JOIN SALA ON CINE.NOMBRE_CINE = SALA.NOMBRE_CINE";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) { // Ejecuta la consulta y obtiene el conjunto de resultados

            while (rs.next()) { // Itera sobre cada fila de resultados
                // Obtiene los datos de la fila actual
                String nombreCine = rs.getString("NOMBRE_CINE");
                String telefono = rs.getString("TELEFONO");
                String direccion = rs.getString("DIRECCION");
                int idSala = rs.getInt("ID_SALA");
                int cantButaca = rs.getInt("CANT_BUTACA");

                // Muestra la información del cine
                System.out.println("Cine: " + nombreCine + ", Teléfono: " + telefono + ", Dirección: " + direccion);
                // Si hay una sala asociada, muestra la información de la sala
                if (idSala != 0) {
                    System.out.println("    Sala ID: " + idSala + ", Cantidad de Butacas: " + cantButaca);
                }
            }
        } catch (SQLException e) { // Captura cualquier excepción SQL que pueda ocurrir
            System.out.println(e.getMessage()); // Muestra el mensaje de error SQL
        }
    }
}
