import 'package:firebase_storage/firebase_storage.dart';

import '../screens/constants/constants.dart';

class FirebaseUtils {
  /// Returns the URL of an image stored in Firebase storage by the path of the image.
  static Future<String> getDownloadURL(String imagePath) async {
    String response;
    Reference firebaseRef;

    try {
      firebaseRef = FirebaseStorage.instance.ref().child(imagePath);
      response = await firebaseRef.getDownloadURL();
    } catch (error) {
      firebaseRef = FirebaseStorage.instance.ref().child(eventPlaceholderImagePath);
      response = await firebaseRef.getDownloadURL();
    }

    return response;
  }
}
