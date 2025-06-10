# Use an official OpenJDK image as the base
FROM eclipse-temurin:17-jdk-alpine

# 設定工作目錄
WORKDIR /app

# 複製 Maven Wrapper 及 pom.xml
COPY mvnw* pom.xml ./
COPY .mvn .mvn

# 先下載依賴，利用快取
RUN ./mvnw dependency:go-offline

# 複製專案所有檔案
COPY . .

# 打包 Spring Boot 應用
RUN ./mvnw package -DskipTests

# 執行 Spring Boot JAR
CMD ["java", "-jar", "target/demo2-0.0.1-SNAPSHOT.jar"]

