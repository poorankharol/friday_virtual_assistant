import 'package:flutter/material.dart';
import 'package:friday_virtual_assistant/presentation/chat/screen/new_chat_screen.dart';
import 'package:friday_virtual_assistant/presentation/image/screen/image_generate_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    const NewChatScreen(),
    const ImageGenerateScreen()
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        title: selectedIndex == 0 ? const Text("Chat") : const Text("Image") ,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text(
                'Friday\nOpen AI',
                style: TextStyle(fontSize: 30),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/images/chat.png",
                height: 25,
                width: 25,
              ),
              title: const Text('New Chat'),
              onTap: () {
                onItemTapped(0);
              },
              selected: selectedIndex == 0,
            ),
            ListTile(
              leading: Image.asset(
                "assets/images/picture.png",
                height: 28,
                width: 28,
              ),
              title: const Text('Generate Image'),
              onTap: () {
                onItemTapped(1);
              },
              selected: selectedIndex == 1,
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: widgetOptions[selectedIndex],
      ),
    );
  }
}
