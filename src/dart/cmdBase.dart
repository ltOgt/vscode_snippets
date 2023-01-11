import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
    
/// ========================================================= base command file
    
/// See [SetupWidget].
class BaseCommand {
  static BuildContext? _rootContext;
  static BuildContext get rootContext {
    assert(
      _rootContext != null,
      \"BaseCommand._rootContext not initialized. Did you forget to call BaseCommand.init(context) ,at the top of your application?\"
    );
    return _rootContext!;
  }
    
  static void init(BuildContext rootContext) {
    BaseCommand._rootContext ??= rootContext;
  }
    
  MyModel get myModel => rootContext.read();
}
    
/// Initializes [BaseCommand] and all of your models
///
/// Put this somewhere high in your application tree
/// E.g. `runApp(const SetupWidget(child: MyApp()));`
class SetupWidget extends StatelessWidget {
  const SetupWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
    
  final Widget child;
    
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyModel>(
          lazy: false,
          create: (context) => MyModel(),
        ),
        // TODO add other models here as needed
      ],
      builder: (context, child) {
        // Called every time, but only has a side effect on first call
        BaseCommand.init(context);
        return child!;
      },
      child: child,
    );
  }
}
    
/// ========================================================= one of the actual command files
    
class CanvasSelectionCmd extends BaseCommand {
  /// Change the selection of the canvas
  void run() async {
    myModel.update(myValue: (i) => i++);
  }
}
    
/// ========================================================= one of the model files
    
typedef Updater<T> = T Function(T current);
    
class MyModel extends ChangeNotifier {
  int _myValue = 0;
    
  /// Update a set of values of the model
  void update({
    Updater<int>? myValue,
  }) {
    bool anyChanged = false;
    void change<T>(T current, Updater<T>? update, void Function(T) apply) {
      if (update != null) {
        apply(update(current));
        anyChanged = true;
      }
    }
    
    /// TODO add values here as needed
    change(_myValue, myValue, (v) => _myValue = v);
    
    if (anyChanged) notifyListeners();
  }
}    