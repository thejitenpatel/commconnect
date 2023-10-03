import 'package:flutter/material.dart';

// TODO(dragostis): Missing functionality:
//   * mobile horizontal mode with adding/removing steps
//   * alternative labeling
//   * stepper feedback in the case of high-latency interactions

/// The state of a [CustomStep] which is used to control the style of the circle and
/// text.
///
/// See also:
///
///  * [CustomStep]
enum CustomStepState {
  /// A step that displays its index in its circle.
  indexed,

  /// A step that displays a pencil icon in its circle.
  editing,

  /// A step that displays a tick icon in its circle.
  complete,

  /// A step that is disabled and does not to react to taps.
  disabled,

  /// A step that is currently having an error. e.g. the user has submitted wrong
  /// input.
  error,
}

/// Defines the [CustomStepper]'s main axis.
enum CustomStepperType {
  /// A vertical layout of the steps with their content in-between the titles.
  vertical,

  /// A horizontal layout of the steps with their content below the titles.
  horizontal,
}

/// Container for all the information necessary to build a Stepper widget's
/// forward and backward controls for any given step.
///
/// Used by [CustomStepper.controlsBuilder].
@immutable
class CustomControlsDetails {
  /// Creates a set of details describing the Stepper.
  const CustomControlsDetails({
    required this.currentStep,
    required this.stepIndex,
    this.onStepCancel,
    this.onStepContinue,
  });

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
}

/// A builder that creates a widget given the two callbacks `onStepContinue` and
/// `onStepCancel`.
///
/// Used by [CustomStepper.controlsBuilder].
///
/// See also:
///
///  * [WidgetBuilder], which is similar but only takes a [BuildContext].
typedef ControlsWidgetBuilder = Widget Function(
    BuildContext context, CustomControlsDetails details);

/// A builder that creates the icon widget for the [CustomStep] at [stepIndex], given
/// [stepState].
typedef StepIconBuilder = Widget? Function(
    int stepIndex, CustomStepState stepState);

const TextStyle _kStepStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 24.0;
const double _kTriangleHeight =
    _kStepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0

/// A material step used in [CustomStepper]. The step can have a title and subtitle,
/// an icon within its circle, some content and a state that governs its
/// styling.
///
/// See also:
///
///  * [CustomStepper]
///  * <https://material.io/archive/guidelines/components/steppers.html>
@immutable
class CustomStep {
  /// Creates a step for a [CustomStepper].
  const CustomStep({
    required this.title,
    this.subtitle,
    required this.content,
    this.state = CustomStepState.indexed,
    this.isActive = false,
    this.label,
  });

  /// The title of the step that typically describes it.
  final Widget title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
  final Widget? subtitle;

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
  final Widget? label;
}

/// A material stepper widget that displays progress through a sequence of
/// steps. Steppers are particularly useful in the case of forms where one step
/// requires the completion of another one, or where multiple steps need to be
/// completed in order to submit the whole form.
///
/// The widget is a flexible wrapper. A parent class should pass [currentStep]
/// to this widget based on some logic triggered by the three callbacks that it
/// provides.
///
/// {@tool dartpad}
/// An example the shows how to use the [CustomStepper], and the [CustomStepper] UI
/// appearance.
///
/// ** See code in examples/api/lib/material/stepper/stepper.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CustomStep]
///  * <https://material.io/archive/guidelines/components/steppers.html>
class CustomStepper extends StatefulWidget {
  /// Creates a stepper from a list of steps.
  ///
  /// This widget is not meant to be rebuilt with a different list of steps
  /// unless a key is provided in order to distinguish the old stepper from the
  /// new one.
  const CustomStepper({
    super.key,
    required this.steps,
    this.controller,
    this.physics,
    this.type = CustomStepperType.vertical,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
    this.elevation,
    this.margin,
    this.connectorColor,
    this.connectorThickness,
    this.stepIconBuilder,
  }) : assert(0 <= currentStep && currentStep < steps.length);

  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// The length of [steps] must not change.
  final List<CustomStep> steps;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// To control the initial scroll offset of the scroll view, provide a
  /// [controller] with its [ScrollController.initialScrollOffset] property set.
  final ScrollController? controller;

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

