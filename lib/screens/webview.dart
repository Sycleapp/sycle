import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget{
  final String displayTitle;
  final String urlToLoad;

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  WebViewPage({this.displayTitle, this.urlToLoad});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text(displayTitle,
          style: TextStyle(
            fontFamily: "Avenir",
            fontWeight: FontWeight.w900,
            color: Colors.black
          )
        )
      ),
      body: WebView(
        initialUrl: urlToLoad,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller){
          _controller.complete(controller);
        },
      )
    );  
  }
}