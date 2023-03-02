import '../../Features/Profile/Screens/privacy.dart';
import '../../Features/Profile/Screens/special_order_details.dart';
import 'package:flutter/material.dart';

import '../../Features/Auth/Screens/signin.dart';
import '../../Features/Auth/Screens/signup.dart';
import '../../Features/General/Screens/home.dart';
import '../../Features/General/Screens/search.dart';
import '../../Features/Product/Screens/category.dart';
import '../../Features/Product/Screens/product_details.dart';
import '../../Features/Product/Screens/products_list.dart';
import '../../Features/Product/Screens/special_cake.dart';
import '../../Features/Profile/Screens/dashboard.dart';
import '../../Features/Profile/Screens/my_discounts.dart';
import '../../Features/Profile/Screens/my_orders.dart';
import '../../Features/Profile/Screens/my_special_orders.dart';
import '../../Features/Profile/Screens/order_details.dart';
import '../../Features/Profile/Screens/profile.dart';
import '../../Features/Shop/Screens/payment.dart';
import '../../Features/Shop/Screens/select_address.dart';
import '../../Features/Shop/Screens/shop_card.dart';

class Routes {
  static const signIn = '/signIn';
  static const signUp = '/signUp';

  static const home = '/home';
  static const search = '/search';

  static const category = '/category';
  static const productDetails = '/productDetails';
  static const specialCake = '/specialCake';
  static const productList = '/productList';

  static const dashboard = '/dashboard';
  static const myDiscounts = '/myDiscounts';
  static const myOrders = '/myOrders';
  static const mySpecialOrders = '/mySpecialOrders';
  static const mySpecialOrder = '/mySpecialOrder';

  static const orderDetails = '/orderDetails';
  static const profile = '/profile';
  static const privacy = '/privacy';

  static const shopCard = '/shopCard';
  static const selectAddress = '/selectAddress';
  static const payment = '/payment';

  final Map<String, Widget Function(BuildContext)> appRoutes = {
    Routes.signIn: (ctx) => SignInScreen(),
    Routes.signUp: (ctx) => SignUpScreen(),
    Routes.home: (ctx) => HomeScreen(),
    Routes.search: (ctx) => SearchScreen(),
    Routes.category: (ctx) => CategoryScreen(),
    Routes.productDetails: (ctx) => ProductDetailsScreen(),
    Routes.specialCake: (ctx) => SpecialCakeScreen(),
    Routes.productList: (ctx) => ProductListScreen(),
    Routes.dashboard: (ctx) => DashboardScreen(),
    Routes.myDiscounts: (ctx) => MyDiscountsScreen(),
    Routes.myOrders: (ctx) => MyOrdersScreen(),
    Routes.mySpecialOrders: (ctx) => MySpecialOrdersScreen(),
    Routes.mySpecialOrder: (ctx) => SpecialOrderDetailsScreen(),
    Routes.orderDetails: (ctx) => OrderDetailsScreen(),
    Routes.profile: (ctx) => ProfileScreen(),
    Routes.privacy: (ctx) => PrivacyScreen(),
    Routes.shopCard: (ctx) => ShopCardScreen(),
    Routes.selectAddress: (ctx) => SelectAddressScreen(),
    Routes.payment: (ctx) => PaymentScreen(),
  };
}
