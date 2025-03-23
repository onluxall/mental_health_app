import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
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
      final response = await http.get(Uri.parse('https://api.api-ninjas.com/v1/quotes'), headers: {
        'X-Api-Key': 'sUQyxNS8th/iZFSyQDxjtw==vBaUIiB7yjC9m79B',
      });
      Quote? quote;
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        quote = (jsonList.map((data) => Quote.fromJson(data)).toList()).firstOrNull;
      } else {
        throw Exception('Failed to load quotes');
      }
      final id = _auth.currentUser?.uid;
      final user = await _userRepo.getUser(id: id ?? '');
      yield HomeInitResponse(quote: quote, user: user);
    } catch (e) {
      print(e);
      yield HomeInitResponse(error: e.toString());
    }
  }
}
