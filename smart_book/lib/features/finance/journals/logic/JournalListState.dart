import 'package:equatable/equatable.dart';
import '../models/JournalModel.dart';

abstract class JournalListState extends Equatable {
  const JournalListState();

  @override
  List<Object?> get props => [];
}

class JournalListInitial extends JournalListState {}

class JournalListLoading extends JournalListState {}

class JournalListLoaded extends JournalListState {
  final List<JournalModel> journals; // استخدمنا الموديل هنا مباشرة

  const JournalListLoaded(this.journals);

  @override
  List<Object?> get props => [journals];
}

class JournalListFailure extends JournalListState {
  final String error;

  const JournalListFailure(this.error);

  @override
  List<Object?> get props => [error];
}