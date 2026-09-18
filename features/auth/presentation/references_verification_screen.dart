import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReferencesVerificationScreen extends StatefulWidget {
  const ReferencesVerificationScreen({super.key});

  @override
  State<ReferencesVerificationScreen> createState() =>
      _ReferencesVerificationScreenState();
}

class _ReferencesVerificationScreenState
    extends State<ReferencesVerificationScreen> {
  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF24211F);
  static const Color green = Color(0xFF55BFA8);

  final _formKey = GlobalKey<FormState>();

  final _reference1NameController = TextEditingController();
  final _reference1RelationshipController = TextEditingController();
  final _reference1EmailController = TextEditingController();
  final _reference1PhoneController = TextEditingController();
  final _reference1DurationController = TextEditingController();

  final _reference2NameController = TextEditingController();
  final _reference2RelationshipController = TextEditingController();
  final _reference2EmailController = TextEditingController();
  final _reference2PhoneController = TextEditingController();
  final _reference2DurationController = TextEditingController();

  bool reference1NonFamily = false;
  bool reference2NonFamily = false;

  bool isSubmitting = false;
  bool submitted = false;

  @override
  void dispose() {
    _reference1NameController.dispose();
    _reference1RelationshipController.dispose();
    _reference1EmailController.dispose();
    _reference1PhoneController.dispose();
    _reference1DurationController.dispose();

    _reference2NameController.dispose();
    _reference2RelationshipController.dispose();
    _reference2EmailController.dispose();
    _reference2PhoneController.dispose();
    _reference2DurationController.dispose();

    super.dispose();
  }

  Future<void> _submitReferences() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!reference1NonFamily || !reference2NonFamily) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Both references must be non-family members.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Demo submission.
    // Replace this with the real Firestore/API submission later.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
      submitted = true;
    });
  }

  void _continueToTraining() {
    context.push('/verification/training');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Verification',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkText,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgress(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  32,
                ),
                child: submitted
                    ? _buildSubmittedState()
                    : _buildReferencesForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() {
    const labels = [
      'ID',
      'Face',
      'DBS',
      'Refs',
      'Train',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        8,
        24,
        0,
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) {
            final bool completed = index < 3;
            final bool active = index == 3;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: completed
                                ? green
                                : active
                                    ? orange
                                    : Colors.black12,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                active || completed
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                            color: active || completed
                                ? darkText
                                : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != labels.length - 1)
                    const SizedBox(width: 5),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReferencesForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          Center(
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: orange.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 46,
                color: orange,
              ),
            ),
          ),

          const SizedBox(height: 28),

          const Center(
            child: Text(
              '2 character references',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                height: 1.15,
                fontWeight: FontWeight.w800,
                color: darkText,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              'We need two people who know you well '
              'and can provide a character reference.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 28),

          _buildRequirementCard(),

          const SizedBox(height: 28),

          _buildReferenceSection(
            number: 1,
            nameController: _reference1NameController,
            relationshipController:
                _reference1RelationshipController,
            emailController: _reference1EmailController,
            phoneController: _reference1PhoneController,
            durationController:
                _reference1DurationController,
            nonFamily: reference1NonFamily,
            onNonFamilyChanged: (value) {
              setState(() {
                reference1NonFamily = value;
              });
            },
          ),

          const SizedBox(height: 28),

          _buildReferenceSection(
            number: 2,
            nameController: _reference2NameController,
            relationshipController:
                _reference2RelationshipController,
            emailController: _reference2EmailController,
            phoneController: _reference2PhoneController,
            durationController:
                _reference2DurationController,
            nonFamily: reference2NonFamily,
            onNonFamilyChanged: (value) {
              setState(() {
                reference2NonFamily = value;
              });
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed:
                  isSubmitting ? null : _submitReferences,
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    Colors.black12,
                disabledForegroundColor:
                    Colors.black38,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<
                                Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Text(
                      'Submit references →',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 14),

          const Center(
            child: Text(
              'Your references will only be contacted '
              'as part of the TimeNest verification process.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Reference requirements',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),
          SizedBox(height: 14),
          _RequirementRow(
            text: 'Two references are required',
          ),
          SizedBox(height: 9),
          _RequirementRow(
            text: 'References must not be family members',
          ),
          SizedBox(height: 9),
          _RequirementRow(
            text: 'They should have known you for 2+ years',
          ),
          SizedBox(height: 9),
          _RequirementRow(
            text: 'Their contact details must be valid',
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceSection({
    required int number,
    required TextEditingController nameController,
    required TextEditingController relationshipController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController durationController,
    required bool nonFamily,
    required ValueChanged<bool> onNonFamilyChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: orange.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: orange,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Reference $number',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          _buildTextField(
            controller: nameController,
            label: 'Full name',
            hint: 'Enter their full name',
            icon: Icons.person_outline_rounded,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: relationshipController,
            label: 'Relationship to you',
            hint: 'e.g. Colleague, friend, former manager',
            icon: Icons.handshake_outlined,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: emailController,
            label: 'Email address',
            hint: 'Enter their email address',
            icon: Icons.email_outlined,
            keyboardType:
                TextInputType.emailAddress,
            validator: _validateEmail,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: phoneController,
            label: 'Phone number',
            hint: 'Enter their phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: durationController,
            label: 'How long have they known you?',
            hint: 'e.g. 5 years',
            icon: Icons.schedule_outlined,
          ),

          const SizedBox(height: 16),

          InkWell(
            onTap: () {
              onNonFamilyChanged(!nonFamily);
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: nonFamily,
                    activeColor: orange,
                    onChanged: (value) {
                      onNonFamilyChanged(
                        value ?? false,
                      );
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 11,
                        right: 4,
                      ),
                      child: Text(
                        'I confirm this person is not a '
                        'family member and has known me '
                        'for at least 2 years.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: darkText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      validator: validator ?? _requiredValidator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.black45,
          size: 21,
        ),
        filled: true,
        fillColor: cream,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: orange,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  Widget _buildSubmittedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 48),

        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F7F2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 52,
            color: green,
          ),
        ),

        const SizedBox(height: 28),

        const Text(
          'References submitted',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: darkText,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Both character references have been '
          'submitted successfully. They may be '
          'contacted by TimeNest as part of your '
          'verification.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 32),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.mark_email_read_outlined,
                color: green,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  '2 references received',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _continueToTraining,
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Continue to training →',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;

  const _RequirementRow({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF55BFA8);
    const darkText = Color(0xFF24211F);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: green,
          size: 18,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: darkText,
            ),
          ),
        ),
      ],
    );
  }
}