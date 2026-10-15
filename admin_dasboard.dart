import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final UserAccount user;

  const AdminDashboardScreen({super.key, required this.user});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedFilter = 'All';

  // ADMIN UTAMA
  bool get _isMainAdmin => widget.user.username == 'admin1';

  List<ItemModel> get _filteredItems {
    if (_selectedFilter == 'All') {
      return globalItemList;
    }

    if (_selectedFilter == 'Approve') {
      return [];
    }

    return globalItemList
        .where((item) => item.status == _selectedFilter)
        .toList();
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

  // =========================
  // LOGOUT
  // =========================

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // =========================
  // UBAH STATUS DATA
  // Admin Utama dan Admin Biasa
  // tetap dapat mengubah status.
  // =========================

  void _changeStatus(ItemModel item) {
    String selectedStatus = item.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // SUBHEADER & CLOSE BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ADMIN ACTION CONTROL',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC84B18),
                          letterSpacing: 0.8,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF1E293B),
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // MAIN TITLE
                  const Text(
                    'Update Status Record',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Divider(color: Color(0xFFE2E8F0), thickness: 1),

                  const SizedBox(height: 12),

                  // ITEM TITLE DISPLAY
                  Text(
                    'Item: "${item.title}"',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // STATUS OPTIONS (PENDING, PROSES, SELESAI)
                  _buildCustomRadioOption(
                    title: 'Pending Approval',
                    subtitle: 'Membutuhkan verifikasi atau penanganan awal',
                    value: 'Pending',
                    groupValue: selectedStatus,
                    onTap: (val) {
                      setModalState(() {
                        selectedStatus = val;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildCustomRadioOption(
                    title: 'In-Progress (Proses)',
                    subtitle: 'Sedang dikerjakan atau dalam tindak lanjut',
                    value: 'Proses',
                    groupValue: selectedStatus,
                    onTap: (val) {
                      setModalState(() {
                        selectedStatus = val;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildCustomRadioOption(
                    title: 'Completed (Selesai)',
                    subtitle: 'Tugas/inventaris telah diverifikasi tuntas',
                    value: 'Selesai',
                    groupValue: selectedStatus,
                    onTap: (val) {
                      setModalState(() {
                        selectedStatus = val;
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  // SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          item.status = selectedStatus;
                        });

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Status berhasil diperbarui'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC84B18),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Simpan Perubahan Status',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // =========================
  // CUSTOM RADIO CARD OPTION
  // =========================

  Widget _buildCustomRadioOption({
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required Function(String) onTap,
  }) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onTap(value),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFEF2F2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFEF4444)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF64748B),
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // HAPUS DATA
  // Admin Utama dan Admin Biasa
  // tetap dapat menghapus data.
  // =========================

  void _deleteItem(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Item?'),
          content: Text('Yakin ingin menghapus "${item.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  globalItemList.remove(item);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item berhasil dihapus')),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // PERSETUJUAN AKUN
  // HANYA ADMIN UTAMA
  // =========================

  void _approveUser(UserAccount user) {
    if (!_isMainAdmin) return;

    setState(() {
      user.status = 'Active';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Akun ${user.username} berhasil diterima.')),
    );
  }

  void _rejectUser(UserAccount user) {
    if (!_isMainAdmin) return;

    setState(() {
      user.status = 'Rejected';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Akun ${user.username} ditolak.')));
  }

  Widget _buildAccountApproval() {
    // Admin Biasa tidak dapat melihat persetujuan akun.
    if (!_isMainAdmin) {
      return const SizedBox.shrink();
    }

    final pendingUsers = registeredUsers
        .where((user) => user.status == 'Pending')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Persetujuan Akun',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        if (pendingUsers.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.check_circle_outline, size: 45, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'Tidak ada pendaftaran akun yang perlu disetujui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

        ...pendingUsers.map((user) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(child: Icon(Icons.person)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Role: ${user.role}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _rejectUser(user);
                        },
                        child: const Text('Tolak'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _approveUser(user);
                        },
                        child: const Text('Terima'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // =========================
  // METRIC CARD
  // =========================

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
              child: Icon(icon, color: iconColor, size: 20),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendDot(String title, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$title ($value)',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF475569),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = globalItemList
        .where((item) => item.status == 'Pending')
        .length;

    final processCount = globalItemList
        .where((item) => item.status == 'Proses')
        .length;

    final completedCount = globalItemList
        .where((item) => item.status == 'Selesai')
        .length;

    final taskCount = globalItemList
        .where((item) => item.category == 'Task')
        .length;

    final inventoryCount = globalItemList
        .where((item) => item.category == 'Inventaris')
        .length;

    final filteredItems = _filteredItems;
    final totalSystemItems = globalItemList.length;

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
                color: const Color(0xFFC84B18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Control Center',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Supervision: ${widget.user.username}',
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
          // BANNER
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB91C1C), Color(0xFFC84B18)],
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
                      const Text(
                        'Panel Pengawasan &\nValidasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Terdapat $pendingCount tugas/inventaris memerlukan tindakan verifikasi status.',
                        style: const TextStyle(
                          color: Color(0xFFFEE2E2),
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.shield_outlined,
                  size: 50,
                  color: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // RINGKASAN OPERASIONAL ADMIN
          const Text(
            'RINGKASAN OPERASIONAL ADMIN',
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
              _buildMetricCard(
                'Need Action',
                '$pendingCount',
                Icons.assignment_late_outlined,
                const Color(0xFFEF4444),
                const Color(0xFFFEF2F2),
              ),
              const SizedBox(width: 12),
              _buildMetricCard(
                'In Progress',
                '$processCount',
                Icons.sync,
                const Color(0xFFF59E0B),
                const Color(0xFFFFFBEB),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _buildMetricCard(
                'Completed',
                '$completedCount',
                Icons.verified_outlined,
                const Color(0xFF10B981),
                const Color(0xFFECFDF5),
              ),
              const SizedBox(width: 12),
              _buildMetricCard(
                'Total System...',
                '$totalSystemItems',
                Icons.format_list_bulleted,
                const Color(0xFF0284C7),
                const Color(0xFFF0F9FF),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // KATEGORI & PROGRESS BAR
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
                      'Analisis Distribusi Data System',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Icon(
                      Icons.pie_chart_outline_rounded,
                      color: Color(0xFFC84B18),
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Proporsi Kategori Data:',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 10,
                    child: Row(
                      children: [
                        Expanded(
                          flex: totalSystemItems == 0 ? 1 : taskCount,
                          child: Container(color: const Color(0xFF0284C7)),
                        ),
                        Expanded(
                          flex: totalSystemItems == 0 ? 1 : inventoryCount,
                          child: Container(color: const Color(0xFFD97706)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildLegendDot('Task', taskCount, const Color(0xFF0284C7)),
                    const Spacer(),
                    _buildLegendDot(
                      'Inventaris',
                      inventoryCount,
                      const Color(0xFFD97706),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // MANAJEMEN RECORD USER & FILTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Manajemen Record User',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${filteredItems.length} Items',
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
                _buildFilterChip('Pending'),
                _buildFilterChip('Proses'),
                _buildFilterChip('Selesai'),

                if (_isMainAdmin) _buildFilterChip('Approve'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // DATA LIST
          if (_selectedFilter == 'Approve' && _isMainAdmin)
            _buildAccountApproval(),

          if (filteredItems.isEmpty && _selectedFilter != 'Approve')
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
                  Text('Tidak ada data.', style: TextStyle(color: Colors.grey)),
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
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  child: Icon(
                    item.category == 'Task'
                        ? Icons.task_alt
                        : Icons.inventory_2_outlined,
                    color: Colors.orange,
                  ),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${item.category} • ${item.createdBy}'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
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
                          fontSize: 11,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Ubah Status',
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _changeStatus(item);
                      },
                    ),
                    IconButton(
                      tooltip: 'Hapus',
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteItem(item);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
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
        selectedColor: const Color(0xFFC84B18),
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
