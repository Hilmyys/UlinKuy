import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../common/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _avatarUrlController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name);
    _emailController = TextEditingController(text: user?.email);
    _avatarUrlController = TextEditingController(text: user?.avatarUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  void _showAlert(String title, String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: isError ? Colors.red : Colors.green),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Attempt to update
    await authProvider.updateProfile(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _avatarUrlController.text.trim().isEmpty ? null : _avatarUrlController.text.trim(),
    );

    if (!mounted) return;
    
    setState(() => _isEditing = false);
    _showAlert('Berhasil', 'Profil Anda telah diperbarui dengan aman.');
  }

  @override
  Widget build(BuildContext context) {
    // We use Consumer to ensure UI updates when provider changes
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(_isEditing ? 'Edit Profil' : 'Profil Saya'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => _isEditing ? setState(() => _isEditing = false) : Navigator.pop(context),
            ),
            actions: [
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit_note_rounded, size: 28),
                  onPressed: () => setState(() {
                    _isEditing = true;
                    // Reset controllers to current user data when starting edit
                    _nameController.text = user?.name ?? '';
                    _emailController.text = user?.email ?? '';
                    _avatarUrlController.text = user?.avatarUrl ?? '';
                  }),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // Avatar Section
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          backgroundImage: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty 
                              ? NetworkImage(user.avatarUrl!) 
                              : null,
                          child: (user?.avatarUrl == null || user!.avatarUrl!.isEmpty) 
                              ? const Icon(Icons.person, size: 60, color: AppColors.primary) 
                              : null,
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (!_isEditing) ...[
                    Text(user?.name ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    Text(user?.email ?? '', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  ],
                  const SizedBox(height: 40),
                  
                  // Input Fields
                  _buildModernInput(
                    controller: _nameController,
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama kamu',
                    icon: Icons.person_outline_rounded,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 20),
                  _buildModernInput(
                    controller: _emailController,
                    label: 'Alamat Email',
                    hint: 'contoh@email.com',
                    icon: Icons.alternate_email_rounded,
                    enabled: _isEditing,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 20),
                    _buildModernInput(
                      controller: _avatarUrlController,
                      label: 'URL Foto Profil (Optional)',
                      hint: 'https://link-foto.com/anda.jpg',
                      icon: Icons.link_rounded,
                      enabled: _isEditing,
                    ),
                  ],
                  
                  const SizedBox(height: 50),
                  
                  // Action Buttons
                  if (_isEditing)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _isEditing = false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Batal', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        const Divider(),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  title: const Text('Keluar Akun', style: TextStyle(fontWeight: FontWeight.bold)),
                                  content: const Text('Apakah Anda yakin ingin mengakhiri sesi petualangan hari ini?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        authProvider.logout();
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                      child: const Text('Ya, Keluar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout_rounded, color: Colors.red),
                            label: const Text('Keluar dari Akun', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool enabled = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: TextStyle(fontWeight: FontWeight.w600, color: enabled ? AppColors.textMain : Colors.grey.shade600),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: enabled ? AppColors.primary : Colors.grey.shade400, size: 20),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF5F0EB).withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: enabled ? BorderSide(color: Colors.grey.shade200) : BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          validator: (value) => (value == null || value.isEmpty) ? 'Harap isi bagian ini' : null,
        ),
      ],
    );
  }
}
