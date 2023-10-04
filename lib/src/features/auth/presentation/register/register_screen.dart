import 'package:commconnect/src/common_widgets/custom_button.dart';
import 'package:commconnect/src/common_widgets/custom_dropdown_field.dart';
import 'package:commconnect/src/common_widgets/custom_textfield.dart';
import 'package:commconnect/src/common_widgets/scrollable_column.dart';
import 'package:commconnect/src/features/auth/data/register_repository.dart';
import 'package:commconnect/src/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../config/theme/app_styles.dart';
import '../../../../helpers/constants.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  void saveDetails({
    required WidgetRef ref,
    required firstName,
    required middleName,
    required surname,
  }) {
    final registerRepo = ref.watch(registerRepositoryProvider);
    registerRepo.saveRegistrationDetails(
      firstName: firstName,
      middleName: middleName,
      surname: surname,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstNameController = useTextEditingController();
    final middleNameController = useTextEditingController();
    final surnameController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Register"),
      ),
      body: ScrollableColumn(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Insets.gapH12,

          /// First Name
          CustomTextField(
            controller: firstNameController,
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
            controller: middleNameController,
            autofocus: false,
            labelText: 'Middle Name',
            hintText: 'Enter your Middle Name',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: FormValidator.nameValidator,
          ),

          /// Surname Name
          Insets.gapH12,
          CustomDropdownField<String>.animated(
            onSelected: (value) {},
            enableSearch: true,
            controller: surnameController,
            hintText: "Surname",
            items: {
              for (var surname in Constants.surnameList) surname: surname
            },
          ),

          /// Save button
          Insets.gapH12,
          CustomButton(
            child: const Text("Save"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
