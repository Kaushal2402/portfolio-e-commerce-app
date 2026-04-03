import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Voice Event
abstract class VoiceEvent extends Equatable {
  const VoiceEvent();
  @override
  List<Object?> get props => [];
}

class StartListening extends VoiceEvent {}
class StopListening extends VoiceEvent {}

// Voice State
abstract class VoiceState extends Equatable {
  const VoiceState();
  @override
  List<Object?> get props => [];
}

class VoiceInitial extends VoiceState {}
class VoiceListening extends VoiceState {
  final String text;
  const VoiceListening({required this.text});
  @override
  List<Object?> get props => [text];
}
class VoiceSuccess extends VoiceState {
  final String result;
  const VoiceSuccess({required this.result});
  @override
  List<Object?> get props => [result];
}
class VoiceError extends VoiceState {
  final String message;
  const VoiceError({required this.message});
  @override
  List<Object?> get props => [message];
}

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  VoiceBloc() : super(VoiceInitial()) {
    on<StartListening>((event, emit) async {
      bool available = await _speech.initialize();
      if (available) {
        emit(const VoiceListening(text: "Listening..."));
        _speech.listen(onResult: (val) {
           // This logic will be handled better with a controller or stream
        });
      } else {
        emit(const VoiceError(message: "Speech recognition unavailable"));
      }
    });

    on<StopListening>((event, emit) async {
      _speech.stop();
      emit(VoiceInitial());
    });
  }
}
