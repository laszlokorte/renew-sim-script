import java.io.*;
import java.nio.file.*;
import java.util.concurrent.*;

public class Interceptor {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(2);

        try {
            // Start the external process (e.g., "cat")
            ProcessBuilder processBuilder = new ProcessBuilder(args);
            Process process = processBuilder.start();

            // ExecutorService to manage input/output threads

            // Piping stdin to the subprocess's stdin (writing to subprocess)
            executor.submit(() -> {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
                     BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        writer.write(line);
                        writer.newLine();
                        writer.flush();  // Make sure it's sent immediately
                    }
                    process.destroy();
                } catch (IOException e) {
                    process.destroy();
                }
            });

            // Piping subprocess's stdout to Java's stdout (reading from subprocess)
            executor.submit(() -> {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        System.out.println(line);  // Output subprocess's output to System.out
                    }
                } catch (IOException e) {
                    process.destroy();
                }
            });

            System.exit(process.waitFor());
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        } finally {
            executor.shutdown();
            try {
                executor.awaitTermination(1, TimeUnit.SECONDS);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}