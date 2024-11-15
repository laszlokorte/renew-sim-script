# Variables
JAVAC = javac
JAR = jar
SRC = Interceptor.java
CLASS = Interceptor.class
JAR_FILE = Interceptor.jar
MANIFEST = manifest2.txt

# Default target
all: $(JAR_FILE)

# Compile the Java source file
$(CLASS): $(SRC)
	$(JAVAC) $(SRC)

# Create a JAR file with a manifest
$(JAR_FILE): $(CLASS) $(MANIFEST)
	$(JAR) cfm $(JAR_FILE) $(MANIFEST) $(CLASS)

# Clean up compiled and packaged files
clean:
	rm -f $(CLASS) $(JAR_FILE)

# PHONY targets to avoid conflicts with file names
.PHONY: all clean