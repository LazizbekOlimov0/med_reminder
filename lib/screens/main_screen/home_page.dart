import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/medication.dart';
import '../../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MedicineModel> medicines = [];
  List<MedicineModel> filteredMedicines = [];
  bool isLoading = true;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchMedicines() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await ApiService.getAllMedicines();
      if (mounted) {
        setState(() {
          medicines = result;
          filteredMedicines = result;
          isLoading = false;
        });
      }
    } catch (e) {
      // Har qanday xatolik bo'lsa ham, bo'sh list ko'rsatamiz
      if (mounted) {
        setState(() {
          medicines = [];
          filteredMedicines = [];
          isLoading = false;
          errorMessage = null; // Xatolik xabarini ko'rsatmaymiz
        });
      }
    }
  }

  Future<void> searchMedicines(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredMedicines = medicines;
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    try {
      // API dan qidiruv
      final searchResults = await ApiService.searchMedicines(query);
      if (mounted) {
        setState(() {
          filteredMedicines = searchResults;
          isSearching = false;
        });
      }
    } catch (e) {
      // Qidiruv xatoligida ham bo'sh natija ko'rsatamiz
      if (mounted) {
        setState(() {
          filteredMedicines = [];
          isSearching = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  String _getTimeOfDay(DateTime time) {
    final hour = time.hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medication_outlined,
            size: 80,
            color: Colors.white30,
          ),
          const SizedBox(height: 16),
          Text(
            searchController.text.isNotEmpty
                ? "Dori topilmadi"
                : "Dorilar yo'q",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchController.text.isNotEmpty
                ? "Boshqa nom bilan qidiring"
                : "Birinchi doringizni qo'shing",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          if (searchController.text.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final result = await context.push('/add');
                // Add page'dan qaytganda refresh qilamiz
                if (result == true) {
                  fetchMedicines();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Dori Qo\'shish'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage ?? 'Something went wrong',
            style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: fetchMedicines,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          "Med Reminder",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // Notification page'ga o'tish
              },
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchMedicines,
        color: const Color(0xFF06B6D4),
        backgroundColor: const Color(0xFF1E293B),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF334155),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    // Debounce qidiruv uchun
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (searchController.text == value) {
                        searchMedicines(value);
                      }
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search medicines...",
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: isSearching
                        ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF06B6D4),
                        ),
                      ),
                    )
                        : const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          filteredMedicines = medicines;
                        });
                      },
                      icon: const Icon(Icons.clear, color: Colors.white70),
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Content
              Expanded(
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF06B6D4),
                  ),
                )
                    : filteredMedicines.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  itemCount: filteredMedicines.length,
                  itemBuilder: (context, index) {
                    final med = filteredMedicines[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF06B6D4).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            // Medicine detail page'ga o'tish
                            // context.push('/medicine-detail/${med.id}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                // Medicine Icon
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.medication,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Medicine Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        med.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${med.quantity} • ${med.type}",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.white.withOpacity(0.8),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${_formatTime(med.doseTime as DateTime)} • ${_getTimeOfDay(med.doseTime as DateTime)}",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Arrow Icon
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push('/add');
          // Add page'dan qaytganda refresh qilamiz
          if (result == true) {
            fetchMedicines();
          }
        },
        backgroundColor: const Color(0xFF06B6D4),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}