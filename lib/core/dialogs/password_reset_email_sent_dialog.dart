import 'package:flutter/material.dart';
import 'package:hiracosmetics/core/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Password reset",
    content: "A password reset link has been sent to your email.",
    optionsBuilder: () => {
      "OK": null,
    },
  );
}