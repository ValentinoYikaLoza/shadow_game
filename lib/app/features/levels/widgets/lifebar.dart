import 'package:flutter/material.dart';

class Lifebar extends StatefulWidget {
  final double totalHearts;
  final double fullHearts;
  const Lifebar({
    super.key,
    required this.totalHearts,
    required this.fullHearts,
  });

  @override
  State<Lifebar> createState() => _LifebarState();
}

class _LifebarState extends State<Lifebar> {

  @override
  void didUpdateWidget(Lifebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Verificar si los valores han cambiado
    if (widget.totalHearts != oldWidget.totalHearts || 
        widget.fullHearts != oldWidget.fullHearts) {
      // Forzar una reconstrucción del widget
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.5,
      width: 22.5 * widget.totalHearts,
      child: Stack(
        children: List.generate(widget.totalHearts.toInt(), (index) {
          double offset = index * 22.5;

          Widget heart = (index < widget.fullHearts)
              ? SizedBox(
                  width: 19.5,
                  child: Image.asset(
                    'assets/icons/life.png',
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox(
                  width: 19.5,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      'assets/icons/life.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                );

          return Positioned(
            left: offset,
            child: heart,
          );
        }),
      ),
    );
  }
}