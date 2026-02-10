// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cwsn/core/theme/app_theme.dart';
// import 'package:cwsn/core/widgets/pill_scaffold.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart'; // Ensure this is imported

import 'package:flutter/material.dart';

class ParentEditProfilePage extends StatelessWidget {
  const ParentEditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: const Center(child: Text("Parent Edit Profile Page")),
    );
  }
}

// class ParentEditProfilePage extends StatefulWidget {
//   const ParentEditProfilePage({super.key});

//   @override
//   State<ParentEditProfilePage> createState() => _ParentEditProfilePageState();
// }

// class _ParentEditProfilePageState extends State<ParentEditProfilePage> {
//   // Controllers
//   final _nameController = TextEditingController(text: "Mahender Sharma");
//   final _locationController = TextEditingController(
//     text: "Hostel 17, IIT Bombay",
//   );
//   final _phoneController = TextEditingController(text: "+91 9813409151");

//   // State
//   String _selectedGender = "Male";
//   List<String> _selectedLanguages = ["Hindi", "English"];
//   bool _isVerifyingPhone = false;

//   final List<String> _allLanguages = [
//     "Hindi",
//     "English",
//     "Marathi",
//     "Tamil",
//     "Telugu",
//     "Kannada",
//     "Malayalam",
//     "Bengali",
//     "Gujarati",
//     "Punjabi",
//   ];

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _locationController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   // --- ACTIONS ---

//   void _showLanguageSelector() async {
//     final List<String>? result = await showDialog(
//       context: context,
//       builder: (context) => _LanguageSelectionDialog(
//         allLanguages: _allLanguages,
//         selectedLanguages: _selectedLanguages,
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         _selectedLanguages = result;
//       });
//     }
//   }

//   void _initiatePhoneChange() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => _PhoneVerificationSheet(
//         currentPhone: _phoneController.text,
//         onVerified: (newPhone) {
//           setState(() {
//             _phoneController.text = newPhone;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Phone Number Verified & Updated!")),
//           );
//         },
//       ),
//     );
//   }

//   void _detectLocation() async {
//     // Simulate location fetching
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Row(
//           children: [
//             SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(width: 16),
//             Text("Fetching current location..."),
//           ],
//         ),
//         duration: Duration(seconds: 1),
//       ),
//     );

//     await Future.delayed(const Duration(seconds: 2)); // Simulating delay

//     if (mounted) {
//       setState(() {
//         _locationController.text = "Powai, Mumbai, Maharashtra 400076";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = context.colorScheme.primary;

//     return PillScaffold(
//       title: 'Edit Profile',
//       actionIcon: Icons.check_rounded,
//       onActionPressed: () {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
//       },

//       body: (context, padding) => SingleChildScrollView(
//         padding: padding.copyWith(left: 24, right: 24, bottom: 40),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             // --- AVATAR ---
//             Center(
//               child: Stack(
//                 children: [
//                   Container(
//                     width: 110,
//                     height: 110,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 4),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       backgroundColor: Colors.grey.shade100,
//                       backgroundImage: const CachedNetworkImageProvider(
//                         "https://i.pravatar.cc/300?img=12",
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: primaryColor,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 3),
//                       ),
//                       child: const Icon(
//                         Icons.camera_alt_rounded,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

//             const SizedBox(height: 40),

//             Column(
//               children: [
//                 // 1. Name
//                 _buildPillInput(
//                   label: "Full Name",
//                   controller: _nameController,
//                   icon: Icons.person_outline_rounded,
//                   delay: 100,
//                 ),
//                 const SizedBox(height: 20),

//                 // 2. Location with "Detect" button
//                 _buildLocationInput(delay: 200),
//                 const SizedBox(height: 20),

//                 // 3. Gender Dropdown
//                 _buildPillDropdown(
//                   label: "Gender",
//                   value: _selectedGender,
//                   items: ["Male", "Female", "Other"],
//                   onChanged: (val) => setState(() => _selectedGender = val!),
//                   icon: Icons.wc_rounded,
//                   delay: 300,
//                 ),
//                 const SizedBox(height: 20),

