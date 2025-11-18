import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

//EVENTS
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  AuthLoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthGuestRequested extends AuthEvent {}
class AuthLogoutRequested extends AuthEvent {}

//STATES
enum AuthStatus { unknown, authenticated, guest, unauthenticated, loading, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState._({this.status = AuthStatus.unknown, this.errorMessage});
  const AuthState.unknown() : this._();
  const AuthState.authenticated() : this._(status: AuthStatus.authenticated);
  const AuthState.guest() : this._(status: AuthStatus.guest);
  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);
  // Add loading and failure states
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.failure(String error) : this._(status: AuthStatus.error, errorMessage: error);
  @override
  List<Object?> get props => [status, errorMessage];
}
//BLOC
class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc() : super(const AuthState.unknown()){

    on<AuthLoginRequested>((event, emit) async {
      emit(const AuthState.loading()); 

      try {
        // Tầng Repository (gọi API PostgreSQL) sẽ nằm ở đây
        await Future.delayed(const Duration(seconds: 2)); 

        // Logic kiểm tra dữ liệu đầu vào (Validation)
        if (event.email.isEmpty || event.password.length < 6) {
          throw Exception("Email hoặc mật khẩu không hợp lệ!");
        }

        emit(const AuthState.authenticated());
      } catch (e) {
        String errorMsg = e.toString();
        // Xóa tiền tố "Exception: " nếu có để thông báo đẹp hơn
        if (errorMsg.startsWith('Exception: ')) {
          errorMsg = errorMsg.replaceFirst('Exception: ', '');
        }
        emit(AuthState.failure(errorMsg));
      }
    });

    // Sửa lỗi cú pháp: Thêm cặp dấu ngoặc đơn ((event, emit))
    on<AuthGuestRequested>((event, emit) {
      emit(const AuthState.guest());
    });

    on<AuthLogoutRequested>((event, emit) {
      emit(const AuthState.unauthenticated());
    });
  }
}
