import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/constants/constants.dart';


class ShowDataScreen extends StatelessWidget {
final String title;
final String pathUrl;
  const ShowDataScreen({super.key,required this.title,required this.pathUrl});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        title: Text(title),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (r) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(pathUrl)),
      ),
    );
  }
}
