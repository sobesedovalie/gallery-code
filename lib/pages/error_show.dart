import 'package:flutter/material.dart';
import '../components/circular_progress_indicator/circular_progress_indicator.dart';

// страница для отображения ошибки
class ErrorShowPage extends StatefulWidget {
  final String error;
  final Future<void> Function() onRefresh;
  const ErrorShowPage({
    super.key,
    required this.error,
    required this.onRefresh,
  });

  @override
  State<ErrorShowPage> createState() => _ErrorShowPageState();
}

class _ErrorShowPageState extends State<ErrorShowPage> {
  bool isButtClick = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.error),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                if (mounted) {
                  setState(() {
                    isButtClick = true;
                  });
                }
                await widget.onRefresh();
                if (mounted) {
                  setState(() {
                    isButtClick = false;
                  });
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                overlayColor: WidgetStateProperty.all<Color>(
                  Colors.grey,
                ),
                fixedSize: WidgetStateProperty.all<Size>(const Size(127, 20)),
              ),
              child: isButtClick == true
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: circularProgressIndicatorWidget(
                        background: Colors.transparent,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Обновить',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
