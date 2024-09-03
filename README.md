# TaskManager

A Task Management App built with Flutter.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to Run

### Recommended Flutter Version to Use: 3.22.3
### Step 1: Run this below command on your terminal (Must be ran on your project root dir)
```yaml
1. flutter clean
2. flutter pub get
3. dart run build_runner build --delete-conflicting-outputs
```
### Step 2: Use this command according to Enviroment (Must be ran on your project root dir)
```yaml
flutter run -t lib/main.dart
```

## Run Tests
```yaml
flutter test
```
## Tech Stack
1. Flutter BLOC with Cubit for State Management
2. REST API with Dio and Retrofit
3. Sqflite for data persistence
4. Json Serializable Model using Build Runner


## Setting Up Mockoon API
	1.	Launch Mockoon: (Don't have mockoon desktop installed? Dowload here: https://mockoon.com/download/)
	•	Open the Mockoon app on your desktop.
	2.	Create a New Environment:
	•	Click on + New environment at the top-left corner.
	•	Give your environment a name, e.g., “CRUD API.”
    	•  	 In the routes tab, specify the path as "tasks"
    	•   	Go to the settings tab and specifiy the following values: 
        	port: 3001, prefix: taskmanager/api
	•	Set a port number for your environment to 3001.

