# Use a specific platform (Linux) for the base image
FROM --platform=linux/amd64 openjdk:11-jre-slim as base

# Set the working directory in the container
WORKDIR /app

# Copy the local code to the container
COPY . /app

RUN mkdir -p /usr/local/newrelic

# Set a health check
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

# Install curl for downloading New Relic
RUN apt-get update && apt-get install -y curl zip && rm -rf /var/lib/apt/lists/*

# Download New Relic Java agent and configuration
RUN curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && \
    unzip newrelic-java.zip -d /usr/local/newrelic && \
    rm newrelic-java.zip

# Copy your preconfigured New Relic yml file (assuming it's prepared in your project directory)
COPY newrelic.yml /usr/local/newrelic/newrelic.yml
#COPY HelloWorld.jar /usr/local/newrelic/HelloWorld.jar

# Make sure your application's jar file is in the container (assuming it's built and named my-application.jar)
COPY HelloWorld.jar /usr/local/newrelic/HelloWorld.jar

COPY ./newrelic/newrelic.jar /usr/local/newrelic/newrelic.jar


# Set the New Relic agent in the Java options
ENV JAVA_OPTS="-javaagent:/usr/local/newrelic/newrelic.jar"

# Command to run the application
ENTRYPOINT ["java", "-javaagent:/usr/local/newrelic/newrelic.jar", "-jar", "HelloWorld.jar"]
