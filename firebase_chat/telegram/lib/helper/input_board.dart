import 'package:flutter/material.dart';
import 'package:telegramchatapp/Pages/ChattingPage.dart';

createInput() {
    return Container(
      child: Row(
        children: <Widget>[
          //SEND IMAGES
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: getImage,
              ),
            ),
            color: Colors.white,
          ),
          //SEND EMOJIS
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face_outlined),
                color: Colors.lightBlueAccent,
                onPressed: () => getSticker(),
              ),
            ),
            color: Colors.white,
          ),

          Flexible(
            child: Container(
              child: TextField(
                //cursorHeight : 10.0,

                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                //selectionControls: TextSelection.fromPosition(TextPosition(offset: controller.text.length)),
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                ),

                focusNode: focusNode,
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                color: Colors.purple,
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.purple, width: 1.5),
          right: BorderSide(color: Colors.orange, width: 1.5),
          left: BorderSide(color: Colors.yellow, width: 1.5),
        ),
        //color: Colors.grey[200],
      ),
    );
  }