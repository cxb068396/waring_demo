import 'package:flutter/material.dart';
import 'package:waring_demo/models/home_model.dart';
import 'package:waring_demo/network/http_request.dart';

import 'home_child/home_child.dart';

class Home extends StatelessWidget {
  final Widget child;

  Home({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('首页'),
        ),
        body: HomeBody());
  }
}

class HomeBody extends StatefulWidget {
  final Widget child;

  HomeBody({Key key, this.child}) : super(key: key);

  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<HomeModel> userList = [];

  get index => null;
  @override
  void initState() {
    super.initState();
    this._getData();
  }

  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        return HomeListItem(userList[index]);
      },
    ));
  }

//获得首页的数据
  void _getData() {
    HttpRequest.request('http://47.97.251.68:3000/call/activeCall').then((res) {
      print(res.data);
      List<HomeModel> users = [];
      for (var user in res.data) {
        users.add(HomeModel.fromJson(user));
      }
      setState(() {
        this.userList = users;
      });
    });
  }
}
