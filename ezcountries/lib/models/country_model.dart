class CountryModel {
  String? code, currency, emoji, emojiU, name, native, phone;
  CountryModel(
      {this.code,
      this.currency,
      this.emoji,
      this.emojiU,
      this.name,
      this.native,
      this.phone});
  CountryModel.fromJson(Map<String, dynamic>? json) {
    code = json?['code'];
    currency = json?['currency'];
    emoji = json?['emoji'];
    name = json?['name'];
    native = json?['native'];
    phone = json?['phone'];
  }
}
