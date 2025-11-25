import 'package:flutter/material.dart';
import '../models/personnel.dart';

class PersonnelCard extends StatelessWidget {
  final Personnel p;
  const PersonnelCard({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xffFFC928),
                  child: Icon(
                    Icons.groups,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.fullName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.roleName,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.isActive ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: p.isActive ? Colors.green : Colors.red),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: p.isActive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        p.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: p.isActive ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.phone, size: 14),
                const SizedBox(width: 4),
                Text(p.contactNumber),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 14),
                const SizedBox(width: 4),
                Expanded(child: Text(p.fullAddress)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
