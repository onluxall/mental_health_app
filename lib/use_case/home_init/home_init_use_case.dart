import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/user/interface.dart';

import '../../data/api_models/quote.dart';
import 'home_init_response.dart';

abstract class IHomeInitUseCase {
  Stream<HomeInitResponse> invoke();
}

@Injectable(as: IHomeInitUseCase)
class HomeInitUseCase extends IHomeInitUseCase {
  HomeInitUseCase(this._userRepo, this._auth);
  final IUserRepo _userRepo;
  final FirebaseAuth _auth;
  @override
  Stream<HomeInitResponse> invoke() async* {
    try {
      yield HomeInitResponse(isLoading: true);
      Quote? quote;
      final random = Random();
      String randomQuote = mentalHealthQuotes.keys.elementAt(random.nextInt(mentalHealthQuotes.length));
      String author = mentalHealthQuotes[randomQuote]!;
      quote = Quote(text: randomQuote, author: author);
      final id = _auth.currentUser?.uid;
      final user = await _userRepo.getUser(id: id ?? '');
      yield HomeInitResponse(quote: quote, user: user);
    } catch (e) {
      print(e);
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
