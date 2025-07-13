import 'package:firebase_performance/firebase_performance.dart';
import 'performance_tracer.dart';

class FirebasePerformanceTracer implements PerformanceTracer {
  final Trace _trace;

  FirebasePerformanceTracer(String name)
      : _trace = FirebasePerformance.instance.newTrace(name);

  @override
  Future<void> start() => _trace.start();

  @override
  Future<void> stop() => _trace.stop();
}
