import 'dart:io';
import 'package:app_flutter/customers/customer_model.dart';
import 'package:app_flutter/customers/customer_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

extension CustomerExport on CustomerService {

Future<void> exportCustomersToCsv(BuildContext context, List<CustomerDTO> customers) async {
  try {
    // Vérification de la permission d'accès au stockage
    if (await Permission.storage.request().isGranted) {
      // Préparer les en-têtes du CSV
      List<List<dynamic>> csvData = [
        ['Name', 'Surname', 'Email', 'Phone Number', 'Birth Date', 'Gender', 'Address', 'Coach ID']
      ];

      // Ajouter les données des clients
      for (var customer in customers) {
        csvData.add([
          customer.name,
          customer.surname,
          customer.email,
          customer.phoneNumber,
          customer.birthDate.toIso8601String(),
          customer.gender,
          customer.address,
          customer.coachId
        ]);
      }

      // Convertir en chaîne CSV
      String csv = const ListToCsvConverter().convert(csvData);

      // Obtenir le répertoire de stockage des documents de l'application
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/customers.csv');

      // Écrire le CSV dans le fichier
      await file.writeAsString(csv);

      // Partager le fichier CSV
      await Share.shareXFiles([XFile(file.path)], subject: 'Customers Export');

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exportation réussie : ${customers.length} clients exportés')),
      );
    } else {
      // Si la permission est refusée
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied to access storage')),
      );
    }
  } catch (e) {
    // Gérer les erreurs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de l\'exportation : $e')),
    );
  }
}

}
