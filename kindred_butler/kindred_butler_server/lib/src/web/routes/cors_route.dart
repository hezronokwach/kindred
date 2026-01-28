import 'package:serverpod/serverpod.dart';

class CorsRoute extends WidgetRoute {
  final WidgetRoute innerRoute;

  CorsRoute(this.innerRoute);

  @override
  Future<RouteResult> handleRequest(Request request) async {
    // Handle preflight OPTIONS request
    if (request.method == 'OPTIONS') {
      return RouteResult.response(
        Response.ok(
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          },
        ),
      );
    }

    // Handle actual request and add CORS headers to response
    final result = await innerRoute.handleRequest(request);
    
    if (result.response != null) {
      result.response!.headers['Access-Control-Allow-Origin'] = '*';
      result.response!.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS';
      result.response!.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization';
    }
    
    return result;
  }
}
