import 'package:flutter/material.dart';

class StudentDataBottomSheetWidget extends StatelessWidget {
  const StudentDataBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data - replace with actual data source later
    Map<String, dynamic> studentData = {
      "student": "محمد",
      "trainerName": "ياسين",
      "birthDate": "2018-2-8",
      "email": "mohamed.student@example.com", // Added placeholder email
      "level": "100",
    };

    return Container(
      // Removed maxHeight constraint to let it fit content, relying on smaller fonts/padding
      padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8.0), // Reduced top/bottom padding
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, -2),
          ),
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Make column height fit content
        children: [
          // Optional: Drag handle indicator
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 8.0), // Reduced margin
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.grey[600]),
              onPressed: () => Navigator.pop(context),
              splashRadius: 20,
              padding: EdgeInsets.zero, // Reduce padding around icon button
              constraints: const BoxConstraints(), // Remove default constraints if needed
            ),
          ),
          // Removed SizedBox here to reduce space
          // Info Rows using ListTile in the new requested order with reduced font/padding
          _buildInfoRow(
            context,
            icon: Icons.person_outline,
            label: "اسم الطالب",
            value: studentData["student"],
          ),
          _buildInfoRow(
            context,
            icon: Icons.supervisor_account_outlined,
            label: "اسم المدرب",
            value: studentData["trainerName"],
          ),
          _buildInfoRow(
            context,
            icon: Icons.cake_outlined,
            label: "تاريخ الميلاد",
            value: studentData["birthDate"],
          ),
          _buildInfoRow(
            context,
            icon: Icons.email_outlined, // Added Email Icon
            label: "البريد الإلكتروني", // Added Email Label
            value: studentData["email"], // Added Email Value
          ),
          _buildInfoRow(
            context,
            icon: Icons.leaderboard_outlined, // Or Icons.format_list_numbered
            label: "المستوى",
            value: studentData["level"],
            isLastItem: true,
          ),
          // Removed SizedBox here
        ],
      ),
    );
  }

  // Helper widget for creating info rows with smaller fonts/padding
  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value, bool isLastItem = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blueGrey[600], size: 20), // Slightly smaller icon
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14, // Reduced font size
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          trailing: Text(
            value,
            style: const TextStyle(
              fontSize: 14, // Reduced font size
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.right,
          ),
          dense: true, // Make ListTile more compact
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0), // Reduced padding
          minVerticalPadding: 4, // Reduced vertical padding
        ),
        if (!isLastItem)
          Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16, color: Colors.grey[300]),
      ],
    );
  }
}

