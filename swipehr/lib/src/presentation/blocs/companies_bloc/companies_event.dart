part of 'companies_bloc.dart';

sealed class CompaniesEvent extends Equatable {
  const CompaniesEvent();
}

class CompaniesLoad extends CompaniesEvent {
  const CompaniesLoad();

  @override
  List<Object> get props => [];
}