  /// The callback for creating custom controls.
  ///
  /// If null, the default controls from the current theme will be used.
  ///
  /// This callback which takes in a context and a [CustomControlsDetails] object, which
  /// contains step information and two functions: [onStepContinue] and [onStepCancel].
  /// These can be used to control the stepper. For example, reading the
  /// [CustomControlsDetails.currentStep] value within the callback can change the text
  /// of the continue or cancel button depending on which step users are at.
  ///
  /// {@tool dartpad}
  /// Creates a stepper control with custom buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Stepper(
  ///     controlsBuilder:
  ///       (BuildContext context, ControlsDetails details) {
  ///          return Row(
  ///            children: <Widget>[
  ///              TextButton(
  ///                onPressed: details.onStepContinue,
  ///                child: Text('Continue to Step ${details.stepIndex + 1}'),
  ///              ),
  ///              TextButton(
  ///                onPressed: details.onStepCancel,
  ///                child: Text('Back to Step ${details.stepIndex - 1}'),
  ///              ),
  ///            ],
  ///          );
  ///       },
  ///     steps: const <Step>[
  ///       Step(
  ///         title: Text('A'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///       Step(
  ///         title: Text('B'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  /// ** See code in examples/api/lib/material/stepper/stepper.controls_builder.0.dart **
  /// {@end-tool}
  final ControlsWidgetBuilder? controlsBuilder;

  /// The elevation of this stepper's [Material] when [type] is [CustomStepperType.horizontal].
  final double? elevation;

  /// Custom margin on vertical stepper.
  final EdgeInsetsGeometry? margin;

