# Use a Maven image with OpenJDK to build the application
FROM maven AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code into the container
COPY src ./src

# Package the application (including tests if necessary)
RUN mvn clean package

# Copy the built JAR file to a designated directory
RUN mkdir -p /output
RUN cp target/*.jar /output/

# For demonstration purposes, print the contents of the output directory
RUN ls -l /output

# The final image stage (if you want to run the application within the same Dockerfile)
# Alternatively, you can use the image only to build and then extract the JAR file.
FROM openjdk

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /output/*.jar app.jar

# Expose the port on which the application runs
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

