import 'package:mongo_dart/mongo_dart.dart';
import '../utils/constants.dart';

class DatabaseService {
  // Singleton instance
  static final DatabaseService _instance = DatabaseService._internal();
  
  // Factory constructor
  factory DatabaseService() => _instance;
  
  // Private constructor
  DatabaseService._internal();
  
  // Database connection
  Db? _db;
  String _selectedDatabase = Constants.databases[0];
  
  // Connection status
  bool get isConnected => _db != null && _db!.isConnected;
  String get selectedDatabase => _selectedDatabase;
  
  // Connect to database
  Future<bool> connect(String databaseName) async {
    try {
      // Disconnect if already connected
      if (_db != null) {
        await disconnect();
      }
      
      _selectedDatabase = databaseName;
      _db = await Db.create('${Constants.mongoUri}$_selectedDatabase');
      await _db!.open();
      return true;
    } catch (e) {
      print('Error connecting to database: $e');
      return false;
    }
  }
  
  // Disconnect from database
  Future<void> disconnect() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
  
  // Get payment data for date range
  Future<List<Map<String, dynamic>>> getPaymentData(DateTime startDate, DateTime endDate) async {
    if (!isConnected) {
      throw Exception('Database not connected');
    }
    
    try {
      final collection = _db!.collection(Constants.paymentCollection);
      final data = await collection.find(where
        .gte('createdAt', startDate)
        .lte('createdAt', endDate)
      ).toList();
      
      return data;
    } catch (e) {
      print('Error fetching payment data: $e');
      throw Exception('Failed to fetch payment data');
    }
  }
  
  // Get sale data for date range
  Future<List<Map<String, dynamic>>> getSaleData(DateTime startDate, DateTime endDate) async {
    if (!isConnected) {
      throw Exception('Database not connected');
    }
    
    try {
      final collection = _db!.collection(Constants.saleCollection);
      final data = await collection.find(where
        .gte('createdAt', startDate)
        .lte('createdAt', endDate)
      ).toList();
      
      return data;
    } catch (e) {
      print('Error fetching sale data: $e');
      throw Exception('Failed to fetch sale data');
    }
  }
}