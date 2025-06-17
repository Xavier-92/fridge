# Fridge Mode 專案

## 作者
- 作者：Xavier Yu
- Email：b11112015@yuntech.edu.tw
- GitHub：[xavier-92](https://github.com/xavier-92)

## 專案簡介
本專案為一個結合 Spring Boot 後端與 Flutter 前端的冰箱管理應用，提供食材管理、購物清單等功能。
- `demo2/`：Spring Boot RESTful API 伺服器，負責資料處理與儲存。
- `my_fridge_app/`：Flutter 前端應用，提供跨平台（iOS/Android/Web）使用者介面。

---

## 專案結構
```
spring-demo/
│
├── demo2/              # Spring Boot 後端
│   ├── src/            # Java 原始碼
│   ├── pom.xml         # Maven 設定
│   ├── Dockerfile      # Docker 映像檔建置
│   └── docker-compose.yml # Docker Compose 設定
│
└── my_fridge_app/      # Flutter 前端
    ├── lib/            # Dart 原始碼
    ├── ios/            # iOS 原生專案
    ├── web/            # Web 專案
    ├── windows/        # Windows 專案
    └── pubspec.yaml    # Flutter 套件設定
```

---

## 環境需求
- JDK 17 以上
- Maven 3.6+
- Docker & Docker Compose
- Flutter 3.x
- 視開發裝置需求，需加入如Xcode(iOS)等各大載體之模擬器

---

## 快速開始

### 1. 啟動 Spring Boot 後端

進入 `demo2` 資料夾，執行：
```bash
./mvnw clean package
docker-compose up --build
```
或單獨建置 JAR：
```bash
./mvnw clean package
java -jar target/*.jar
```

### 2. 啟動 Flutter 前端

進入 `my_fridge_app` 資料夾，執行：
```bash
flutter pub get
flutter run
```
如需啟動 Web 版：
```bash
flutter run -d chrome
```

---

## 常用指令

### Spring Boot
- 打包 JAR：`./mvnw clean package`
- Docker 建置：`docker build -t demo2-app .`
- Docker Compose 啟動：`docker-compose up --build`
- 停止並移除資料庫：`docker-compose down -v`

### Flutter
- 安裝套件：`flutter pub get`
- 執行 App：`flutter run`
- 執行 Web：`flutter run -d chrome`

---

## 其他說明
- 若需自訂資料庫連線，請修改 `demo2/src/main/resources/application.properties`。
- Flutter 專案支援多平台，請依需求選擇目標裝置。
- 可以將Docker部署至線上平台，以節省本地架設資源

---

如需協助，請開啟 issue 或聯絡專案維護者。
