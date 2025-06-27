import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.name, super.key});

  final String name;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  Uint8List? _imageBytes;

  // SharedPreferences keys
  static const String _profileImageKey = 'profile_image';
  static const String _currentMedicinesKey = 'current_medicines';
  static const String _streakDaysKey = 'streak_days';
  static const String _completionRateKey = 'completion_rate';
  static const String _totalDosesKey = 'total_doses';
  static const String _userNameKey = 'user_name';
  static const String _isActiveKey = 'is_active';

  // Profile data
  String _userName = '';
  bool _isActive = true;
  int _currentMedicines = 5;
  int _streakDays = 12;
  int _completionRate = 87;
  int _totalDoses = 156;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // SharedPreferences ma'lumotlarini yuklash
  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        _userName = prefs.getString(_userNameKey) ?? widget.name;
        _isActive = prefs.getBool(_isActiveKey) ?? true;
        _currentMedicines = prefs.getInt(_currentMedicinesKey) ?? 5;
        _streakDays = prefs.getInt(_streakDaysKey) ?? 12;
        _completionRate = prefs.getInt(_completionRateKey) ?? 87;
        _totalDoses = prefs.getInt(_totalDosesKey) ?? 156;
      });

      // Profil rasmini yuklash
      final imageString = prefs.getString(_profileImageKey);
      if (imageString != null) {
        setState(() {
          _imageBytes = base64Decode(imageString);
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  // SharedPreferences ga ma'lumotlarni saqlash
  Future<void> _saveProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_userNameKey, _userName);
      await prefs.setBool(_isActiveKey, _isActive);
      await prefs.setInt(_currentMedicinesKey, _currentMedicines);
      await prefs.setInt(_streakDaysKey, _streakDays);
      await prefs.setInt(_completionRateKey, _completionRate);
      await prefs.setInt(_totalDosesKey, _totalDoses);

      // Profil rasmini saqlash
      if (_imageBytes != null) {
        final imageString = base64Encode(_imageBytes!);
        await prefs.setString(_profileImageKey, imageString);
      }
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }

  // Statistikalarni yangilash
  Future<void> _updateStats() async {
    setState(() {
      _currentMedicines = (_currentMedicines + 1) % 10; // Test uchun
      _streakDays += 1;
      _totalDoses += 1;
      if (_completionRate < 100) _completionRate += 1;
    });
    await _saveProfileData();
  }

  // Profil ma'lumotlarini tozalash
  Future<void> _clearProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileImageKey);
      await prefs.remove(_currentMedicinesKey);
      await prefs.remove(_streakDaysKey);
      await prefs.remove(_completionRateKey);
      await prefs.remove(_totalDosesKey);
      await prefs.remove(_userNameKey);
      await prefs.remove(_isActiveKey);

      // Ma'lumotlarni qayta yuklash
      await _loadProfileData();
    } catch (e) {
      print('Error clearing profile data: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      // Show dialog to choose between camera and gallery
      final source = await _showImageSourceDialog();
      if (source == null) return;

      final XFile? photo = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 90,
      );

      if (photo != null) {
        // Web uchun bytes olish
        final bytes = await photo.readAsBytes();
        setState(() {
          _selectedImage = photo;
          _imageBytes = bytes;
        });

        // Rasmni saqlash
        await _saveProfileData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update profile image'),
            backgroundColor: Colors.green.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('There was an error selecting the image'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "choose a picture",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Where do you want to choose the picture from?",
            style: TextStyle(color: Colors.grey.shade300),
          ),
          actions: [
            // Web'da kamera mavjud bo'lmasa, faqat gallery ko'rsatish
            if (!kIsWeb || _picker.supportsImageSource(ImageSource.camera))
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                icon: Icon(Icons.camera_alt, color: Color(0xFF06B6D4)),
                label: Text(
                  "Camera",
                  style: TextStyle(color: Color(0xFF06B6D4)),
                ),
              ),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              icon: Icon(Icons.photo_library, color: Color(0xFF8B5CF6)),
              label: Text(
                "Galera",
                style: TextStyle(color: Color(0xFF8B5CF6)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage() {
    if (_imageBytes != null) {
      // Web uchun bytes dan image
      return Image.memory(
        _imageBytes!,
        fit: BoxFit.cover,
        width: 112,
        height: 112,
      );
    } else {
      // Default image yoki placeholder
      return Image.asset(
        "assets/images/pr.png",
        fit: BoxFit.cover,
        width: 112,
        height: 112,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 112,
            height: 112,
            color: Color(0xFF334155),
            child: Icon(Icons.person, size: 60, color: Colors.white),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _updateStats,
            icon: Icon(Icons.refresh, color: Colors.white),
            tooltip: "Update statistic",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Header with gradient background
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF334155)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Picture
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          gradient: LinearGradient(
                            colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF06B6D4).withOpacity(0.4),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(56),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(56),
                            child: _buildProfileImage(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF10B981).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _takePicture,
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Name and Status
                  Text(
                    _userName.isEmpty ? widget.name : _userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (_isActive ? Color(0xFF10B981) : Color(0xFFEF4444)).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _isActive ? Color(0xFF10B981) : Color(0xFFEF4444), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _isActive ? Color(0xFF10B981) : Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _isActive ? "Online" : "Offline",
                          style: TextStyle(
                            color: _isActive ? Color(0xFF10B981) : Color(0xFFEF4444),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: "current medications",
                    value: "$_currentMedicines",
                    icon: Icons.medication,
                    color: Color(0xFF06B6D4),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: "day after day",
                    value: "$_streakDays",
                    icon: Icons.local_fire_department,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: "Success",
                    value: "$_completionRate%",
                    icon: Icons.check_circle,
                    color: Color(0xFF10B981),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: "All medical",
                    value: "$_totalDoses",
                    icon: Icons.timeline,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Menu Options
            _buildMenuSection("account settings", [
              _buildMenuItem(
                Icons.person_outline,
                "Update profile",
                _showEditProfileDialog,
              ),
              _buildMenuItem(Icons.history, "Archive medical", () {}),
              _buildMenuItem(
                Icons.notifications_outlined,
                "Notifications",
                    () {},
              ),
              _buildMenuItem(
                Icons.delete_outline,
                "Clear data",
                _showClearDataDialog,
              ),
            ]),
            SizedBox(height: 50),

            // Logout Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFEF4444).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showLogoutDialog();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Quite",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: 16),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF06B6D4).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Color(0xFF06B6D4), size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade500,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName.isEmpty ? widget.name : _userName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Update profile",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.grey.shade300),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF06B6D4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text("Online:", style: TextStyle(color: Colors.white)),
                      Spacer(),
                      Switch(
                        value: _isActive,
                        onChanged: (value) {
                          setDialogState(() {
                            _isActive = value;
                          });
                        },
                        activeColor: Color(0xFF10B981),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _userName = nameController.text;
                    });
                    await _saveProfileData();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Update Profile'),
                        backgroundColor: Colors.green.shade400,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Color(0xFF06B6D4)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Clear data",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "All saved data will be deleted. Do you want to continue?",
            style: TextStyle(color: Colors.grey.shade300),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _clearProfileData();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Clear data'),
                    backgroundColor: Colors.orange.shade400,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              child: Text(
                "Clear",
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Quite",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure quite?",
            style: TextStyle(color: Colors.grey.shade300),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logout logic here
              },
              child: Text(
                "Quite",
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ],
        );
      },
    );
  }
}