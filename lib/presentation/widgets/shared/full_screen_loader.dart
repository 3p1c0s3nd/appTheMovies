import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando',
      'Esto esta tardando mas de lo esperado',
      'Esto puede llevar un tiempo',
      'Por favor espere',
    ];
    return Stream.periodic(const Duration(seconds: 2), (i) => messages[i])
        .take(messages.length);
  }
  /*Stream<String> get stream async* {
    for (var i = 0; i < messages.length; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield messages[i];
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Espere por favor"),
          const SizedBox(height: 10),
          const CircularProgressIndicator(
            strokeWidth: 2,
          ),
          const SizedBox(height: 10),
          StreamBuilder(
              stream: getLoadingMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("Cargando");
                }
                return Text(snapshot.data!);
              })
        ],
      ),
    );
  }
}
