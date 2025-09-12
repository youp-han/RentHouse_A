enum Currency {
  krw('원화 (KRW)', '원', '₩'),
  usd('달러 (USD)', '달러', '\$'),
  eur('유로 (EUR)', '유로', '€'),
  jpy('엔화 (JPY)', '엔', '¥');

  const Currency(this.displayName, this.shortName, this.symbol);
  
  final String displayName;
  final String shortName;
  final String symbol;
}