# ─────────────────────────────────────────
# Stage 1: Compile
# ─────────────────────────────────────────
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

# Copy all Java source files
COPY src/ src/

# Compile every .java file, outputting .class files to /app/out
RUN mkdir -p out && \
    find src -name "*.java" > sources.txt && \
    javac -d out @sources.txt

# Package into a JAR with the correct Main-Class manifest
RUN jar cfe AirportManagementSystem.jar airport.system.AirportSystem -C out .

# ─────────────────────────────────────────
# Stage 2: Run
# ─────────────────────────────────────────
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy only the compiled JAR from the builder stage
COPY --from=builder /app/AirportManagementSystem.jar .

# Run the application
ENTRYPOINT ["java", "-jar", "AirportManagementSystem.jar"]
