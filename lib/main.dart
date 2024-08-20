import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'searchbar.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(600, 900),
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            headlineMedium: TextStyle(color: Colors.white, fontSize: 14.sp),
            titleMedium: TextStyle(color: Colors.white, fontSize: 8.sp),
            bodyMedium: TextStyle(color: Colors.white, fontSize: 6.sp),
            bodyLarge: TextStyle(color: Colors.white, fontSize: 8.sp),
          ),
        ),
        home: SearchBarPage(apiService: apiService),
      ),
    );
  }
}