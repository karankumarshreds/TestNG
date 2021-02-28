FROM openjdk:11-jre-slim

## copy the artifact and rename it as container-test.jar
ADD target/container-test.jar  /usr/share/tag/container-test.jar
RUN ls -l /usr/share/tag/container-test.jar

## add xml (xl) file and rename it 
ADD order-module.xml /usr/share/tag/custom.xml
RUN ls -l /usr/share/tag/custom.xml

## running test
ENTRYPOINT java -cp /usr/share/tag/container-test.jar org.testng.TestNG /usr/share/tag/custom.xml
