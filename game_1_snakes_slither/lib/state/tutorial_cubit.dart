import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/save_store.dart';

class TutorialState extends Equatable {
  const TutorialState({this.seen = const {}});

  /// FTUE steps ("1_tap_to_slither"), booster tips ("b_shield") and
  /// mechanic intro cards ("M005") the player has already been shown.
  final Set<String> seen;

  bool has(String id) => seen.contains(id);
  @override
  List<Object?> get props => [seen];
}

/// Remembers which tutorial steps and intro cards were shown, so each one
/// appears once (cards can be replayed from Settings › Jungle Guide).
class TutorialCubit extends Cubit<TutorialState> {
  TutorialCubit(this._store)
    : super(TutorialState(seen: {...((_store.read(_key)?['seen'] as List?) ?? const []).cast<String>()}));

  static const _key = 'tutorial';
  final SaveStore _store;

  /// Analytics hook for `ftue_step`.
  void Function(String step)? onStep;

  void markSeen(String id) {
    if (state.has(id)) return;
    onStep?.call(id);
    emit(TutorialState(seen: {...state.seen, id}));
  }

  @override
  void onChange(Change<TutorialState> change) {
    super.onChange(change);
    _store.write(_key, {'seen': change.nextState.seen.toList()..sort()});
  }
}