  /// Customize connected lines colors.
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.disabled].
  ///
  /// If not set then the widget will use default colors, primary for selected state
  /// and grey.shade400 for disabled state.
  final MaterialStateProperty<Color>? connectorColor;

  /// The thickness of the connecting lines.
  final double? connectorThickness;

  /// Callback for creating custom icons for the [steps].
  ///
  /// When overriding icon for [CustomStepState.error], please return
  /// a widget whose width and height are 14 pixels or less to avoid overflow.
  ///
  /// If null, the default icons will be used for respective [CustomStepState].
  final StepIconBuilder? stepIconBuilder;

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper>
    with TickerProviderStateMixin {
  late List<GlobalKey> _keys;
  final Map<int, CustomStepState> _oldStates = <int, CustomStepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );

    for (int i = 0; i < widget.steps.length; i += 1) {
      _oldStates[i] = widget.steps[i].state;
    }
  }

  @override
  void didUpdateWidget(CustomStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (int i = 0; i < oldWidget.steps.length; i += 1) {
      _oldStates[i] = oldWidget.steps[i].state;
    }
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  bool _isCurrent(int index) {
    return widget.currentStep == index;
  }

  bool _isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  bool _isLabel() {
    for (final CustomStep step in widget.steps) {
      if (step.label != null) {
        return true;
      }
    }
    return false;
  }

  Color _connectorColor(bool isActive) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Set<MaterialState> states = <MaterialState>{
      if (isActive) MaterialState.selected else MaterialState.disabled,
    };
    final Color? resolvedConnectorColor =
        widget.connectorColor?.resolve(states);
    if (resolvedConnectorColor != null) {
      return resolvedConnectorColor;
    }
    return isActive ? colorScheme.primary : Colors.grey.shade400;
  }

  Widget _buildLine(bool visible, bool isActive) {
    return Container(
      width: visible ? widget.connectorThickness ?? 1.0 : 0.0,
      height: 16.0,
      color: _connectorColor(isActive),
    );
  }

  Widget _buildCircleChild(int index, bool oldState) {
    final CustomStepState state =
        oldState ? _oldStates[index]! : widget.steps[index].state;
    final bool isDarkActive = _isDark() && widget.steps[index].isActive;
    final Widget? icon = widget.stepIconBuilder?.call(index, state);
    if (icon != null) {
      return icon;
    }
    switch (state) {
      case CustomStepState.indexed:
      case CustomStepState.disabled:
        return Text(
          '${index + 1}',
          style: isDarkActive
              ? _kStepStyle.copyWith(color: Colors.black87)
              : _kStepStyle,
        );
      case CustomStepState.editing:
        return Icon(
          Icons.edit,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case CustomStepState.complete:
        return Icon(
          Icons.check,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case CustomStepState.error:
        return const Text('!', style: _kStepStyle);
    }
  }

  Color _circleColor(int index) {
    final bool isActive = widget.steps[index].isActive;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Set<MaterialState> states = <MaterialState>{
      if (isActive) MaterialState.selected else MaterialState.disabled,
    };
    final Color? resolvedConnectorColor =
        widget.connectorColor?.resolve(states);
    if (resolvedConnectorColor != null) {
      return resolvedConnectorColor;
    }
    if (!_isDark()) {
      return isActive
          ? colorScheme.primary
          : colorScheme.onSurface.withOpacity(0.38);
    } else {
      return isActive ? colorScheme.secondary : colorScheme.background;
    }
  }

  Widget _buildCircle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: _circleColor(index),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _buildCircleChild(index,
              oldState && widget.steps[index].state == CustomStepState.error),
        ),
      ),
    );
  }

  Widget _buildTriangle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: Center(
        child: SizedBox(
          width: _kStepSize,
          height:
              _kTriangleHeight, // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(
              color: _isDark() ? _kErrorDark : _kErrorLight,
            ),
            child: Align(
              alignment: const Alignment(
                  0.0, 0.8), // 0.8 looks better than the geometrical 0.33.
              child: _buildCircleChild(
                  index,
                  oldState &&
                      widget.steps[index].state != CustomStepState.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.steps[index].state == CustomStepState.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != CustomStepState.error) {
        return _buildCircle(index, false);
      } else {
        return _buildTriangle(index, false);
      }
    }
  }

  Widget _buildVerticalControls(int stepIndex) {
    if (widget.controlsBuilder != null) {
      return widget.controlsBuilder!(
        context,
        CustomControlsDetails(
          currentStep: widget.currentStep,
          onStepContinue: widget.onStepContinue,
          onStepCancel: widget.onStepCancel,
          stepIndex: stepIndex,
        ),
      );
    }

    final Color cancelColor;
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        cancelColor = Colors.black54;
      case Brightness.dark:
        cancelColor = Colors.white70;
    }

    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    const OutlinedBorder buttonShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)));
    const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 48.0),
        child: Row(
          // The Material spec no longer includes a Stepper widget. The continue
          // and cancel button styles have been configured to match the original
          // version of this widget.
          children: <Widget>[
            TextButton(
              onPressed: widget.onStepContinue,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : (_isDark()
                          ? colorScheme.onSurface
                          : colorScheme.onPrimary);
                }),
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return _isDark() || states.contains(MaterialState.disabled)
                      ? null
                      : colorScheme.primary;
                }),
                padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    buttonPadding),
                shape:
                    const MaterialStatePropertyAll<OutlinedBorder>(buttonShape),
              ),
              child: Text(themeData.useMaterial3
                  ? localizations.continueButtonLabel
                  : localizations.continueButtonLabel.toUpperCase()),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 8.0),
              child: TextButton(
                onPressed: widget.onStepCancel,
                style: TextButton.styleFrom(
                  foregroundColor: cancelColor,
                  padding: buttonPadding,
                  shape: buttonShape,
                ),
                child: Text(themeData.useMaterial3
                    ? localizations.cancelButtonLabel
                    : localizations.cancelButtonLabel.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case CustomStepState.indexed:
      case CustomStepState.editing:
      case CustomStepState.complete:
        return textTheme.bodyLarge!;
      case CustomStepState.disabled:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case CustomStepState.error:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  TextStyle _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case CustomStepState.indexed:
      case CustomStepState.editing:
      case CustomStepState.complete:
        return textTheme.bodySmall!;
      case CustomStepState.disabled:
        return textTheme.bodySmall!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case CustomStepState.error:
        return textTheme.bodySmall!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  TextStyle _labelStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case CustomStepState.indexed:
      case CustomStepState.editing:
      case CustomStepState.complete:
        return textTheme.bodyLarge!;
      case CustomStepState.disabled:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case CustomStepState.error:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: _titleStyle(index),
          duration: kThemeAnimationDuration,
          curve: Curves.fastOutSlowIn,
          child: widget.steps[index].title,
        ),
        if (widget.steps[index].subtitle != null)
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: AnimatedDefaultTextStyle(
              style: _subtitleStyle(index),
              duration: kThemeAnimationDuration,
              curve: Curves.fastOutSlowIn,
              child: widget.steps[index].subtitle!,
            ),
          ),
      ],
    );
  }

  Widget _buildLabelText(int index) {
    if (widget.steps[index].label != null) {
      return AnimatedDefaultTextStyle(
        style: _labelStyle(index),
        duration: kThemeAnimationDuration,
        child: widget.steps[index].label!,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildVerticalHeader(int index) {
    final bool isActive = widget.steps[index].isActive;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Line parts are always added in order for the ink splash to
              // flood the tips of the connector lines.
              _buildLine(!_isFirst(index), isActive),
              _buildIcon(index),
              _buildLine(!_isLast(index), isActive),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsetsDirectional.only(start: 12.0),
              child: _buildHeaderText(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 24.0,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: 24.0,
            child: Center(
              child: SizedBox(
                width: widget.connectorThickness ?? 1.0,
                child: Container(
                  color: _connectorColor(widget.steps[index].isActive),
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(height: 0.0),
          secondChild: Container(
            margin: widget.margin ??
                const EdgeInsetsDirectional.only(
                  start: 60.0,
                  end: 24.0,
                  bottom: 24.0,
                ),
            child: Column(
              children: <Widget>[
                widget.steps[index].content,
                _buildVerticalControls(index),
              ],
            ),
          ),
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: _isCurrent(index)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
      ],
    );
  }

  Widget _buildVertical() {
    return ListView(
      controller: widget.controller,
      shrinkWrap: true,
      physics: widget.physics,
      children: <Widget>[
        for (int i = 0; i < widget.steps.length; i += 1)
          Column(
            key: _keys[i],
            children: <Widget>[
              InkWell(
                onTap: widget.steps[i].state != CustomStepState.disabled
                    ? () {
                        // In the vertical case we need to scroll to the newly tapped
                        // step.
                        Scrollable.ensureVisible(
                          _keys[i].currentContext!,
                          curve: Curves.fastOutSlowIn,
                          duration: kThemeAnimationDuration,
                        );

                        widget.onStepTapped?.call(i);
                      }
                    : null,
                canRequestFocus:
                    widget.steps[i].state != CustomStepState.disabled,
                child: _buildVerticalHeader(i),
              ),
              _buildVerticalBody(i),
            ],
          ),
      ],
    );
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          onTap: widget.steps[i].state != CustomStepState.disabled
              ? () {
                  widget.onStepTapped?.call(i);
                }
              : null,
          canRequestFocus: widget.steps[i].state != CustomStepState.disabled,
          child: Row(
            children: <Widget>[
              SizedBox(
                height: _isLabel() ? 104.0 : 72.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (widget.steps[i].label != null)
                      const SizedBox(
                        height: 24.0,
                      ),
                    Center(child: _buildIcon(i)),
                    if (widget.steps[i].label != null)
                      SizedBox(
                        height: 24.0,
                        child: _buildLabelText(i),
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(start: 12.0),
                child: _buildHeaderText(i),
              ),
            ],
          ),
        ),
        if (!_isLast(i))
          Container(
            key: Key('line$i'),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            height: widget.connectorThickness ?? 1.0,
            color: _connectorColor(widget.steps[i + 1].isActive),
          ),
      ],
    ];

    final List<Widget> stepPanels = <Widget>[];
    for (int i = 0; i < widget.steps.length; i += 1) {
      stepPanels.add(
        Visibility(
          maintainState: true,
          visible: i == widget.currentStep,
          child: widget.steps[i].content,
        ),
      );
    }

    return Column(
      children: <Widget>[
        Material(
          elevation: widget.elevation ?? 2,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: children,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            controller: widget.controller,
            physics: widget.physics,
            padding: const EdgeInsets.all(24.0),
            children: <Widget>[
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: kThemeAnimationDuration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: stepPanels,
                ),
              ),
              _buildVerticalControls(widget.currentStep),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<CustomStepper>() != null) {
        throw FlutterError(
          'Steppers must not be nested.\n'
          'The material specification advises that one should avoid embedding '
          'steppers within steppers. '
          'https://material.io/archive/guidelines/components/steppers.html#steppers-usage',
        );
      }
      return true;
    }());
    switch (widget.type) {
      case CustomStepperType.vertical:
        return _buildVertical();
      case CustomStepperType.horizontal:
        return _buildHorizontal();
    }
  }
}

// Paints a triangle whose base is the bottom of the bounding rectangle and its
// top vertex the middle of its top.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({
    required this.color,
  });

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(
      Path()..addPolygon(points, true),
      Paint()..color = color,
    );
  }
}

