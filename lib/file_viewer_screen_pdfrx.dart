// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pdfrx/pdfrx.dart';

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
//   Uint8List? fileBytes;
//   PdfDocument? pdfDocument;
//   bool isLoading = true;
//   String? error;
//   String? contentType;

//   @override
//   void initState() {
//     super.initState();
//     _fetchFile();
//   }

//   Future<void> _fetchFile() async {
//     try {
//       final response = await http.get(
//         Uri.parse(widget.apiUrl),
//         headers: {'Authorization': 'Bearer ${widget.bearerToken}'},
//       );

//       if (response.statusCode != 200) {
//         setState(() {
//           error = "Error al descargar: ${response.statusCode}";
//           isLoading = false;
//         });
//         return;
//       }

//       contentType = response.headers['content-type'] ?? '';

//       fileBytes = response.bodyBytes;

//       if (contentType!.contains('pdf')) {
//         pdfDocument = await PdfDocument.openData(fileBytes!);
//       } else if (contentType!.startsWith('image/')) {
//         // Para imagen, los bytes ya están listos
//       } else {
//         setState(() {
//           error = "Tipo de archivo no soportado: $contentType";
//           isLoading = false;
//         });
//         return;
//       }

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = "Error al descargar: $e";
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) return const Center(child: CircularProgressIndicator());
//     if (error != null) return Center(child: Text(error!));

//     if (contentType == null) {
//       return const Center(child: Text("Tipo de archivo desconocido"));
//     }

//     if (contentType!.contains('pdf')) {
//       if (pdfDocument == null) {
//         return const Center(child: Text("No se pudo cargar el PDF"));
//       }
//       return PdfViewer(
//         PdfDocumentRefData(fileBytes!, sourceName: 'document'),
//         params: const PdfViewerParams(),
//       );
//     } else if (contentType!.startsWith('image/')) {
//       if (fileBytes == null) {
//         return const Center(child: Text("No se pudo cargar la imagen"));
//       }
//       return InteractiveViewer(
//         child: Image.memory(
//           fileBytes!,
//           fit: BoxFit.contain,
//           errorBuilder: (context, error, stackTrace) =>
//               const Center(child: Text('Error al cargar la imagen')),
//         ),
//       );
//     } else {
//       return Center(child: Text("Formato no soportado: $contentType"));
//     }
//   }
// }
