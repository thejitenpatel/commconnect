import 'package:commconnect/src/config/theme/app_colors.dart';
import 'package:commconnect/src/config/theme/app_typography.dart';
import 'package:flutter/material.dart';

import '../config/constants.dart';

enum CustomStepState {
  inProgress,
  completed,
}

enum CustomStepperType {
  horizontal,
  vertical,
}

@immutable
class ControlsDetails {
  /// Index that is active for the surrounding [CustomStepper] widget. This may be
  /// different from [stepIndex] if the user has just changed steps and we are
  /// currently animating toward that step.
  final int currentStep;

  /// Index of the step for which these controls are being built. This is
  /// not necessarily the active index, if the user has just changed steps and
  /// this step is animating away. To determine whether a given builder is building
  /// the active step or the step being navigated away from, see [isActive].
  final int stepIndex;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final VoidCallback? onStepContinue;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final VoidCallback? onStepCancel;

  /// True if the indicated step is also the current active step. If the user has
  /// just activated the transition to a new step, some [CustomStepper.type] values will
  /// lead to both steps being rendered for the duration of the animation shifting
  /// between steps.
  bool get isActive => currentStep == stepIndex;

  const ControlsDetails({
    required this.currentStep,
    required this.stepIndex,
    this.onStepContinue,
    this.onStepCancel,
  });
}

///  * [WidgetBuilder], which is similar but only takes a [BuildContext].
typedef ControlsWidgetBuilder = Widget Function(
  BuildContext context,
  ControlsDetails details,
);

@immutable
class CustomStep {
  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
  final Widget content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final CustomStepState state;

  /// Whether or not the step is active. The flag only influences styling.
  final bool isActive;

  /// Only [CustomStepperType.horizontal], Optional widget that appears under the [title].
  /// By default, uses the `bodyLarge` theme.
  final Widget? name;

  final String title;
  final String subtitle;

  /// Creates a step for a [CustomStepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  const CustomStep({
    required this.content,
    this.state = CustomStepState.inProgress,
    this.isActive = false,
    this.name,
    this.title = "",
    this.subtitle = "",
  });
}

class CustomStepper extends StatefulWidget {
  const CustomStepper({
    super.key,
    required this.steps,
    this.physics,
    this.type = CustomStepperType.horizontal,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
    this.margin,
  }) : assert(0 <= currentStep && currentStep < steps.length);

  final List<CustomStep> steps;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// The type of stepper that determines the layout. In the case of
  /// [CustomStepperType.horizontal], the content of the current step is displayed
  /// underneath as opposed to the [CustomStepperType.vertical] case where it is
  /// displayed in-between.
  final CustomStepperType type;

  /// The index into [steps] of the current step whose content is displayed.
  final int currentStep;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final ValueChanged<int>? onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final VoidCallback? onStepContinue;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final VoidCallback? onStepCancel;

  final ControlsWidgetBuilder? controlsBuilder;

  /// custom margin on vertical stepper.
  final EdgeInsetsGeometry? margin;

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper>
    with TickerProviderStateMixin {
  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  Widget _buildIcon(int index) {
    final CustomStepState state = widget.steps[index].state;
    switch (state) {
      case CustomStepState.inProgress:
        return const Icon(
          Icons.panorama_fish_eye,
          color: AppColors.successColor,
          size: Constants.kSize18,
        );
      case CustomStepState.completed:
        return const Icon(
          Icons.check_circle,
          color: AppColors.successColor,
          size: Constants.kSize18,
        );
    }
  }

  TextStyle _nameTextStyle(int index) {
    switch (widget.steps[index].state) {
      case CustomStepState.inProgress:
        return AppTypography.primary.label12;
      case CustomStepState.completed:
        return AppTypography.primary.label11;
    }
  }

  Widget _buildNameText(int index) {
    if (widget.steps[index].name != null) {
      return AnimatedDefaultTextStyle(
        style: _nameTextStyle(index),
        duration: kThemeAnimationDuration,
        child: widget.steps[index].name!,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildIcon(i),
                if (!_isLast(i))
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    height: Constants.kSize2,
                    width: Constants.kSize80,
                    color: widget.steps[i].state == CustomStepState.completed
                        ? AppColors.successColor
                        : AppColors.greyColor,
                  ),
              ],
            ),
            const SizedBox(
              height: Constants.kSize10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Constants.kSize58,
                  height: Constants.kSize28,
                  child: _buildNameText(i),
                )
              ],
            )
          ],
        )
      ],
    ];

    final List<Widget> contentWidgetList = <Widget>[];
    for (int i = 0; i < widget.steps.length; i += 1) {
      contentWidgetList.add(
        Visibility(
          maintainState: true,
          visible: i == widget.currentStep,
          child: widget.steps[i].content,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          color: AppColors.whiteColor,
          elevation: 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: AppColors.whiteColor,
              height: Constants.kSize76,
              padding: const EdgeInsets.fromLTRB(
                  Constants.kSize20, Constants.kSize20, 0, 0),
              child: Row(
                children: children,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Constants.kSize20,
            Constants.kSize10,
            Constants.kSize20,
            0,
          ),
          child: Text(
            widget.steps[widget.currentStep].title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: Constants.kSize12,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Constants.kPadding20,
            Constants.kPadding16,
            Constants.kPadding20,
            Constants.kPadding16,
          ),
          child: Text(
            widget.steps[widget.currentStep].subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                ),
          ),
        ),
        Expanded(
          child: ListView(
            physics: widget.physics,
            padding: const EdgeInsets.fromLTRB(
                Constants.kSize20, 0, Constants.kSize20, Constants.kSize20),
            children: <Widget>[
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: kThemeAnimationDuration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: contentWidgetList,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHorizontal();
  }
}
