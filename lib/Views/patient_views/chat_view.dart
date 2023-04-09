import 'package:flutter/material.dart';
import 'package:hospitalmanagementsystem/Containers/side_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("View"),
      ),
      body: Center(
        child: FloatingActionButton(
            onPressed: () => launch("tel://01068338658"),
            child: const Text("Call me")),
      ),
    );
  }
}
