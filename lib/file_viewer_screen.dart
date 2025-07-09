import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
  File? localFile;
  String? contentType;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAndSaveFile();
  }

  Future<void> _fetchAndSaveFile() async {
    try {
      final response = await http.get(
        Uri.parse(widget.apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.bearerToken}',
        },
      );

      if (response.statusCode != 200) {
        setState(() {
          errorMessage = "Error ${response.statusCode} al obtener el archivo";
          isLoading = false;
        });
        return;
      }

      final type =
          response.headers['content-type'] ?? 'application/octet-stream';
      final ext = _extensionFromMime(type);
      final tempDir = await getTemporaryDirectory();
      final path = "${tempDir.path}/archivo.$ext";

      final file = File(path);
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        localFile = file;
        contentType = type;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error al cargar el archivo: $e";
        isLoading = false;
      });
    }
  }

  String _extensionFromMime(String mime) {
    if (mime == 'application/pdf') return 'pdf';
    if (mime == 'image/jpeg') return 'jpg';
    if (mime == 'image/png') return 'png';
    return 'bin';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) return Center(child: Text(errorMessage!));
    if (localFile == null)
      return const Center(child: Text("Archivo no disponible."));

    if (contentType == 'application/pdf') {
      return SfPdfViewer.file(localFile!);
    } else if (contentType?.startsWith('image/') == true) {
      return InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        minScale: 1.0,
        maxScale: 5.0,
        boundaryMargin: const EdgeInsets.all(1000),
        constrained: false,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.file(
            localFile!,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return const Center(child: Text("Tipo de archivo no soportado."));
    }
  }
}
