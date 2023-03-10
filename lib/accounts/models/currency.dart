const tblCurrency = 'Currency',
    colCurrName = 'currName',
    colTheCode = 'theCode',
    colExchangePrice = 'exchangePrice',
    colType = 'type';

class Currency {
  String id, currName;
  num exchange_Price;
  String exchange_type;

  Currency({
    required this.id,
    required this.currName,
    required this.exchange_Price,
    required this.exchange_type,
  });
}
