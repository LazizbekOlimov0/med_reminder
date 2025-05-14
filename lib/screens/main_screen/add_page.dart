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
              backgroundColor: Colors.white,
              hourMinuteTextColor: Colors.blue,
              dayPeriodTextColor: Colors.blue,
              dialHandColor: Colors.blue,
              dialBackgroundColor: Colors.blue.shade100,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
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
      return 'Dose Start Date  ';
    }
    return DateFormat('EEEE, MMMM d, yyyy').format(selectedDateStart!);
  }

  String getFormattedDateEnd() {
    if (selectedDateEnd == null) {
      return 'Dose End Date  ';
    }
    return DateFormat('EEEE, MMMM d, yyyy').format(selectedDateEnd!);
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
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
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
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDateEnd) {
      setState(() {
        selectedDateEnd = pickedDate;

        // Save the selected date
        _saveDateToStorage(pickedDate);
      });
    }
  }

  void _saveDateToStorage(DateTime dateToSave) {
    final int timestamp = dateToSave.millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Medicine",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            height: sizeHeight,
            width: sizeWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownMenu(
                          hintText: 'Medication Type',
                          onSelected: (value) {},
                          width: sizeWidth * 0.44,
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 'tablet', label: 'Tablet'),
                            DropdownMenuEntry(value: 'liquid', label: 'Liquid'),
                            DropdownMenuEntry(
                              value: 'injection',
                              label: 'Injection',
                            ),
                            DropdownMenuEntry(value: 'drops', label: 'Drops'),
                            DropdownMenuEntry(value: 'spray', label: 'Spray'),
                          ],
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "How much days?",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                              ),
                            ),
                          ),
                          onChanged: (value) {},
                          controller: controllerDayCount,
                          cursorColor: Colors.blue.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownMenu(
                          hintText: 'Frequency',
                          onSelected: (value) {},
                          width: sizeWidth * 0.44,
                          dropdownMenuEntries: [],
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          onPressed: () => _selectTime(context),
                          height: sizeHeight * 0.08,
                          minWidth: sizeWidth * 0.44,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 1),
                              Text(
                                getFormatTime(),
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(Icons.access_time, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownMenu(
                          hintText: 'Duration',
                          onSelected: (value) {},
                          width: sizeWidth * 0.44,
                          dropdownMenuEntries: [
                            DropdownMenuEntry(
                              value: 'morning',
                              label: 'Morning',
                            ),
                            DropdownMenuEntry(
                              value: 'evening',
                              label: 'Evening',
                            ),
                            DropdownMenuEntry(value: 'night', label: 'Night'),
                          ],
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "strength",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                              ),
                            ),
                          ),
                          onChanged: (value) {},
                          controller: controllerStrength,
                          cursorColor: Colors.blue.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "Medicine",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Medication Name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.blue.shade200,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  onChanged: (value) {},
                  controller: controllerMedicineName,
                  cursorColor: Colors.blue.shade200,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () => _selectDateStart(context),
                      height: sizeHeight * 0.08,
                      minWidth: sizeWidth * 0.4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getFormattedDateStart(),
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          Icon(Icons.date_range, color: Colors.grey),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () => _selectDateEnd(context),
                      height: sizeHeight * 0.08,
                      minWidth: sizeWidth * 0.4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getFormattedDateEnd(),
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          Icon(Icons.date_range, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Notes",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.blue.shade200,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  onChanged: (value) {},
                  controller: controllerNotes,
                  cursorColor: Colors.blue.shade200,
                ),
                SizedBox(height: 30),
                MaterialButton(
                  onPressed: () {},
                  height: sizeHeight * 0.08,
                  minWidth: sizeWidth,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.blue.shade200),
                  ),
                  color: Colors.blueAccent.shade700,
                  child: Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
