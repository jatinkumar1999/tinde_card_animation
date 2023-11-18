import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinde_card_animation/provider/card_provider.dart';
import 'package:tinde_card_animation/views/tinder_card_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CardProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<CardProvider>(context);
    print('fdsf=>>>${cardProvider.urlImages}');

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              cardProvider.superLike();
            },
            child: const Icon(
              Icons.star,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              cardProvider.rewind();
            },
            child: const Icon(
              Icons.refresh,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, CardProvider controller, _) => Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: buildCard(controller),
        ),
      ),
    );
  }

  buildCard(CardProvider controller) {
    // final cardProvider = Provider.of<CardProvider>(context);
    final urlImages = controller.urlImages;
    return urlImages.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'no user found!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.reserImages();
                  },
                  child: const Text(
                    "Refresh",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Stack(
            children: urlImages
                .map((e) => TinderCardView(
                      image: e,
                      isFront: urlImages.last == e,
                    ))
                .toList(),
          );
  }
}
