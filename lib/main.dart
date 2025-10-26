import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fancy Counter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: _isDark ? Brightness.dark : Brightness.light),
        useMaterial3: true),
      home: MyHomePage(
        title: 'Fancy Counter',
        onThemeToggle: () {
          setState(() {
            _isDark = !_isDark;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final VoidCallback onThemeToggle;

  const MyHomePage({super.key, required this.title, required this.onThemeToggle});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  final List<int> _history = [];
  late AnimationController _controller;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _history.add(_counter);
      _controller.forward(from: 0);
    });
    _confettiController.play();
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _history.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  LinearGradient _animatedGradient() {
    final colors = [
      [Colors.teal, Colors.greenAccent],
      [Colors.purple, Colors.pinkAccent],
      [Colors.blue, Colors.cyan],
      [Colors.orange, Colors.deepOrangeAccent],
    ];
    return LinearGradient(
      colors: colors[_counter % colors.length],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        gradient: _animatedGradient(),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title, style: const TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.dark_mode, color: Colors.white),
              onPressed: widget.onThemeToggle)
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:',style: TextStyle(fontSize: 17, color: Colors.white)),
                ScaleTransition(
                  scale: Tween<double>(begin: 1, end: 1.3).animate(
                    CurvedAnimation(parent: _controller, curve: Curves.elasticOut)),
                  child: Text('$_counter',style: const TextStyle(fontSize: 60,fontWeight: FontWeight.bold,color: Colors.white)),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.history, color: Colors.white),
                        title: Text("Count: ${_history[index]}",style: const TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                )
              ],
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.red, Colors.blue, Colors.green, Colors.orange]),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: _incrementCounter,
              icon: const Icon(Icons.add),
              label: const Text("Add"),
            ),
            const SizedBox(width: 10),
            FloatingActionButton.extended(
              onPressed: _resetCounter,
              icon: const Icon(Icons.refresh),
              label: const Text("Reset"),
              backgroundColor: Colors.redAccent),
          ],
        ),
      ),
    );
  }
}