//                 // 4. Phone with Verification Logic
//                 _buildPhoneInput(delay: 400),
//                 const SizedBox(height: 20),

//                 // 5. Language Selector (Clickable Pill)
//                 _buildLanguageSelector(delay: 500),
//               ],
//             ),

//             const SizedBox(height: 40),

//             // SAVE BUTTON
//             SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryColor,
//                   foregroundColor: Colors.white,
//                   elevation: 10,
//                   shadowColor: primaryColor.withOpacity(0.4),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: const Text(
//                   "Save Changes",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ).animate().fade(delay: 600.ms).slideY(begin: 0.5, end: 0),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- WIDGETS ---

//   Widget _buildPillInput({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//     TextInputType? keyboardType,
//     int delay = 0,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF1D1617).withOpacity(0.05),
//             offset: const Offset(0, 4),
//             blurRadius: 16,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         style: const TextStyle(
//           fontWeight: FontWeight.w600,
//           color: Colors.black87,
//         ),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//           prefixIcon: Icon(
//             icon,
//             color: context.colorScheme.secondary,
//             size: 22,
//           ),
//           prefixIconConstraints: const BoxConstraints(minWidth: 40),
//         ),
//       ),
//     ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
//   }

//   Widget _buildLocationInput({int delay = 0}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF1D1617).withOpacity(0.05),
//             offset: const Offset(0, 4),
//             blurRadius: 16,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               controller: _locationController,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 labelText: "Location",
//                 labelStyle: TextStyle(
//                   color: Colors.grey.shade500,
//                   fontSize: 14,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.location_on_outlined,
//                   color: context.colorScheme.secondary,
//                   size: 22,
//                 ),
//                 prefixIconConstraints: const BoxConstraints(minWidth: 40),
//               ),
//             ),
//           ),
//           // Detect Button
//           IconButton(
//             onPressed: _detectLocation,
//             icon: Icon(
//               Icons.my_location_rounded,
//               color: context.colorScheme.primary,
//             ),
//             tooltip: "Use Current Location",
//           ),
//         ],
//       ),
//     ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
//   }

//   Widget _buildPhoneInput({int delay = 0}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF1D1617).withOpacity(0.05),
//             offset: const Offset(0, 4),
//             blurRadius: 16,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               controller: _phoneController,
//               readOnly: true, // Lock editing
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade700,
//               ),
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 labelText: "Phone Number",
//                 labelStyle: TextStyle(
//                   color: Colors.grey.shade500,
//                   fontSize: 14,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.phone_outlined,
//                   color: context.colorScheme.secondary,
//                   size: 22,
//                 ),
//                 prefixIconConstraints: const BoxConstraints(minWidth: 40),
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: _initiatePhoneChange,
//             child: Text(
//               "CHANGE",
//               style: TextStyle(
//                 color: context.colorScheme.primary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
//   }

//   Widget _buildLanguageSelector({int delay = 0}) {
//     final text = _selectedLanguages.isEmpty
//         ? "Select Languages"
//         : _selectedLanguages.join(", ");

//     return GestureDetector(
//       onTap: _showLanguageSelector,
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF1D1617).withOpacity(0.05),
//               offset: const Offset(0, 4),
//               blurRadius: 16,
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.translate_rounded,
//                   color: context.colorScheme.secondary,
//                   size: 22,
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   "Languages Spoken",
//                   style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.only(left: 34),
//               child: Text(
//                 text,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
//   }

//   Widget _buildPillDropdown({
//     required String label,
//     required String value,
//     required List<String> items,
//     required Function(String?) onChanged,
//     required IconData icon,
//     int delay = 0,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF1D1617).withOpacity(0.05),
//             offset: const Offset(0, 4),
//             blurRadius: 16,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         items: items.map((String item) {
//           return DropdownMenuItem(
//             value: item,
//             child: Text(
//               item,
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           );
//         }).toList(),
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//           prefixIcon: Icon(
//             icon,
//             color: context.colorScheme.secondary,
//             size: 22,
//           ),
//           prefixIconConstraints: const BoxConstraints(minWidth: 40),
//         ),
//         icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
//       ),
//     ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
//   }
// }

