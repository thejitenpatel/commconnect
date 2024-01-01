import 'package:commconnect/src/common_widgets/custom_button.dart';
import 'package:commconnect/src/common_widgets/custom_dropdown_field.dart';
import 'package:commconnect/src/common_widgets/custom_textfield.dart';
import 'package:commconnect/src/common_widgets/scrollable_column.dart';
import 'package:commconnect/src/config/theme/app_colors.dart';
import 'package:commconnect/src/config/theme/app_typography.dart';
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
    final cPasswordController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');
    final mobileNumberController = useTextEditingController(text: '');
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

          /// Mobile Number
          Insets.gapH12,
          CustomTextField(
            controller: mobileNumberController,
            labelText: 'Mobile number',
            hintText: 'Enter your mobile number',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            maxLength: 10,
            validator: FormValidator.contactValidator,
            prefix: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Insets.gapW4,
                Text(
                  '  +91',
                  style: AppTypography.primary.body14,
                ),
                Container(
                  width: 1.2,
                  height: 18,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: AppColors.greyColor,
                ),
              ],
            ),
          ),

          /// Password
          Insets.gapH12,
          CustomTextField(
            controller: passwordController,
            labelText: 'Enter your password',
            hintText: 'Type your password',
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            validator: FormValidator.passwordValidator,
          ),

          /// Confirm Password
          Insets.gapH12,
          CustomTextField(
            controller: cPasswordController,
            labelText: 'Confirm your password',
            hintText: 'Retype your password',
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            validator: (confirmPw) => FormValidator.confirmPasswordValidator(
              confirmPw,
              passwordController.text,
            ),
          ),

          /// Save button
          Insets.gapH20,
          CustomButton(
            child: Text(
              "NEXT",
              style: AppTypography.primary.body16.copyWith(color: Colors.white),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
