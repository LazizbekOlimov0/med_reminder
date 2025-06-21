import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/medication.dart';
import '../../services/api_service.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController controllerMedicineName = TextEditingController();
  final TextEditingController controllerDayCount = TextEditingController();
  final TextEditingController controllerStrength = TextEditingController();
  final TextEditingController controllerNotes = TextEditingController();

  TimeOfDay? selectedTime;
  String? selectedMedicationType;
  DateTime? selectedDateStart;
  bool isLoading = false;

  @override
  void dispose() {
    controllerMedicineName.dispose();
    controllerDayCount.dispose();
    controllerStrength.dispose();
    controllerNotes.dispose();
    super.dispose();
  }

  String getFormatTime() {
    if (selectedTime == null) {
      return 'First Dose Time';
    }
    return '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Color(0xFF1E293B),
              hourMinuteTextColor: Color(0xFF06B6D4),
              dayPeriodTextColor: Color(0xFF06B6D4),
              dialHandColor: Color(0xFF06B6D4),
              dialBackgroundColor: Color(0xFF334155),
              hourMinuteTextStyle: TextStyle(color: Colors.white),
              dayPeriodTextStyle: TextStyle(color: Colors.white),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF06B6D4),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  String getFormattedDateStart() {
    if (selectedDateStart == null) {
      return 'Dose Start Date';
    }
    return DateFormat('dd.MM.yyyy').format(selectedDateStart!);
  }

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateStart ?? currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF06B6D4),
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF06B6D4),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDateStart) {
      setState(() {
        selectedDateStart = pickedDate;
      });
    }
  }

  Widget _buildInputDecoration({required Widget child, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF334155)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  bool _validateInputs() {
    if (controllerMedicineName.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter medicine name");
      return false;
    }
    if (selectedMedicationType == null) {
      _showErrorSnackBar("Please select medication type");
      return false;
    }
    if (controllerDayCount.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter duration");
      return false;
    }
    if (int.tryParse(controllerDayCount.text.trim()) == null ||
        int.parse(controllerDayCount.text.trim()) <= 0) {
      _showErrorSnackBar("Please enter valid duration");
      return false;
    }
    if (controllerStrength.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter strength/dose");
      return false;
    }
    if (selectedTime == null) {
      _showErrorSnackBar("Please select dose time");
      return false;
    }
    if (selectedDateStart == null) {
      _showErrorSnackBar("Please select start date");
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> addMed() async {
    if (!_validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final duration = int.parse(controllerDayCount.text.trim());
      final endDate = selectedDateStart!.add(Duration(days: duration));

      final medicine = MedicineModel(
        name: controllerMedicineName.text.trim(),
        type: selectedMedicationType!,
        duration: duration,
        quantity: controllerStrength.text.trim(),
        doseTime: getFormatTime(),
        startDate: selectedDateStart!,
        endDate: endDate,
        notes: controllerNotes.text.trim(),
        isActive: true,
        userId: "123",
        medicineDoseTimes: [getFormatTime()],
      );

      final res = await ApiService.createMedicine(medicine);

      if (res.statusCode == 200 || res.statusCode == 201) {
        _showSuccessSnackBar("Medicine added successfully!");
        if (mounted) {
          context.go('/home');
        }
      } else {
        _showErrorSnackBar("Failed to add medicine: ${res.body}");
      }
    } catch (e) {
      _showErrorSnackBar("An error occurred: ${e.toString()}");
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
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          "Add Medicine",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient line
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Medicine Details",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // First Row - Medication Type & Day Count
              Row(
                children: [
                  Expanded(
                    child: _buildInputDecoration(
                      label: "Medication Type",
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(canvasColor: const Color(0xFF1E293B)),
                        child: DropdownButtonFormField<String>(
                          value: selectedMedicationType,
                          hint: Text(
                            'Select Type',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          dropdownColor: const Color(0xFF1E293B),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'tablet',
                              child: Text('💊 Tablet'),
                            ),
                            DropdownMenuItem(
                              value: 'liquid',
                              child: Text('🧪 Liquid'),
                            ),
                            DropdownMenuItem(
                              value: 'injection',
                              child: Text('💉 Injection'),
                            ),
                            DropdownMenuItem(
                              value: 'drops',
                              child: Text('💧 Drops'),
                            ),
                            DropdownMenuItem(
                              value: 'spray',
                              child: Text('🌬️ Spray'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedMedicationType = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputDecoration(
                      label: "Duration (Days)",
                      child: TextField(
                        controller: controllerDayCount,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "e.g., 7",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF06B6D4),
                          ),
                        ),
                        cursorColor: const Color(0xFF06B6D4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Second Row - Time & Add Button
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildInputDecoration(
                      label: "Dose Time",
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _selectTime(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getFormatTime(),
                                  style: TextStyle(
                                    color:
                                        selectedTime != null
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(
                                  Icons.access_time,
                                  color: Color(0xFF06B6D4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // You can implement additional time slots here
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  "Add",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Third Row - Start Date & Strength
              Row(
                children: [
                  Expanded(
                    child: _buildInputDecoration(
                      label: "Start Date",
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _selectDateStart(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getFormattedDateStart(),
                                  style: TextStyle(
                                    color:
                                        selectedDateStart != null
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                  ),
                                ),
                                const Icon(
                                  Icons.date_range,
                                  color: Color(0xFF06B6D4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputDecoration(
                      label: "Strength/Dose",
                      child: TextField(
                        controller: controllerStrength,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "e.g., 500mg",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon: const Icon(
                            Icons.medication,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        cursorColor: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Medicine Name
              _buildInputDecoration(
                label: "Medicine Name",
                child: TextField(
                  controller: controllerMedicineName,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Enter medicine name",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    prefixIcon: const Icon(
                      Icons.local_pharmacy,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                  cursorColor: const Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(height: 24),

              // Notes
              _buildInputDecoration(
                label: "Additional Notes",
                child: TextField(
                  controller: controllerNotes,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Any special instructions or notes...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  cursorColor: const Color(0xFF06B6D4),
                ),
              ),
              const SizedBox(height: 40),

              // Add Button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isLoading ? null : addMed,
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                              : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Add Medicine",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
