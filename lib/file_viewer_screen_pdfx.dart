// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdfx/pdfx.dart';

// class FileViewerScreen extends StatefulWidget {
//   final String apiUrl;
//   final String bearerToken;

//   const FileViewerScreen({
//     required this.apiUrl,
//     required this.bearerToken,
//     super.key,
//   });

//   @override
//   State<FileViewerScreen> createState() => _FileViewerScreenState();
// }

// class _FileViewerScreenState extends State<FileViewerScreen> {
//   // File? localFile;
//   String? contentType;
//   Uint8List? imageBytes;
//   PdfControllerPinch? pdfController;
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAndHandleFile();
//   }

//   Future<void> _fetchAndHandleFile() async {
//     try {
//       final response = await http.get(
//         Uri.parse(widget.apiUrl),
//         headers: {'Authorization': 'Bearer ${widget.bearerToken}'},
//       );

//       if (response.statusCode != 200) {
//         setState(() {
//           errorMessage = "Error ${response.statusCode} al obtener el archivo";
//           isLoading = false;
//         });
//         return;
//       }

//       final type =
//           response.headers['content-type'] ?? 'application/octet-stream';

//       // final ext = _extensionFromMime(type);
//       // final tempDir = await getTemporaryDirectory();
//       // final path = "${tempDir.path}/archivo.$ext";
//       // final file = File(path);
//       // await file.writeAsBytes(response.bodyBytes);

//       setState(() {
//         contentType = type;
//         // localFile = file;
//       });

//       if (type == 'application/pdf') {
//         /** guardado local */
//         // pdfController = PdfControllerPinch(
//         //   document: PdfDocument.openFile(localFile!.path),
//         // );
//         /** cargar en memoria */
//         pdfController = PdfControllerPinch(
//           document: PdfDocument.openData(response.bodyBytes),
//         );
//       } else if (type.startsWith('image/')) {
//         // imageBytes = await file.readAsBytes();
//         imageBytes = response.bodyBytes;
//       }

//       setState(() => isLoading = false);
//     } catch (e) {
//       setState(() {
//         errorMessage = "Error al cargar el archivo: $e";
//         isLoading = false;
//       });
//     }
//   }

//   String _extensionFromMime(String mime) {
//     if (mime == 'application/pdf') return 'pdf';
//     if (mime == 'image/jpeg') return 'jpg';
//     if (mime == 'image/png') return 'png';
//     return 'bin';
//   }

//   @override
//   void dispose() {
//     pdfController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (errorMessage != null) {
//       return Scaffold(body: Center(child: Text(errorMessage!)));
//     }

//     // if (localFile == null) {
//     //   return const Scaffold(
//     //     body: Center(child: Text("Archivo no disponible.")),
//     //   );
//     // }

//     if (contentType == 'application/pdf' && pdfController != null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("PDF")),
//         body: PdfViewPinch(controller: pdfController!),
//       );
//     } else if (contentType?.startsWith('image/') == true &&
//         imageBytes != null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Imagen")),
//         body: InteractiveViewer(
//           panEnabled: true,
//           scaleEnabled: true,
//           minScale: 1.0,
//           maxScale: 5.0,
//           boundaryMargin: const EdgeInsets.all(1000),
//           constrained: false,
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Image.memory(
//               imageBytes!,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       );
//     }

//     return const Scaffold(
//       body: Center(child: Text("Tipo de archivo no soportado.")),
//     );
//   }
// }
