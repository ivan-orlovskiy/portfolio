extension IconExtension on String {
  String get iconPath => switch (this) {
        'air' => 'assets/list_icons/air.svg',
        'attachment' => 'assets/list_icons/attachment.svg',
        'basket' => 'assets/list_icons/basket.svg',
        'basketball' => 'assets/list_icons/basketball.svg',
        'bell' => 'assets/list_icons/bell.svg',
        'cart' => 'assets/list_icons/cart.svg',
        'heart' => 'assets/list_icons/heart.svg',
        'snow' => 'assets/list_icons/snow.svg',
        _ => 'assets/list_icons/cart.svg',
      };
}
