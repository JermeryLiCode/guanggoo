import 'package:flutter/material.dart';
import 'bottom_tabbar.dart';
// 2. 调用runApp
void main() => runApp(new MyApp());

// 3. 实现静态组件
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      // 4. 调用IndexPage()方法，填充组件
      home: IndexPage(),
      theme: new ThemeData(
        primaryColor: Colors.orange,
      ),
    );
  }
}
