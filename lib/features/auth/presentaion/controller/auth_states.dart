class AuthStates {}

class AuthInitialState extends AuthStates {}

class CreateMemberAccountLoadingState extends AuthStates {}
class CreateMemberAccountSuccessState extends AuthStates {}
class CreateMemberAccountErrorState extends AuthStates {}

class LoginMemberLoadingState extends AuthStates {}
class LoginMemberSuccessState extends AuthStates {}
class LoginMemberErrorState extends AuthStates {}