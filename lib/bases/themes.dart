import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/webservice.dart';

class AppThemes {
  AppThemes._(); // Private constructor to prevent instantiation

  // Constants for BRC theme
  static const Color brc_background = Color(0xFFE09559);
  static const Color brc_textcolor = Color(0xFFFFFFFF);
  static const Color brc_bottom_icon = Color(0xFF433E3F);
  static const Color brc_separation_bar = Color(0xFFF3F3F3);
  static const Color brc_splashbg = Color(0XFFF9F8F7);
  static const Color brc_splashtextcolor = Color(0xFF4B213F);
  static const Color brc_gradient_light_color = Color(0xFFF2CD7A);
  static const Color brc_gradient_dark_color = Color(0xFFE7AD7A);
  static const Color brc_tablebooking_dark_text = Color(0xFF818181);
  static const Color brc_selectyourslot_text = Color(0xFF3C3C43);
  static const Color brc_not_available_bg = Color(0xFFE1E1E1);
  static const Color brc_not_available_bottom_bg = Color(0xFFC9C9C9);
  static const Color brc_spotsbooking_hint_text = Color(0xFF000000);
  static const Color brc_spotsbooking_confirm_booking = Color(0xFF999999);
  static const Color brc_inprogress_color = Color(0xFFD7B439);
  static const Color brc_blocked_color = Color(0xFF888787);
  static const Color brc_mybooking_color = Color(0xFF318457);
  static const Color brc_profilecard_color = Color(0xFFF5F5F5);
  static const Color brc_helpdesk_screen_card_bg = Color(0xFFC4C4C4);
  static const Color brc_helpdesk_text_color = Color(0xFF232743);
  static const Color brc_notification_divider = Color(0xFF4C213F);
  static const Color slider_button_on = Color(0xFF35C75A);
  static const Color slider_button_off = Color(0xFFD2D2D4);
  static const Color dropdown_border = Color(0xFFDADADA);
  static const Color brc_leadership_sepreator = Color(0xFFD9D9D9);
  static const Color brc_otp_success = Color(0xFF4BB543);
  static const Color brc_otp_error = Color(0xFFFF0000);

  // Constants for CSC theme
  static const Color csc_background = Color(0xFFAF1412);
  static const Color csc_textcolor = Color(0x0fffffff);

  // Constants for CSC theme
  static const Color mm_background = Color(0xFFdc2228);
  static const Color mm_light_card = Color.fromARGB(255, 238, 222, 222);

  // Constants for Madhuwan theme
  static const Color madhuwan_background = Color(0xFF2d2d92);
  static const Color madhuwan_home_birthday_card =
      Color.fromARGB(255, 205, 211, 242);

  // Method to get the background color based on appNickname
  static Color getBackground() {
    if (Webservice.appNickname == 'forcempower') {
      return brc_background;
    } else if (Webservice.appNickname == 'madhuban') {
      return madhuwan_background;
    } else if (Webservice.appNickname == 'millenniumMams') {
      return mm_background;
    } else {
      return csc_background;
    }
  }

  static Color getLightColor() {
    if (Webservice.appNickname == 'forcempower') {
      return brc_background;
    } else if (Webservice.appNickname == 'madhuban') {
      return madhuwan_home_birthday_card;
    } else if (Webservice.appNickname == 'millenniumMams') {
      return mm_light_card;
    } else {
      return csc_background;
    }
  }
}
