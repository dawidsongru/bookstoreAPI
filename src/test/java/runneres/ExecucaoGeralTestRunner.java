package runneres;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class ExecucaoGeralTestRunner {

    @Test
    public void runExecucaoGeralParalela() {
        Runner.Builder builder = new Runner.Builder();
        builder.path("classpath:features");
        Results result = builder.parallel(5);
        assertEquals(0, result.getFailCount());
    }
}
