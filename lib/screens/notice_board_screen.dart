import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  late WebViewController webViewController;
  var loadingPercentage = 0;
  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
      Uri.parse('https://hstu.ac.bd/page/all_notice/type/f/id/2')
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
          centerTitle: true,
          title: const Text("Notice Board",style: TextStyle(
            color: Colors.white,
          ),),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    if (await webViewController.canGoBack()) {
                      await webViewController.goBack();
                    } else {
                      messenger.showSnackBar(
                        const SnackBar(
                            duration: Duration(milliseconds: 200),
                            content: Text(
                              'Can\'t go back',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      );
                      return;
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios,color: Colors.white,),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    if (await webViewController.canGoForward()) {
                      await webViewController.goForward();
                    } else {
                      messenger.showSnackBar(
                        const SnackBar(
                            duration: Duration(milliseconds: 200),
                            content: Text(
                              'No forward history item',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      );
                      return;
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.replay,color: Colors.white,),
                  onPressed: () {
                    webViewController.reload();
                  },
                ),
              ],
            )
          ]),
      body: Stack(
        children: [
          WebViewWidget(
            controller: webViewController,
          ),
          loadingPercentage < 100
              ? LinearProgressIndicator(
            color: Colors.red,
            value: loadingPercentage / 100.0,
          )
              : Container()
        ],
      ),
    );
  }
}
