/// A class to generate routes with optional hash-based routing.
class RouteGenerator {
  /// If true, use hash routing (e.g. '/#/page'), otherwise use path routing ('/page').
  /// Nullable to allow unspecified behavior.
  final bool? useHashRouting;

  /// Creates a [RouteGenerator] instance.
  ///
  /// The [useHashRouting] parameter controls whether hash routing is used.
  /// If null, routing behavior can be handled with a default elsewhere.
  RouteGenerator({this.useHashRouting});
}