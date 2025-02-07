import 'package:flutter/material.dart';
import 'customer_service.dart';

class NewCustomerPage extends StatefulWidget {
  @override
  _NewCustomerPageState createState() => _NewCustomerPageState();
}

class _NewCustomerPageState extends State<NewCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final CustomerService _customerService = CustomerService();

  String _nom = '';
  String _prenom = '';
  int _age = 0;
  String _sexe = 'Masculin';
  DateTime _dateNaissance = DateTime.now();
  String _telephone = '';
  String _signeAstrologique = 'Lion';
  String _description = '';
  String _email = '';
  String _address = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final customerData = {
        'nom': _nom,
        'prenom': _prenom,
        'age': _age,
        'sexe': _sexe,
        'dateNaissance': _dateNaissance.toIso8601String(),
        'telephone': _telephone,
        'signeAstrologique': _signeAstrologique,
        'description': _description,
        'email': _email,
        'address': _address,
      };

      try {
        final success = await _customerService.createCustomer(customerData);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Client ajouté avec succès!')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'ajout du client.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un client")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildCardSection(
                title: "Informations personnelles",
                children: [
                  _buildTextFormField("Nom", (value) => setState(() => _nom = value)),
                  _buildTextFormField("Prénom", (value) => setState(() => _prenom = value)),
                  _buildTextFormField("Âge", (value) => setState(() => _age = int.tryParse(value) ?? 0), keyboardType: TextInputType.number),
                ],
              ),

              _buildCardSection(
                title: "Détails personnels",
                children: [
                  _buildSexeDropdownField(),
                  _buildDatePickerField(),
                ],
              ),

              _buildCardSection(
                title: "Contact",
                children: [
                  _buildTextFormField("Numéro de téléphone", (value) => setState(() => _telephone = value)),
                  _buildSigneAstrologiqueDropdownField(),
                  _buildTextFormField("Description", (value) => setState(() => _description = value)),
                  _buildTextFormField("Email", (value) => setState(() => _email = value), keyboardType: TextInputType.emailAddress),
                  _buildTextFormField("Adresse", (value) => setState(() => _address = value)),
                ],
              ),

              SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Envoyer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// 🔹 Fonction pour structurer chaque section avec un Card
Widget _buildCardSection({required String title, required List<Widget> children}) {
  return Card(
    margin: EdgeInsets.only(bottom: 16),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[700]),
          ),
          SizedBox(height: 12),
          ...children.map((widget) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: widget,
              )),
        ],
      ),
    ),
  );
}

  // Méthode pour créer une section avec un titre
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[700]),
      ),
    );
  }

  // Méthode pour créer un champ TextFormField
  Widget _buildTextFormField(String label, Function(String) onChanged, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: keyboardType,
        validator: (value) => value!.isEmpty ? 'Veuillez entrer un $label' : null,
        onChanged: onChanged,
      ),
    );
  }

Widget _buildSigneAstrologiqueDropdownField() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      value: _signeAstrologique,
      decoration: InputDecoration(
        labelText: 'Signe astrologique',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: [
        'Bélier', 'Taureau', 'Gémeaux', 'Cancer', 'Lion', 'Vierge', 'Balance', 'Scorpion', 
        'Sagittaire', 'Capricorne', 'Verseau', 'Poissons'
      ].map((signe) {
        return DropdownMenuItem<String>(
          value: signe,
          child: Text(signe),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _signeAstrologique = value!);
      },
      validator: (value) => value == null || value.isEmpty
          ? 'Veuillez sélectionner un signe astrologique'
          : null,
    ),
  );
}

Widget _buildSexeDropdownField() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      value: _sexe,
      decoration: InputDecoration(
        labelText: 'Sexe',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: ['Masculin', 'Féminin', 'Autre'].map((sexe) {
        return DropdownMenuItem<String>(
          value: sexe,
          child: Text(sexe),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _sexe = value!);
      },
      validator: (value) => value == null || value.isEmpty
          ? 'Veuillez sélectionner un sexe'
          : null,
    ),
  );
}

  // Méthode pour créer un champ de sélection de la date de naissance
  Widget _buildDatePickerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Date de naissance',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        controller: TextEditingController(text: '${_dateNaissance.toLocal()}'.split(' ')[0]),
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _dateNaissance,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null && pickedDate != _dateNaissance) {
            setState(() {
              _dateNaissance = pickedDate;
            });
          }
        },
        readOnly: true,
        validator: (value) => value!.isEmpty ? 'Veuillez sélectionner une date' : null,
      ),
    );
  }
}
