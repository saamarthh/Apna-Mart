import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apna_mart/controllers/models.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _cartProducts = [];
  List<Product> get cartProducts => _cartProducts;

  List<Category> _category = [];
  List<Category> get category => _category;

  List<Product> _categoryProducts = [];
  List<Product> get categoryProducts => _categoryProducts;



  double totalCost = 0;
  double deliveryCost = 0;
  bool hasMoreItems = true;
  int itemsPerPage = 8;
  DocumentSnapshot<Map<String, dynamic>>? lastDocument;

  // Read all grocery items from Firestore
  Future<void> fetchProduct() async {
    try {
      final List<Product> loadedProduct = [];
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('quantity', isEqualTo: 1)
          .get();
      snapshot.docs.forEach((doc) {
        loadedProduct.add(
          Product(
              id: doc['id'],
              name: doc['name'],
              quantity: doc['quantity'],
              our_price: doc['our_price'],
              image: doc['image'],
              category: doc['category'],
              mrp_price: doc['mrp_price']),
        );
      });
      _products = loadedProduct;
      // notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> setProductList(QuerySnapshot<Map<String, dynamic>> snapshot) async {
    try {
      final List<Product> loadedProduct = [];
      snapshot.docs.forEach((doc) {
        loadedProduct.add(
          Product(
              id: doc['id'],
              name: doc['name'],
              quantity: doc['quantity'],
              our_price: doc['our_price'],
              image: doc['image'],
              category: doc['category'],
              mrp_price: doc['mrp_price']),
        );
      });
      _products = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void setDeliveryCost() {
    if (totalCost < 700) {
      deliveryCost = 40;
      totalCost += deliveryCost;
    } else {
      deliveryCost = 0;
      totalCost += deliveryCost;
    }
    notifyListeners();
  }

  Future<void> fetchPaginatedProducts() async {
    try {
      List<Product> paginatedProducts = [];
      DocumentSnapshot<Map<String, dynamic>>? lastProduct = lastDocument;
      if (!hasMoreItems) {
        return; // No need to fetch more if there are no more items
      }

      var query = FirebaseFirestore.instance
          .collection('products')
          .orderBy('name')
          .limit(itemsPerPage);

      if (lastProduct != null) {
        query = query.startAfterDocument(lastProduct);
      }

      var querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastProduct = querySnapshot.docs.last;
        paginatedProducts.addAll(
            querySnapshot.docs.map((doc) => Product.fromMap(doc.data())));

        if (querySnapshot.docs.length < itemsPerPage) {
          hasMoreItems = false; // No more items to load
        }
        lastDocument = lastProduct;
        print(lastProduct.id);
        print(paginatedProducts.length);
      } else {
        hasMoreItems = false;
      }
      paginatedProducts.forEach((element) {
        _products.add(element);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchCategory() async {
    try {
      final List<Category> loadedCategory = [];
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('category').get();
      snapshot.docs.forEach((doc) {
        loadedCategory.add(Category(
            categoryName: doc['categoryName'],
            categoryImage: doc['categoryImage']));
      });
      _category = loadedCategory;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchCategoryProduct(QuerySnapshot<Map<String, dynamic>> snapshot) async {
    final List<Product> loadedProduct = [];
    try {
      // final QuerySnapshot snapshot = await FirebaseFirestore.instance
      //     .collection('products')
      //     .where('category', isEqualTo: category)
      //     .where('quantity', isEqualTo: 1)
      //     .get();
      snapshot.docs.forEach((doc) {
        loadedProduct.add(
          Product(
              id: doc['id'],
              name: doc['name'],
              quantity: doc['quantity'],
              our_price: doc['our_price'],
              image: doc['image'],
              category: doc['category'],
              mrp_price: doc['mrp_price']),
        );
      });
    } catch (error) {
      print(error);
    }
    _categoryProducts = loadedProduct;
    notifyListeners();
  }

  void totalPrice() {
    double orderPrice = 0;
    try {
      _cartProducts.forEach((item) {
        orderPrice += (item.our_price * item.quantity);
      });
    } catch (error) {
      print(error);
    }
    totalCost = orderPrice;
    notifyListeners();
  }

  Future<void> fetchCart() async {
    try {
      final List<Product> loadedProduct = [];
      var snapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      snapshot.docs.forEach((doc) {
        loadedProduct.add(
          Product(
              id: doc['id'],
              name: doc['productName'],
              quantity: doc['quantity'],
              our_price: doc['our_price'],
              image: doc['image'],
              category: doc['category'],
              mrp_price: doc['mrp_price']),
        );
      });
      _cartProducts = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void emptyCart() {
    _cartProducts = [];
    notifyListeners();
  }

  void increaseQuantity(int index) {
    List<Product> tempCart = _cartProducts;
    tempCart[index].quantity += 1;
    _cartProducts = tempCart;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    List<Product> tempCart = _cartProducts;
    tempCart[index].quantity =
        tempCart[index].quantity <= 0 ? 0 : tempCart[index].quantity - 1;
    if (tempCart[index].quantity == 0) {
      tempCart.removeAt(index);
    }
    _cartProducts = tempCart;
    notifyListeners();
  }
}
