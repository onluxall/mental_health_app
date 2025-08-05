import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/data/chat/data.dart';
import 'package:mental_health_app/get_it_conf.dart';
import 'package:mental_health_app/ui/therapist_chat/therapist_chat_bloc/therapist_chat_bloc.dart';

class TherapistChatScreen extends StatelessWidget {
  const TherapistChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<TherapistChatBloc>()..add(TherapistChatInit()),
      child: BlocBuilder<TherapistChatBloc, TherapistChatState>(builder: (context, state) {
        print(state.currentChat);
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.add_comment_outlined,
                    size: 24,
                  ),
                  onTap: () => context.read<TherapistChatBloc>()..add(TherapistChatSelectChat(chat: null)),
                ),
                Text(state.currentChat?.title ?? "Chat"),
                GestureDetector(
                    child: Icon(
                      Icons.reorder,
                      size: 24,
                    ),
                    onTapDown: (details) {
                      final offset = details.globalPosition;
                      showMenu(
                          context: context,
                          items: [
                            ...state.chats.map((chat) {
                              return PopupMenuItem<ChatHistory>(
                                value: chat,
                                onTap: () => context.read<TherapistChatBloc>()..add(TherapistChatSelectChat(chat: chat)),
                                child: Text(chat.title ?? ""),
                              );
                            })
                          ],
                          position: RelativeRect.fromLTRB(
                            offset.dx,
                            offset.dy,
                            MediaQuery.of(context).size.width - offset.dx,
                            MediaQuery.of(context).size.height - offset.dy,
                          ));
                    })
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: state.currentChat?.messages?.length ?? 0,
                    itemBuilder: (context, index) {
                      final message = state.currentChat?.messages?[index];
                      return ListTile(
                        title: Align(
                          alignment: message?.sender == ChatMessageType.user ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color:
                                    message?.sender == ChatMessageType.user ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                                borderRadius: message?.sender == ChatMessageType.user
                                    ? const BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                                    : const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                            child: Text(message?.content ?? '',
                                style: message?.sender == ChatMessageType.user
                                    ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                        )
                                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.white,
                                        )),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32, top: 16.0, left: 16.0, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (text) {
                            context.read<TherapistChatBloc>().add(TherapistChatChangeText(text: text));
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            hintText: 'Write your message',
                            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      state.isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: state.text?.isNotEmpty ?? false
                                    ? () {
                                        context.read<TherapistChatBloc>().add(TherapistChatSendMessage());
                                      }
                                    : null,
                                child: Icon(
                                  Icons.send,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
