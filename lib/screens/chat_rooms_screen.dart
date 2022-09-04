import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lost_found_app/services/firebase_repository.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:lost_found_app/util/screen_size.dart';

import 'chat_screen.dart';
import 'package:lost_found_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream ListofPeople;
  var num = [];
  var image = [
    'https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2F77c5b7e9dd53143594f0663ba07b9c4c.png?alt=media&token=c7c5b4a0-a470-4a1d-b012-0cae60150ba1',
    'https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2F66377888_242269586730532_1532890469642947208_n.jpg?alt=media&token=2cfe880d-088b-48e0-a11b-53d88482546d',
    'https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2F06d0c1d123bf45368295da7e6744c186.webp?alt=media&token=c7f92b39-5afe-45a5-85f7-beb112897bb3',
    'https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2F11272992_1586350538290474_2098431562_n.jpg?alt=media&token=149bc158-0c5e-4ae5-aa12-adf712d511f7',
    'https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2F13734272_1629975600646084_1645582746_n.jpg?alt=media&token=53e2a503-e95d-4b6d-85ff-501ed7fb65fb',
    'https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2F2%20(1).jpg?alt=media&token=d254738f-3257-4d22-96e9-037b8ec6e2b4',
  ];

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: ListofPeople,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? snapshot.data.docs.length == 0
                ? Container(
                    height: 600 * ScreenSize.heightMultiplyingFactor,
                    child: Center(
                      child: Text(
                        "No Chats Yet..!",
                        style: GoogleFonts.montserrat(
                          fontSize: 15 * ScreenSize.heightMultiplyingFactor,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      //sleep(const Duration(seconds: 5));

                      /* print(num[snapshot.data.docs.length - index - 1].toString() +
                      snapshot.data.docs[snapshot.data.docs.length - index - 1]
                          .data()["sender_name"]);*/

                      return ChatRoomsTile(
                        userName: snapshot
                            .data.docs[snapshot.data.docs.length - index - 1]
                            .data()['user_name']
                            .toString(),
                        chatRoomId: getChatRoomId(
                            user.userId,
                            snapshot.data
                                .docs[snapshot.data.docs.length - index - 1]
                                .data()["user_ID"]),
                        personID: snapshot
                            .data.docs[snapshot.data.docs.length - index - 1]
                            .data()["user_ID"],
                        lastMessage: snapshot
                            .data.docs[snapshot.data.docs.length - index - 1]
                            .data()['lastMessage']
                            .toString(),
                        senderName: snapshot
                            .data.docs[snapshot.data.docs.length - index - 1]
                            .data()['sender_name']
                            .toString(),
                        lastMessageTime: snapshot
                            .data.docs[snapshot.data.docs.length - index - 1]
                            .data()["lastMessageTime"],
                        Unread: snapshot
                            .data.docs[snapshot.data.docs.length - index - 1]
                            .data()["read"],
                        notification:
                            num[snapshot.data.docs.length - index - 1],
                        lastMessageId: snapshot
                            .data.docs[snapshot.data.docs.length - index - 1]
                            .data()["lastMessage_sendBy"],
                        index: index,
                        img: image[snapshot.data
                                .docs[snapshot.data.docs.length - index - 1]
                                .data()["user_ID"]
                                .toString()
                                .codeUnitAt(1) %
                            6],
                      );
                    })
            : SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: Image(
                    image: CachedNetworkImageProvider(
                        'https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2Fanimation_640_km7rzhxu.gif?alt=media&token=2364d71b-834c-426c-845d-495276705a32'),
                    width: 120,
                    height: 120,
                  ),
                ));
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    QuerySnapshot list = await FirebaseFirestore.instance
        .collection("UserChatPeople")
        .doc(user.userId)
        .collection(user.userId)
        .orderBy('lastMessageTime')
        .get();
    List lit = list.docs;
    for (DocumentSnapshot i in lit) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection("UserChatPeople")
          .doc(i['user_ID'])
          .collection(i['user_ID'])
          .doc(user.userId)
          .get();

      print(document["read"].toString() + "realbefore");
      setState(() {
        num.add(document["read"]);
      });
    }

    FirebaseRepository().getUserPeople().then((snapshots) {
      setState(() {
        ListofPeople = snapshots;
        print(
            "we got the data + ${ListofPeople.toString()} this is name  ${user.name}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        backgroundColor: primaryColour,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          " Messages ",
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20 * ScreenSize.heightMultiplyingFactor,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ColoredBox(
          color: Colors.white,
          child: Column(children: [
            chatRoomsList(),
          ])),
    ));
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String personID;
  final String lastMessage;
  final String senderName;
  final Timestamp lastMessageTime;
  final int Unread;
  int notification;
  final String lastMessageId;
  final int index;
  final String img;

  ChatRoomsTile(
      {this.userName,
      @required this.chatRoomId,
      this.personID,
      this.lastMessage,
      this.senderName,
      this.lastMessageTime,
      this.Unread,
      this.notification,
      this.lastMessageId,
      this.index,
      this.img});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: 8 * ScreenSize.heightMultiplyingFactor,
          start: 10 * ScreenSize.widthMultiplyingFactor,
          end: 10 * ScreenSize.widthMultiplyingFactor,
          top: index == 0 ? 8 * ScreenSize.heightMultiplyingFactor : 0,
        ),
        child: GestureDetector(
            onTap: () {
              navigatorKey.currentState.pushReplacement(MaterialPageRoute(
                  builder: (context) => Chat(
                        chatRoomId: chatRoomId,
                        username: userName,
                        personID: personID,
                        personName: userName,
                        img: img,
                      )));
            },
            child: Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                lightSource: LightSource.topRight,
              ),
              child: Container(
                color: Colors.white60,
                height: MediaQuery.of(context).size.height / 10,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Stack(
                  children: [
                    Stack(children: [
                      Positioned(
                        left: 0,
                        child: ClipOval(
                          child: Image(
                            image: CachedNetworkImageProvider(img),
                            width: 55 * ScreenSize.widthMultiplyingFactor,
                            height: 55 * ScreenSize.heightMultiplyingFactor,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Text(
                              "  " +
                                  DateFormat('hh:mm a')
                                      .format(lastMessageTime.toDate())
                                      .toString(),
                              style: GoogleFonts.poppins(
                                  color: Color(0xff505C6B),
                                  fontSize:
                                      14 * ScreenSize.heightMultiplyingFactor,
                                  fontWeight: FontWeight.normal))),
                      Positioned(
                          left: MediaQuery.of(context).size.width / 6,
                          top: 0,
                          child: Text(
                              userName.length > 16
                                  ? userName.substring(0, 13) + "..."
                                  : userName[0].toUpperCase() +
                                      userName.substring(1),
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  color: Color(0xff505C6B),
                                  fontSize:
                                      22 * ScreenSize.heightMultiplyingFactor,
                                  fontWeight: FontWeight.bold))),
                      Positioned(
                          left: lastMessageId == user.userId
                              ? MediaQuery.of(context).size.width / 8
                              : MediaQuery.of(context).size.width / 6,
                          top: lastMessageId == user.userId
                              ? MediaQuery.of(context).size.height / 40
                              : MediaQuery.of(context).size.height / 23,
                          child: Row(
                            children: [
                              lastMessageId == user.userId
                                  ? Unread == 0
                                      ? IconButton(
                                          icon: Icon(Icons.check),
                                          iconSize: 15.0 *
                                              ScreenSize
                                                  .heightMultiplyingFactor,
                                          color: Colors.black,
                                          onPressed: () {},
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.done_all),
                                          iconSize: 15.0 *
                                              ScreenSize
                                                  .heightMultiplyingFactor,
                                          color: Colors.green,
                                          onPressed: () {},
                                        )
                                  : Text(
                                      senderName.length > 16
                                          ? senderName.substring(0, 13) +
                                              "..." +
                                              "  :  "
                                          : senderName[0].toUpperCase() +
                                              senderName.substring(1) +
                                              "  :  ",
                                      style: GoogleFonts.poppins(
                                          fontWeight:
                                              lastMessageId == user.userId
                                                  ? FontWeight.normal
                                                  : notification != 0
                                                      ? FontWeight.normal
                                                      : FontWeight.bold)),
                              Text(
                                  lastMessage.length > 20
                                      ? lastMessage.substring(0, 18) + "..."
                                      : lastMessage,
                                  style: GoogleFonts.poppins(
                                      fontWeight: lastMessageId == user.userId
                                          ? FontWeight.normal
                                          : notification != 0
                                              ? FontWeight.normal
                                              : FontWeight.bold)),
                            ],
                          ))
                    ]),
                  ],
                ),
              ),
            )));
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
