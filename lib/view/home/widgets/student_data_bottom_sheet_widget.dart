import 'package:flutter/material.dart';

class StudentDataBottomSheetWidget extends StatelessWidget {
  const StudentDataBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme and check if dark mode
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Placeholder data - replace with actual data source later
    Map<String, dynamic> studentData = {
      "student": "محمد",
      "trainerName": "ياسين",
      "birthDate": "2018-2-8",
      "email": "mohamed.student@example.com", // Added placeholder email
      "level": "100",
    };

    // Define colors based on theme
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final handleColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final closeIconColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final dividerColor = isDarkMode ? Colors.grey[800] : Colors.grey[300];
    final shadowColor = isDarkMode ? Colors.black54 : Colors.black26;

    return Container(
      // Removed maxHeight constraint to let it fit content, relying on smaller fonts/padding
      padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8.0), // Reduced top/bottom padding
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10.0,
            offset: const Offset(0, -2),
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
              color: handleColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, color: closeIconColor),
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
            isDarkMode: isDarkMode,
          ),
          _buildInfoRow(
            context,
            icon: Icons.supervisor_account_outlined,
            label: "اسم المدرب",
            value: studentData["trainerName"],
            isDarkMode: isDarkMode,
          ),
          _buildInfoRow(
            context,
            icon: Icons.cake_outlined,
            label: "تاريخ الميلاد",
            value: studentData["birthDate"],
            isDarkMode: isDarkMode,
          ),
          _buildInfoRow(
            context,
            icon: Icons.email_outlined, // Added Email Icon
            label: "البريد الإلكتروني", // Added Email Label
            value: studentData["email"], // Added Email Value
            isDarkMode: isDarkMode,
          ),
          _buildInfoRow(
            context,
            icon: Icons.leaderboard_outlined, // Or Icons.format_list_numbered
            label: "المستوى",
            value: studentData["level"],
            isLastItem: true,
            isDarkMode: isDarkMode,
          ),
          // Removed SizedBox here
        ],
      ),
    );
  }

  // Helper widget for creating info rows with smaller fonts/padding
  Widget _buildInfoRow(BuildContext context, {
    required IconData icon, 
    required String label, 
    required String value, 
    bool isLastItem = false,
    required bool isDarkMode,
  }) {
    // Define colors based on theme
    final iconColor = isDarkMode ? Colors.lightBlue[300] : Colors.blueGrey[600];
    final labelColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];
    final valueColor = isDarkMode ? Colors.white : Colors.black87;
    final dividerColor = isDarkMode ? Colors.grey[800] : Colors.grey[300];
    
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor, size: 20), // Slightly smaller icon
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14, // Reduced font size
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
          trailing: Text(
            value,
            style: TextStyle(
              fontSize: 14, // Reduced font size
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.right,
          ),
          dense: true, // Make ListTile more compact
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0), // Reduced padding
          minVerticalPadding: 4, // Reduced vertical padding
        ),
        if (!isLastItem)
          Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16, color: dividerColor),
      ],
    );
  }
}
