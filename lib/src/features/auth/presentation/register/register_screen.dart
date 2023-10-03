import 'package:commconnect/src/common_widgets/custom_textfield.dart';
import 'package:commconnect/src/common_widgets/scrollable_column.dart';
import 'package:commconnect/src/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../config/theme/app_styles.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: const ScrollableColumn(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          /// First Name
          CustomTextField(
            autofocus: false,
            labelText: 'First Name',
            hintText: 'Enter your First Name',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: FormValidator.nameValidator,
          ),

          /// Middle Name
          Insets.gapH12,
          CustomTextField(
            autofocus: false,
            labelText: 'Middle Name',
            hintText: 'Enter your Middle Name',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: FormValidator.nameValidator,
          ),

          /// Surname Name
          Insets.gapH12,
          // CustomDropdownField<String>.animated(
          //   onSelected: (value) {},
          //   enableSearch: true,
          //   // controller: surnameController,
          //   hintText: "Surname",
          //   items: {
          //     for (var surname in Constants.surnameList) surname: surname
          //   },
          // ),
        ],
      ),
    );
  }
}
