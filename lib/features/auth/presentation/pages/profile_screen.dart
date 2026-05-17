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
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.updateProfile(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _avatarUrlController.text.trim().isEmpty ? null : _avatarUrlController.text.trim(),
    );

    setState(() => _isEditing = false);
    if (!mounted) return;
    _showAlert('Berhasil', 'Profil Anda telah diperbarui.');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                    child: user?.avatarUrl == null ? const Icon(Icons.person, size: 60, color: AppColors.primary) : null,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 18,
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              _buildInfoTile(controller: _nameController, label: 'Nama Lengkap', icon: Icons.person_outline, enabled: _isEditing),
              const SizedBox(height: 20),
              _buildInfoTile(controller: _emailController, label: 'Alamat Email', icon: Icons.email_outlined, enabled: _isEditing, keyboardType: TextInputType.emailAddress),
              if (_isEditing) ...[
                const SizedBox(height: 20),
                _buildInfoTile(controller: _avatarUrlController, label: 'URL Foto Profil (Optional)', icon: Icons.link, enabled: _isEditing),
              ],
              const SizedBox(height: 40),
              if (_isEditing)
                Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: () => setState(() => _isEditing = false), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text('Batal'))),
                    const SizedBox(width: 15),
                    Expanded(child: ElevatedButton(onPressed: _handleSave, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text('Simpan'))),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                            TextButton(onPressed: () { Navigator.pop(context); Provider.of<AuthProvider>(context, listen: false).logout(); Navigator.pop(context); }, child: const Text('Keluar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Keluar Akun', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({required TextEditingController controller, required String label, required IconData icon, bool enabled = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFFBF9F8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: enabled ? BorderSide(color: Colors.grey.shade300) : BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          validator: (value) => (value == null || value.isEmpty) ? 'Field ini tidak boleh kosong' : null,
        ),
      ],
    );
  }
}
