public class Sala {
    private int cantButaca;
    private String nombreCine;

    public Sala(int cantButaca, String nombreCine) {
        this.cantButaca = cantButaca;
        this.nombreCine = nombreCine;
    }

    public int getCantButaca() {
        return cantButaca;
    }

    public String getNombreCine() {
        return nombreCine;
    }
}
