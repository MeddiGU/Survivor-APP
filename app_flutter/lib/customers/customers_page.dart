import 'package:app_flutter/coaches/coaches_service.dart';
import 'package:app_flutter/customers/customer_export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'customer_model.dart';
import 'customer_service.dart';
import 'edit_customer_page.dart';
import 'new_customer_page.dart';
import '../coaches/coaches_model.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final CustomerService _customerService = CustomerService();
  final CoachesService _coachesService = CoachesService();
  List<CustomerDTO> customers = [];
  List<CustomerDTO> _filteredCustomers = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<CoachesDTO> coaches = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadCoaches();
  }

  Future<void> _loadCustomers() async {
    try {
      setState(() => isLoading = true);
      final loadedCustomers = await _customerService.getCustomers();
      setState(() {
        customers = loadedCustomers;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading customers: $e')),
      );
    }
  }


  Future<void> _loadCoaches() async {
    try {
      final loadedCoaches = await _coachesService.fetchCoaches();
      setState(() {
        coaches = loadedCoaches;
      });
    } catch (e) {
      print("Erreur lors du chargement des coachs: $e");
    }
  }

  void _filterCustomers(String query) {
    setState(() {
      _filteredCustomers = customers
          .where((customer) =>
              customer.name.toLowerCase().contains(query.toLowerCase()) ||
              customer.surname.toLowerCase().contains(query.toLowerCase()) ||
              customer.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void exportCustomers(List<CustomerDTO> customers) {
    // Exporter les clients
    _customerService.exportCustomersToCsv(context, customers);
  }

String getCoachSurname(int coachId) {
  final coach = coaches.firstWhere(
    (coach) => coach.id == coachId,
    orElse: () => CoachesDTO(id: -1, name: "", surname:  "Unknow", email: "", gender: "", work: "", birth_date: DateTime(1900, 1, 1)) // Sécurisation
  );
  return coach.surname;
}


  Future<void> _deleteCustomer(BuildContext context, int id) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce client ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        final success = await _customerService.deleteCustomer(id);
        if (success) {
          await _loadCustomers();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Client supprimé avec succès!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la suppression du client.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression du client: $e')),
        );
      }
    }
  }

  void _showCustomerDetails(CustomerDTO customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${customer.fullName} Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Birth Date'),
                subtitle: Text(DateFormat('MMMM d, yyyy').format(customer.birthDate)),
              ),
              ListTile(
                title: Text('Description'),
                subtitle: Text(customer.description),
              ),
              ListTile(
                title: Text('Contact Information'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${customer.email}'),
                    Text('Phone: ${customer.phoneNumber}'),
                    Text('Address: ${customer.address}'),
                  ],
                ),
              ),
              ListTile(
                title: Text('Additional Information'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender: ${customer.gender}'),
                    Text('Astrological Sign: ${customer.astrologicalSign}'),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style, // Style par défaut du texte
                        children: [
                          TextSpan(text: 'Coach: ', style: TextStyle(color: Colors.black)), // Texte normal
                          TextSpan(
                            text: getCoachSurname(customer.coachId),
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // Texte en gras
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.people,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Customers List',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C365D),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 4),
                  Text(
                    'You have ${customers.length} customers.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            exportCustomers(customers);
                          },
                          icon: Icon(Icons.download, size: 18),
                          label: Text('Export'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewCustomerPage()),
                            );
                          },
                          icon: Icon(Icons.add, size: 18),
                          label: Text('Add Customer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher un client...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                onChanged: _filterCustomers,
              ),
            ),
            Expanded(
              child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: _filteredCustomers.isEmpty ? customers.length : _filteredCustomers.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers.isEmpty ? customers[index] : _filteredCustomers[index];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey[200]!),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            '${customer.name} ${customer.surname}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                customer.email,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'view',
                                child: Text('View Details'),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete',
                                style: TextStyle(color: Colors.red)),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'view') {
                                _showCustomerDetails(customer);
                              } else if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditCustomerPage(customer: customer)),
                                );
                              } else if (value == 'delete') {
                                _deleteCustomer(context, customer.id);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}