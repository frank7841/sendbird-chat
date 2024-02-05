import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sendbird_chat_app/channel_list.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          return FutureBuilder(
            future: initializeSendbird(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ChatListScreen(openChannelUrl: snapshot.data.toString());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error initializing Sendbird: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<String> initializeSendbird() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await SendbirdChat.init(appId: 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF');
      final user = await SendbirdChat.connect('@#790943918');
      log("${user} is connected");

      final openChannel = await OpenChannel.getChannel(
          "sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211");
      openChannel.enter();
      log("Open channel created: ${openChannel.channelUrl}");

      return openChannel.channelUrl;
    } catch (e) {
      print('Error initializing Sendbird: $e');
      throw e;
    }
  }
}
