/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/account_endpoint.dart' as _i4;
import '../endpoints/alert_endpoint.dart' as _i5;
import '../endpoints/expense_endpoint.dart' as _i6;
import '../endpoints/product_endpoint.dart' as _i7;
import '../endpoints/seed_endpoint.dart' as _i8;
import '../endpoints/shortcut_endpoint.dart' as _i9;
import '../endpoints/test_endpoint.dart' as _i10;
import '../greetings/greeting_endpoint.dart' as _i11;
import 'package:kindred_butler_server/src/generated/alert.dart' as _i12;
import 'package:kindred_butler_server/src/generated/expense.dart' as _i13;
import 'package:kindred_butler_server/src/generated/product.dart' as _i14;
import 'package:kindred_butler_server/src/generated/shortcut.dart' as _i15;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i16;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i17;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'account': _i4.AccountEndpoint()
        ..initialize(
          server,
          'account',
          null,
        ),
      'alert': _i5.AlertEndpoint()
        ..initialize(
          server,
          'alert',
          null,
        ),
      'expense': _i6.ExpenseEndpoint()
        ..initialize(
          server,
          'expense',
          null,
        ),
      'product': _i7.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'seed': _i8.SeedEndpoint()
        ..initialize(
          server,
          'seed',
          null,
        ),
      'shortcut': _i9.ShortcutEndpoint()
        ..initialize(
          server,
          'shortcut',
          null,
        ),
      'test': _i10.TestEndpoint()
        ..initialize(
          server,
          'test',
          null,
        ),
      'greeting': _i11.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['account'] = _i1.EndpointConnector(
      name: 'account',
      endpoint: endpoints['account']!,
      methodConnectors: {
        'getAccount': _i1.MethodConnector(
          name: 'getAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _i4.AccountEndpoint)
                  .getAccount(session),
        ),
        'updateBalance': _i1.MethodConnector(
          name: 'updateBalance',
          params: {
            'newBalance': _i1.ParameterDescription(
              name: 'newBalance',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['account'] as _i4.AccountEndpoint).updateBalance(
                    session,
                    params['newBalance'],
                  ),
        ),
        'addToBalance': _i1.MethodConnector(
          name: 'addToBalance',
          params: {
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['account'] as _i4.AccountEndpoint).addToBalance(
                    session,
                    params['amount'],
                  ),
        ),
        'subtractFromBalance': _i1.MethodConnector(
          name: 'subtractFromBalance',
          params: {
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _i4.AccountEndpoint)
                  .subtractFromBalance(
                    session,
                    params['amount'],
                  ),
        ),
      },
    );
    connectors['alert'] = _i1.EndpointConnector(
      name: 'alert',
      endpoint: endpoints['alert']!,
      methodConnectors: {
        'addAlert': _i1.MethodConnector(
          name: 'addAlert',
          params: {
            'alert': _i1.ParameterDescription(
              name: 'alert',
              type: _i1.getType<_i12.Alert>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i5.AlertEndpoint).addAlert(
                session,
                params['alert'],
              ),
        ),
        'getAlerts': _i1.MethodConnector(
          name: 'getAlerts',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i5.AlertEndpoint).getAlerts(session),
        ),
        'deleteAlert': _i1.MethodConnector(
          name: 'deleteAlert',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i5.AlertEndpoint).deleteAlert(
                session,
                params['id'],
              ),
        ),
      },
    );
    connectors['expense'] = _i1.EndpointConnector(
      name: 'expense',
      endpoint: endpoints['expense']!,
      methodConnectors: {
        'getAllExpenses': _i1.MethodConnector(
          name: 'getAllExpenses',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['expense'] as _i6.ExpenseEndpoint)
                  .getAllExpenses(session),
        ),
        'getExpensesByCategory': _i1.MethodConnector(
          name: 'getExpensesByCategory',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['expense'] as _i6.ExpenseEndpoint)
                  .getExpensesByCategory(
                    session,
                    params['category'],
                  ),
        ),
        'getExpensesByDateRange': _i1.MethodConnector(
          name: 'getExpensesByDateRange',
          params: {
            'start': _i1.ParameterDescription(
              name: 'start',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'end': _i1.ParameterDescription(
              name: 'end',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['expense'] as _i6.ExpenseEndpoint)
                  .getExpensesByDateRange(
                    session,
                    params['start'],
                    params['end'],
                  ),
        ),
        'createExpense': _i1.MethodConnector(
          name: 'createExpense',
          params: {
            'expense': _i1.ParameterDescription(
              name: 'expense',
              type: _i1.getType<_i13.Expense>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['expense'] as _i6.ExpenseEndpoint).createExpense(
                    session,
                    params['expense'],
                  ),
        ),
        'updateExpense': _i1.MethodConnector(
          name: 'updateExpense',
          params: {
            'expense': _i1.ParameterDescription(
              name: 'expense',
              type: _i1.getType<_i13.Expense>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['expense'] as _i6.ExpenseEndpoint).updateExpense(
                    session,
                    params['expense'],
                  ),
        ),
        'deleteExpense': _i1.MethodConnector(
          name: 'deleteExpense',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['expense'] as _i6.ExpenseEndpoint).deleteExpense(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['product'] = _i1.EndpointConnector(
      name: 'product',
      endpoint: endpoints['product']!,
      methodConnectors: {
        'getAllProducts': _i1.MethodConnector(
          name: 'getAllProducts',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i7.ProductEndpoint)
                  .getAllProducts(session),
        ),
        'getProductById': _i1.MethodConnector(
          name: 'getProductById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i7.ProductEndpoint).getProductById(
                    session,
                    params['id'],
                  ),
        ),
        'getProductsByName': _i1.MethodConnector(
          name: 'getProductsByName',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i7.ProductEndpoint)
                  .getProductsByName(
                    session,
                    params['name'],
                  ),
        ),
        'createProduct': _i1.MethodConnector(
          name: 'createProduct',
          params: {
            'product': _i1.ParameterDescription(
              name: 'product',
              type: _i1.getType<_i14.Product>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i7.ProductEndpoint).createProduct(
                    session,
                    params['product'],
                  ),
        ),
        'updateProduct': _i1.MethodConnector(
          name: 'updateProduct',
          params: {
            'product': _i1.ParameterDescription(
              name: 'product',
              type: _i1.getType<_i14.Product>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i7.ProductEndpoint).updateProduct(
                    session,
                    params['product'],
                  ),
        ),
        'deleteProduct': _i1.MethodConnector(
          name: 'deleteProduct',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i7.ProductEndpoint).deleteProduct(
                    session,
                    params['id'],
                  ),
        ),
        'updateStock': _i1.MethodConnector(
          name: 'updateStock',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newStockCount': _i1.ParameterDescription(
              name: 'newStockCount',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i7.ProductEndpoint).updateStock(
                    session,
                    params['productId'],
                    params['newStockCount'],
                  ),
        ),
      },
    );
    connectors['seed'] = _i1.EndpointConnector(
      name: 'seed',
      endpoint: endpoints['seed']!,
      methodConnectors: {
        'seedDatabase': _i1.MethodConnector(
          name: 'seedDatabase',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['seed'] as _i8.SeedEndpoint).seedDatabase(session),
        ),
        'resetDatabase': _i1.MethodConnector(
          name: 'resetDatabase',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['seed'] as _i8.SeedEndpoint).resetDatabase(
                session,
              ),
        ),
      },
    );
    connectors['shortcut'] = _i1.EndpointConnector(
      name: 'shortcut',
      endpoint: endpoints['shortcut']!,
      methodConnectors: {
        'addShortcut': _i1.MethodConnector(
          name: 'addShortcut',
          params: {
            'shortcut': _i1.ParameterDescription(
              name: 'shortcut',
              type: _i1.getType<_i15.Shortcut>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shortcut'] as _i9.ShortcutEndpoint).addShortcut(
                    session,
                    params['shortcut'],
                  ),
        ),
        'getShortcuts': _i1.MethodConnector(
          name: 'getShortcuts',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shortcut'] as _i9.ShortcutEndpoint)
                  .getShortcuts(session),
        ),
      },
    );
    connectors['test'] = _i1.EndpointConnector(
      name: 'test',
      endpoint: endpoints['test']!,
      methodConnectors: {
        'runAllTests': _i1.MethodConnector(
          name: 'runAllTests',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['test'] as _i10.TestEndpoint).runAllTests(session),
        ),
        'getSystemStatus': _i1.MethodConnector(
          name: 'getSystemStatus',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['test'] as _i10.TestEndpoint)
                  .getSystemStatus(session),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i11.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i16.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i17.Endpoints()
      ..initializeEndpoints(server);
  }
}
