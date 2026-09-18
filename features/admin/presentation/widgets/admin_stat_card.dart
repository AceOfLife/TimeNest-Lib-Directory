import 'package:flutter/material.dart';

class AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const AdminStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      elevation: 3,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.all(
            16,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    color.withOpacity(
                  .12,
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                title,
                style:
                    TextStyle(
                  color: Colors
                      .grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}