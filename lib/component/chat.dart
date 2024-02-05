import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:sendbird_chat_app/constants/colors.dart';

class SenderMessage extends StatelessWidget {
  final String message;

  const SenderMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Bubble(
        margin: const BubbleEdges.only(top: 10),
        alignment: Alignment.topRight,
        nipWidth: 30,
        nipHeight: 10,
        nip: BubbleNip.rightTop,
        color: Colors.transparent, // Set the bubble color to transparent
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 192, 203, 1.0), // Light Pink
                Color.fromRGBO(255, 105, 180, 1.0), // Deep Pink
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white), // Text color
            ),
          ),
        ),
      ),
    );
  }
}

class ReceiverMessage extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final String imageUrl;

  const ReceiverMessage({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bubble(
                nipWidth: 30,
                nipHeight: 10,
                nip: BubbleNip.leftTop,
                showNip: false,
                color: darkGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: darkWhite),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                    // Adjust the space between message and time
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 150),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Transform.translate(
                    offset: const Offset(0, -10),
                    child: Text(
                      time,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
