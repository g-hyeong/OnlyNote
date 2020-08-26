import 'package:flutter/material.dart';
import 'package:onlynote2/database/memo.dart';
import 'package:onlynote2/database/db.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  BuildContext _context;

  String title = '';
  String text = '';
  String createTime = '';

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: barTitleBuilder(),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                updateDB();
                Navigator.pop(_context);
              },
            )
          ],
        ),
        body: Padding(padding: EdgeInsets.all(20), child: loadBuilder()));
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

          title = memo.title;
          text = memo.text;

          var tecTitle = TextEditingController();
          title = memo.title;
          tecTitle.text = title;

          var tecText = TextEditingController();
          text = memo.text;
          tecText.text = text;

          createTime = memo.createTime;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(3)),
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  controller: tecText,
                  maxLines: null,
                  onChanged: (String text) {
                    this.text = text;
                    updateDB();
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  barTitleBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        Memo memo = snapshot.data[0];

        title = memo.title;

        var tecTitle = TextEditingController();
        title = memo.title;
        tecTitle.text = title;

        return TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: tecTitle,
            onChanged: (String title) {
              this.title = title;
              updateDB();
            },
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400));
      },
    );
  }

  void updateDB() {
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: widget.id, // String
      title: this.title,
      text: this.text,
      createTime: this.createTime,
      editTime: DateTime.now().toString(),
    );

    sd.updateMemo(fido);
    //Navigator.pop(_context);
  }
}
