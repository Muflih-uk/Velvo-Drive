# --- Build Stage ---
# Use an official Maven image to build the application
FROM maven:3.9.11-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Build the project and create the executable JAR
RUN mvn clean package -DskipTests

# --- Run Stage ---
# Use a slim OpenJDK image to run the application
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the application runs on
EXPOSE 8080

# The command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]