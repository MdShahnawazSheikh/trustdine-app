import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('Orders');

  // Updated addData method to accept orderId
  Future<void> addData(
      String orderId, Map<String, Map<String, dynamic>> purchases) async {
    try {
      // Use the custom orderId as the document ID
      await _collectionReference.doc(orderId).set(purchases);
      print('Data added successfully to Firestore with orderId: $orderId');
    } catch (e) {
      print('Error adding data to Firestore: $e');
    }
  }

  Future<void> updateData(String documentId, Map<String, dynamic> data) async {
    try {
      await _collectionReference.doc(documentId).update(data);
      print('Data updated successfully in Firestore');
    } catch (e) {
      print('Error updating data in Firestore: $e');
    }
  }

  Future<void> removeData(String documentId) async {
    try {
      await _collectionReference.doc(documentId).delete();
      print('Data removed successfully from Firestore');
    } catch (e) {
      print('Error removing data from Firestore: $e');
    }
  }
}
