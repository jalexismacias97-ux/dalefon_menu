import 'package:flutter/material.dart';

enum DeactivationStep {
  selector,
  debtBlocked,
  confirmCancel,
  generalError,
  success,
  actionError,
}

class PostpaidDeactivationFlow extends StatefulWidget {
  final bool isDark;
  final VoidCallback onDeactivated;

  const PostpaidDeactivationFlow({
    Key? key,
    required this.isDark,
    required this.onDeactivated,
  }) : super(key: key);

  @override
  State<PostpaidDeactivationFlow> createState() => _PostpaidDeactivationFlowState();
}

class _PostpaidDeactivationFlowState extends State<PostpaidDeactivationFlow> {
  DeactivationStep _currentStep = DeactivationStep.selector;
  bool _isLoading = false;
  bool _simulateSuccess = true; // Sub-toggle to test success vs error outputs

  void _transitionTo(DeactivationStep step) {
    setState(() {
      _currentStep = step;
    });
  }

  void _simulateProcessing(VoidCallback onDone) {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        onDone();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = widget.isDark ? const Color(0xFFFEFFFF) : const Color(0xFF13171A);
    final subtitleColor = widget.isDark ? const Color(0xFF8E8E93) : const Color(0xFF5A5165);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 320.0,
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(widget.isDark ? 0.4 : 0.08),
                  blurRadius: 24.0,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: _isLoading
                    ? _buildLoadingState(titleColor)
                    : _buildStepContent(titleColor, subtitleColor),
              ),
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close_rounded,
                color: widget.isDark ? const Color(0xFF8E8E93) : const Color(0xFF5A5165).withOpacity(0.7),
                size: 20.0,
              ),
              splashRadius: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(Color titleColor) {
    return Padding(
      key: const ValueKey('loading'),
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF6226A6),
            strokeWidth: 3.0,
          ),
          const SizedBox(height: 24.0),
          Text(
            'Procesando solicitud...',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(Color titleColor, Color subtitleColor) {
    switch (_currentStep) {
      case DeactivationStep.selector:
        return _buildSelectorStep(titleColor, subtitleColor);
      case DeactivationStep.debtBlocked:
        return _buildDebtBlockedStep(titleColor, subtitleColor);
      case DeactivationStep.confirmCancel:
        return _buildConfirmCancelStep(titleColor, subtitleColor);
      case DeactivationStep.generalError:
        return _buildGeneralErrorStep(titleColor, subtitleColor);
      case DeactivationStep.success:
        return _buildSuccessStep(titleColor, subtitleColor);
      case DeactivationStep.actionError:
        return _buildActionErrorStep(titleColor, subtitleColor);
    }
  }

  // STEP 1: Simulation Selector
  Widget _buildSelectorStep(Color titleColor, Color subtitleColor) {
    return Padding(
      key: const ValueKey('selector'),
      padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Simulador',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            'Selecciona un escenario de prueba:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.0,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 16.0),
          
          _buildSimulationOption(
            label: 'Con Adeudo (Bloqueo)',
            icon: Icons.money_off,
            onTap: () => _transitionTo(DeactivationStep.debtBlocked),
          ),
          const SizedBox(height: 8.0),
          
          _buildSimulationOption(
            label: 'Sin Adeudo (Confirmación)',
            icon: Icons.check_circle_outline,
            onTap: () => _transitionTo(DeactivationStep.confirmCancel),
          ),
          const SizedBox(height: 8.0),
          
          _buildSimulationOption(
            label: 'Error General de Entrada',
            icon: Icons.error_outline,
            onTap: () => _transitionTo(DeactivationStep.generalError),
          ),
          const SizedBox(height: 16.0),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resultado esperado:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _simulateSuccess = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: _simulateSuccess ? const Color(0xFF6226A6) : Colors.transparent,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: _simulateSuccess ? Colors.transparent : subtitleColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Éxito',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: _simulateSuccess ? Colors.white : subtitleColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () => setState(() => _simulateSuccess = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: !_simulateSuccess ? const Color(0xFFE25C5C) : Colors.transparent,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: !_simulateSuccess ? Colors.transparent : subtitleColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Error',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: !_simulateSuccess ? Colors.white : subtitleColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationOption({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 11.0),
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF2C2D30) : const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: widget.isDark ? const Color(0xFF333436) : const Color(0xFFE5E5EA),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6226A6), size: 18.0),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: widget.isDark ? Colors.white : const Color(0xFF13171A),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: widget.isDark ? Colors.white54 : Colors.black45,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  // STEP 2: Debt Blocked Screen
  Widget _buildDebtBlockedStep(Color titleColor, Color subtitleColor) {
    return Padding(
      key: const ValueKey('debtBlocked'),
      padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9500).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF9500), size: 28.0),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'No es posible cambiar a pre-pago',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'No es posible pasar a pre-pago debido a que hay un adeudo en tu cuenta actual.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.0,
              height: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.isDark ? Colors.white : const Color(0xFF13171A),
                    side: BorderSide(
                      color: widget.isDark ? Colors.white24 : Colors.black12,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Salir',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _simulateProcessing(() {
                      if (_simulateSuccess) {
                        widget.onDeactivated();
                        _transitionTo(DeactivationStep.success);
                      } else {
                        _transitionTo(DeactivationStep.actionError);
                      }
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
                    'Pagar adeudo',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // STEP 3: Confirm Cancel Screen
  Widget _buildConfirmCancelStep(Color titleColor, Color subtitleColor) {
    return Padding(
      key: const ValueKey('confirmCancel'),
      padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 20.0),
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
              child: const Icon(Icons.swap_horizontal_circle_outlined, color: Color(0xFF6226A6), size: 28.0),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Confirmar cambio a pre-pago',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            '¿Estás seguro que deseas cambiar tu línea a pre-pago? Esta acción cancelará tu renta mensual.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.0,
              height: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.isDark ? Colors.white : const Color(0xFF13171A),
                    side: BorderSide(
                      color: widget.isDark ? Colors.white24 : Colors.black12,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _simulateProcessing(() {
                      if (_simulateSuccess) {
                        widget.onDeactivated();
                        _transitionTo(DeactivationStep.success);
                      } else {
                        _transitionTo(DeactivationStep.actionError);
                      }
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
                    'Confirmar',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // STEP 4: General Processing Error Screen
  Widget _buildGeneralErrorStep(Color titleColor, Color subtitleColor) {
    return Padding(
      key: const ValueKey('generalError'),
      padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: const Color(0xFFE25C5C).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, color: Color(0xFFE25C5C), size: 28.0),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Error al procesar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Lo sentimos, tenemos problemas para procesar tu solicitud en este momento.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.0,
              height: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
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
              'Cerrar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 5: Success Screen
  Widget _buildSuccessStep(Color titleColor, Color subtitleColor) {
    return Padding(
      key: const ValueKey('success'),
      padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: const Color(0xFF34C759).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF34C759), size: 28.0),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            '¡Operación exitosa!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Tu línea ahora es prepago, puedes volver a activar el post-pago cuando lo desees.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.0,
              height: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
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
              'Entendido',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 6: Action Error Screen
  Widget _buildActionErrorStep(Color titleColor, Color subtitleColor) {
    return Padding(
      key: const ValueKey('actionError'),
      padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: const Color(0xFFE25C5C).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, color: Color(0xFFE25C5C), size: 28.0),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'No se pudo completar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Tuvimos problemas al procesar tu solicitud, espera unos momentos o comunícate a nuestro Centro de Atención Telefónica.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.0,
              height: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
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
              'Entendido',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
