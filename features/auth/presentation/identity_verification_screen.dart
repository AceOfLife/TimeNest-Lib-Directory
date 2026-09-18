import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  // ============================================================
  // Theme
  // ============================================================

  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF24211F);

  final ImagePicker _picker = ImagePicker();

  // ============================================================
  // State
  // ============================================================

  String selectedDocument = 'Passport';

  File? documentImage;

  bool isCapturing = false;
  bool documentConfirmed = false;

  // ============================================================
  // Document options
  // ============================================================

  final List<String> documentTypes = const [
    'Passport',
    'Driving Licence',
    'National ID',
  ];

  // ============================================================
  // Camera
  // ============================================================

  Future<void> captureDocument() async {
    setState(() {
      isCapturing = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          documentImage = File(image.path);
          documentConfirmed = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to open camera: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isCapturing = false;
        });
      }
    }
  }

  // ============================================================
  // Upload fallback
  // ============================================================

  Future<void> uploadDocument() async {
    setState(() {
      isCapturing = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          documentImage = File(image.path);
          documentConfirmed = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to select image: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isCapturing = false;
        });
      }
    }
  }

  // ============================================================
  // Confirm document
  // ============================================================

  void confirmDocument() {
    if (documentImage == null) {
      return;
    }

    setState(() {
      documentConfirmed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'ID document submitted for manual verification.',
        ),
      ),
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () {
            context.pop();
          },
        ),

        title: const Text(
          'Identity verification',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // Verification progress
              // ==================================================

              _buildProgressIndicator(),

              const SizedBox(height: 28),

              // ==================================================
              // Heading
              // ==================================================

              const Text(
                'Scan your ID',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Place your ID inside the frame. We need a clear '
                'photo of your document.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // Document type
              // ==================================================

              _buildDocumentTypeSelector(),

              const SizedBox(height: 18),

              // ==================================================
              // Scanner / Preview
              // ==================================================

              _buildDocumentScanner(),

              const SizedBox(height: 14),

              // ==================================================
              // Action buttons
              // ==================================================

              if (documentImage == null) ...[
                _buildCaptureButton(),

                const SizedBox(height: 10),

                _buildUploadButton(),
              ] else ...[
                _buildConfirmButton(),

                const SizedBox(height: 10),

                _buildRetakeButton(),
              ],

              const SizedBox(height: 18),

              // ==================================================
              // Security note
              // ==================================================

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 15,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Your document is encrypted and secure',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // Demo/manual verification status
              // ==================================================

              if (documentConfirmed) ...[
                const SizedBox(height: 22),
                _buildSubmittedCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Progress indicator
  // ============================================================

  Widget _buildProgressIndicator() {
    const labels = [
      'ID scan',
      'Face',
      'DBS',
      'References',
      'Training',
      'Review',
    ];

    return Column(
      children: [
        Row(
          children: List.generate(
            labels.length,
            (index) {
              final bool active = index == 0;
              final bool completed = index < 0;

              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active || completed
                            ? orange
                            : Colors.white,
                        border: Border.all(
                          color: active || completed
                              ? orange
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: completed
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: active
                                      ? Colors.white
                                      : Colors.grey.shade500,
                                ),
                              ),
                      ),
                    ),

                    if (index < labels.length - 1)
                      Expanded(
                        child: Container(
                          height: 1.5,
                          color: Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 7),

        Row(
          children: labels.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final label = entry.value;

              return Expanded(
                child: Text(
                  label,
                  textAlign: index == 0
                      ? TextAlign.left
                      : index == labels.length - 1
                          ? TextAlign.right
                          : TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: index == 0
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: index == 0
                        ? orange
                        : Colors.grey.shade500,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  // ============================================================
  // Document selector
  // ============================================================

  Widget _buildDocumentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DOCUMENT TYPE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 9),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: documentTypes.map(
              (type) {
                final bool selected =
                    selectedDocument == type;

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDocument = type;
                        documentImage = null;
                        documentConfirmed = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 180),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? orange.withValues(
                                alpha: 0.12,
                              )
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? orange
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? orange
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Scanner
  // ============================================================

  Widget _buildDocumentScanner() {
    return Container(
      width: double.infinity,
      height: 245,
      decoration: BoxDecoration(
        color: const Color(0xFF211C19),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ----------------------------------------------------
          // Captured image
          // ----------------------------------------------------

          if (documentImage != null)
            Positioned.fill(
              child: Image.file(
                documentImage!,
                fit: BoxFit.cover,
              ),
            ),

          // ----------------------------------------------------
          // Dark overlay on captured image
          // ----------------------------------------------------

          if (documentImage != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.18,
                ),
              ),
            ),

          // ----------------------------------------------------
          // Scanner instructions
          // ----------------------------------------------------

          if (documentImage == null)
            Positioned(
              top: 24,
              left: 20,
              right: 20,
              child: Text(
                'Position your $selectedDocument inside the frame',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // ----------------------------------------------------
          // Corner guides
          // ----------------------------------------------------

          SizedBox(
            width: 245,
            height: 150,
            child: CustomPaint(
              painter: _ScannerFramePainter(
                color: orange,
              ),
            ),
          ),

          // ----------------------------------------------------
          // Captured indicator
          // ----------------------------------------------------

          if (documentImage != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.65,
                ),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 17,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    documentConfirmed
                        ? 'Document submitted'
                        : 'Document captured',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

          // ----------------------------------------------------
          // Loading indicator
          // ----------------------------------------------------

          if (isCapturing)
            Container(
              color: Colors.black.withValues(
                alpha: 0.45,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // Capture button
  // ============================================================

  Widget _buildCaptureButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: orange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: isCapturing
            ? null
            : captureDocument,
        icon: const Icon(
          Icons.camera_alt_rounded,
          size: 20,
        ),
        label: const Text(
          'Scan document',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Upload button
  // ============================================================

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: orange,
          side: BorderSide(
            color: orange.withValues(
              alpha: 0.45,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: isCapturing
            ? null
            : uploadDocument,
        icon: const Icon(
          Icons.upload_file_rounded,
          size: 19,
        ),
        label: const Text(
          'Upload photo instead',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Confirm button
  // ============================================================

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: orange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: documentConfirmed
            ? null
            : confirmDocument,
        child: Text(
          documentConfirmed
              ? 'Document submitted ✓'
              : 'Document looks good →',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Retake
  // ============================================================

  Widget _buildRetakeButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: orange,
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: isCapturing
            ? null
            : () {
                setState(() {
                  documentImage = null;
                  documentConfirmed = false;
                });
              },
        child: const Text(
          'Retake / choose another photo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Submitted card
  // ============================================================

  Widget _buildSubmittedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF9F4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFBFE6D3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF55BFA8),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'ID submitted',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Your document has been recorded. '
                  'Manual verification will be completed '
                  'for now.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Scanner frame painter
// ============================================================

class _ScannerFramePainter extends CustomPainter {
  final Color color;

  const _ScannerFramePainter({
    required this.color,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 24;

    // Top left
    canvas.drawLine(
      const Offset(0, cornerLength),
      const Offset(0, 0),
      paint,
    );

    canvas.drawLine(
      const Offset(0, 0),
      const Offset(cornerLength, 0),
      paint,
    );

    // Top right
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // Bottom left
    canvas.drawLine(
      Offset(0, size.height - cornerLength),
      Offset(0, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    // Bottom right
    canvas.drawLine(
      Offset(size.width - cornerLength, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ScannerFramePainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}