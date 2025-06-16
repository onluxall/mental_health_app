import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/emotion/interface.dart';
import 'package:mental_health_app/data/journal/data.dart';
import 'package:mental_health_app/data/journal/interface.dart';
import 'package:mental_health_app/data/user/interface.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/api_models/quote.dart';
import '../../data/emotion/data.dart';
import 'home_init_response.dart';

abstract class IHomeInitUseCase {
  Stream<HomeInitResponse> invoke();
}

@Injectable(as: IHomeInitUseCase)
class HomeInitUseCase extends IHomeInitUseCase {
  HomeInitUseCase(this._userRepo, this._auth, this._journalRepo, this._emotionRepo);
  final IUserRepo _userRepo;
  final FirebaseAuth _auth;
  final IJournalRepo _journalRepo;
  final IEmotionRepo _emotionRepo;
  @override
  Stream<HomeInitResponse> invoke() async* {
    try {
      yield HomeInitResponse(isLoading: true);
      final random = Random();
      String randomQuote = mentalHealthQuotes.keys.elementAt(random.nextInt(mentalHealthQuotes.length));
      String author = mentalHealthQuotes[randomQuote]!;
      Quote? quote = Quote(text: randomQuote, author: author);
      final userId = _auth.currentUser?.uid;
      final user = await _userRepo.getUser(id: userId ?? '');
      final combinedStream = CombineLatestStream.combine2(
          _journalRepo.observeJournalEntryByDate(userId: userId ?? "", date: DateTime.now()), _emotionRepo.observeEmotionForTodayByUser(userId: userId ?? ""),
          (JournalEntry? journalEntry, List<EmotionData?> emotion) {
        return HomeInitResponse(quote: quote, user: user, todayJournalEntry: journalEntry, todayEmotionData: emotion.isNotEmpty ? emotion.first : null);
      });
      await for (var result in combinedStream) {
        yield result;
      }
    } catch (e) {
      print("Error in HomeInitUseCase: $e");
      yield HomeInitResponse(error: e.toString());
    }
  }
}

Map<String, String> mentalHealthQuotes = {
  "Nothing can dim the light that shines from within.": "Maya Angelou",
  "Your present circumstances don’t determine where you go; they merely determine where you start.": "Nido Qubein",
  "You, yourself, as much as anybody in the entire universe, deserve your love and affection.": "Buddha",
  "Do not let your difficulties fill you with anxiety; after all, it is only in the darkest nights that stars shine more brightly.": "Ali Ibn Abi Talib",
  "There is hope, even when your brain tells you there isn’t.": "John Green",
  "Happiness can be found even in the darkest of times, if one only remembers to turn on the light.": "Albus Dumbledore (J.K. Rowling)",
  "You don’t have to control your thoughts. You just have to stop letting them control you.": "Dan Millman",
  "Healing takes time, and asking for help is a courageous step.": "Mariska Hargitay",
  "Self-care is not a luxury, it’s a necessity.": "Audre Lorde",
  "Mental health needs a great deal of attention. It’s the final taboo and it needs to be faced and dealt with.": "Adam Ant"
};
