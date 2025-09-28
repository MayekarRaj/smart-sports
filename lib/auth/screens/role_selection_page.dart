import 'package:flutter/material.dart';
import 'club_registration_page.dart';
import 'corporate_registration_page.dart';
import 'merchandise_registration_page.dart';
import 'coach_registration_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Select Your Role',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Text(
                      '🚀 Join Our Community',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Choose your role and unlock amazing features tailored just for you',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _RoleCard(
                      icon: Icons.business,
                      title: 'Club',
                      description: 'Sports club owner or manager',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToRoleForm(context, 'club'),
                    ),
                    _RoleCard(
                      icon: Icons.sports,
                      title: 'Coach',
                      description: 'Professional sports coach',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToRoleForm(context, 'coach'),
                    ),
                    _RoleCard(
                      icon: Icons.corporate_fare,
                      title: 'Corporate',
                      description: 'Corporate sports program',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9500), Color(0xFFFF5722)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToRoleForm(context, 'corporate'),
                    ),
                    _RoleCard(
                      icon: Icons.shopping_bag,
                      title: 'Merchandise',
                      description: 'Sports merchandise seller',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToRoleForm(context, 'merchandise'),
                    ),
                    _RoleCard(
                      icon: Icons.person,
                      title: 'Member',
                      description: 'Sports club member',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToRoleForm(context, 'member'),
                    ),
                    _RoleCard(
                      icon: Icons.work,
                      title: 'Freelancer',
                      description: 'Independent sports professional',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToRoleForm(context, 'freelancer'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRoleForm(BuildContext context, String role) {
    switch (role) {
      case 'club':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClubRegistrationPage()),
        );
        break;
      case 'corporate':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CorporateRegistrationPage(),
          ),
        );
        break;
      case 'merchandise':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MerchandiseRegistrationPage(),
          ),
        );
        break;
      case 'coach':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CoachRegistrationPage(),
          ),
        );
        break;
      default:
        // For other roles, show coming soon dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('${role.toUpperCase()} Registration'),
            content: const Text('This role registration is coming soon!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
    }
  }
}

class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _animationController.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _animationController.reverse();
              widget.onTap();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.colors.first.withOpacity(0.3),
                    blurRadius: _isPressed ? 8 : 15,
                    offset: const Offset(0, 5),
                    spreadRadius: _isPressed ? -2 : 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: widget.gradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradient.colors.first.withOpacity(
                              0.4,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(widget.icon, size: 28, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
