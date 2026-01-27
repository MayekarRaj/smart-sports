import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'club_registration_page.dart';
import 'corporate_registration_page.dart';
import 'merchandise_registration_page.dart';
import 'coach_registration_page.dart';
import 'member_registration_page.dart';
import 'freelancer_registration_page.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/registration_constants.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _gridAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Header animation
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Grid animation
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Start animations
    _headerAnimationController.forward();
    _gridAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _gridAnimationController.dispose();
    super.dispose();
  }

  void _navigateToRoleForm(BuildContext context, String role) async {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Add slight delay for better UX
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    // Save registration state
    await StorageService().saveString(
      RegistrationConstants.KEY_REGISTRATION_STEP,
      RegistrationConstants.STEP_ROLE_SELECTED,
    );
    await StorageService().saveString(
      RegistrationConstants.KEY_TEMP_ROLE,
      role,
    );

    switch (role) {
      case 'club':
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ClubRegistrationPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        ),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 'corporate':
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const CorporateRegistrationPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        ),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 'merchandise':
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MerchandiseRegistrationPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        ),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 'coach':
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const CoachRegistrationPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        ),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 'member':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MemberRegistrationPage(),
          ),
        );
        break;
      case 'freelancer':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FreelancerRegistrationPage(),
          ),
        );
        break;
      default:
        // For other roles, show coming soon dialog
        HapticFeedback.mediumImpact();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  '${role.toUpperCase()} Registration',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            content: const Text(
              'This role registration is coming soon! We\'re working hard to bring you the best experience.',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('OK', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to calculate dynamic aspect ratio
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate aspect ratio: (width / 2 - padding) / desired_height
    // Increasing desired_height makes the ratio smaller
    final double cardWidth =
        (screenWidth - 40 - 16) / 2; // horizontal padding (20*2) + spacing (16)
    const double cardHeight = 190.0; // Increased height to prevent overflow
    final double aspectRatio = cardWidth / cardHeight;

    final roles = [
      _RoleData(
        icon: Icons.business_center,
        title: 'Club',
        description: 'Sports club owner or manager',
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        role: 'club',
        // badge: 'Popular',
      ),
      _RoleData(
        icon: Icons.sports_soccer,
        title: 'Coach',
        description: 'Professional sports coach',
        gradient: const LinearGradient(
          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        role: 'coach',
      ),
      _RoleData(
        icon: Icons.corporate_fare,
        title: 'Corporate',
        description: 'Corporate sports program',
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9500), Color(0xFFFF5722)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        role: 'corporate',
      ),
      _RoleData(
        icon: Icons.shopping_bag,
        title: 'Merchandise',
        description: 'Sports merchandise seller',
        gradient: const LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        role: 'merchandise',
      ),
      _RoleData(
        icon: Icons.person,
        title: 'Member',
        description: 'Sports club member',
        gradient: const LinearGradient(
          colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        role: 'member',
      ),
      _RoleData(
        icon: Icons.work_outline,
        title: 'Freelancer',
        description: 'Independent sports professional',
        gradient: const LinearGradient(
          colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        role: 'freelancer',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            // SliverAppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   floating: true,
            //   leading: Padding(
            //     padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(12),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.08),
            //             blurRadius: 10,
            //             offset: const Offset(0, 2),
            //           ),
            //         ],
            //       ),
            //       child: IconButton(
            //         icon: const Icon(
            //           Icons.arrow_back,
            //           color: Color(0xFF1E293B),
            //         ),
            //         onPressed: () {
            //           HapticFeedback.lightImpact();
            //           Navigator.pop(context);
            //         },
            //         tooltip: 'Back',
            //         iconSize: 20,
            //         padding: EdgeInsets.zero,
            //       ),
            //     ),
            //   ),
            // ),

            // Header Section
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _headerFadeAnimation,
                child: SlideTransition(
                  position: _headerSlideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        // Moved Title here for cleaner layout
                        const Text(
                          'Select Your Role',
                          style: TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF667EEA).withOpacity(0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.verified_user,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Join\n Universal Sport Connect (USC)',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Choose your role and access features\ndesigned specifically for you',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.95),
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Grid Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: aspectRatio,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final role = roles[index];
                  return AnimatedBuilder(
                    animation: _gridAnimationController,
                    builder: (context, child) {
                      final delay = index * 0.1;
                      final animationValue = Curves.easeOutCubic.transform(
                        (_gridAnimationController.value - delay).clamp(
                          0.0,
                          1.0,
                        ),
                      );

                      return Opacity(
                        opacity: animationValue,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - animationValue)),
                          child: _RoleCard(
                            icon: role.icon,
                            title: role.title,
                            description: role.description,
                            gradient: role.gradient,
                            badge: role.badge,
                            onTap: () =>
                                _navigateToRoleForm(context, role.role),
                            animationDelay: Duration(milliseconds: index * 100),
                          ),
                        ),
                      );
                    },
                  );
                }, childCount: roles.length),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _RoleData {
  final IconData icon;
  final String title;
  final String description;
  final LinearGradient gradient;
  final String role;
  final String? badge;

  _RoleData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.role,
    this.badge,
  });
}

class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final LinearGradient gradient;
  final String? badge;
  final VoidCallback onTap;
  final Duration animationDelay;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    this.badge,
    required this.onTap,
    this.animationDelay = Duration.zero,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            elevation: 4, // Increased elevation for better visibility
            shadowColor: Colors.black.withOpacity(0.1),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTapDown: (_) {
                if (mounted) {
                  HapticFeedback.selectionClick();
                  _controller.forward();
                }
              },
              onTapUp: (_) {
                if (mounted) {
                  _controller.reverse();
                }
              },
              onTapCancel: () {
                if (mounted) {
                  _controller.reverse();
                }
              },
              onTap: () {
                if (mounted) {
                  widget.onTap();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Container
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: widget.gradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradient.colors.first.withOpacity(
                              0.3,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(widget.icon, size: 28, color: Colors.white),
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      // Removed Flexible to allow natural sizing
                      widget.description,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Colors.blueGrey[600], // Darker text for readability
                        fontWeight: FontWeight.w500,
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
