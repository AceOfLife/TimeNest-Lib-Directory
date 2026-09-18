import 'package:flutter/material.dart';

class ChildSelectorCard extends StatelessWidget {
  final String childName;
  final String gender;
  final int age;
  final bool selected;
  final VoidCallback onTap;

  const ChildSelectorCard({
    super.key,
    required this.childName,
    required this.gender,
    required this.age,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? primary : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
           

            const SizedBox(height: 12),

            Text(
              childName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "$age yrs • $gender",
              style: TextStyle(
                fontSize: 12,
                color: selected
                    ? Colors.white70
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}