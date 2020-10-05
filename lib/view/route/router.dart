import 'package:auto_route/auto_route_annotations.dart';
import 'package:domainDrivenDesign/view/sign_in/sign_in_page.dart';
import 'package:domainDrivenDesign/view/splash/splash_page.dart';

@MaterialAutoRouter(generateNavigationHelperExtension: true)
class $Router{
  @initial
  SplashPage splashPage;
  SignInPage signInPage;
}