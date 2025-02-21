import 'package:local_auth/local_auth.dart';

class AuthService {
  Future<bool> authenticateWithBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isAuthenticated = false;

    try {
      isAuthenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to access this feature',
          options: AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: true,
          ));
    } catch (e) {
      print(e);
    }
    return isAuthenticated;
  }
}
