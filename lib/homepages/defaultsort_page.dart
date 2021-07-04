import 'dart:collection';
import 'dart:convert' show JsonDecoder, jsonDecode, utf8;
// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:guanggoo/model/TopicInfoModel.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html/dom.dart' as dom;
// ignore: import_of_legacy_library_into_null_safe
import 'package:html/parser.dart';
enum Sort {
  defaultSort,
  themeSort,
  nodeSort,
  topicSort
}
// ignore: must_be_immutable
class DefaultSortPage extends StatefulWidget {
  Sort sort;
  DefaultSortPage({required Key key,required this.sort}) : super(key: key);

  @override
  FriendsState createState() => new FriendsState();
}


class FriendsState extends State<DefaultSortPage> {
  int page = 1;
  List<TopicInfoModel> topicList = [];
  var baseUrl = "http://www.guanggoo.com/";

  late GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    // 进入页面立即显示刷新动画
    SchedulerBinding.instance!.addPostFrameCallback((_){  _refreshIndicatorKey.currentState?.show(); } );

    this._onRefresh();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _onLoadmore();
      }
    });
  }

  _fetchData() async {

    List<TopicInfoModel> topicList = [];
    try {
      Dio dio = new Dio();
      String url = '${this.baseUrl}?p=${this.page}';
      if(widget.sort == Sort.topicSort) {
        url = '${this.baseUrl}?tab=latest?p=${this.page}';
      }else if(widget.sort == Sort.themeSort) {
        url = '${this.baseUrl}?tab=elite?p=${this.page}';
      }else if(widget.sort == Sort.nodeSort) {
        url = '${this.baseUrl}?tab=node?p=${this.page}';
      }
      // 发起请求获取首页的html数据
      Response res = await dio.get(url);
      var document = parse(res.data.toString());
      // 解析标签的值
      List<dom.Element> items = document.getElementsByClassName('topic-item');
      items.forEach((element) {
        String topicItemImageSrc = element.getElementsByTagName('img').first.attributes['src'].toString();

        List<dom.Element> titleElements = element.getElementsByClassName('title');
        String titleText = _matchString(titleElements.first.text.toString());
        String titleHref = element.getElementsByTagName('a').first.attributes['href'].toString();

        List<dom.Element> metaElements = element.getElementsByClassName('node');
        String nodeText = _matchString(metaElements.first.text.toString());

        List<dom.Element> userNameElements = element.getElementsByClassName('username');
        String userNameText = _matchString(userNameElements.first.text.toString());
        String userNameHref = element.getElementsByTagName('a').first.attributes['href'].toString();

        List<dom.Element> lastTouchedElements = element.getElementsByClassName('last-touched');
        String lastTouchedText = _matchString(lastTouchedElements.first.text.toString());

        List<dom.Element> lastReplyElements = element.getElementsByClassName('last-reply-username');
        String lastReplyText = "";
        if(lastReplyElements.length != 0) {
          lastReplyText = _matchString(lastReplyElements.first.text.toString());
        }
        String lastReplyHref = element.getElementsByTagName('a').first.attributes['href'].toString();

        List<dom.Element> countElements = element.getElementsByClassName('count');
        String countText = "";
        if(countElements.length != 0) {
          countText = _matchString(countElements.first.text.toString());
        }

        TopicInfoModel friendsModel = new TopicInfoModel(titleText,titleHref,nodeText,
            topicItemImageSrc,userNameText,userNameHref,
            lastReplyText,lastReplyHref,(countText.length != 0?int.parse(countText):0),lastTouchedText,'','','','',[]);
        topicList.add(friendsModel);
      });

    } catch (exception) {
      print(exception.toString());
    }
    return topicList;
  }
  
  String _matchString(String str) {
    String str1 = str.replaceAll(new RegExp(r"\\s*|\t|\r|\n"), "");
    String str2 = str1.replaceAll(new RegExp(r"\s+"), "");
    return str2.replaceAll("/u/", "");
  }

  Future<dynamic> _onRefresh() {
    this.topicList.clear();
    this.page = 1;
    return _fetchData().then((data) {
      setState(() => this.topicList.addAll(data));
    });
  }

  Future<dynamic> _onLoadmore() {
    this.page++;
    return _fetchData().then((data) {
      setState((){
        this.topicList.addAll(data);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _loadMoreWidget() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
          child: new CircularProgressIndicator()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
              controller: _scrollController,
              itemCount: this.topicList.length,
              itemBuilder: (context, index) {
                if (index == topicList.length - 1) {
                  return _loadMoreWidget();
                } else {
                  TopicInfoModel _data = this.topicList[index];
                  return _buildRow(_data);
                }
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            )
        ));
  }
}

  Widget _buildRow(TopicInfoModel friendsModel) {

    return Container(
      margin: const EdgeInsets.all(10),
      child:Column(
        children: [
          _buildTopContent(friendsModel),
          SizedBox(height: 8,),
          _buildBotContent(friendsModel)
        ],
      )
    );
  }

  Widget _buildTopContent(TopicInfoModel friendsModel) {
  return Row(
    children: [
      Image.network(friendsModel.creatorImg,width: 30, height: 30,),
      SizedBox(width: 10,),
      _buildTextTitle(friendsModel),
      Flexible(fit: FlexFit.tight, child: SizedBox()),
      Align(
        alignment: Alignment.centerRight,
        child:
        _buildTopRightContent(friendsModel)
      )
    ],
  );
  }

  Widget _buildBotContent(TopicInfoModel friendsModel) {
  return Container(
      alignment: Alignment.centerLeft,
      child: Text(friendsModel.title,textAlign: TextAlign.left,style: TextStyle(color: Colors.black54)));
  }

  Widget _buildTextTitle(TopicInfoModel friendsModel) {
   return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text(friendsModel.creatorName,textAlign: TextAlign.left,style: TextStyle(color: Colors.black54)),
          Text(friendsModel.replyDescription,textAlign: TextAlign.left,style: TextStyle(color: Colors.black54)),
        ]);
  }

  Widget _buildTopRightContent(TopicInfoModel friendsModel) {
  return Row(
    children: [
      Text(friendsModel.node,textAlign: TextAlign.left,style: TextStyle(color: Colors.grey)),
      SizedBox(width: 5),
      Container(
      child:  Text(friendsModel.replyCount.toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.grey)),
      alignment: Alignment.center,
      width: 15.0,
      height: 15.0,
      decoration:
      new BoxDecoration(
    border: Border.all(width: 1.0,color: Colors.black12)),
    )
    ],
  );
  }