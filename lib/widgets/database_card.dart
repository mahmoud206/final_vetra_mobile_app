import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class DatabaseCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const DatabaseCard({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shadowColor: isSelected 
          ? AppTheme.primaryColor.withOpacity(0.5) 
          : Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.borderRadius,
        side: BorderSide(
          color: isSelected 
              ? AppTheme.primaryColor 
              : Colors.grey.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppTheme.primaryColor 
                      : AppTheme.primaryLightColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pets,
                  color: isSelected 
                      ? Colors.white 
                      : AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getDisplayName(name),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected 
                            ? AppTheme.primaryColor 
                            : AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getLocationDescription(name),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getDisplayName(String databaseName) {
    // Extract clinic name from database name
    return databaseName.replaceAll('Elanam-', 'عيادة الإنعام - ');
  }
  
  String _getLocationDescription(String databaseName) {
    // Return Arabic location description based on database name
    if (databaseName.contains('KhamisMushit')) {
      return 'فرع خميس مشيط';
    } else if (databaseName.contains('Baish')) {
      return 'فرع بيش';
    } else if (databaseName.contains('Zapia')) {
      return 'فرع الظبية';
    } else {
      return 'فرع غير معروف';
    }
  }
}