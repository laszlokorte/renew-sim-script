import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

class Main {
	public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("Welcome to the console app!");
        System.out.println("Type 'exit' to quit.");

        while (true) {
            System.out.print(">> "); // Prompt
            try {
                String input = reader.readLine();

                if (input == null) {
                    // `readLine` returns null when EOF is encountered
                    System.out.println("\nEOF detected. Exiting.");
                    return;
                }

                // Check for exit command
                if ("exit".equalsIgnoreCase(input)) {
                    System.out.println("Goodbye!");
                    break;
                }

                // Process the input (example: echo back to user)
                System.out.println("You typed: " + input);


            } catch (IOException e) {
                System.err.println("An error occurred while reading input: " + e.getMessage());
                return;
            }
        }
	}
}