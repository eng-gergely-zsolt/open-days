import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUtils {
  /// Returns the URL of an image stored in Firebase storage by the path of the image.
  static Future<String> getDownloadURL(String imagePath) async {
    String response;
    var imageRef = FirebaseStorage.instance.ref().child(imagePath);

    try {
      response = await imageRef.getDownloadURL();
    } catch (_) {
      imageRef = FirebaseStorage.instance.ref().child('event/placeholder.jpg');
      response = await imageRef.getDownloadURL();
    }

    return response;
  }
}
