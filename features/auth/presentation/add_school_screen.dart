import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddSchoolScreen extends StatefulWidget {
  const AddSchoolScreen({super.key});

  @override
  State<AddSchoolScreen> createState() => _AddSchoolScreenState();
}

class _AddSchoolScreenState extends State<AddSchoolScreen> {
  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF24211F);
  static const Color green = Color(0xFF55BFA8);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _schoolNameController =
      TextEditingController();

  final TextEditingController _addressController =
      TextEditingController();

  final TextEditingController _cityController =
      TextEditingController();

  final TextEditingController _notesController =
      TextEditingController();

  String? _schoolType;
  bool _isSaving = false;

  final List<String> _schoolTypes = [
    'Nursery',
    'Primary',
    'Secondary',
    'Sixth Form',
    'Special Educational Needs',
    'Other',
  ];

  @override
  void dispose() {
    _schoolNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveSchool() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Demo save.
    // Firestore integration will be added once the onboarding flow
    // and data structure are finalised.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    context.push('/verification/complete');
  }

  void _addAnotherSchool() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('School saved. You can add another school.'),
      ),
    );

    _schoolNameController.clear();
    _addressController.clear();
    _cityController.clear();
    _notesController.clear();

    setState(() {
      _schoolType = null;
    });
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null
          ? null
          : Icon(
              icon,
              color: Colors.black45,
              size: 21,
            ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
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
          color: Colors.black.withOpacity(0.06),
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
    );
  }

  Widget _buildProgressStep({
    required String label,
    required bool completed,
    required bool active,
  }) {
    final Color circleColor = completed || active
        ? orange
        : Colors.black.withOpacity(0.12);

    final Color textColor = completed || active
        ? darkText
        : Colors.black45;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: completed
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 17,
                  )
                : Center(
                    child: Text(
                      label.substring(0, 1),
                      style: TextStyle(
                        color: active ? Colors.white : Colors.black45,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight:
                  active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      children: [
        _buildProgressStep(
          label: 'ID',
          completed: true,
          active: false,
        ),
        _buildProgressLine(completed: true),
        _buildProgressStep(
          label: 'Face',
          completed: true,
          active: false,
        ),
        _buildProgressLine(completed: true),
        _buildProgressStep(
          label: 'DBS',
          completed: true,
          active: false,
        ),
        _buildProgressLine(completed: true),
        _buildProgressStep(
          label: 'Refs',
          completed: true,
          active: false,
        ),
        _buildProgressLine(completed: true),
        _buildProgressStep(
          label: 'Train',
          completed: true,
          active: false,
        ),
      ],
    );
  }

  Widget _buildProgressLine({
    required bool completed,
  }) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(
          bottom: 23,
        ),
        color: completed
            ? orange.withOpacity(0.65)
            : Colors.black12,
      ),
    );
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
          'Add school',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(
          color: darkText,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              32,
            ),
            children: [
              _buildProgress(),

              const SizedBox(height: 32),

              const Text(
                'Add your child’s school',
                style: TextStyle(
                  color: darkText,
                  fontSize: 28,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Tell us which school your child attends so we can personalise their TimeNest experience.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      color: green,
                      size: 23,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You can add more than one school if your child attends multiple schools or settings.',
                        style: TextStyle(
                          color: darkText,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _schoolNameController,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration(
                  label: 'School name',
                  hint: 'e.g. Greenfield Primary School',
                  icon: Icons.school_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the school name';
                  }

                  if (value.trim().length < 2) {
                    return 'Please enter a valid school name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _schoolType,
                decoration: _inputDecoration(
                  label: 'School type',
                  hint: 'Select school type',
                  icon: Icons.category_outlined,
                ),
                items: _schoolTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _schoolType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the school type';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                textCapitalization: TextCapitalization.words,
                maxLines: 2,
                decoration: _inputDecoration(
                  label: 'School address',
                  hint: 'Enter the school address',
                  icon: Icons.location_on_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the school address';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _cityController,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration(
                  label: 'Town / city',
                  hint: 'e.g. London',
                  icon: Icons.location_city_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the town or city';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                decoration: _inputDecoration(
                  label: 'Additional notes',
                  hint: 'Optional information about the school',
                  icon: Icons.notes_outlined,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.06),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: Colors.black45,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your child’s school information is kept private and is only used to support the TimeNest service.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.5,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveSchool,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        orange.withOpacity(0.55),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Save school & continue →',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed:
                      _isSaving ? null : _addAnotherSchool,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: darkText,
                    side: BorderSide(
                      color: orange.withOpacity(0.45),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '+ Add another school',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'You can update school information later.',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}