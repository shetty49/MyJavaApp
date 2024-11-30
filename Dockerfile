# Stage 1: Use Maven to build the WAR file
FROM maven:3.8.5-openjdk-11 AS builder

# Set the working directory
WORKDIR /app

# Copy the project files to the container
COPY . .

# Build the WAR file
RUN mvn clean package

# Stage 2: Use Tomcat to deploy the application
FROM tomcat:9.0

# Change Tomcat's default port to 5000
RUN sed -i 's/port="8080"/port="5000"/g' /usr/local/tomcat/conf/server.xml

# Copy the WAR file from the builder stage to the Tomcat webapps directory
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/MyJavaApp.war

# Expose the custom port
EXPOSE 5000

# Default command to start Tomcat
CMD ["catalina.sh", "run"]

