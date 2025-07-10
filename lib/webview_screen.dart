// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewScreen extends StatefulWidget {
//   final String apiUrl;
//   final String bearerToken;

//   const WebViewScreen({
//     required this.apiUrl,
//     required this.bearerToken,
//     super.key,
//   });

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();

//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(
//         Uri.parse(widget.apiUrl),
//         headers: {
//           'Authorization': 'Bearer ${widget.bearerToken}',
//           'Accept': 'application/json',
//         },
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Visor WebView")),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }
