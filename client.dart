import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:3000';

Future<void> main() async {
  print("Client HTTP Dart pour le TP");
  
  while (true) {
    print("\nMenu:");
    print("1. Lister les produits");
    print("2. Ajouter un produit");
    print("3. Lister les commandes");
    print("4. Créer une commande");
    print("5. Quitter");
    stdout.write("Votre choix: ");
    
    final choice = stdin.readLineSync();
    
    try {
      switch (choice) {
        case '1':
          await getProducts();
          break;
        case '2':
          await addProduct();
          break;
        case '3':
          await getOrders();
          break;
        case '4':
          await addOrder();
          break;
        case '5':
          exit(0);
        default:
          print("Choix invalide");
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }
}

// Fonctions pour les produits
Future<void> getProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/products'));
  
  if (response.statusCode == 200) {
    final products = jsonDecode(response.body) as List;
    print("\nListe des produits:");
    products.forEach((p) => print(" - ${p['name']}: ${p['price']}€"));
  } else {
    print("Erreur ${response.statusCode}");
  }
}

Future<void> addProduct() async {
  stdout.write("Nom du produit: ");
  final name = stdin.readLineSync();
  
  stdout.write("Prix: ");
  final price = double.tryParse(stdin.readLineSync() ?? '0') ?? 0.0;

  final response = await http.post(
    Uri.parse('$baseUrl/products'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': name, 'price': price}),
  );
  
  print(response.statusCode == 201 
      ? "Produit ajouté!" 
      : "Erreur ${response.statusCode}");
}

// Fonctions pour les commandes
Future<void> getOrders() async {
  final response = await http.get(Uri.parse('$baseUrl/orders'));
  
  if (response.statusCode == 200) {
    final orders = jsonDecode(response.body) as List;
    print("\nListe des commandes:");
    orders.forEach((o) => print(" - ${o['product']} x${o['quantity']}"));
  } else {
    print("Erreur ${response.statusCode}");
  }
}

Future<void> addOrder() async {
  stdout.write("Nom du produit: ");
  final product = stdin.readLineSync();
  
  stdout.write("Quantité: ");
  final quantity = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

  final response = await http.post(
    Uri.parse('$baseUrl/orders'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'product': product, 'quantity': quantity}),
  );
  
  print(response.statusCode == 201 
      ? "Commande créée!" 
      : "Erreur ${response.statusCode}");
} 