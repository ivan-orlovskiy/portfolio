part of 'companies_bloc.dart';

sealed class CompaniesState extends Equatable {
  const CompaniesState();
}

class CompaniesLoading extends CompaniesState {
  const CompaniesLoading();

  @override
  List<Object> get props => [];
}

class CompaniesLoaded extends CompaniesState {
  final List<Employer> companies;

  const CompaniesLoaded(this.companies);

  @override
  List<Object> get props => [...companies];
}

class CompaniesError extends CompaniesState {
  final String errorMessage;

  const CompaniesError(
    this.errorMessage,
  );

  @override
  List<Object> get props => [errorMessage];
}
