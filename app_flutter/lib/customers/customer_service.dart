import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_flutter/config_service.dart';
import 'customer_model.dart';

class CustomerService {
  final String baseUrl = ConfigService.get('API_BASE_URL');

  Future<List<CustomerDTO>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/customers'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['message'] == 'success') {
          final List<dynamic> customersData = responseData['data'];
          return customersData.map((data) => CustomerDTO.fromJson(data)).toList();
        }
      }
      throw Exception('Failed to load customers');
    } catch (e) {
      throw Exception('Failed to load customers: $e');
    }
  }

  Future<bool> deleteCustomer(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/deleteCustomer/$id'),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete customer: $e');
    }
  }

   Future<bool> updateCustomer(int id, Map<String, dynamic> customerData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/customersEdit/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(customerData),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  Future<bool> createCustomer(Map<String, dynamic> customerData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/addCustomer'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(customerData),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }
}