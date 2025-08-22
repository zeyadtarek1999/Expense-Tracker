class EndPoints {
  static String baseUrl = '';

  static const String exchangeBase = 'https://v6.exchangerate-api.com/v6';

  static String currencyLatestRates(String apiKey, String base) =>
      '$exchangeBase/$apiKey/latest/$base';
}
