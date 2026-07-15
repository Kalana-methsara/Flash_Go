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
      'si': 'වේගවත්ම කැම්පස් Errand ජාලය',
    },

    // Login
    'campus_email': {'en': 'Campus Email', 'si': 'කැම්පස් ඊමේල් ලිපිනය'},
    'password': {'en': 'Password', 'si': 'මුරපදය (Password)'},
    'login': {'en': 'Login', 'si': 'ඇතුළු වන්න (Login)'},
    'no_account': {
      'en': "Don't have an account? Register here",
      'si': 'ගිණුමක් නැද්ද? මෙතනින් ලියාපදිංචි වෙන්න',
    },
    'enter_email': {'en': 'Please enter your email', 'si': 'කරුණාකර ඊමේල් ලිපිනය ඇතුළත් කරන්න'},
    'enter_password': {'en': 'Please enter your password', 'si': 'කරුණාකර මුරපදය ඇතුළත් කරන්න'},
    'login_error_generic': {
      'en': 'Something went wrong. Please try again.',
      'si': 'කිසියම් දෝෂයක් සිදු විය. නැවත උත්සාහ කරන්න.',
    },
    'login_error_credentials': {
      'en': 'The email or password you entered is incorrect.',
      'si': 'ඇතුළත් කළ ඊමේල් ලිපිනය හෝ මුරපදය වැරදියි.',
    },
    'login_error_invalid_email': {
      'en': 'The email format is invalid.',
      'si': 'ඇතුළත් කළ ඊමේල් ලිපිනය වලංගු නැත.',
    },
    'login_error_disabled': {
      'en': 'This account has been temporarily disabled.',
      'si': 'මෙම ගිණුම තාවකාලිකව අත්හිටුවා ඇත.',
    },

    // Register
    'create_account': {'en': 'Create Account', 'si': 'ගිණුමක් සාදන්න'},
    'full_name': {'en': 'Full Name', 'si': 'සම්පූර්ණ නම'},
    'phone_number': {'en': 'Phone Number', 'si': 'දුරකථන අංකය'},
    'sign_up': {'en': 'Sign Up', 'si': 'ලියාපදිංචි වන්න'},
    'enter_name': {'en': 'Please enter your name', 'si': 'කරුණාකර ඔබේ නම ඇතුළත් කරන්න'},
    'enter_phone': {'en': 'Please enter your phone number', 'si': 'කරුණාකර දුරකථන අංකය ඇතුළත් කරන්න'},
    'enter_password_register': {'en': 'Please enter a password', 'si': 'කරුණාකර මුරපදයක් ඇතුළත් කරන්න'},
    'register_error_generic': {'en': 'Registration failed.', 'si': 'ලියාපදිංචි වීම අසාර්ථකයි.'},
    'register_error_email_used': {
      'en': 'This email is already in use.',
      'si': 'මෙම ඊමේල් ලිපිනය දැනටමත් භාවිතයේ පවතී.',
    },
    'register_error_weak_password': {
      'en': 'Password must be at least 6 characters.',
      'si': 'මුරපදය සඳහා අවම වශයෙන් අකුරු 6ක්වත් තිබිය යුතුය.',
    },

    // Bottom nav / dashboard
    'nav_request': {'en': 'Request Errand', 'si': 'ඉල්ලීමක් කරන්න'},
    'nav_pool': {'en': 'Campus Pool', 'si': 'කැම්පස් Pool එක'},
    'nav_tracking': {'en': 'Tracking', 'si': 'සොයා බැලීම් (Tracking)'},
    'nav_profile': {'en': 'Profile', 'si': 'මගේ ගිණුම (Profile)'},

    // Create order
    'new_request_title': {'en': 'New Request (Errand)', 'si': 'අලුත් ඉල්ලීමක් (Errand)'},
    'create_order_banner': {
      'en': "Fill in the errand you need done. A nearby campus friend will get it done for you!",
      'si': 'ඔයාට කරගන්න ඕන වැඩේ මෙතන දාන්න. කැම්පස් එකේ ළඟ ඉන්න යාළුවෙක් ඒක කරලා දේවි!',
    },
    'title_label': {'en': 'What do you need? (Title)', 'si': 'මොකක්ද වෙන්න ඕනේ? (මාතෘකාව)'},
    'title_hint': {
      'en': 'e.g., a chicken rice from the canteen',
      'si': 'උදා: කැන්ටිමෙන් චිකන් රයිස් එකක්',
    },
    'desc_label': {'en': 'Description', 'si': 'විස්තරය (Description)'},
    'desc_hint': {
      'en': "Bring the food to IT Lab 2, I'll pay cash.",
      'si': 'කෑම එක IT Lab 2 එකට ගෙනත් දෙන්න. සල්ලි අතට දෙන්නම්.',
    },
    'enter_title': {'en': 'Please fill in this section', 'si': 'කරුණාකර මෙම කොටස පුරවන්න'},
    'enter_desc': {'en': 'Please enter a description', 'si': 'කරුණාකර විස්තරයක් ඇතුළත් කරන්න'},
    'pickup_label': {'en': 'Pickup Location', 'si': 'බඩු ලබාගත යුතු ස්ථානය (Pickup)'},
    'drop_label': {'en': 'Drop Location', 'si': 'ගෙනත් දිය යුතු ස්ථානය (Drop)'},
    'pick_on_map': {'en': 'Pick on map', 'si': 'සිතියමෙන් තෝරන්න (Map)'},
    'tip_label': {'en': 'Tip for Runner (LKR)', 'si': 'Runner ට ගෙවන ගාස්තුව (LKR)'},
    'tip_hint': {'en': 'e.g., 150', 'si': 'උදා: 150'},
    'enter_tip': {'en': 'Please enter an amount', 'si': 'කරුණාකර මුදලක් ඇතුළත් කරන්න'},
    'valid_amount': {'en': 'Please enter a valid amount', 'si': 'කරුණාකර වලංගු මුදලක් ඇතුළත් කරන්න'},
    'post_to_pool': {'en': 'Post to Campus Pool', 'si': 'Campus Pool එකට දාන්න'},
    'select_locations_error': {
      'en': 'Please select both pickup and drop locations on the map',
      'si': 'කරුණාකර Pickup සහ Drop ස්ථාන දෙකම සිතියමෙන් තෝරන්න',
    },
    'please_login_first': {'en': 'Please log in first.', 'si': 'කරුණාකර ප්‍රථමයෙන් ලොග් වන්න.'},
    'order_posted_success': {
      'en': 'Your order was posted to the Campus Pool! 🚀',
      'si': 'ඔබේ ඉල්ලීම සාර්ථකව Campus Pool එකට එකතු කළා! 🚀',
    },

    // Campus pool
    'campus_pool_title': {'en': 'Campus Errand Pool', 'si': 'කැම්පස් Errand Pool එක'},
    'no_requests': {
      'en': 'No requests in the pool right now! 😴',
      'si': 'මේ වෙලාවේ Pool එකේ කිසිම ඉල්ලීමක් නැහැ! 😴',
    },
    'accept_errand': {'en': 'Accept Errand 🚀', 'si': 'වැඩේ බාරගන්න 🚀'},
    'from_label': {'en': 'From', 'si': 'කොහෙන්ද (From)'},
    'to_label': {'en': 'To', 'si': 'කොහාටද (To)'},
    'order_accepted_success': {
      'en': 'You successfully accepted the order! 🚴‍♂️',
      'si': 'ඔයා වැඩේ සාර්ථකව බාරගත්තා! 🚴‍♂️',
    },

    // Active orders
    'active_orders_title': {'en': 'My Active Orders', 'si': 'මගේ සක්‍රීය ඇණවුම්'},
    'no_active_orders': {
      'en': 'No active orders right now! 🏃‍♂️',
      'si': 'දැනට ක්‍රියාත්මක වන ඇණවුම් කිසිවක් නැත! 🏃‍♂️',
    },
    'status_label': {'en': 'Status', 'si': 'තත්ත්වය (Status)'},
    'runner_label': {'en': 'Runner', 'si': 'භාරගත් කෙනා (Runner)'},
    'customer_label': {'en': 'Customer', 'si': 'ඇණවුම්කරු (Customer)'},

    // Order status
    'order_tracking_title': {'en': 'Order Tracking', 'si': 'ඇණවුම සොයා බැලීම'},
    'step_placed_title': {'en': 'Order Placed', 'si': 'ඇණවුම යොමු කළා'},
    'step_placed_sub': {
      'en': 'Your order has been posted successfully.',
      'si': 'ඔබේ ඇණවුම සාර්ථකව පෝස්ට් කර ඇත.',
    },
    'step_accepted_title': {'en': 'Accepted', 'si': 'භාරගත්තා'},
    'step_accepted_sub': {
      'en': 'A runner has accepted the order.',
      'si': 'Runner කෙනෙක් ඇණවුම භාරගෙන ඇත.',
    },
    'step_pickedup_title': {'en': 'Picked Up', 'si': 'ලබාගත්තා'},
    'step_pickedup_sub': {
      'en': 'The runner is bringing the item.',
      'si': 'Runner භාණ්ඩය රැගෙන එමින් පවතී.',
    },
    'step_delivered_title': {'en': 'Delivered', 'si': 'භාරදුන්නා'},
    'step_delivered_sub': {
      'en': 'Your order has been delivered. Thank you! 🎉',
      'si': 'ඔබේ ඇණවුම සාර්ථකව භාරදී ඇත. ස්තූතියි! 🎉',
    },
    'picked_up_button': {'en': 'I Picked Up the Item 🛍️', 'si': 'මම බඩු ටික ලබාගත්තා 🛍️'},
    'delivered_button': {'en': 'Mark as Delivered ✅', 'si': 'භාරදුන් බව සලකුණු කරන්න ✅'},

    // Chat
    'live_chat_title': {'en': 'Live Chat 💬', 'si': 'සජීවී කතාබහ (Chat) 💬'},
    'type_message': {'en': 'Type a message...', 'si': 'පණිවිඩයක් ලියන්න...'},

    // Location picker
    'pick_location_title': {'en': 'Select a Location', 'si': 'ස්ථානයක් තෝරන්න'},
    'pick_pickup_title': {'en': 'Select Pickup Location', 'si': 'ලබාගන්නා ස්ථානය (Pickup) තෝරන්න'},
    'pick_drop_title': {'en': 'Select Drop Location', 'si': 'ගෙනත් දෙන ස්ථානය (Drop) තෝරන්න'},
    'location_name_label': {'en': 'Location name', 'si': 'ස්ථානයේ නම'},
    'location_name_hint': {'en': 'e.g. Main Canteen', 'si': 'උදා: ප්‍රධාන කැන්ටිම'},
    'confirm_location': {'en': 'Confirm this location ✅', 'si': 'මෙම ස්ථානය තහවුරු කරන්න ✅'},
    'enter_location_name_error': {
      'en': 'Please give this location a name (e.g. Main Canteen)',
      'si': 'කරුණාකර මෙම ස්ථානයට නමක් දෙන්න (උදා: ප්‍රධාන කැන්ටිම)',
    },

    // Order map screen
    'calculating_route': {'en': 'Calculating route...', 'si': 'පාර සොයමින් පවතී...'},
    'approx_straight_line': {'en': 'Approx. straight-line', 'si': 'ආසන්න ගුවන් දුර'},
    'pickup_word': {'en': 'Pickup', 'si': 'ලබාගන්නා තැන'},
    'drop_word': {'en': 'Drop', 'si': 'ගෙනත් දෙන තැන'},

    // Profile
    'my_profile_title': {'en': 'My Profile', 'si': 'මගේ ගිණුම'},
    'member_tag': {'en': 'Flash Go Student Member', 'si': 'Flash Go ශිෂ්‍ය සාමාජික'},
    'contact_number': {'en': 'Contact Number', 'si': 'දුරකථන අංකය'},
    'dark_theme': {'en': 'Dark Theme Mode', 'si': 'Dark Theme පහසුකම'},
    'language': {'en': 'Language', 'si': 'භාෂාව (Language)'},
    'logout': {'en': 'Logout from Account', 'si': 'ගිණුමෙන් ඉවත් වන්න (Logout)'},
    'user_not_found': {'en': 'Could not find user details.', 'si': 'පරිශීලක තොරතුරු සොයාගත නොහැකි විය.'},
    'no_name': {'en': 'No name', 'si': 'නමක් සඳහන් කර නැත'},
    'no_email': {'en': 'No email', 'si': 'ඊමේල් ලිපිනයක් නැත'},
    'no_phone': {'en': 'No phone number', 'si': 'දුරකථන අංකයක් නැත'},
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