// import "package:commconnect/src/config/theme/app_colors.dart";
// import "package:commconnect/src/config/theme/app_typography.dart";
// import "package:flutter/material.dart";

// import "../config/constants.dart";

// enum CustomStepState {
//   inProgress,
//   completed,
//   disabled,
// }

// enum CustomStepperType {
//   horizontal,
//   vertical,
// }

// @immutable
// class ControlsDetails {
//   /// Creates a set of details describing the CustomStepper.
//   const ControlsDetails({
//     required this.currentStep,
//     required this.stepIndex,
//     this.onStepCancel,
//     this.onStepContinue,
//   });

//   /// Index that is active for the surrounding [CustomStepper] widget. This may be
//   /// different from [stepIndex] if the user has just changed steps and we are
//   /// currently animating toward that step.
//   final int currentStep;

//   /// Index of the step for which these controls are being built. This is
//   /// not necessarily the active index, if the user has just changed steps and
//   /// this step is animating away. To determine whether a given builder is building
//   /// the active step or the step being navigated away from, see [isActive].
//   final int stepIndex;

//   /// The callback called when the 'continue' button is tapped.
//   ///
//   /// If null, the 'continue' button will be disabled.
//   final VoidCallback? onStepContinue;

//   /// The callback called when the 'cancel' button is tapped.
//   ///
//   /// If null, the 'cancel' button will be disabled.
//   final VoidCallback? onStepCancel;

