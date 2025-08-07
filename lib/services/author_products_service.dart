import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/screens/author_products_layout.dart';
import 'dart:convert';
import 'package:random_please/models/author_product_model.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:random_please/variables.dart';
import 'package:random_please/widgets/generic/generic_settings_helper.dart';

class AuthorProductsService {
  static const String _userAgent = userAgent;

  static Future<void> navigateToAuthorProductsScreen(
      BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    GenericSettingsHelper.showSettings(
        context,
        GenericSettingsConfig(
          title: loc.authorProducts,
          settingsLayout: const AuthorProductsLayout(),
          onSettingsChanged: (newSettings) {},
        ));
  }

  /// Fetch all author products from the endpoint
  static Future<List<AuthorProduct>> fetchAuthorProducts() async {
    try {
      logInfo('Fetching author products from: $authorProductsEndpoint');

      final response = await http.get(
        Uri.parse(authorProductsEndpoint),
        headers: {
          'User-Agent': _userAgent,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final products = jsonList
            .map((json) => AuthorProduct.fromJson(json as Map<String, dynamic>))
            .toList();

        logInfo('Successfully fetched ${products.length} author products');
        return products;
      } else {
        final errorMsg =
            'Failed to fetch author products. Status: ${response.statusCode}';
        logError(errorMsg);
        throw Exception(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Error fetching author products: $e';
      logError(errorMsg);
      throw Exception(errorMsg);
    }
  }

  /// Fetch author products excluding the current app
  static Future<List<AuthorProduct>> fetchOtherAuthorProducts() async {
    try {
      final allProducts = await fetchAuthorProducts();

      // Filter out the current app
      final otherProducts =
          allProducts.where((product) => product.code != appCode).toList();

      logInfo(
          'Filtered ${otherProducts.length} other author products (excluding current app: $appCode)');
      return otherProducts;
    } catch (e) {
      logError('Error fetching other author products: $e');
      rethrow;
    }
  }
}
