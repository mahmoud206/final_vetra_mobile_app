import 'package:dio/dio.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../utils/constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  factory ApiClient() => _instance;
  
  ApiClient._internal();
  
  // Connect to MongoDB and send request
  Future<bool> testConnection(String databaseName) async {
    try {
      final db = await Db.create('${Constants.mongoUri}$databaseName');
      await db.open();
      await db.close();
      return true;
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }
  
  // Get collection stats
  Future<Map<String, dynamic>> getCollectionStats(String databaseName, String collectionName) async {
    try {
      final db = await Db.create('${Constants.mongoUri}$databaseName');
      await db.open();
      
      final result = await db.runCommand({
        'collStats': collectionName,
      });
      
      await db.close();
      return result;
    } catch (e) {
      print('Error getting collection stats: $e');
      throw Exception('Failed to get collection stats: $e');
    }
  }
  
  // Get database stats
  Future<Map<String, dynamic>> getDatabaseStats(String databaseName) async {
    try {
      final db = await Db.create('${Constants.mongoUri}$databaseName');
      await db.open();
      
      final result = await db.runCommand({
        'dbStats': 1,
      });
      
      await db.close();
      return result;
    } catch (e) {
      print('Error getting database stats: $e');
      throw Exception('Failed to get database stats: $e');
    }
  }
}