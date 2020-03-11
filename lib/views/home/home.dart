import 'package:flutter/material.dart';
import 'package:waring_demo/models/home_model.dart';
import 'package:waring_demo/network/http_request.dart';
import 'package:intl/intl.dart';
import 'dart:async';

//import 'home_child/home_child.dart';

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
  Timer _timer;

  get index => null;
  @override
  void initState() {
    super.initState();
    this._getData();
    this._startTimer();
  }

  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        var id = userList[index].id;
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 10,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(10),
            // decoration: BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(width: 10, color: Color(0xffe2e2e2)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                  child: Text(
                    '警报时间:' +
                        DateFormat.yMd()
                            .add_jm()
                            .format(DateTime.parse(userList[index].createdAt)),
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('警报楼号：',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 9),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    userList[index].building + '号楼',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: <Widget>[
                                Text('警报楼层：',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 9),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    userList[index].floor + '层',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: <Widget>[
                                Text('警报楼床：',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 9),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    userList[index].bed + '床',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        FlatButton(
                          color: Colors.red,
                          highlightColor: Colors.blue[700],
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text("了解"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            HttpRequest.request(
                                    'http://47.97.251.68:3000/call/inActiveCall/' +
                                        id,
                                    method: 'post')
                                .then((res) {
                              print(res);
                              this._getData();
                            });
                          },
                        )
                      ],
                    )),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //     color: Color(0xfff2f2f2),
                  //     borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    '住户信息：' + userList[index].id,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                )
              ],
            ),
          ),
        );
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

  void _startTimer() {
    /*创建循环*/
    _timer = new Timer.periodic(new Duration(seconds: 3), (timer) {
      setState(() {
        this._getData();
      });
    });
  }
}
