import 'package:auto_route/auto_route.dart';
import 'package:justdoit/INFRASTRUCTURE/auth/auth_repository.dart';
import 'package:justdoit/injection.dart';
import 'package:justdoit/PRESENTATION/account/account/account_page.dart';
import 'package:justdoit/PRESENTATION/account/delete_account/delete_account_page.dart';
import 'package:justdoit/PRESENTATION/account/mes_heureux_beneficiaires/mes_heureux_beneficiaires_page.dart';
import 'package:justdoit/PRESENTATION/account/modify_account/modify_account_page.dart';
import 'package:justdoit/PRESENTATION/account/new_password/new_password_page.dart';
import 'package:justdoit/PRESENTATION/account/reauthenticate/reauthenticate_page.dart';
import 'package:justdoit/PRESENTATION/add_task/add_task.dart';
import 'package:justdoit/PRESENTATION/auth/auth_check_email/auth_check_email_page.dart';
import 'package:justdoit/PRESENTATION/auth/auth_connexion/auth_connexion.dart';
import 'package:justdoit/PRESENTATION/auth/auth_init/auth_init.dart';
import 'package:justdoit/PRESENTATION/auth/auth_register/auth_register.dart';
import 'package:justdoit/PRESENTATION/auth/auth_reset_password.dart/auth_reset_password.dart';
import 'package:justdoit/PRESENTATION/autre/autre_page.dart';
import 'package:justdoit/PRESENTATION/home/home_page.dart';
import 'package:justdoit/PRESENTATION/main_navigation/main_navigation_page.dart';
import 'package:justdoit/PRESENTATION/core/_splash/splash_page.dart';

import 'router.gr.dart';

@MaterialAutoRouter(replaceInRouteName: "Page,Route", routes: [
  //RedirectRoute(path: '*', redirectTo: '/'),
  AutoRoute(
    path: '/',
    name: 'SplashRoute',
    page: SplashPage,
    initial: true,
  ),
  AutoRoute(
    path: '/main',
    page: MainNavigationPage,
    children: [
      RedirectRoute(path: '', redirectTo: 'home'),
      AutoRoute(
        path: 'home',
        name: 'HomeRoute',
        page: HomePage,
      ),
      AutoRoute(
        path: 'autre',
        name: 'AutreRoute',
        page: AutrePage,
      ),
      AutoRoute(
        path: 'account',
        name: 'AccountRoute',
        page: AccountPage,
      ),
    ],
  ),
  AutoRoute(
    path: 'add-task',
    name: 'AddTaskRoute',
    page: AddTaskPage,
  ),
  AutoRoute(
    path: '/auth-init',
    name: 'AuthInitRoute',
    page: AuthInitPage,
  ),
  AutoRoute(
    path: '/auth-connexion',
    name: 'AuthConnexionRoute',
    page: AuthConnexionPage,
  ),
  AutoRoute(
    path: '/auth-register',
    name: 'AuthRegisterRoute',
    page: AuthRegisterPage,
  ),
  AutoRoute(
    path: '/auth-check-email',
    name: 'AuthCheckEmailRoute',
    page: AuthCheckEmailPage,
  ),
  AutoRoute(
    path: '/auth-reset-password',
    name: 'AuthResetPasswordRoute',
    page: AuthResetPasswordPage,
  ),
  AutoRoute(
    path: '/modify-account',
    name: 'ModifyAccountRoute',
    page: ModifyAccountPage,
  ),
  AutoRoute(
    path: '/reauthenticate',
    name: 'ReauthenticateRoute',
    page: ReauthenticatePage,
  ),
  AutoRoute(
    path: '/delete-account',
    name: 'DeleteAccountRoute',
    page: DeleteAccountPage,
  ),
  AutoRoute(
    path: '/new-password',
    name: 'NewPasswordRoute',
    page: NewPasswordPage,
  ),
  AutoRoute(
    path: '/mes-heureux-beneficiaires',
    name: 'MesHeureuxBeneficiairesRoute',
    page: MesHeureuxBeneficiairesPage,
  ),
  //insert-route
])
class $AppRouter {}
