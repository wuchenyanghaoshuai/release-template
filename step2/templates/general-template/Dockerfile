FROM 192.168.100.36:1179/xiaoke/general-template:base

# Workdir
#WORKDIR $PROJECT_PATH

# Copy project to docker
COPY . $PROJECT_PATH

# Build faster
#RUN mkdir ~/.gradle
#RUN touch ~/.gradle/gradle.properties && echo "org.gradle.daemon=true" >> ~/.gradle/gradle.properties

# Compile
RUN ./gradlew clean build

# Copy jar to docker
RUN cp -r $PROJECT_PATH/build/libs/*.jar $PROJECT_PATH/

# Copy scripts to docker
COPY release/config.sh $PROJECT_PATH
COPY release/run.sh $PROJECT_PATH

# Chmod scripts
RUN chmod 755 $PROJECT_PATH/run.sh

# ENV
ENV JAVA_OPTS="-Duser.timezone=GMT+8 -Xms256m -Xmx2048m"

# Startup auto run scripts
ENTRYPOINT ["./run.sh"]
