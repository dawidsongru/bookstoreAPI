package runneres;

import com.intuit.karate.junit5.Karate;

public class GetusuarioTestRunner {
    @Karate.Test
    public Karate runGetusuarios() {
        // Caminho correto considerando onde está
        return Karate.run("classpath:feature/usuarios/GetUsuarios.feature");
    }
}