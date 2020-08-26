import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlynote2/database/db.dart';
import 'package:onlynote2/database/memo.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class WritePage extends StatefulWidget {
  WritePage({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String title = '';
  String text = '';
  String createTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: TextField(
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
            autofocus: true,
            onChanged: (String title) {
              this.title = title;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '제목',
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.star_border), onPressed: () {} // 즐겨찾기 추가
                ),
            IconButton(
                icon: Icon(Icons.save_alt),
                onPressed: () {
                  saveDB();
                }),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(12, 2, 12, 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(3)),
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  controller: TextEditingController(),
                  onChanged: (String text) {
                    this.text = text;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> saveDB() async {
    //저장 함수
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: str2Sha512(DateTime.now().toString()),
      title: this.title,
      text: this.text,
      createTime: DateTime.now().toString(),
      editTime: DateTime.now().toString(),
    );
    await sd.insertMemo(fido);

    print(await sd.memos());
    Navigator.pop(context); //오류나면 이거 점검
  }

  String str2Sha512(String text) {
    //메모별 id 랜덤배정을 위한 암호화함수
    var bytes = utf8.encode(text); // data being hashed

    var digest = sha512.convert(bytes);
    return digest.toString();
  }
}
