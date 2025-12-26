import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'premium_service.dart';

class PaymentService extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final PremiumService _premiumService;

  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;

  // IDs dos produtos no Google Play Console
  static const String _basicPlanId = 'premium_basic_monthly';
  static const String _premiumPlanId = 'premium_premium_monthly';
  static const String _enterprisePlanId = 'premium_enterprise_monthly';

  static const Set<String> _productIds = {
    _basicPlanId,
    _premiumPlanId,
    _enterprisePlanId,
  };

  PaymentService(this._premiumService) {
    _init();
  }

  Future<void> _init() async {
    _isAvailable = await _inAppPurchase.isAvailable();

    if (_isAvailable) {
      await _getProducts();
      _listenToPurchaseUpdates();
    }

    notifyListeners();
  }

  Future<void> _getProducts() async {
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(_productIds);

    if (response.error != null) {
      debugPrint('Erro ao carregar produtos: ${response.error}');
      return;
    }

    _products = response.productDetails;
    notifyListeners();
  }

  void _listenToPurchaseUpdates() {
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        debugPrint('Erro no stream de compras: $error');
      },
    );
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    _purchases = purchaseDetailsList;

    for (final purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }

    notifyListeners();
  }

  void _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // Compra pendente - mostrar loading
      debugPrint('Compra pendente: ${purchaseDetails.productID}');
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        // Erro na compra
        debugPrint('Erro na compra: ${purchaseDetails.error}');
        _showErrorDialog(
          'Erro na compra: ${purchaseDetails.error?.message ?? 'Erro desconhecido'}',
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Compra bem-sucedida
        await _deliverProduct(purchaseDetails);
      }

      // Confirmar entrega da compra
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    final productId = purchaseDetails.productID;
    String planName;

    switch (productId) {
      case _basicPlanId:
        planName = 'Básico';
        break;
      case _premiumPlanId:
        planName = 'Premium';
        break;
      case _enterprisePlanId:
        planName = 'Empresarial';
        break;
      default:
        planName = 'Premium';
    }

    // Atualizar status premium
    _premiumService.upgradeToPremium(planName.toLowerCase());

    // Mostrar sucesso
    _showSuccessDialog(
      '🎉 Bem-vindo ao plano $planName!\nVocê agora tem acesso a todos os recursos premium.',
    );

    debugPrint('Produto entregue: $productId');
  }

  Future<bool> buyProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: null,
    );

    try {
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      return success;
    } catch (e) {
      debugPrint('Erro ao iniciar compra: $e');
      _showErrorDialog('Erro ao iniciar compra: $e');
      return false;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      _showSuccessDialog('Compras restauradas com sucesso!');
    } catch (e) {
      debugPrint('Erro ao restaurar compras: $e');
      _showErrorDialog('Erro ao restaurar compras: $e');
    }
  }

  ProductDetails? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Métodos auxiliares para mostrar dialogs
  void _showSuccessDialog(String message) {
    // Este método será chamado do contexto da UI
    debugPrint('Sucesso: $message');
  }

  void _showErrorDialog(String message) {
    // Este método será chamado do contexto da UI
    debugPrint('Erro: $message');
  }

  // Método para definir callbacks de UI (será chamado da tela)
  void setDialogCallbacks({
    required Function(String) onSuccess,
    required Function(String) onError,
  }) {
    // Override dos métodos de dialog
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
