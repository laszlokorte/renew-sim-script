import java.io.*;
import java.nio.file.*;
import java.util.concurrent.*;

public class Interceptor {
    public static void main(String[] args) {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder(args);
            Process process = processBuilder.start();

            CompletableFuture<Boolean> input = CompletableFuture.supplyAsync(() -> {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
                     BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        writer.write(line);
                        writer.newLine();
                        writer.flush();  // Make sure it's sent immediately
                    }
                } catch (IOException e) {
                    throw new RuntimeException(e);
                } finally {
                    return true;
                }
            });

            // Piping subprocess's stdout to Java's stdout (reading from subprocess)
            CompletableFuture<Boolean> output = CompletableFuture.supplyAsync(() -> {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        System.out.println(line);  // Output subprocess's output to System.out
                    }
                } catch (IOException e) {
                    throw new RuntimeException(e);
                } finally {
                    return true;
                }
            });

            CompletableFuture.anyOf(input, output).thenRun(process::destroy);

            System.exit(process.waitFor());
        } catch(InterruptedException|IOException e) {
            throw new RuntimeException(e);
        }
    }
}