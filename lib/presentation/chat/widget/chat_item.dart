import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.isMe, required this.message});

  final bool isMe;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: Image.network(isMe
                    ? "https://upload.wikimedia.org/wikipedia/commons/7/71/Black.png"
                    : "https://freelogopng.com/images/all_img/1681038242chatgpt-logo-png.png"),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              isMe ? "YOU".toUpperCase() : "CHATGPT".toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        SelectableText(
          message.trim(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
