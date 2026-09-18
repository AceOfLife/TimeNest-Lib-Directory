import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF24211F);
  // static const Color green = Color(0xFF55BFA8);

  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? dateOfBirth;
  String? selectedGender;
  String? selectedRelationship;

  bool isSaving = false;

  final List<String> genders = [
    'Female',
    'Male',
    'Prefer not to say',
  ];

  final List<String> relationships = [
    'Parent',
    'Guardian',
    'Other',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime(
        now.year - 8,
        now.month,
        now.day,
      ),
      firstDate: DateTime(
        now.year - 18,
        now.month,
        now.day,
      ),
      lastDate: now,
      helpText: 'Select child\'s date of birth',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: orange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: darkText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() {
        dateOfBirth = selected;
      });
    }
  }

  Future<void> _saveChild() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select the child\'s date of birth.',
          ),
        ),
      );
      return;
    }

    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select the child\'s gender.',
          ),
        ),
      );
      return;
    }

    if (selectedRelationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select your relationship to the child.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    // Demo save.
    //
    // Later this will create the child document in
    // Firestore and associate it with the authenticated
    // parent.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    context.push('/verification/add-school');
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
          'Add child',
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'Child details',
                ),

                const SizedBox(height: 14),

                _buildTextField(
                  controller: _firstNameController,
                  label: 'First name',
                  hint: 'Enter child\'s first name',
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _lastNameController,
                  label: 'Last name',
                  hint: 'Enter child\'s last name',
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 16),

                _buildDateOfBirthField(),

                const SizedBox(height: 16),

                _buildDropdownField(
                  label: 'Gender',
                  hint: 'Select gender',
                  icon: Icons.wc_outlined,
                  value: selectedGender,
                  items: genders,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'Your relationship',
                ),

                const SizedBox(height: 14),

                _buildDropdownField(
                  label: 'Relationship to child',
                  hint: 'Select relationship',
                  icon: Icons.family_restroom_outlined,
                  value: selectedRelationship,
                  items: relationships,
                  onChanged: (value) {
                    setState(() {
                      selectedRelationship = value;
                    });
                  },
                ),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'Additional information',
                ),

                const SizedBox(height: 8),

                const Text(
                  'Optional information that may help '
                  'TimeNest provide the right experience '
                  'for your child.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 14),

                _buildNotesField(),

                const SizedBox(height: 24),

                _buildPrivacyNotice(),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        isSaving ? null : _saveChild,
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
                    child: isSaving
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
                            'Save child & continue →',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: orange.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.child_care_rounded,
              size: 44,
              color: orange,
            ),
          ),
        ),

        const SizedBox(height: 24),

        const Center(
          child: Text(
            'Add your child',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 29,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: darkText,
            ),
          ),
        ),

        const SizedBox(height: 10),

        const Center(
          child: Text(
            'Tell us a little about the child you '
            'want to add to your TimeNest account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: darkText,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.black45,
          size: 21,
        ),
        filled: true,
        fillColor: Colors.white,
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

  Widget _buildDateOfBirthField() {
    final String text = dateOfBirth == null
        ? 'Select date of birth'
        : _formatDate(dateOfBirth!);

    return InkWell(
      onTap: _selectDateOfBirth,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of birth',
          prefixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: Colors.black45,
            size: 21,
          ),
          filled: true,
          fillColor: Colors.white,
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
              color:
                  Colors.black.withValues(alpha: 0.06),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: dateOfBirth == null
                ? Colors.black45
                : darkText,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.black45,
          size: 21,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
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
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      maxLines: 4,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText:
            'Anything else you would like us to know...',
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.all(16),
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
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1ED),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            color: orange,
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your child\'s information is private and '
              'will only be used to provide TimeNest '
              'services and keep their profile secure.',
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}
