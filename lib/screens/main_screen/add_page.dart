import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController controllerMedicineName = TextEditingController();
  TextEditingController controllerDayCount = TextEditingController();
  TextEditingController controllerStrength = TextEditingController();
  TextEditingController controllerNotes = TextEditingController();

  TimeOfDay? selectedTime;
  String? selectedMedicationType;
  String? selectedFrequency;
  String? selectedDuration;

  String getFormatTime() {
    if (selectedTime == null) {
      return 'First Dose Time';
    }
    return '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Color(0xFF1E293B),
              hourMinuteTextColor: Color(0xFF06B6D4),
              dayPeriodTextColor: Color(0xFF06B6D4),
              dialHandColor: Color(0xFF06B6D4),
              dialBackgroundColor: Color(0xFF334155),
              hourMinuteTextStyle: TextStyle(color: Colors.white),
              dayPeriodTextStyle: TextStyle(color: Colors.white),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF06B6D4)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        _saveTimeToDatabase(pickedTime);
      });
    }
  }

  void _saveTimeToDatabase(TimeOfDay timeToSave) {
    int minutesSinceMidnight = timeToSave.hour * 60 + timeToSave.minute;
  }

  DateTime? selectedDateStart;
  DateTime? selectedDateEnd;

  String getFormattedDateStart() {
    if (selectedDateStart == null) {
      return 'Dose Start Date';
    }
    return DateFormat('dd.MM.yyyy').format(selectedDateStart!);
  }

  String getFormattedDateEnd() {
    if (selectedDateEnd == null) {
      return 'Dose End Date';
    }
    return DateFormat('dd.MM.yyyy').format(selectedDateEnd!);
  }

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateStart ?? currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF06B6D4),
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF06B6D4)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDateStart) {
      setState(() {
        selectedDateStart = pickedDate;
        _saveDateToStorage(pickedDate);
      });
    }
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateEnd ?? currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF06B6D4),
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF06B6D4)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDateEnd) {
      setState(() {
        selectedDateEnd = pickedDate;
        _saveDateToStorage(pickedDate);
      });
    }
  }

  void _saveDateToStorage(DateTime dateToSave) {
    final int timestamp = dateToSave.millisecondsSinceEpoch;
  }

  Widget _buildInputDecoration({required Widget child, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
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
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
        title: Text(
          "Add Medicine",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
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
                    "Medicine Details",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // First Row - Medication Type & Day Count
              Row(
                children: [
                  Expanded(
                    child: _buildInputDecoration(
                      label: "Medication Type",
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(canvasColor: Color(0xFF1E293B)),
                        child: DropdownButtonFormField<String>(
                          value: selectedMedicationType,
                          hint: Text(
                            'Select Type',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          dropdownColor: Color(0xFF1E293B),
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          items: [
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
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildInputDecoration(
                      label: "Duration (Days)",
                      child: TextField(
                        controller: controllerDayCount,
                        style: TextStyle(color: Colors.white),
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
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF06B6D4),
                          ),
                        ),
                        cursorColor: Color(0xFF06B6D4),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Second Row - Frequency & Time
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildInputDecoration(
                      label: "Dose Time",
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _selectTime(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: EdgeInsets.all(16),
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
                                Icon(
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
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
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
              SizedBox(height: 24),

              // Third Row - Duration & Strength
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
                            padding: EdgeInsets.all(16),
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
                                Icon(
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
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildInputDecoration(
                      label: "Strength/Dose",
                      child: TextField(
                        controller: controllerStrength,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "e.g., 500mg",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon: Icon(
                            Icons.medication,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        cursorColor: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Medicine Name
              _buildInputDecoration(
                label: "Medicine Name",
                child: TextField(
                  controller: controllerMedicineName,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Enter medicine name",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(
                      Icons.local_pharmacy,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                  cursorColor: Color(0xFF8B5CF6),
                ),
              ),
              SizedBox(height: 24),

              // Notes
              _buildInputDecoration(
                label: "Additional Notes",
                child: TextField(
                  controller: controllerNotes,
                  style: TextStyle(color: Colors.white),
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
                  cursorColor: Color(0xFF06B6D4),
                ),
              ),
              SizedBox(height: 40),

              // Add Button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF06B6D4).withOpacity(0.4),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Add medicine logic here
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Row(
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
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
