import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'add_item_screen.dart';
import 'login_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  final UserAccount user;

  const UserDashboardScreen({super.key, required this.user});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  String _selectedFilter = 'All';

  List<ItemModel> get _filteredItems {
    if (_selectedFilter == 'All') {
      return globalItemList;
    }

    return globalItemList
        .where((item) => item.category == _selectedFilter)
        .toList();
  }

  int get _totalTask {
    return globalItemList.where((item) => item.category == 'Task').length;
  }

  int get _totalInventory {
    return globalItemList.where((item) => item.category == 'Inventaris').length;
  }

  int get _totalPending {
    return globalItemList.where((item) => item.status == 'Pending').length;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xFFEF4444);

      case 'Proses':
        return const Color(0xFFF59E0B);

      case 'Selesai':
        return const Color(0xFF10B981);

      default:
        return Colors.grey;
    }
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend(String title, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$title: $value',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF475569),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(builder: (context) => const LoginScreen()),

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    final totalItems = globalItemList.length;
    final pendingCount = globalItemList
        .where((i) => i.status == 'Pending')
        .length;
    final processCount = globalItemList
        .where((i) => i.status == 'Proses')
        .length;
    final completedCount = globalItemList
        .where((i) => i.status == 'Selesai')
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D6E57),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Workspace',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Account: ${widget.user.username}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          // =========================
          // BANNER
          // =========================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF054F3F), Color(0xFF0D6E57)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang, ${widget.user.username}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pantau status inventaris dan penyelesaian tugas operasional Anda secara real-time.',
                        style: TextStyle(
                          color: Color(0xFFD1FAE5),
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // =========================
          // RINGKASAN METRIK ENTERPRISE
          // =========================
          const Text(
            'RINGKASAN METRIK ENTERPRISE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _buildSummaryCard(
                'Total Item',
                '${globalItemList.length}',
                Icons.archive_outlined,
                const Color(0xFF0284C7),
                const Color(0xFFF0F9FF),
              ),
              const SizedBox(width: 12),
              _buildSummaryCard(
                'Total Task',
                '$_totalTask',
                Icons.check_circle_outline_rounded,
                const Color(0xFF0284C7),
                const Color(0xFFF0F9FF),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _buildSummaryCard(
                'Inventaris',
                '$_totalInventory',
                Icons.grid_view_outlined,
                const Color(0xFFD97706),
                const Color(0xFFFFFBEB),
              ),
              const SizedBox(width: 12),
              _buildSummaryCard(
                'Pending Stat...',
                '$_totalPending',
                Icons.assignment_late_outlined,
                const Color(0xFFEF4444),
                const Color(0xFFFEF2F2),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =========================
          // PENYELESAIAN STATUS TASK & INVENTARIS
          // =========================
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Penyelesaian Status Task & Inventaris',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Icon(
                      Icons.bar_chart_rounded,
                      color: Color(0xFF0D6E57),
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Multi-Color Progress Bar Visual
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 10,
                    child: Row(
                      children: [
                        Expanded(
                          flex: totalItems == 0 ? 1 : completedCount,
                          child: Container(color: const Color(0xFF10B981)),
                        ),
                        Expanded(
                          flex: totalItems == 0 ? 1 : processCount,
                          child: Container(color: const Color(0xFFF59E0B)),
                        ),
                        Expanded(
                          flex: totalItems == 0 ? 1 : pendingCount,
                          child: Container(color: const Color(0xFFEF4444)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildChartLegend(
                      'Selesai',
                      completedCount,
                      const Color(0xFF10B981),
                    ),
                    _buildChartLegend(
                      'Proses',
                      processCount,
                      const Color(0xFFF59E0B),
                    ),
                    _buildChartLegend(
                      'Pending',
                      pendingCount,
                      const Color(0xFFEF4444),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // =========================
          // DAFTAR RECORD DATA & FILTER
          // =========================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Record Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${filteredItems.length} Item',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Task'),
                _buildFilterChip('Inventaris'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // =========================
          // DAFTAR ITEM LIST
          // =========================
          if (filteredItems.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.inbox_outlined, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Belum ada data.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

          ...filteredItems.map((item) {
            final statusColor = _getStatusColor(item.status);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF0D6E57).withOpacity(0.1),
                  child: Icon(
                    item.category == 'Task'
                        ? Icons.task_alt
                        : Icons.inventory_2_outlined,
                    color: const Color(0xFF0D6E57),
                  ),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${item.category} • Dibuat oleh ${item.createdBy}',
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),

      // =========================
      // TAMBAH ENTRY
      // =========================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0D6E57),
        elevation: 4,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemScreen(user: widget.user),
            ),
          );

          if (result == true) {
            setState(() {});
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Entry',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: isSelected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
        label: Text(filter),
        selected: isSelected,
        selectedColor: const Color(0xFF0D6E57),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF475569),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }
}
