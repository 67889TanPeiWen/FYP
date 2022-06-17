import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi{

  static UploadTask? uploadImage(String destination, File file){
    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    }on FirebaseException catch (e){
      return null;
    }

  }



  static UploadTask? uploadAudio (String destination, File file){
    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file,SettableMetadata(contentType: 'audio/mp4'));
    }on FirebaseException catch (e){
      return null;
    }

  }
}

