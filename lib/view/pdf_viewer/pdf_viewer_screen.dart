import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Represents Homepage for Navigation
class PdfViewerScreen extends StatefulWidget {
  final String? pdfUrl;
  final String? userName;

  const PdfViewerScreen({super.key, this.pdfUrl, this.userName});

  @override
  State<PdfViewerScreen> createState() => _HomePage();
}

class _HomePage extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CV of ${widget.userName!}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: widget.pdfUrl!.isEmpty
          ? const Center(
              child: Text('No PDF Found'),
            )
          : SfPdfViewer.network(
              widget.pdfUrl!,
              key: _pdfViewerKey,
            ),
    );
  }
}
