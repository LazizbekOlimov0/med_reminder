import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controllerSearch = TextEditingController();
  final authController = AuthController();

  // Dorilar uchun turli ranglar
  final List<Map<String, dynamic>> medicineColors = [
    {
      'gradient': [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Indigo to Purple
      'shadowColor': Color(0xFF6366F1).withOpacity(0.3),
    },
    {
      'gradient': [Color(0xFF06B6D4), Color(0xFF0891B2)], // Cyan to Sky
      'shadowColor': Color(0xFF06B6D4).withOpacity(0.3),
    },
    {
      'gradient': [Color(0xFF10B981), Color(0xFF059669)], // Emerald to Green
      'shadowColor': Color(0xFF10B981).withOpacity(0.3),
    },
    {
      'gradient': [Color(0xFFF59E0B), Color(0xFFD97706)], // Amber to Orange
      'shadowColor': Color(0xFFF59E0B).withOpacity(0.3),
    },
    {
      'gradient': [Color(0xFFEF4444), Color(0xFFDC2626)], // Red to Red-600
      'shadowColor': Color(0xFFEF4444).withOpacity(0.3),
    },
    {
      'gradient': [Color(0xFFEC4899), Color(0xFFDB2777)], // Pink to Pink-600
      'shadowColor': Color(0xFFEC4899).withOpacity(0.3),
    },
    {
      'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Violet to Purple-600
      'shadowColor': Color(0xFF8B5CF6).withOpacity(0.3),
    },
  ];

  final List<String> medicineNames = [
    'Amoxicillin',
    'Ibuprofen',
    'Paracetamol',
    'Aspirin',
    'Metformin',
    'Omeprazole',
    'Lisinopril',
  ];

  final List<String> medicineTime = [
    'Night',
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
    'Morning',
    'Afternoon',
  ];

  final List<String> medicineDose = [
    '1 Tablet',
    '2 Tablets',
    '1 Capsule',
    '1 Tablet',
    '2 Tablets',
    '1 Capsule',
    '1 Tablet',
  ];

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF0F172A), // Dark background
      appBar: AppBar(
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
        title: Text(
          "Med Reminder",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        titleSpacing: 20,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Color(0xFF334155),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF334155)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: "Search medicines & advice",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF06B6D4)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Color(0xFF06B6D4), width: 2),
                    ),
                  ),
                  onChanged: (value) async {
                    final success = await authController.search(
                        context,
                        controllerSearch.text
                    );
                    if (success) {
                      context.go('/home');
                    }
                  },
                  controller: controllerSearch,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color(0xFF06B6D4),
                ),
              ),
              SizedBox(height: 30),

              // Title
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Your Medicines",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Medicine List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final colorData = medicineColors[index % medicineColors.length];

                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colorData['gradient'],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colorData['shadowColor'],
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          medicineNames[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            "Antibiotic",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.9),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        medicineTime[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.medication,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        medicineDose[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}