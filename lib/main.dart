import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '3D Model Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '3D Model View'),
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
  Flutter3DController controller = Flutter3DController();
  String? chosenAnimation;
  String? chosenTexture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Custom AppBar color
        title: Text(
          widget.title,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true, // Center the title
        elevation: 10, // Add shadow to the AppBar
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              controller.setCameraOrbit(20, 20, 5);
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.camera_alt, color: Colors.white),
            elevation: 6, // Shadow for floating action button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ), // Rounded corners
          ),
          const SizedBox(
            height: 12,
          ),
          FloatingActionButton(
            onPressed: () {
              controller.resetCameraOrbit();
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.cameraswitch_outlined, color: Colors.white),
            elevation: 6, // Shadow for floating action button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ), // Rounded corners
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/1.jpg"), fit: BoxFit.fill),
          gradient: RadialGradient(
            colors: [
              Color(0xFFE1E1E1),
              Color(0xFFB4B4B4), // dark gray
              Color(0xFF737373), // medium gray
              // light gray
              Color(0xFF3C3C3C) // almost white
            ],
            center: Alignment.center,
            radius: 1.2, // controls how wide the gradient is
          ),
        ),
        child: Stack(
          children: [
            Flutter3DViewer(
              progressBarColor: Colors.white,
              controller: controller,
              src: 'assets/1.glb',
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(16),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade800,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showPickerDialog(List<String> inputList, dynamic context,
    [String? chosenItem]) async {
  return await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 250,
          child: ListView.separated(
            itemCount: inputList.length,
            padding: const EdgeInsets.only(top: 16),
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context, inputList[index]);
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${index + 1}'),
                      Text(inputList[index]),
                      Icon(chosenItem == inputList[index]
                          ? Icons.check_box
                          : Icons.check_box_outline_blank)
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const Divider(
                color: Colors.grey,
                thickness: 0.6,
                indent: 10,
                endIndent: 10,
              );
            },
          ),
        );
      });
}
