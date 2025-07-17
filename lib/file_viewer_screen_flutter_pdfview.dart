import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class FileViewerScreen extends StatefulWidget {
  final String apiUrl;
  final String bearerToken;

  const FileViewerScreen({
    required this.apiUrl,
    required this.bearerToken,
    super.key,
  });

  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  String? localPdfPath;
  Uint8List? imageBytes;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchAndHandleFile();
  }

  Future<void> _fetchAndHandleFile() async {
    try {
      final response = await http.get(
        Uri.parse(widget.apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.bearerToken}',
        },
      );

      if (response.statusCode != 200) {
        setState(() {
          error = "Error ${response.statusCode} al descargar el archivo.";
          isLoading = false;
        });
        return;
      }

      final contentType = response.headers['content-type'] ?? "";

      // PDFs
      if (contentType.contains('pdf')) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/temp.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          localPdfPath = file.path;
          isLoading = false;
        });
        return;
      }

      // Imágenes
      if (contentType.contains('image')) {
        setState(() {
          imageBytes = response.bodyBytes;
          isLoading = false;
        });
        return;
      }

      // Otros
      setState(() {
        error = "Tipo de archivo no soportado: $contentType";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Error al descargar o procesar el archivo: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));

    if (localPdfPath != null) {
      return PDFView(
        filePath: localPdfPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageSnap: false,
        pageFling: false,
        onError: (err) => debugPrint("PDF error: $err"),
      );
    }

    if (imageBytes != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Imagen")),
        body: InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 1.0,
          maxScale: 5.0,
          // boundaryMargin: const EdgeInsets.all(200),
          constrained: false,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.memory(
              imageBytes!,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    return const Center(child: Text("Archivo no disponible."));
  }
}