// // --- SUB-COMPONENTS ---

// class _LanguageSelectionDialog extends StatefulWidget {
//   final List<String> allLanguages;
//   final List<String> selectedLanguages;

//   const _LanguageSelectionDialog({
//     required this.allLanguages,
//     required this.selectedLanguages,
//   });

//   @override
//   State<_LanguageSelectionDialog> createState() =>
//       _LanguageSelectionDialogState();
// }

// class _LanguageSelectionDialogState extends State<_LanguageSelectionDialog> {
//   late List<String> _tempSelected;

//   @override
//   void initState() {
//     super.initState();
//     _tempSelected = List.from(widget.selectedLanguages);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Select Languages"),
//       content: SingleChildScrollView(
//         child: Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: widget.allLanguages.map((lang) {
//             final isSelected = _tempSelected.contains(lang);
//             return FilterChip(
//               label: Text(lang),
//               selected: isSelected,
//               onSelected: (selected) {
//                 setState(() {
//                   if (selected) {
//                     _tempSelected.add(lang);
//                   } else {
//                     _tempSelected.remove(lang);
//                   }
//                 });
//               },
//               selectedColor: context.colorScheme.primary.withOpacity(0.2),
//               checkmarkColor: context.colorScheme.primary,
//             );
//           }).toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel"),
//         ),
//         TextButton(
//           onPressed: () => Navigator.pop(context, _tempSelected),
//           child: const Text(
//             "Done",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PhoneVerificationSheet extends StatefulWidget {
//   final String currentPhone;
//   final Function(String) onVerified;

//   const _PhoneVerificationSheet({
//     required this.currentPhone,
//     required this.onVerified,
//   });

//   @override
//   State<_PhoneVerificationSheet> createState() =>
//       _PhoneVerificationSheetState();
// }

// class _PhoneVerificationSheetState extends State<_PhoneVerificationSheet> {
//   final _newPhoneController = TextEditingController();
//   final _otpController = TextEditingController();
//   int _step = 1; // 1: Enter Phone, 2: Enter OTP
//   bool _isLoading = false;

//   void _sendOtp() async {
//     if (_newPhoneController.text.length < 10) return;
//     setState(() => _isLoading = true);
//     await Future.delayed(const Duration(seconds: 1)); // Simulate API
//     setState(() {
//       _isLoading = false;
//       _step = 2;
//     });
//   }

//   void _verifyOtp() async {
//     if (_otpController.text.length < 4) return;
//     setState(() => _isLoading = true);
//     await Future.delayed(const Duration(seconds: 1)); // Simulate API

//     if (mounted) {
//       widget.onVerified(_newPhoneController.text);
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         left: 24,
//         right: 24,
//         top: 24,
//       ),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             _step == 1 ? "Update Phone Number" : "Verify OTP",
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),

//           if (_step == 1) ...[
//             TextField(
//               controller: _newPhoneController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: "New Phone Number",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.phone),
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _sendOtp,
//                 child: _isLoading
//                     ? const SpinKitThreeBounce(color: Colors.white, size: 20)
//                     : const Text("Send Verification Code"),
//               ),
//             ),
//           ] else ...[
//             Text("Enter the code sent to ${_newPhoneController.text}"),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 24, letterSpacing: 8),
//               maxLength: 6,
//               decoration: const InputDecoration(
//                 hintText: "000000",
//                 border: OutlineInputBorder(),
//                 counterText: "",
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _verifyOtp,
//                 child: _isLoading
//                     ? const SpinKitThreeBounce(color: Colors.white, size: 20)
//                     : const Text("Verify & Update"),
//               ),
//             ),
//           ],
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
