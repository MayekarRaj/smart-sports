import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InviteReferralDialog extends StatefulWidget {
  const InviteReferralDialog({super.key});

  @override
  State<InviteReferralDialog> createState() => _InviteReferralDialogState();
}

class _InviteReferralDialogState extends State<InviteReferralDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(
    text: 'admin@xyz.com , admin@xyz.com , admin@xyz.com',
  );
  final _messageController = TextEditingController(
    text: 'Hello, Invitee name, company name, City and Country is inviting you to subscribe to Smart Planner application. This application is useful to ... promotion message. Add Sign Up URL. Thank you and we are looking forward to your subscription. Sincerely, Director, SEKAI-ICHI Engg........ Yokohama, JAPAN.',
  );

  bool _isLoading = false;
  String _selectedParagraph = 'paragraph';
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;
  TextAlign _textAlign = TextAlign.left;
  bool _isBulletList = false;
  bool _isNumberedList = false;
  bool _isBlockquote = false;

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendInvite() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral invitation sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _pickFile() async {
    // File picker implementation would go here
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File picker functionality would be implemented here'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                padding: const EdgeInsets.all(16),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Center(
                        child: Text(
                          'Invite Referrals',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '(Generates an email list by entering multiple email addresses separated by a comma in a single input field)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Section
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter email addresses separated by commas',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF009A69),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF3B82F6),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter at least one email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Invite Message Section
                      const Text(
                        'Invite Message',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Rich Text Editor Toolbar
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          color: const Color(0xFFF9FAFB),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Paragraph dropdown
                            DropdownButton<String>(
                              value: _selectedParagraph,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(
                                  value: 'paragraph',
                                  child: Text('paragraph'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedParagraph = value!);
                              },
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            // Formatting buttons
                            _buildToolbarButton(
                              icon: Icons.format_bold,
                              isActive: _isBold,
                              onTap: () => setState(() => _isBold = !_isBold),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_italic,
                              isActive: _isItalic,
                              onTap: () => setState(() => _isItalic = !_isItalic),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_underlined,
                              isActive: _isUnderline,
                              onTap: () => setState(() => _isUnderline = !_isUnderline),
                            ),
                            _buildToolbarButton(
                              icon: Icons.strikethrough_s,
                              isActive: _isStrikethrough,
                              onTap: () => setState(() => _isStrikethrough = !_isStrikethrough),
                            ),
                            const SizedBox(width: 8),
                            // Alignment buttons
                            _buildToolbarButton(
                              icon: Icons.format_align_left,
                              isActive: _textAlign == TextAlign.left,
                              onTap: () => setState(() => _textAlign = TextAlign.left),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_align_center,
                              isActive: _textAlign == TextAlign.center,
                              onTap: () => setState(() => _textAlign = TextAlign.center),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_align_right,
                              isActive: _textAlign == TextAlign.right,
                              onTap: () => setState(() => _textAlign = TextAlign.right),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_align_justify,
                              isActive: _textAlign == TextAlign.justify,
                              onTap: () => setState(() => _textAlign = TextAlign.justify),
                            ),
                            const SizedBox(width: 8),
                            // List buttons
                            _buildToolbarButton(
                              icon: Icons.format_list_bulleted,
                              isActive: _isBulletList,
                              onTap: () => setState(() => _isBulletList = !_isBulletList),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_list_numbered,
                              isActive: _isNumberedList,
                              onTap: () => setState(() => _isNumberedList = !_isNumberedList),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_quote,
                              isActive: _isBlockquote,
                              onTap: () => setState(() => _isBlockquote = !_isBlockquote),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_indent_increase,
                              isActive: false,
                              onTap: () {},
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_indent_decrease,
                              isActive: false,
                              onTap: () {},
                            ),
                          ],
                          ),
                        ),
                      ),
                      // Rich Text Editor Content
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey[300]!),
                            right: BorderSide(color: Colors.grey[300]!),
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: TextFormField(
                          controller: _messageController,
                          maxLines: 8,
                          textAlign: _textAlign,
                          decoration: InputDecoration(
                            hintText: 'Enter your invitation message...',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                            fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                            decoration: TextDecoration.combine([
                              if (_isUnderline) TextDecoration.underline,
                              if (_isStrikethrough) TextDecoration.lineThrough,
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Attachment Section
                      const Text(
                        'Attachment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _pickFile,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.attach_file, color: Colors.grey[400]),
                              const SizedBox(width: 12),
                              Text(
                                'select images or pdf',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '[Required file size is less than 6 MB]',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[600],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // SEND INVITE Button
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4B5563),
                                Color(0xFF009A69),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _sendInvite,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'SEND INVITE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF009A69) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
