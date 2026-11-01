import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/save_store.dart';

class ComplianceState extends Equatable {
  const ComplianceState({this.ageGateDone = false, this.underAge = false});

  /// The first-launch age question was answered.
  final bool ageGateDone;

  /// Under 13: child-directed, G-rated, non-personalised ads and no ad
  /// personalisation in analytics.
  final bool underAge;
  @override
  List<Object?> get props => [ageGateDone, underAge];
}

/// Neutral age gate result. Only the under-13 flag is kept, never the year.
class ComplianceCubit extends Cubit<ComplianceState> {
  ComplianceCubit(this._store)
    : super(
        ComplianceState(
          ageGateDone: _store.read(_key)?['ageGateDone'] as bool? ?? false,
          underAge: _store.read(_key)?['underAge'] as bool? ?? false,
        ),
      );

  static const _key = 'compliance';
  static const adultAge = 13;
  final SaveStore _store;

  void submitBirthYear(int year, {required int currentYear}) {
    // Whole-year check errs on the safe side: someone who turns 13 later this
    // year still counts as under 13.
    final under = currentYear - year <= adultAge;
    emit(ComplianceState(ageGateDone: true, underAge: under));
  }

  @override
  void onChange(Change<ComplianceState> change) {
    super.onChange(change);
    _store.write(_key, {'ageGateDone': change.nextState.ageGateDone, 'underAge': change.nextState.underAge});
  }
}