//   /// True if the indicated step is also the current active step. If the user has
//   /// just activated the transition to a new step, some [CustomStepper.type] values will
//   /// lead to both steps being rendered for the duration of the animation shifting
//   /// between steps.
//   bool get isActive => currentStep == stepIndex;
// }

// ///  * [WidgetBuilder], which is similar but only takes a [BuildContext].
// typedef ControlsWidgetBuilder = Widget Function(
//   BuildContext context,
//   ControlsDetails details,
// );

// @immutable
// class CustomStep {
//   /// Creates a step for a [CustomStepper].
//   ///
//   /// The [title], [content], and [state] arguments must not be null.
//   const CustomStep({
//     required this.content,
//     this.state = CustomStepState.inProgress,
//     this.isActive = false,
//     this.name,
//     this.title = "",
//     this.subtitle = "",
//   });

//   /// The content of the step that appears below the [title] and [subtitle].
//   ///
//   /// Below the content, every step has a 'continue' and 'cancel' button.
//   final Widget content;

//   /// The state of the step which determines the styling of its components
//   /// and whether steps are interactive.
//   final CustomStepState state;

//   /// Whether or not the step is active. The flag only influences styling.
//   final bool isActive;

//   /// Only [CustomStepperType.horizontal], Optional widget that appears under the [title].
//   /// By default, uses the `bodyLarge` theme.
//   final Widget? name;

//   final String title;
//   final String subtitle;
// }

// class CustomStepper extends StatefulWidget {
//   const CustomStepper({
//     super.key,
//     required this.steps,
//     this.physics,
//     this.type = CustomStepperType.horizontal,
//     this.currentStep = 0,
//     this.onStepTapped,
//     this.onStepContinue,
//     this.onStepCancel,
//     this.controlsBuilder,
//     this.margin,
//   }) : assert(0 <= currentStep && currentStep < steps.length);

//   final List<CustomStep> steps;

//   /// How the stepper's scroll view should respond to user input.
//   ///
//   /// For example, determines how the scroll view continues to
//   /// animate after the user stops dragging the scroll view.
//   ///
//   /// If the stepper is contained within another scrollable it
//   /// can be helpful to set this property to [ClampingScrollPhysics].
//   final ScrollPhysics? physics;

//   /// The type of stepper that determines the layout. In the case of
//   /// [CustomStepperType.horizontal], the content of the current step is displayed
//   /// underneath as opposed to the [CustomStepperType.vertical] case where it is
//   /// displayed in-between.
//   final CustomStepperType type;

//   /// The index into [steps] of the current step whose content is displayed.
//   final int currentStep;

//   /// The callback called when a step is tapped, with its index passed as
//   /// an argument.
//   final ValueChanged<int>? onStepTapped;

//   /// The callback called when the 'continue' button is tapped.
//   ///
//   /// If null, the 'continue' button will be disabled.
//   final VoidCallback? onStepContinue;

