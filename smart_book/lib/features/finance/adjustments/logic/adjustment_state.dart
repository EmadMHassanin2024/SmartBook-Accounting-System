import 'package:equatable/equatable.dart';
import '../models/adjustment_entry.dart';
import '../widgets/adjustment_form.dart';

abstract class AdjustmentState extends Equatable {
  const AdjustmentState();

  @override
  List<Object?> get props => [];
}

class AdjustmentInitial extends AdjustmentState {
  const AdjustmentInitial();
}

class AdjustmentLoading extends AdjustmentState {
  const AdjustmentLoading();
}

class AdjustmentError extends AdjustmentState {
  final String message;
  const AdjustmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdjustmentLoaded extends AdjustmentState {
  final List<AdjustmentEntry> entries;
  final double totalAmount;

  // الحساب يتم تلقائياً بناءً على حقل amount في الموديل
  AdjustmentLoaded(this.entries)
      : totalAmount = entries.fold(0.0, (sum, item) => sum + item.amount);

  @override
  List<Object?> get props => [entries, totalAmount];
}

// في ملف adjustment_state.dart
class AdjustmentSuccess extends AdjustmentState {
  final String message;
  const AdjustmentSuccess(this.message);

  @override
  List<Object> get props => [message];
}