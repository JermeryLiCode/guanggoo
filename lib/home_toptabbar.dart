
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homepages/defaultsort_page.dart';

class HomeTopIndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('光谷社区', style: TextStyle(
            fontSize: 18,
            color: Colors.white),),
          backgroundColor: Colors.pinkAccent,
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                text: "默认排序",
              ),
              Tab(
                text: "最新话题",
              ),
              Tab(
                text: "精华主题",
              ),
              Tab(
                text: "兴趣节点",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DefaultSortPage(key: Key('1'),sort: Sort.defaultSort),
            DefaultSortPage(key: Key('2'),sort: Sort.topicSort),
            DefaultSortPage(key: Key('3'),sort: Sort.themeSort),
            DefaultSortPage(key: Key('4'),sort: Sort.nodeSort)]
        ),
      ),
    );
  }
}