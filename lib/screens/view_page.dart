import 'package:flutter/material.dart';
import 'package:onlynote2/database/db.dart';
import 'package:onlynote2/database/memo.dart';

import 'edit.dart';

class ViewPage extends StatefulWidget {
  ViewPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        appBar: AppBar(
          title: barTitleBuilder(),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: showAlertDialog,
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditPage(id: widget.id)));
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(12, 15, 12, 5),
          child: loadBuilder(),
        ));
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  loadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        if (snapshot.data == null || snapshot.data == []) {
          return Container(child: Text("데이터를 불러올 수 없습니다."));
        } else {
          Memo memo = snapshot.data[0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    memo.text,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Text(
                '생성 날짜: ' + memo.createTime.split('.')[0],
                style: TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.end,
              ),
              Text(
                '마지막 수정 날짜: ' + memo.editTime.split('.')[0],
                style: TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.end,
              ),
              Padding(padding: EdgeInsets.all(3)),
            ],
          );
        }
      },
    );
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }

  void showAlertDialog() async {
    await showDialog(
      context: _context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("정말 삭제하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '취소',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context, "취소");
              },
            ),
            FlatButton(
              child: Text(
                '삭제',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context, "삭제");
                deleteMemo(widget.id);
                Navigator.pop(_context);
              },
            ),
          ],
        );
      },
    );
  }

  barTitleBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        Memo memo = snapshot.data[0];
        return Text(
          memo.title,
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }
}
