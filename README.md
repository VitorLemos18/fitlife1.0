# fitlife_app

Aplicativo Flutter do projeto **FitLife** com API em Spring Boot.

Este README mostra como rodar o app Flutter e a API Spring Boot de forma prática.

---

## Requisitos

Instale antes de rodar o projeto:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (já vem com o Flutter)
- Android Studio ou VS Code
- Git
- Java 17 ou superior
- [Spring Boot](https://spring.io/projects/spring-boot)
- Um emulador Android ou celular com depuração USB ativado
- Postgres (ou outro banco configurado na API)

Para verificar Flutter:

```bash
flutter doctor
```

Para verificar Java:

```bash
java --version
```

---

## Clonando o projeto

```bash
git clone https://github.com/Fellipe-lessa/fitlife_app.git
cd fitlife_app
```

---

## Rodando o app Flutter

### 1. Instalar dependências

Vai na pasta do app Flutter:

```bash
cd fitlife_app
flutter pub get
```

### 2. Rodar o app

```bash
flutter run
```

Se tiver mais de um dispositivo:

```bash
flutter devices
flutter run -d <device_id>
```

Exemplo:

```bash
flutter run -d emulator-5554
```

---

## Rodando a API Spring Boot

### 1. Navegar até a pasta da API

O projeto da API está dentro de:

```bash
cd api
```

### 2. Compilar e rodar com Maven

Se já tem Maven instalado:

```bash
mvn clean spring-boot:run
```

Se não tem Maven instalado, use o wrapper do projeto:

```bash
./mvnw clean spring-boot:run
```

No Windows (PowerShell):

```bash
mvnw.cmd clean spring-boot:run
```

### 3. Verificar se a API está rodando

A API deve estar em:
http://localhost:8080


Um endpoint comum para testar:

```bash
curl http://localhost:8080/usuarios
```

Ou acesse no navegador.

---

## Comandos úteis

### Flutter

```bash
flutter pub get
flutter run
flutter clean
flutter analyze
flutter test
flutter build apk --debug
```

### Spring Boot

```bash
mvn clean spring-boot:run
mvn clean install
./mvnw clean spring-boot:run
```

---

## Sequência rápida

Para rodar o projeto completo:

```bash
# API Spring Boot
cd fitlife_app/api
./mvnw clean spring-boot:run

# App Flutter
cd fitlife_app
flutter pub get
flutter run
```
