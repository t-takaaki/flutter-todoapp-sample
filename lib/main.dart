import 'package:flutter/material.dart';

void main() {
  runApp(MyTodoApp());
}


class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示される"debug"ラベルを消す
      debugShowCheckedModeBanner: false,
      // アプリ名
      title: 'My Todo App',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // リスト一覧画面を表示
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

// リスト一覧画面用Widget
class _TodoListPageState extends State<TodoListPage> {
  // Todoリストのデータ
  List<String> todoList = ["ほげほげ", "ふがふが", "ぴよぴよ"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text("リスト一覧"),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(todoList[index]),
              trailing: Icon(Icons.more_vert),
              onTap: () {
                // https://qiita.com/coka__01/items/4c1aea5fb1646e463f91#alertdialog
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("削除しますか？"),
                      actions: <Widget>[
                        // ボタン領域
                        FlatButton(
                          child: Text("キャンセル"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text("OK", style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            setState((){
                              todoList.removeAt(index);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"で新規画面に遷移 -> awaitで遷移先から値が返ってくるまで待ってる
          // リスト追加画面から渡される値を受け取る
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return TodoAddPage();
            }),
          );
          if (newListText != null) {
            // キャンセルした場合は newListText が null となるので注意
            setState(() {
              // リスト追加
              todoList.add(newListText);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

// リスト追加画面用Widget
class _TodoAddPageState extends State<TodoAddPage> {
  // 入力されたテキストをデータとして持つ
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("リスト追加"),
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // テキスト入力
            Text(_text, style: TextStyle(color: Colors.blue)),
            TextField(
              // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
              onChanged: (String value) {
                // データが変更したことを知らせる（画面を更新する）
                setState(() {
                  // データを変更
                  _text = value;
                });
              },
            ),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // リスト追加ボタン
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  // "pop"の引数から前の画面にデータを渡す
                  Navigator.of(context).pop(_text); // popの引数にわたすだけ！簡単！
                },
                child: Text('リスト追加', style: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // キャンセルボタン
              child: FlatButton(
                // ボタンをクリックした時の処理
                onPressed: () {
                  // "pop"で前の画面に戻る
                  Navigator.of(context).pop();
                },
                child: Text('キャンセル'),
              ),
            ),
          ],
        ),
      ),
      /*
      body: Center(
        child: FlatButton(
          // ボタンをクリックした時の処理
          onPressed: () {
            // "pop"で前の画面に戻る
            Navigator.of(context).pop();
          },
          child: Text('リスト追加画面（クリックで戻る）'),
        ),
      ),
      */
    );
  }
}
