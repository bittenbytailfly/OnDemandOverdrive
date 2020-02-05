class Subscription {
  final String subscriptionId;
  final int subscriptionTypeId;
  final String value;

  Subscription({this.subscriptionId, this.subscriptionTypeId, this.value});

  factory Subscription.fromJson(Map<String, dynamic> json){
    return Subscription(
      subscriptionId: json['id'],
      subscriptionTypeId: json['type'],
      value: json['value'],
    );
  }
}