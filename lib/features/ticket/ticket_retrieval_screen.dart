import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../core/constants.dart';
import 'ticket_provider.dart';

class TicketRetrievalScreen extends ConsumerStatefulWidget {
  const TicketRetrievalScreen({super.key});

  @override
  ConsumerState<TicketRetrievalScreen> createState() => _TicketRetrievalScreenState();
}

class _TicketRetrievalScreenState extends ConsumerState<TicketRetrievalScreen> {
  void _validateAndProceed(String code) {
    final success = ref.read(ticketProvider.notifier).validateAndSetTicket(code);
    if (success && mounted) {
      context.push('/fare');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid ticket code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Retrieve Ticket'),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(icon: Icon(Icons.keyboard), text: 'Manual'),
              Tab(icon: Icon(Icons.qr_code_scanner), text: 'QR Scan'),
              Tab(icon: Icon(Icons.camera_alt), text: 'OCR'),
              Tab(icon: Icon(Icons.directions_car), text: 'Billboard'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ManualTab(onValid: _validateAndProceed),
            _QRScanTab(onValid: _validateAndProceed),
            _OCRTab(onValid: _validateAndProceed),
            _BillboardTab(onValid: _validateAndProceed),
          ],
        ),
      ),
    );
  }
}

class _ManualTab extends StatefulWidget {
  final Function(String) onValid;
  const _ManualTab({required this.onValid});

  @override
  State<_ManualTab> createState() => _ManualTabState();
}

class _ManualTabState extends State<_ManualTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter 6-digit Code',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => widget.onValid(_controller.text),
            child: const Text('Check Code'),
          ),
        ],
      ),
    );
  }
}

class _QRScanTab extends StatelessWidget {
  final Function(String) onValid;
  const _QRScanTab({required this.onValid});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
          onValid(barcodes.first.rawValue!);
        }
      },
    );
  }
}

class _OCRTab extends StatefulWidget {
  final Function(String) onValid;
  const _OCRTab({required this.onValid});

  @override
  State<_OCRTab> createState() => _OCRTabState();
}

class _OCRTabState extends State<_OCRTab> {
  bool _isProcessing = false;

  Future<void> _processImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    setState(() => _isProcessing = true);
    
    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String foundCode = "";
      for (TextBlock block in recognizedText.blocks) {
        if (block.text.replaceAll(RegExp(r'\D'), '').length >= 4) {
          foundCode = block.text.replaceAll(RegExp(r'\D'), '');
          break;
        }
      }
      
      if (foundCode.isNotEmpty) {
        widget.onValid(foundCode);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid code found in image')),
          );
        }
      }
    } finally {
      textRecognizer.close();
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isProcessing 
          ? const CircularProgressIndicator(color: AppColors.primary)
          : ElevatedButton.icon(
              icon: const Icon(Icons.camera),
              label: const Text('Capture Ticket Photo'),
              onPressed: _processImage,
            ),
    );
  }
}

class _BillboardTab extends StatefulWidget {
  final Function(String) onValid;
  const _BillboardTab({required this.onValid});

  @override
  State<_BillboardTab> createState() => _BillboardTabState();
}

class _BillboardTabState extends State<_BillboardTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Look at the digital billboard above your lane and enter the temporary code.', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Billboard Hint Code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => widget.onValid(_controller.text),
            child: const Text('Submit Billboard Code'),
          ),
        ],
      ),
    );
  }
}
