import 'package:flutter/services.dart';

class OpenBookService{
   static const MethodChannel _channel = MethodChannel('readium_integration');

  Future<void> openEpub(String bookId) async {
    try {
      await _channel.invokeMethod('openEpub', {'path': "https://jmp.sh/s/HOiBlfhiSe0eicJiWD4j"});
      print("here we go----------------");
      print("successss.............>>>>>>>>>>>");
    } on PlatformException catch (e) {
      // Handle exception.
      print('Failed to open EPUB: ${e.message}');
    }
  }
}
