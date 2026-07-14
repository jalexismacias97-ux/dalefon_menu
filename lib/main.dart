import 'package:flutter/material.dart';
import 'widgets/profile_card.dart';
import 'widgets/menu_item_tile.dart';
import 'widgets/custom_switch.dart';
import 'widgets/svg_placeholder.dart';
import 'widgets/postpaid_deactivation_flow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Theme state controlled reactively by the "Modo oscuro" switch
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dalefon Menú',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        iconTheme: const IconThemeData(color: Color(0xFF242424)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF121315),
        iconTheme: const IconThemeData(color: Colors.white),
        useMaterial3: true,
      ),
      home: DalefonMenuScreen(
        onThemeChanged: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class DalefonMenuScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  const DalefonMenuScreen({
    Key? key,
    required this.onThemeChanged,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<DalefonMenuScreen> createState() => _DalefonMenuScreenState();
}

class _DalefonMenuScreenState extends State<DalefonMenuScreen> {
  // State variables for interactive elements
  late bool _biometricsEnabled;
  late bool _darkModeEnabled;
  bool _isPostPaid = false;

  @override
  void initState() {
    super.initState();
    // Initialize states to match mockups:
    // Light mode mockup: Biometrics switch is ON, Dark Mode switch is OFF
    // Dark mode mockup: Both switches are ON
    _biometricsEnabled = true;
    _darkModeEnabled = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant DalefonMenuScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDarkMode != oldWidget.isDarkMode) {
      _darkModeEnabled = widget.isDarkMode;
      // In dark mode mockup, biometrics is ON too
      if (widget.isDarkMode) {
        _biometricsEnabled = true;
      }
    }
  }

  // Action for theme toggle
  void _toggleDarkMode(bool value) {
    widget.onThemeChanged(value);
    setState(() {
      _darkModeEnabled = value;
      if (value) {
        _biometricsEnabled = true;
      } else {
        _biometricsEnabled = true; // Match light mode mockup
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      color: isDark ? const Color(0xFF121315) : const Color(0xFFF5F5F7),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Let the AnimatedContainer background show through
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Spacing top of screen to header
                const SizedBox(height: 30.0),

                // 2. Custom Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SvgPlaceholder(
                      assetName: 'three_dots_icon.svg',
                    ),
                    SvgPlaceholder(
                      assetName: 'close_x_icon.svg',
                    ),
                  ],
                ),

                // 3. Spacing header to Profile Card
                const SizedBox(height: 30.0),

                // 4. User Profile Card
                const ProfileCard(),

                // 5. Spacing Profile Card to MI DALEFON
                const SizedBox(height: 24.0),

                // 6. Section: MI DALEFON
                _buildSectionHeader('MI DALEFON', isDark),
                const SizedBox(height: 12.0),
                _buildSectionCard(
                  isDark: isDark,
                  children: [
                    const MenuItemTile(
                      title: 'Mi eSIM/SIM',
                      iconAsset: 'sim_icon.svg',
                      trailing: SvgPlaceholder(
                        assetName: 'arrow_down_icon.svg',
                      ),
                    ),
                    _buildDivider(isDark),
                    const MenuItemTile(
                      title: 'Datos fiscales',
                      iconAsset: 'fiscal_icon.svg',
                    ),
                    _buildDivider(isDark),
                    const MenuItemTile(
                      title: 'Tarjetas bancarias',
                      iconAsset: 'bank_card_plus_icon.svg',
                    ),
                    _buildDivider(isDark),
                    MenuItemTile(
                      title: _isPostPaid ? 'Convertirme pre-pago' : 'Convertirme post-pago',
                      iconAsset: _isPostPaid ? 'prepaid_icon.svg' : 'postpaid_icon.svg',
                      onTap: () => _showSubscriptionModal(context, !_isPostPaid, isDark),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // 7. Section: RECARGAS
                _buildSectionHeader('RECARGAS', isDark),
                const SizedBox(height: 12.0),
                _buildSectionCard(
                  isDark: isDark,
                  children: [
                    const MenuItemTile(
                      title: 'Domiciliadas',
                      iconAsset: 'history_icon.svg',
                    ),
                    _buildDivider(isDark),
                    const MenuItemTile(
                      title: 'Por transferencia',
                      iconAsset: 'transfer_icon.svg',
                    ),
                    _buildDivider(isDark),
                    const MenuItemTile(
                      title: 'Promociones',
                      iconAsset: 'promo_icon.svg',
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // 8. Section: CONFIGURACIÓN
                _buildSectionHeader('CONFIGURACIÓN', isDark),
                const SizedBox(height: 12.0),
                _buildSectionCard(
                  isDark: isDark,
                  children: [
                    const MenuItemTile(
                      title: 'Notificaciones',
                      iconAsset: 'notification_icon.svg',
                    ),
                    _buildDivider(isDark),
                    MenuItemTile(
                      title: 'Biométricos',
                      iconAsset: 'biometric_icon.svg',
                      trailing: CustomSwitch(
                        value: _biometricsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _biometricsEnabled = value;
                          });
                        },
                      ),
                    ),
                    _buildDivider(isDark),
                    MenuItemTile(
                      title: 'Modo oscuro',
                      iconAsset: 'dark_mode_icon.svg',
                      trailing: CustomSwitch(
                        value: _darkModeEnabled,
                        onChanged: _toggleDarkMode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // 9. Section: Action Card (Eliminar cuenta)
                _buildSectionCard(
                  isDark: isDark,
                  children: [
                    MenuItemTile(
                      title: 'Eliminar cuenta',
                      iconAsset: 'trash_icon.svg',
                      textColor: const Color(0xFFD32F2F),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Acción: Eliminar cuenta'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 34.0),

                // 10. Footer
                Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: isDark ? const Color(0xFF88898B) : const Color(0xFFA7A7A7),
                    ),
                    child: const Text('© 2026 Dalefon'),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSubscriptionModal(BuildContext context, bool targetPostPaid, bool isDark) {
    if (!targetPostPaid) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return PostpaidDeactivationFlow(
            isDark: isDark,
            onDeactivated: () {
              setState(() {
                _isPostPaid = false;
              });
            },
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 320.0,
                padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 20.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                      blurRadius: 24.0,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 56.0,
                        height: 56.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6226A6).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.swap_horizontal_circle_outlined,
                          color: Color(0xFF6226A6),
                          size: 28.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Convertirse a Post-pago',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFFEFFFF) : const Color(0xFF13171A),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Aquí se definirá el mensaje explicativo y las condiciones para convertirse en Post-pago (renta mensual de línea).',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.0,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF5A5165),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _isPostPaid = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6226A6),
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 13.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Convertirme a Post-pago',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: isDark ? const Color(0xFF8E8E93) : const Color(0xFF5A5165),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF5A5165).withOpacity(0.7),
                    size: 20.0,
                  ),
                  splashRadius: 20.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Section Header widget (MI DALEFON, RECARGAS, CONFIGURACIÓN)
  Widget _buildSectionHeader(String title, bool isDark) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 11.0,
        fontWeight: FontWeight.w600,
        color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF9F9EA3),
        letterSpacing: 1.0,
      ),
      child: Text(title),
    );
  }

  // Divider builder to create clean stateless lines for the menu lists
  Widget _buildDivider(bool isDark) {
    final targetColor = isDark ? const Color(0xFF333436) : const Color(0xFFF2F2F7);
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: targetColor),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, animatedColor, child) {
        return Divider(
          height: 1.0,
          thickness: 0.5,
          indent: 0.0,
          endIndent: 0.0,
          color: animatedColor ?? targetColor,
        );
      },
    );
  }

  // Card container holding item list
  Widget _buildSectionCard({
    required List<Widget> children,
    required bool isDark,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242527) : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

