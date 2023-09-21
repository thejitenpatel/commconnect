import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

class StepperForm extends ConsumerWidget {
  StepperForm({super.key});

  final List<Step> steps = [
    Step(
      title: const Text("Step 1"),
      isActive: true,
      content: TextFormField(
        decoration: const InputDecoration(labelText: 'Field 1'),
      ),
    ),
    Step(
      title: const Text("Step 1"),
      content: TextFormField(
        decoration: const InputDecoration(labelText: 'Field 1'),
      ),
    ),
    Step(
      title: const Text("Step 1"),
      content: TextFormField(
        decoration: const InputDecoration(labelText: 'Field 1'),
      ),
    ),
    Step(
      title: const Text("Step 1"),
      content: TextFormField(
        decoration: const InputDecoration(labelText: 'Field 1'),
      ),
    ),
    Step(
      title: const Text("Step 1"),
      content: TextFormField(
        decoration: const InputDecoration(labelText: 'Field 1'),
      ),
    ),
    Step(
      title: const Text("Step 1"),
      content: TextFormField(
        decoration: const InputDecoration(labelText: 'Field 1'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(stepIndexProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Stepper(
            steps: steps,
            type: StepperType.horizontal,
            currentStep: currentStep,
          );
          return null;
        },
      ),
    );
  }
}
