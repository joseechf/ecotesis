import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';

class Nosotros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar:
          media.width < 600 ? AppBar() : AppBar(title: Text('nosotros !!!')),
      drawer:
          media.width < 600
              ? Drawer(child: customAppBar(context: context))
              : null,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('greeting'.tr(), style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Alterna entre inglés y español
                final newLocale =
                    context.locale == const Locale('en')
                        ? const Locale('es')
                        : const Locale('en');
                context.setLocale(newLocale);
              },
              child: Text('change_language'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
