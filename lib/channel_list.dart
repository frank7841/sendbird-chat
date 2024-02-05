import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_app/component/chat.dart';
import 'package:sendbird_chat_app/constants/colors.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class ChatListScreen extends StatefulWidget {
  final String openChannelUrl;

  const ChatListScreen({Key? key, required this.openChannelUrl})
      : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late TextEditingController _messageController;
  late OpenChannel? openChannel;
  List<Map<String, String>> messages = [];
  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    initializeOpenChannel();

    addReceivedMessage(
      '목이길어슬픈기린',
      '너 T발 C야?',
      '2분 전',
      'https://images.unsplash.com/photo-1583122624368-93607357113c?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    );
    addReceivedMessage(
      'Jane Smith',
      'Hello there!',
      '10분 전',
      'https://images.unsplash.com/photo-1570527140771-020891229bb4?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    );
  }

  Future<void> initializeOpenChannel() async {
    try {
      openChannel = await OpenChannel.getChannel(widget.openChannelUrl);

      // print("Open channel Entered: ${openChannel.channelUrl}");
      // print("Open channel name: ${openChannel.name}");
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  void addSentMessage(String messageText) {
    setState(() {
      messages.add({'type': 'sent', 'message': messageText});
    });
  }

  // Function to add received messages to the list
  void addReceivedMessage(
      String senderName, String messageText, String time, String imageUrl) {
    setState(() {
      messages.add({
        'type': 'received',
        'senderName': senderName,
        'message': messageText,
        'time': time,
        'imageUrl': imageUrl,
      });
    });
  }

  Future<void> sendMessage() async {
    try {
      final messageText = _messageController.text;
      final params = UserMessageCreateParams(message: _messageController.text)
        ..data = 'DATA'
        ..customType = 'CUSTOM_TYPE';

      openChannel?.sendUserMessage(params, handler: (message, e) {
        if (e != null) {
          // Handle error.
          // print('Error sending message: $e');
        } else {
          // Handle successful message sending.
          // print('Message sent successfully: $messageText');
          setState(() {
            // print('Before: $messageText');
            addSentMessage(messageText);
            // print('After: $messages');
          });
        }
      });

      _messageController.clear();
    } catch (e) {
      // Handle error.
      // print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 5, 5, 5),
        title: openChannel != null
            ? Text(
                openChannel!.name,
                style: const TextStyle(color: darkWhite),
              )
            : const Text(
                'Loading...',
                style: TextStyle(color: darkWhite),
              ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: darkWhite),
          onPressed: () {
            // Implement your back button functionality here
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: darkWhite),
            onPressed: () {
              // Implement your menu icon functionality here
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                if (message['type'] == 'sent') {
                  return SenderMessage(
                    message: message['message'] ?? '',
                  );
                } else {
                  return ReceiverMessage(
                    title: message['senderName'] ?? '',
                    message: message['message'] ?? '',
                    time: message['time'] ?? '',
                    imageUrl: message['imageUrl'] ?? '',
                  );
                }
              },
            ),
          ),
          Container(
            color: darkGrey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Implement your plus icon functionality here
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              cursorColor: darkWhite,
                              style: const TextStyle(color: darkWhite),
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(179, 247, 242, 242),
                                hintStyle: TextStyle(color: darkWhite),
                                hintText: '안녕하세요...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.arrow_up_circle,
                              color: Color.fromARGB(255, 214, 63, 113),
                            ),
                            onPressed: () {
                              sendMessage();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
