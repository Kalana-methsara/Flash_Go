import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';

/// 💡 App එකේ static UI text ඔක්කොම මෙතන එකම තැනකින් manage කරනවා.
/// අලුත් screen එකකට text එකක් ඕන නම්, මෙතනට key එකක් + en/si value එකතු කරලා
/// context.tr('key_name') විදිහට use කරන්න.
class AppStrings {
  static const Map<String, Map<String, String>> _strings = {
    // App-wide
    'app_name': {'en': 'Flash Go', 'si': 'Flash Go'},
    'app_tagline': {
      'en': 'Fastest Campus Errand Network',
      'si': 'වේගවත්ම කැම්පස් Errand Network එක',
    },

    // Login
    'campus_email': {'en': 'Campus Email', 'si': 'කැම්පස් ඊමේල්'},
    'password': {'en': 'Password', 'si': 'මුරපදය'},
    'login': {'en': 'Login', 'si': 'ලොග් වන්න'},
    'no_account': {
      'en': "Don't have an account? Register here",
      'si': 'ගිණුමක් නැද්ද? Register වෙන්න මෙතනින්',
    },
    'enter_email': {'en': 'Please enter your email', 'si': 'Email එක ඇතුළත් කරන්න'},
    'enter_password': {'en': 'Please enter your password', 'si': 'Password එක ඇතුළත් කරන්න'},
    'login_error_generic': {
      'en': 'Something went wrong. Please try again.',
      'si': 'වැරදීමක් සිදුවුණා. නැවත උත්සාහ කරන්න.',
    },
    'login_error_credentials': {
      'en': 'The email or password you entered is incorrect.',
      'si': 'ඇතුළත් කළ Email හෝ Password එක වැරදියි.',
    },
    'login_error_invalid_email': {
      'en': 'The email format is invalid.',
      'si': 'ඇතුළත් කළ Email රටාව වැරදියි.',
    },
    'login_error_disabled': {
      'en': 'This account has been temporarily disabled.',
      'si': 'මෙම ගිණුම තාවකාලිකව අත්හිටුවා ඇත.',
    },

    // Register
    'create_account': {'en': 'Create Account', 'si': 'ගිණුමක් හදන්න'},
    'full_name': {'en': 'Full Name', 'si': 'සම්පූර්ණ නම'},
    'phone_number': {'en': 'Phone Number', 'si': 'දුරකථන අංකය'},
    'sign_up': {'en': 'Sign Up', 'si': 'ලියාපදිංචි වන්න'},
    'enter_name': {'en': 'Please enter your name', 'si': 'ඔයාගේ නම ඇතුළත් කරන්න'},
    'enter_phone': {'en': 'Please enter your phone number', 'si': 'දුරකථන අංකය ඇතුළත් කරන්න'},
    'enter_password_register': {'en': 'Please enter a password', 'si': 'Password එකක් ඇතුළත් කරන්න'},
    'register_error_generic': {'en': 'Registration failed.', 'si': 'ලියාපදිංචි වීම අසාර්ථකයි.'},
    'register_error_email_used': {
      'en': 'This email is already in use.',
      'si': 'මේ Email එක දැනටමත් භාවිතයේ පවතී.',
    },
    'register_error_weak_password': {
      'en': 'Password must be at least 6 characters.',
      'si': 'Password එක අවම වශයෙන් අකුරු 6ක්වත් විය යුතුය.',
    },

    // Bottom nav / dashboard
    'nav_request': {'en': 'Request Errand', 'si': 'Errand එකක් ඉල්ලන්න'},
    'nav_pool': {'en': 'Campus Pool', 'si': 'කැම්පස් Pool'},
    'nav_tracking': {'en': 'Tracking', 'si': 'Tracking'},
    'nav_profile': {'en': 'Profile', 'si': 'Profile'},

    // Create order
    'new_request_title': {'en': 'New Request (Errand)', 'si': 'අලුත් ඉල්ලීමක් (Errand)'},
    'create_order_banner': {
      'en': "Fill in the errand you need done. A nearby campus friend will get it done for you!",
      'si': 'ඔයාට කරගන්න ඕන errand එක ඇතුළත් කරන්න. කැම්පස් එකේ ළඟ ඉන්න යාළුවෙක් ඒක කරලා දේවි!',
    },
    'title_label': {'en': 'What do you need? (Title)', 'si': 'මොකක්ද වෙන්න ඕනේ? (Title)'},
    'title_hint': {
      'en': 'e.g., a chicken rice from the canteen',
      'si': 'e.g., කැන්ටින් එකෙන් චිකන් රයිස් එකක්',
    },
    'desc_label': {'en': 'Description', 'si': 'විස්තරය (Description)'},
    'desc_hint': {
      'en': "Bring the food to IT Lab 2, I'll pay cash.",
      'si': 'කෑම එක අරන් IT Lab 2 එකට ගෙනත් දෙන්න. සල්ලි cash දෙන්නම්.',
    },
    'enter_title': {'en': 'Please fill in this section', 'si': 'කරුණාකර මේ කොටස පුරවන්න'},
    'enter_desc': {'en': 'Please enter a description', 'si': 'විස්තරයක් ඇතුළත් කරන්න'},
    'pickup_label': {'en': 'Pickup Location', 'si': 'බඩු ගන්න ඕන තැන (Pickup Location)'},
    'drop_label': {'en': 'Drop Location', 'si': 'ගෙනත් දෙන්න ඕන තැන (Drop Location)'},
    'pick_on_map': {'en': 'Pick on map', 'si': 'Map එකෙන් තෝරන්න'},
    'tip_label': {'en': 'Tip for Runner (LKR)', 'si': 'Runner ට දෙන ගාස්තුව (Tip Amount - LKR)'},
    'tip_hint': {'en': 'e.g., 150', 'si': 'e.g., 150'},
    'enter_tip': {'en': 'Please enter an amount', 'si': 'ගාස්තුවක් ඇතුළත් කරන්න'},
    'valid_amount': {'en': 'Please enter a valid amount', 'si': 'වලංගු මුදලක් ඇතුළත් කරන්න'},
    'post_to_pool': {'en': 'Post to Campus Pool', 'si': 'Post to Campus Pool'},
    'select_locations_error': {
      'en': 'Please select both pickup and drop locations on the map',
      'si': 'කරුණාකර Pickup සහ Drop location දෙකම map එකෙන් තෝරන්න',
    },
    'please_login_first': {'en': 'Please log in first.', 'si': 'කරුණාකර ප්‍රථමයෙන් ලොග් වන්න.'},
    'order_posted_success': {
      'en': 'Your order was posted to the Campus Pool! 🚀',
      'si': 'Order එක Campus Pool එකට සාර්ථකව එකතු වුණා! 🚀',
    },

    // Campus pool
    'campus_pool_title': {'en': 'Campus Errand Pool', 'si': 'Campus Errand Pool'},
    'no_requests': {
      'en': 'No requests in the pool right now! 😴',
      'si': 'දැනට Pool එකේ කිසිම රික්වෙස්ට් එකක් නැහැ! 😴',
    },
    'accept_errand': {'en': 'Accept Errand 🚀', 'si': 'Accept Errand 🚀'},
    'from_label': {'en': 'From', 'si': 'From'},
    'to_label': {'en': 'To', 'si': 'To'},
    'order_accepted_success': {
      'en': 'You successfully accepted the order! 🚴‍♂️',
      'si': 'ඔයා ඕඩර් එක සාර්ථකව බාරගත්තා! 🚴‍♂️',
    },

    // Active orders
    'active_orders_title': {'en': 'My Active Orders', 'si': 'My Active Orders'},
    'no_active_orders': {
      'en': 'No active orders right now! 🏃‍♂️',
      'si': 'දැනට සක්‍රීය ඇණවුම් කිසිවක් නැත! 🏃‍♂️',
    },
    'status_label': {'en': 'Status', 'si': 'Status'},
    'runner_label': {'en': 'Runner', 'si': 'Runner'},
    'customer_label': {'en': 'Customer', 'si': 'Customer'},

    // Order status
    'order_tracking_title': {'en': 'Order Tracking', 'si': 'Order Tracking'},
    'step_placed_title': {'en': 'Order Placed', 'si': 'Order Placed'},
    'step_placed_sub': {
      'en': 'Your order has been posted successfully.',
      'si': 'ඇණවුම සාර්ථකව පෝස්ට් කර ඇත.',
    },
    'step_accepted_title': {'en': 'Accepted', 'si': 'Accepted'},
    'step_accepted_sub': {
      'en': 'A runner has accepted the order.',
      'si': 'Runner කෙනෙක් ඇණවුම බාරගෙන ඇත.',
    },
    'step_pickedup_title': {'en': 'Picked Up', 'si': 'Picked Up'},
    'step_pickedup_sub': {
      'en': 'The runner is bringing the item.',
      'si': 'Runner භාණ්ඩය රැගෙන එමින් පවතී.',
    },
    'step_delivered_title': {'en': 'Delivered', 'si': 'Delivered'},
    'step_delivered_sub': {
      'en': 'Your order has been delivered. Thank you! 🎉',
      'si': 'ඇණවුම ඔබට ලැබී ඇත. ස්තූතියි! 🎉',
    },
    'picked_up_button': {'en': 'I Picked Up the Item 🛍️', 'si': 'I Picked Up the Item 🛍️'},
    'delivered_button': {'en': 'Mark as Delivered ✅', 'si': 'Mark as Delivered ✅'},

    // Chat
    'live_chat_title': {'en': 'Live Chat 💬', 'si': 'Live Chat 💬'},
    'type_message': {'en': 'Type a message...', 'si': 'මැසේජ් එකක් type කරන්න...'},

    // Location picker
    'pick_location_title': {'en': 'Select a Location', 'si': 'ස්ථානය තෝරන්න'},
    'pick_pickup_title': {'en': 'Select Pickup Location', 'si': 'Pickup ස්ථානය තෝරන්න'},
    'pick_drop_title': {'en': 'Select Drop Location', 'si': 'Drop ස්ථානය තෝරන්න'},
    'location_name_label': {'en': 'Location name', 'si': 'ස්ථානයේ නම'},
    'location_name_hint': {'en': 'e.g. Main Canteen', 'si': 'e.g. Main Canteen'},
    'confirm_location': {'en': 'Confirm this location ✅', 'si': 'මේ ස්ථානය තෝරගන්න ✅'},
    'enter_location_name_error': {
      'en': 'Please give this location a name (e.g. Main Canteen)',
      'si': 'ස්ථානයට නමක් දෙන්න (e.g. Main Canteen)',
    },

    // Order map screen
    'calculating_route': {'en': 'Calculating route...', 'si': 'Route calculate කරමින්...'},
    'approx_straight_line': {'en': 'Approx. straight-line', 'si': 'Approx. straight-line'},
    'pickup_word': {'en': 'Pickup', 'si': 'Pickup'},
    'drop_word': {'en': 'Drop', 'si': 'Drop'},

    // Profile
    'my_profile_title': {'en': 'My Profile', 'si': 'My Profile'},
    'member_tag': {'en': 'Flash Go Student Member', 'si': 'Flash Go Student Member'},
    'contact_number': {'en': 'Contact Number', 'si': 'Contact Number'},
    'dark_theme': {'en': 'Dark Theme Mode', 'si': 'Dark Theme Mode'},
    'language': {'en': 'Language', 'si': 'භාෂාව'},
    'logout': {'en': 'Logout from Account', 'si': 'Logout from Account'},
    'user_not_found': {'en': 'Could not find user details.', 'si': 'යූසර්ගේ විස්තර සොයාගත නොහැකි විය.'},
    'no_name': {'en': 'No name', 'si': 'නමක් නොමැත'},
    'no_email': {'en': 'No email', 'si': 'ඊමේල් නොමැත'},
    'no_phone': {'en': 'No phone number', 'si': 'ෆෝන් අංකයක් නොමැත'},
    'please_login_first_profile': {
      'en': 'Please log in first.',
      'si': 'කරුණාකර ප්‍රථමයෙන් ලොග් වන්න.',
    },
  };

  static String get(BuildContext context, String key) {
    final isSinhala = context.watch<LanguageProvider>().isSinhala;
    final entry = _strings[key];
    if (entry == null) return key;
    return entry[isSinhala ? 'si' : 'en'] ?? entry['en'] ?? key;
  }
}

/// 💡 Usage: context.tr('login')  ->  "Login" හෝ "ලොග් වන්න" language එකට අනුව
extension TrContext on BuildContext {
  String tr(String key) => AppStrings.get(this, key);
}