//   /// The callback called when the 'cancel' button is tapped.
//   ///
//   /// If null, the 'cancel' button will be disabled.
//   final VoidCallback? onStepCancel;

//   final ControlsWidgetBuilder? controlsBuilder;

//   /// custom margin on vertical stepper.
//   final EdgeInsetsGeometry? margin;

//   @override
//   State<CustomStepper> createState() => _CustomStepperState();
// }

// class _CustomStepperState extends State<CustomStepper>
//     with TickerProviderStateMixin {
//   bool _isLast(int index) {
//     return widget.steps.length - 1 == index;
//   }

//   Widget _buildIcon(int index) {
//     final CustomStepState state = widget.steps[index].state;
//     switch (state) {
//       case CustomStepState.disabled:
//         return const Icon(
//           Icons.panorama_fish_eye,
//           color: AppColors.greyColor,
//           size: Constants.kSize18,
//         );
//       case CustomStepState.inProgress:
//         return Icon(
//           Icons.panorama_fish_eye,
//           color: AppColors.successColor,
//           shadows: <Shadow>[
//             Shadow(
//               color: AppColors.barrierColor.withOpacity(0.5),
//               blurRadius: 4,
//               offset: const Offset(0, 0),
//             )
//           ],
//           size: Constants.kSize18,
//         );
//       case CustomStepState.completed:
//         return const Icon(
//           Icons.check_circle,
//           color: AppColors.successColor,
//           size: Constants.kSize18,
//         );
//     }
//   }

//   TextStyle _nameTextStyle(int index) {
//     switch (widget.steps[index].state) {
//       case CustomStepState.inProgress:
//         return AppTypography.primary.label12;
//       case CustomStepState.completed:
//         return AppTypography.primary.label12;
//       case CustomStepState.disabled:
//         return AppTypography.primary.label11;
//     }
//   }

//   Widget _buildNameText(int index) {
//     if (widget.steps[index].name != null) {
//       return AnimatedDefaultTextStyle(
//         style: _nameTextStyle(index),
//         duration: kThemeAnimationDuration,
//         child: widget.steps[index].name!,
//       );
//     }
//     return const SizedBox.shrink();
//   }

//   Widget _buildHorizontal() {
//     final List<Widget> children = <Widget>[
//       for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 _buildIcon(i),
//                 if (!_isLast(i))
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 0),
//                     height: Constants.kSize2,
//                     width: Constants.kSize80,
//                     color: widget.steps[i].state == CustomStepState.completed
//                         ? AppColors.successColor
//                         : AppColors.greyColor,
//                   ),
//               ],
//             ),
//             const SizedBox(
//               height: Constants.kSize10,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: Constants.kSize58,
//                   height: Constants.kSize28,
//                   child: _buildNameText(i),
//                 )
//               ],
//             )
//           ],
//         )
//       ],
//     ];

//     final List<Widget> contentWidgetList = <Widget>[];
//     for (int i = 0; i < widget.steps.length; i += 1) {
//       contentWidgetList.add(
//         Visibility(
//           maintainState: true,
//           visible: i == widget.currentStep,
//           child: widget.steps[i].content,
//         ),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Material(
//           color: AppColors.whiteColor,
//           elevation: 0,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Container(
//               color: AppColors.whiteColor,
//               height: Constants.kSize76,
//               padding: const EdgeInsets.fromLTRB(
//                   Constants.kSize20, Constants.kSize20, 0, 0),
//               child: Row(
//                 children: children,
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(
//               Constants.kSize20, Constants.kSize10, Constants.kSize20, 0),
//           child: Text(
//             widget.steps[widget.currentStep].title,
//             style: Theme.of(context).textTheme.displayMedium?.copyWith(
//                   fontSize: Constants.kSize12,
//                 ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(
//             Constants.kPadding20,
//             Constants.kPadding16,
//             Constants.kPadding20,
//             Constants.kPadding16,
//           ),
//           child: Text(
//             widget.steps[widget.currentStep].subtitle,
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   fontSize: 10,
//                 ),
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             physics: widget.physics,
//             padding: const EdgeInsets.fromLTRB(
//                 Constants.kSize20, 0, Constants.kSize20, Constants.kSize20),
//             children: <Widget>[
//               AnimatedSize(
//                 curve: Curves.fastOutSlowIn,
//                 duration: kThemeAnimationDuration,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: contentWidgetList,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildHorizontal();
//   }
// }
