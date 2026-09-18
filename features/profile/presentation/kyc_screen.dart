import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../providers/kyc_repository_provider.dart';

class KycScreen
    extends ConsumerStatefulWidget {
  const KycScreen({
    super.key,
  });

  @override
  ConsumerState<KycScreen>
      createState() =>
          _KycScreenState();
}

class _KycScreenState
    extends ConsumerState<KycScreen> {
  final fullNameController =
      TextEditingController();

  String selectedId =
      'National ID';

  File? idImage;

  File? selfieImage;

  Future<void> pickId() async {
    final image =
        await ImagePicker()
            .pickImage(
      source:
          ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      idImage =
          File(image.path);
    });
  }

  Future<void> pickSelfie() async {
    final image =
        await ImagePicker()
            .pickImage(
      source:
          ImageSource.camera,
    );

    if (image == null) return;

    setState(() {
      selfieImage =
          File(image.path);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('KYC'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller:
                  fullNameController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Full Name',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            DropdownButtonFormField<
                String>(
              value:
                  selectedId,
              items: const [
                DropdownMenuItem(
                  value:
                      'National ID',
                  child: Text(
                    'National ID',
                  ),
                ),
                DropdownMenuItem(
                  value:
                      'Passport',
                  child: Text(
                    'Passport',
                  ),
                ),
                DropdownMenuItem(
                  value:
                      'Drivers License',
                  child: Text(
                    'Drivers License',
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedId =
                      value!;
                });
              },
            ),

            const SizedBox(
              height: 20,
            ),

            FilledButton(
              onPressed:
                  pickId,
              child: const Text(
                'Upload ID',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed:
                  pickSelfie,
              child: const Text(
                'Take Selfie',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            FilledButton(
              onPressed: () async {
                if (idImage ==
                        null ||
                    selfieImage ==
                        null) {
                  return;
                }

                await ref
                    .read(
                      kycRepositoryProvider,
                    )
                    .submitKyc(
                      fullName:
                          fullNameController
                              .text,
                      idType:
                          selectedId,
                      idImage:
                          idImage!,
                      selfieImage:
                          selfieImage!,
                    );

                if (mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child: const Text(
                'Submit Verification',
              ),
            ),
          ],
        ),
      ),
    );
  }
}