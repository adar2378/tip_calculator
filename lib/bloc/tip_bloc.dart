import 'package:rxdart/rxdart.dart';

class TipBloc {
  final currentTip = BehaviorSubject<double>();
  final totalTip = BehaviorSubject<double>();

  Observable<double> get getCurrentTip => currentTip.stream;
  Observable<double> get getTotal => totalTip.stream;

  Future<void> calculateTip(double percentage, double total) async {
    final double totalTipValue = (total / 100) * percentage;
    currentTip.sink.add(totalTipValue);
    totalTip.sink.add(total + totalTipValue);
  }

  dispose() {
    currentTip.close();
    totalTip.close();
  }
}

final tipBloc = TipBloc();
