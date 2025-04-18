import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../utils/constants.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

class DatabaseProvider extends ChangeNotifier {
  // Connection variables
  Db? _db;
  String _selectedDatabase = Constants.databases[0];
  ConnectionStatus _status = ConnectionStatus.disconnected;
  String _errorMessage = '';
  
  // Getters
  String get selectedDatabase => _selectedDatabase;
  ConnectionStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isConnected => _status == ConnectionStatus.connected;
  
  // Change selected database
  void selectDatabase(String database) {
    if (Constants.databases.contains(database) && _selectedDatabase != database) {
      _selectedDatabase = database;
      notifyListeners();
    }
  }
  
  // Connect to the database
  Future<bool> connect() async {
    if (_status == ConnectionStatus.connecting) {
      return false;
    }
    
    // Disconnect if already connected
    if (_db != null) {
      await disconnect();
    }
    
    _status = ConnectionStatus.connecting;
    _errorMessage = '';
    notifyListeners();
    
    try {
      _db = await Db.create('${Constants.mongoUri}$_selectedDatabase');
      await _db!.open();
      _status = ConnectionStatus.connected;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ConnectionStatus.error;
      notifyListeners();
      return false;
    }
  }
  
  // Disconnect from the database
  Future<void> disconnect() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
    _status = ConnectionStatus.disconnected;
    notifyListeners();
  }
  
  // Get payment data for the given date range
  Future<List<Map<String, dynamic>>> getPaymentData(DateTime startDate, DateTime endDate) async {
    if (_db == null || !isConnected) {
      throw Exception('Database not connected');
    }
    
    try {
      // Set the time to the beginning and end of the days
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      
      final collection = _db!.collection(Constants.paymentCollection);
      final data = await collection.find(where
        .gte('createdAt', start)
        .lte('createdAt', end)
      ).toList();
      
      return data;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      throw Exception('Failed to fetch payment data: $_errorMessage');
    }
  }
  
  // Get sale data for the given date range
  Future<List<Map<String, dynamic>>> getSaleData(DateTime startDate, DateTime endDate) async {
    if (_db == null || !isConnected) {
      throw Exception('Database not connected');
    }
    
    try {
      // Set the time to the beginning and end of the days
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      
      final collection = _db!.collection(Constants.saleCollection);
      final data = await collection.find(where
        .gte('createdAt', start)
        .lte('createdAt', end)
      ).toList();
      
      return data;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      throw Exception('Failed to fetch sale data: $_errorMessage');
    }
  }
}