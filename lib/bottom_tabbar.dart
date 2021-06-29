import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'node_page.dart';
import 'message_page.dart';
import 'my_page.dart';
import 'home_toptabbar.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // 底部导航按钮数组
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      // 使用asset图片，也可以使用系统提供的图片，如Icons.home等
        icon: Image.asset(
          'images/home_unselected.png',
          width: 18,
          height: 18,
        ),
        activeIcon: Image.asset(
          'images/home_selected.png',
          width: 18,
          height: 18,
        ),
        label: '首页'),
    BottomNavigationBarItem(
        icon: Image.asset(
          'images/node_unselected.png',
          width: 18,
          height: 18,
        ),
        activeIcon: Image.asset(
          'images/node_selected.png',
          width: 18,
          height: 18,
        ),
        label: '节点'),
    BottomNavigationBarItem(
        icon: Image.asset(
          'images/message_unselected.png',
          width: 18,
          height: 18,
        ),
        activeIcon: Image.asset(
          'images/message_selected.png',
          width: 18,
          height: 18,
        ),
        label: '消息'),
    BottomNavigationBarItem(
        icon: Image.asset(
          'images/my_unselected.png',
          width: 18,
          height: 18,
        ),
        activeIcon: Image.asset(
          'images/my_selected.png',
          width: 18,
          height: 18,
        ),
        label: '我的')
  ];
  // 模块容器数组
  final List tabPages = [HomeTopIndexPage(), NodePage(), MessagePage(), MyPage()];
  // 当前选择index
  int currentIndex = 0;
  // 当前页
  var currentPage;

  @override
  void initState() {
    currentPage = tabPages[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? labelStr = bottomTabs[currentIndex].label;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        // elevation: 0,
        items: bottomTabs,
        onTap: (idx) {
          // 必须实现setState方法
          setState(() {
            currentIndex = idx;
            currentPage = tabPages[idx];
          });
        },
      ),
      body: currentPage,
    );
  }
}