import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

class SelectStyle extends OnboardingEvent {
  final String style;
  const SelectStyle(this.style);
  @override
  List<Object?> get props => [style];
}

class SelectAesthetic extends OnboardingEvent {
  final String aesthetic;
  const SelectAesthetic(this.aesthetic);
  @override
  List<Object?> get props => [aesthetic];
}

class SelectBudget extends OnboardingEvent {
  final String budget;
  const SelectBudget(this.budget);
  @override
  List<Object?> get props => [budget];
}

class NextStep extends OnboardingEvent {}

// State
class OnboardingState extends Equatable {
  final int currentStep;
  final String? selectedStyle;
  final String? selectedAesthetic;
  final String? selectedBudget;
  final bool isComplete;

  const OnboardingState({
    this.currentStep = 0,
    this.selectedStyle,
    this.selectedAesthetic,
    this.selectedBudget,
    this.isComplete = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    String? selectedStyle,
    String? selectedAesthetic,
    String? selectedBudget,
    bool? isComplete,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      selectedAesthetic: selectedAesthetic ?? this.selectedAesthetic,
      selectedBudget: selectedBudget ?? this.selectedBudget,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [currentStep, selectedStyle, selectedAesthetic, selectedBudget, isComplete];
}

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<SelectStyle>((event, emit) {
      emit(state.copyWith(selectedStyle: event.style, currentStep: 1));
    });

    on<SelectAesthetic>((event, emit) {
      emit(state.copyWith(selectedAesthetic: event.aesthetic, currentStep: 2));
    });

    on<SelectBudget>((event, emit) {
      emit(state.copyWith(selectedBudget: event.budget, isComplete: true));
    });
    
    on<NextStep>((event, emit) {
      if (state.currentStep < 2) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      } else {
        emit(state.copyWith(isComplete: true));
      }
    });
  }
}
