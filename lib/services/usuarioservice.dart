import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<List<Map<String, dynamic>>> getUsers() async {
    final QuerySnapshot snapshot =
        await _userCollection.where('rol', isEqualTo: 'usuario').get();

    return snapshot.docs
        .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
        .toList();
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _userCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Error al eliminar el usuario: $e');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _userCollection.doc(userId).update(userData);
    } catch (e) {
      throw Exception('Error al actualizar el usuario: $e');
    }
  }
}


