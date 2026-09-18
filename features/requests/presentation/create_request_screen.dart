import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timenest/features/requests/widgets/child_selector_card.dart';

import '../../../providers/request_repository_provider.dart';
import '../widgets/task_selector_card.dart';
import '../../../providers/child_provider.dart';
import '../../../models/child_model.dart';


class CreateRequestScreen extends ConsumerStatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  ConsumerState<CreateRequestScreen> createState() =>
      _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  bool isLoading = false;

  String selectedTask = "Drop-off";

  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  String? selectedChild;

  int get credits => selectedTask == "After School" ? 2 : 1;

  Future<void> pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  Future<void> pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (result != null) {
      setState(() {
        selectedTime = result;
      });
    }
  }

  Future<void> submit() async {
    if (titleController.text.trim().isEmpty) {
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      return;
    }

    if (selectedDate == null) {
      return;
    }

    if (selectedTime == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ref
          .read(requestRepositoryProvider)
          .createRequest(
            category: selectedTask,
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            creditsReward: credits,

            taskDate: selectedDate!,

            taskTime: selectedTime!,
          );

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Request Posted")));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post a request")),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
    
//----------------------------------------------------
// Task Type
//----------------------------------------------------

const Text(
  "TYPE OF HELP",
  style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
    color: Colors.grey,
  ),
),

const SizedBox(height: 16),

Row(
  children: [
    Expanded(
      child: TaskSelectorCard(
        title: "Drop-off",
        icon: Icons.drive_eta_rounded,
        selected: selectedTask == "Drop-off",
        onTap: () {
          setState(() {
            selectedTask = "Drop-off";
          });
        },
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: TaskSelectorCard(
        title: "Pick-up",
        icon: Icons.location_on_rounded,
        selected: selectedTask == "Pick-up",
        onTap: () {
          setState(() {
            selectedTask = "Pick-up";
          });
        },
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: TaskSelectorCard(
        title: "After School",
        icon: Icons.school_rounded,
        selected: selectedTask == "After School",
        onTap: () {
          setState(() {
            selectedTask = "After School";
          });
        },
      ),
    ),
  ],
),

const SizedBox(height: 30),

 //----------------------------------------------------
// Child
//----------------------------------------------------

const Text(
  "WHICH CHILD",
  style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: Colors.grey,
  ),
),

const SizedBox(height: 10),

ref.watch(childrenProvider).when(
  loading: () => const SizedBox(
    height: 120,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ),

  error: (error, _) => SizedBox(
    height: 120,
    child: Center(
      child: Text(
        "Unable to load children",
        style: TextStyle(
          color: Colors.red.shade400,
        ),
      ),
    ),
  ),

  data: (children) {
    if (children.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.orange.shade200,
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.child_care),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "No children have been added yet.",
              ),
            ),
          ],
        ),
      );
    }

    if (selectedChild == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            selectedChild = children.first.id;
          });
        }
      });
    }

    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final ChildModel child = children[index];

          return ChildSelectorCard(
            childName: child.name,
            gender: child.gender,
            age: child.age,
            selected: selectedChild == child.id,
            onTap: () {
              setState(() {
                selectedChild = child.id;
              });
            },
          );
        },
      ),
    );
  },
),

//----------------------------------------------------
// School
//----------------------------------------------------



const Text(
  "SCHOOL",
  style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: Colors.grey,
  ),
),

const SizedBox(height: 10),

TextField(
  decoration: InputDecoration(
    hintText: "Enter school name",
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    ),
  ),
),

const SizedBox(height: 24),

//----------------------------------------------------
// Notes
//----------------------------------------------------

const Text(
  "NOTES FOR YOUR CARER",
  style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: Colors.grey,
  ),
),

const SizedBox(height: 10),

TextField(
  controller: descriptionController,
  minLines: 4,
  maxLines: 6,
  decoration: InputDecoration(
    hintText: "eg not allergic, gate code...",
    alignLabelWithHint: true,
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    ),
  ),
),

const SizedBox(height: 28),

          ListTile(
            leading: const Icon(Icons.date_range),
            title: Text(
              selectedDate == null
                  ? "Select Date"
                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
            ),
            onTap: pickDate,
          ),

          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(
              selectedTime == null
                  ? "Select Time"
                  : selectedTime!.format(context),
            ),
            onTap: pickTime,
          ),

          const SizedBox(height: 24),

          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Cost"),

                        Text(
                          "$credits Credit${credits > 1 ? 's' : ''}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          FilledButton(
            onPressed: isLoading ? null : submit,
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Post Request"),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
