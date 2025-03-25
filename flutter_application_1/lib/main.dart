import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<String> messages = [];
  Color _bgColor = Colors.white;

  void addText() {
    setState(() {
      messages.add('Hello World!');
    });
  }

  void removeText() {
    setState(() {
      if (messages.isNotEmpty) {
        messages.removeLast();
      }
    });
  }

  void changeColor() {
    setState(() {
      _bgColor = _bgColor == Colors.white ? Colors.blue[100]! : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          title: Text('Flutter Assignment'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: addText,
                  child: Text('Add Text'),
                ),
                ElevatedButton(
                  onPressed: removeText,
                  child: Text('Remove Text'),
                ),
                ElevatedButton(
                  onPressed: changeColor,
                  child: Text('Change Color'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}