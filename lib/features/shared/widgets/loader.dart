import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  final String? message;
  const Loader({
    super.key,
    this.message = 'Cargando',
  });

  Stream<String> getLoadingMessages(message) {
    final messages = <String>[
      '$message...',
      '$message..',
      '$message.',
      message,
      '$message.',
      '$message..',
      '$message...',
      '$message...',
    ];

    return Stream.periodic(const Duration(milliseconds: 250),
        (step) => messages[step % messages.length]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E424B).withOpacity(0.4),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: 230,
            height: 80,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Row(
                    children: [
                      const SpinKitFadingCircle(
                        color: Colors.black,
                        size: 40,
                      ),
                      const SizedBox(width: 20),
                      StreamBuilder<String>(
                        stream: getLoadingMessages(message),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print('corriendo...');
                            return Expanded(
                              child: Text(
                                snapshot.data!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Text(
                                '$message...',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
