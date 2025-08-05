import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/chat/data.dart';
import 'package:mental_health_app/ui/base/base_event.dart';

import '../../../use_case/therapist_chat_add/therapist_chat_add_use_case.dart';
import '../../../use_case/therapist_chat_init/therapist_chat_init_use_case.dart';

part 'therapist_chat_event.dart';
part 'therapist_chat_state.dart';

@Injectable()
class TherapistChatBloc extends Bloc<TherapistChatEvent, TherapistChatState> {
  TherapistChatBloc(this._therapistInitUseCase, this._therapistAddUseCase) : super(TherapistChatState(isLoading: true, chats: [])) {
    on<TherapistChatInit>(_onInit);
    on<TherapistChatChangeText>(_changeText);
    on<TherapistChatSendMessage>(_onSendMessage);
    on<TherapistChatSelectChat>(_selectChat);
  }

  final ITherapistChatInitUseCase _therapistInitUseCase;
  final ITherapistChatAddUseCase _therapistAddUseCase;

  Future _onInit(TherapistChatInit event, Emitter<TherapistChatState> emit) async {
    try {
      await emit.forEach(
        _therapistInitUseCase.invoke(),
        onData: (data) {
          return state.copyWith(
            chats: data.chats,
            currentChat: data.chats.firstOrNull,
            isLoading: data.isLoading,
            error: data.error.toString(),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _changeText(TherapistChatChangeText event, Emitter<TherapistChatState> emit) {
    emit(state.copyWith(text: event.text));
  }

  void _selectChat(TherapistChatSelectChat event, Emitter<TherapistChatState> emit) {
    emit(state.copyWith(currentChat: event.chat, text: null, isNewChat: event.chat == null));
  }

  Future<void> _onSendMessage(TherapistChatSendMessage event, Emitter<TherapistChatState> emit) async {
    try {
      if (state.text == null || state.text!.isEmpty) {
        emit(state.copyWith(error: "Message cannot be empty", isLoading: false));
        return;
      }
      await emit.forEach(
        _therapistAddUseCase.invoke(message: state.text!, chatId: state.currentChat?.chatId, isNewChat: state.currentChat == null),
        onData: (data) {
          return state.copyWith(
            isLoading: data.isLoading,
            error: data.error.toString(),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
