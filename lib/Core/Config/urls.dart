class Urls {
  static const baseUrl = 'https://www.shirinibalout.com/api/v1';
  // static const domain = 'https://www.kamancable.ir';

  static const login = '$baseUrl/login_send_code';
  static const submitLogin = '$baseUrl/login';

  static const register = '$baseUrl/client_register';
  static const submitRegister = '$baseUrl/check_code';
  static const resendCode = '$baseUrl/send_code';

  static logout(String phone) => '$baseUrl/logout?phone=$phone';

  static const userData = '$baseUrl/show_myself';
  static const updateUserData = '$baseUrl/update_profile';

  static getCategoryData(String id) => '$baseUrl/get-categories/$id';

  static getProducts(String id, String page) =>
      '$baseUrl/get-products-mobile?category_id=$id&page=$page';
  static getProductsByName(String name, String page) =>
      '$baseUrl/get-products-mobile?name=$name&page=$page';

  static getProduct(String id) => '$baseUrl/get-products-mobile/$id';

  static const addToCart = '$baseUrl/cart/store_product_mobile';
  static const getCart = '$baseUrl/cart/mobile';
  static const getCartCount = '$baseUrl/cart/num_items';

  static deleteCart(String id) {
    return '$baseUrl/cart/destroy_product/$id';
  }

  static const getSubmitCardDatas = '$baseUrl/getData/orderAddress';
  static const getMyOrders = '$baseUrl/client_orders';
  static const getMySpecialOrders = '$baseUrl/special_client_orders';

  static const getSpecialOrderDates =
      '$baseUrl/getData/special_orders/get_date';

  static const getMyDiscounts = '$baseUrl/my_discounts';
  static const checkDiscount = '$baseUrl/discounts/checkDiscountMobile';

  static const getCitiesList = '$baseUrl/getData/cities';
  static getRegionsList(String cityId) {
    return '$baseUrl/getData/districts/$cityId';
  }

  static const addAddress = '$baseUrl/shopping/user_address';
  static updateAddress(String id) => '$baseUrl/user_addresses/$id';
  static deleteAddress(String id) => '$baseUrl/user_addresses/$id';

  static const addSpecialOrder = '$baseUrl/special_client_orders';
  static updateSpecialOrder(String id) => '$baseUrl/special_client_orders/$id';
  static deleteSpecialOrder(String id) => '$baseUrl/special_client_orders/$id';

  static const sendComment = '$baseUrl/feedbacks/store';
  static getComments(String id) => '$baseUrl/feedbacks/$id';

  static const getBranches = '$baseUrl/getData/branches';
  static specialOrderPayment(String id) =>
      'https://shirinibalout.com/user/pay-special-orders/$id';

  // static const getrReadySendProducts =
  //     '$baseUrl/get-products-mobile?preparation=false';

  static getReadySendProducts(String page) =>
      '$baseUrl/get-products-mobile?preparation=false&page=$page';

  // static const login = '$baseUrl/login_send_code';
}
