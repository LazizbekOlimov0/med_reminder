import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class Main extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const Main({super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context,
                  index: 0,
                  icon: FontAwesomeIcons.pills,
                  label: "Medicines",
                  isSelected: currentIndex == 0,
                  gradientColors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                ),
                _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.add_rounded,
                  label: "Add",
                  isSelected: currentIndex == 1,
                  gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                _buildNavItem(
                  context,
                  index: 2,
                  icon: Icons.person_rounded,
                  label: "Profile",
                  isSelected: currentIndex == 2,
                  gradientColors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required int index,
        required IconData icon,
        required String label,
        required bool isSelected,
        required List<Color> gradientColors,
      }) {
    return GestureDetector(
      onTap: () {
        if (currentIndex != index) {
          String page = switch (index) {
            0 => "/home",
            1 => "/add",
            2 => "/profile",
            _ => "/main",
          };
          context.go(page);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isSelected ? 100 : 60,
        height: 50,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade400,
              size: isSelected ? 24 : 22,
            ),
            if (isSelected) ...[
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}