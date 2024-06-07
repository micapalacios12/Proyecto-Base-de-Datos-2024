public class Sala {
    //atributos
    private int cantButaca;
    private String nombreCine;

    //constructor
    public Sala(int cantButaca, String nombreCine) {
        this.cantButaca = cantButaca;
        this.nombreCine = nombreCine;
    }

    //geters
    public int getCantButaca() {
        return cantButaca;
    }

    public String getNombreCine() {
        return nombreCine;
    }
}
