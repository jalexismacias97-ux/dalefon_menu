import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that loads actual SVG icons using flutter_svg.
/// It maps the internal SVG asset filenames to the real SVG files added by the user.
class SvgPlaceholder extends StatelessWidget {
  final String assetName;
  final Color? color;
  final double? size;

  const SvgPlaceholder({
    Key? key,
    required this.assetName,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Default color is #FFFFFF in dark mode, and #5A5165 in light mode
    final defaultColor = color ?? (isDark ? Colors.white : const Color(0xFF5A5165));

    String? localPath;
    double? width;
    double? height;

    switch (assetName) {
      case 'three_dots_icon.svg':
        localPath = 'assets/images/puntos.svg';
        width = 14.0;
        height = 12.4;
        break;
      case 'close_x_icon.svg':
        localPath = 'assets/images/equis.svg';
        width = 11.0;
        height = 11.0;
        break;
      case 'edit_icon.svg':
        localPath = 'assets/images/editar.svg';
        width = 14.0;
        height = 14.0;
        break;
      case 'sim_icon.svg':
        localPath = 'assets/images/esim/esim_sim.svg';
        width = 15.0;
        height = 15.0;
        break;
      case 'fiscal_icon.svg':
        localPath = 'assets/images/datos_fiscales.svg';
        width = 11.0;
        height = 13.5;
        break;
      case 'bank_card_plus_icon.svg':
        localPath = 'assets/images/tarjetas_bancarias.svg';
        width = 17.0;
        height = 13.2;
        break;
      case 'history_icon.svg':
        localPath = 'assets/images/domiciliadas.svg';
        width = 15.0;
        height = 15.0;
        break;
      case 'transfer_icon.svg':
        localPath = 'assets/images/por_transferencia.svg';
        width = 17.5;
        height = 15.5;
        break;
      case 'promo_icon.svg':
        localPath = 'assets/images/promociones.svg';
        width = 17.0;
        height = 17.0;
        break;
      case 'notification_icon.svg':
        localPath = 'assets/images/notificaciones.svg';
        width = 15.0;
        height = 14.0;
        break;
      case 'biometric_icon.svg':
        localPath = 'assets/images/biometricos.svg';
        width = 15.0;
        height = 15.0;
        break;
      case 'dark_mode_icon.svg':
        localPath = 'assets/images/modo oscuro.svg';
        width = 15.5;
        height = 15.1;
        break;
      case 'trash_icon.svg':
        localPath = 'assets/images/eliminar_cuenta.svg';
        width = 14.0;
        height = 14.2;
        break;
      case 'arrow_down_icon.svg':
        localPath = 'assets/images/flecha_abajo.svg';
        width = 9.0;
        height = 5.1;
        break;
      case 'postpaid_icon.svg':
        localPath = 'assets/images/post-pago.svg';
        width = 13.5;
        height = 11.8;
        break;
      case 'prepaid_icon.svg':
        localPath = 'assets/images/pre-apgo.svg';
        width = 15.0;
        height = 15.0;
        break;
    }

    final finalWidth = size ?? width ?? 15.0;
    final finalHeight = size ?? height ?? 15.0;

    if (localPath != null) {
      return TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: defaultColor),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, colorValue, child) {
          final targetColor = colorValue ?? defaultColor;
          return SvgPicture.asset(
            localPath!,
            width: finalWidth,
            height: finalHeight,
            colorFilter: ColorFilter.mode(targetColor, BlendMode.srcIn),
          );
        },
      );
    }

    // Fallbacks for any missing SVGs
    switch (assetName) {
      default:
        return Icon(
          Icons.help_outline,
          color: defaultColor,
          size: finalWidth,
        );
    }
  }
}

