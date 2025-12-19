import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rider_pay_driver/core/res/constant/const_pop_up.dart' show ConstPopUp;
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/constant/const_text_btn.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';


class ExitPopup {
  static Future<bool> show(BuildContext context, AppLocalizations tr) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return ConstPopUp(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          borderRadius: 12.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade700,
                size: 40,
              ),
              const SizedBox(height: 15),
              ConstText(
                text: tr.exit_app_title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              const SizedBox(height: 10),
              ConstText(
                text: tr.exit_app_message,
                fontSize: 14,
                textAlign: TextAlign.center,
                color: Theme.of(context).hintColor,
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ConstTextBtn(
                      text: tr.cancel,
                      onTap: () => Navigator.of(context).pop(false),
                      textColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ConstTextBtn(
                      text: tr.ok_exit_button,
                      onTap: () => Navigator.of(context).pop(true),
                      textColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ) ?? false;
  }

  // For direct exit
  static Future<void> exitApp(BuildContext context, AppLocalizations tr) async {
    bool shouldExit = await show(context, tr);
    if (shouldExit) SystemNavigator.pop();
  }
}
