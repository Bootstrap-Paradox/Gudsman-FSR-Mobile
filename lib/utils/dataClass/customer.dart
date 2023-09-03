class CustomerModel {
  final String id;
  final String displayName;
  final Map<String, dynamic> customerData;

  CustomerModel(
      {required this.id,
      required this.displayName,
      required this.customerData});

  // factory CustomerModel.fromJson(Map<String, dynamic> json) {
  //   return CustomerModel(
  //     customer_id: json["id"],
  //     customer_display_name: json["display_name"],
  //     customer_email: json["email"],
  //     customer_phone: json["phone"],
  //   );
  // }

  // static List<CustomerModel> fromJsonList(List list) {
  //   return list.map((item) => CustomerModel.fromJson(item)).toList();
  // }

  // ///this method will prevent the override of toString
  // String userAsString() {
  //   return '#${customer_id} ${customer_display_name}';
  // }

  // ///custom comparing function to check if two users are equal
  // bool isEqual(CustomerModel model) {
  //   return customer_id == model.customer_id;
  // }

  // @override
  // String toString() => customer_id;
}
