import 'package:flutter/material.dart';
import 'package:onlynote2/database/db.dart';
import 'package:onlynote2/database/memo.dart';
import 'package:onlynote2/screens/view_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = '';
  String text = '';
  String deleteId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '현재 위치',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search), color: Colors.white, onPressed: () {})
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('드로워헤더'),
              decoration: BoxDecoration(color: Color(0xffB5B2FF)),
            ),
            ListTile(
              title: Text('리스트타이틀제목'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('리스트타이틀2'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor, //아이콘 색
        onPressed: () {
          Navigator.pushNamed(context, '*second');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 8)),
          Expanded(
            child: memoBuilder(context),
          )
        ],
      ),
    );
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Future<List<Memo>> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          content: Text("정말 삭제하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text('삭제'),
              textColor: Colors.black,
              onPressed: () {
                Navigator.pop(context, "삭제");
                setState(() {
                  deleteMemo(deleteId);
                  deleteId = '';
                });
              },
            ),
            FlatButton(
              child: Text('취소'),
              textColor: Colors.black,
              onPressed: () {
                deleteId = '';
                Navigator.pop(context, "취소");
              },
            ),
          ],
        );
      },
    );
  }

  Widget memoBuilder(BuildContext parentContext) {
    return FutureBuilder(
      builder: (context, Snap) {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: Snap.data.length,
          itemBuilder: (context, index) {
            Memo memo = Snap.data[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    parentContext,
                    MaterialPageRoute(
                        builder: (context) => ViewPage(id: memo.id)));
              },
              onLongPress: () {
                deleteId = memo.id;
                showAlertDialog(parentContext);
              },
              child: Container(
                margin: EdgeInsets.all(4.5),
                padding: EdgeInsets.all(5),
                height: 100,
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)],
                    color: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 0.5)),
                child: Column(
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            memo.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(padding: EdgeInsets.all(2.5)),
                          Text(
                            memo.text,
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            memo.createTime.split('.')[0],
                            style: TextStyle(fontSize: 9),
                            textAlign: TextAlign.end,
                          ),
                        ]),
                  ],
                ),
              ),
            );
          },
        );
      },
      future: loadMemo(),
    );
  }
}
