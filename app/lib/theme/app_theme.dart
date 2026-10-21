import 'package:flutter/material.dart';

// --- アプリ全体の見た目(テーマ) ---
//
// docs/design/README.md の「Design Tokens」で決めた配色・角丸を、
// Flutterのテーマ(ThemeData / ColorScheme)として1か所にまとめたもの。
//
// なぜ1か所にまとめるか:
// 画面ごとに色や角丸を直接書くと、後から配色を変えたい時に全画面を直す必要がある。
// ここにまとめておけば、各画面は「テーマの色を使う」だけで済み、見た目の一貫性も保てる。
//
// フォント(IBM Plex Sans / Noto Sans JP)は、アプリに同梱するか
// 実行時に取得するかの方針が未決定のため、まだ適用していない。

// デザイン見本の色(oklchをhexに変換した値)。
// ColorScheme に入らない色(食事のアクセント、PFCの色など)や、
// const の文字スタイルの中で使いたい色のために、名前付きの定数にしている。
class AppColors {
  AppColors._();

  // ブランドの深緑
  static const primary = Color(0xFF244A45);
  static const primaryPressed = Color(0xFF103833);
  static const primaryContainer = Color(0xFFE6F3F1);
  static const onPrimaryContainer = Color(0xFF18403B);
  static const navPill = Color(0xFFDEEBE9);

  // 食事・補助情報のアクセント(テラコッタ)
  static const meal = Color(0xFF84573E);
  static const mealPressed = Color(0xFF71462E);
  static const mealText = Color(0xFF68432F);
  static const mealContainer = Color(0xFFFDEFE7);

  // PFCのうち、炭水化物の色(たんぱく質=primary、脂質=meal)
  static const carbs = Color(0xFF6B765A);

  static const error = Color(0xFF9C433F);

  // 面・線
  static const background = Color(0xFFF7F5F3);
  static const surface = Color(0xFFFEFDFA);
  static const surfaceVariant = Color(0xFFF7F5F2);
  static const outline = Color(0xFFE6E2DD);
  static const divider = Color(0xFFEFEAE5);
  static const strongOutline = Color(0xFFD4D0CB);
  static const switchOff = Color(0xFFCECAC5);

  // 文字
  static const textPrimary = Color(0xFF272320);
  static const textBody = Color(0xFF2B2825);
  static const textSecondary = Color(0xFF504C48);
  static const textTertiary = Color(0xFF63605C);
}

ThemeData buildAppTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    // 選択中のチップやナビゲーションの「丸い印」に使われる色。
    secondary: AppColors.primaryPressed,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.navPill,
    onSecondaryContainer: AppColors.primaryPressed,
    tertiary: AppColors.meal,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.mealContainer,
    onTertiaryContainer: AppColors.mealText,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textTertiary,
    surfaceContainerLowest: AppColors.surface,
    surfaceContainerLow: AppColors.surface,
    surfaceContainer: AppColors.surfaceVariant,
    surfaceContainerHigh: AppColors.surfaceVariant,
    surfaceContainerHighest: AppColors.divider,
    outline: AppColors.strongOutline,
    outlineVariant: AppColors.outline,
  );

  // 文字スタイルは、標準のテキストテーマを元に作る(TextStyle を単体で書かない)。
  // 単体で書くとフォントの指定が空になり、将来フォントを適用した時に反映されない部分が出るため。
  // フォントを適用する時は、この textTheme を差し替えるだけで全体に反映される。
  final textTheme = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
  ).textTheme;

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: AppColors.background,
    dividerColor: AppColors.divider,
    dividerTheme: const DividerThemeData(color: AppColors.divider),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: textTheme.titleLarge!.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    ),
    // カード: 面の色 + 1pxの枠、影なし、角丸18(デザイン見本の仕様)。
    cardTheme: CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.outline),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.navPill,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.primaryPressed
              : AppColors.textTertiary,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => textTheme.labelMedium!.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: states.contains(WidgetState.selected)
              ? AppColors.primaryPressed
              : AppColors.textTertiary,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(0, 48),
        textStyle: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(0, 48),
        side: const BorderSide(color: AppColors.strongOutline),
        textStyle: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(side: BorderSide(color: AppColors.strongOutline)),
      side: BorderSide(color: AppColors.strongOutline),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : AppColors.switchOff,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      thumbColor: const WidgetStatePropertyAll(Colors.white),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
