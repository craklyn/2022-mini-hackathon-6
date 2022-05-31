import 'package:demo_another_brother_prime/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class IsPrintingDialog extends ConsumerStatefulWidget {
  const IsPrintingDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<IsPrintingDialog> createState() => _IsPrintingDialogState();
}

class _IsPrintingDialogState extends ConsumerState<IsPrintingDialog> {
  @override
  void initState() {
    ref.read(screenProvider).addListener(() {
      if (!ref.read(screenProvider).isPrinting) {
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    ref.read(screenProvider).removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 256,
      height: 470,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            Lottie.asset('assets/animations/printing.json',
                width: 200, height: 325),
            Material(
              color: Theme.of(context).primaryColor,
              child: const Text(
                'Printing invoice...',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ));
  }
}
