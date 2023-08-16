import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controller/CartController.dart';
import '../../model/navigation/nb.dart';

class BuyScreen extends StatefulWidget {
  // final  totalCartPrice;
  final  totalItemsInCart;

  const BuyScreen({
    // required this.totalCartPrice,
    required this.totalItemsInCart,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final selectedPaymentOption = 0.obs;

   // Addeefault to Google Pay

  void _showBottomSheet(CartProvider cartProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {

        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, 
            children: [
              Text(
                'Cart Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Divider(),

              Text("Total Items in Cart: ${widget.totalItemsInCart}"),
              // Text("Total Cost: \$${widget.totalCartPrice}"),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {

                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirm Buy'),

                          content:Column(mainAxisSize: MainAxisSize.min,children: [  Center(
                            child: Text(
                              "Your Payment Is Successful",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                            SizedBox(height: 10),
                            Image.network(
                              'https://s3-alpha-sig.figma.com/img/8005/9c3b/cd4f896e1f6359037e37527b152b5add?Expires=1691971200&Signature=Od6k~O~q5Y1W3nbNozSzAFdI4pc816fm0M9DzLSfjsSL-dX4xdUUvwVPCuM43~R3YRfMNGD~vLbU5saGKISTAwFfz~m81OdcFqyKQhhf4TP0q88H0XxhoRqOLFJbu7atdwmj5CCVl-RRnesqRQWfuF2B0bbBscU5NQnctUpD4-CJwYdfA-pFWslC4KaP-XumcFV34AROXl9Dhj8M1vvtFhwbPRVH7tM0lFaUD3SMys66CZhbW2OLZV6f6Y8KDRwEF0M6FNKzZGLdhg1puc4jetTTNL60fybnHJFZaNLQ9Jkuy~m7Hyyeq0dZ1CRS1X2hnMxQZMbO-1K1WlHh36MqKQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
                              width: 150,
                              height: 150,
                            ),],),
                          actions: [
                            TextButton(
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(46, 184, 197, 0.5019607843137255),)),

                              onPressed: () {

                                Get.back(); // Close the dialog
                              },
                              child: Text('Cancel',style: TextStyle(color: Colors.white)),
                            ),
                        TextButton(
                        onPressed: () async {
                        await cartProvider.moveCartToOrder(
                          addressController.text,
                          mobileController.text,
                          emailController.text,
                          getPaymentMethodName(selectedPaymentOption.value),
                        );
                        Get.off(BottomNavBar()); // Navigate to home screen
                        },
                        child: Text('Shop More', style: TextStyle(color: Colors.white)),
                        ),
                        ]
                        );
                      },
                    );
                  },
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(46, 184, 197, 0.5019607843137255),)),

                  child: Text('Confirm Buy'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // Future<void> _saveShoppingDetails(CartProvider cartProvider) async {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  //
  //   final user = FirebaseAuth.instance.currentUser;
  //   Future<void> saveShoppingDetails({
  //     required String uid,
  //     required String address,
  //     required String mobileNumber,
  //     required String email,
  //     required String paymentMethod,
  //   }) async {
  //     try {
  //       final currentTime = DateTime.now();
  //       final formattedTime = currentTime.toLocal().toString();
  //       await _firestore.collection('Registration')
  //           .doc(user!.uid)
  //           .collection('Order')
  //           .doc(formattedTime).set({
  //         'address': address,
  //         'mobileNumber': mobileNumber,
  //         'email': email,
  //         'paymentMethod': paymentMethod,
  //         'timestamp': FieldValue.serverTimestamp(),
  //       });
  //     } catch (e) {
  //       print('Error saving shopping details: $e');
  //       throw e;
  //     }
  //   }
  //   final String currentUserUid = ''; // Replace with actual user UID
  //
  //   try {
  //     await saveShoppingDetails(
  //       uid: currentUserUid,
  //       address: addressController.text,
  //       mobileNumber: mobileController.text,
  //       email: emailController.text,
  //       paymentMethod: getPaymentMethodName(selectedPaymentOption.value),
  //     );
  //     cartProvider.clearCart(); // Clear cart items
  //   } catch (e) {
  //     print('Error saving shopping details: $e');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
   final cartProvider = Provider.of<CartProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
             IconButton(onPressed: () => Get.back(), icon:Icon(CupertinoIcons.back),color: Colors.black, ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.08,
                    ),

                    Text(
                      "Contact Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),
                    TextFormFieldWithIcon(
                      keytyp: TextInputType.streetAddress,
                      controller: addressController,
                      icon: Icons.location_on,
                      hintText: 'Enter your address', maxlate: 256,
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormFieldWithIcon(
                      keytyp: TextInputType.phone,
                      controller: mobileController,
                      icon: Icons.phone,
                      hintText: 'Enter your mobile number', maxlate: 10,
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormFieldWithIcon(
                      keytyp: TextInputType.emailAddress,

                      controller: emailController,
                      icon: Icons.email,
                      hintText: 'Enter your email', maxlate: 256,
                    ),
                    SizedBox(height: height * 0.05),

                    Center(
                      child: Image.asset(
                        "assets/images/location.png",
                        width: width * 0.9,
                        // height: height*0.15,
                      ),
                    ),

                    SizedBox(height: height * 0.05),
                    Text(
                      "Payment Method",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(() => Column(
                      children: [
                        PaymentMethodRadio(
                          title: 'Google Pay',
                          value: 0,
                          selectedPaymentOption: selectedPaymentOption.value,
                          onChanged: (value) {
                            selectedPaymentOption.value = value!;
                          },
                        ),
                        PaymentMethodRadio(
                          title: 'PayPal',
                          value: 1,
                          selectedPaymentOption: selectedPaymentOption.value,
                          onChanged: (value) {
                            selectedPaymentOption.value = value!;
                          },
                        ),
                        PaymentMethodRadio(
                          title: 'Credit/Debit Card',
                          value: 2,
                          selectedPaymentOption: selectedPaymentOption.value,
                          onChanged: (value) {
                            selectedPaymentOption.value = value!;
                          },
                        ),
                        PaymentMethodRadio(
                          title: 'Cash on Delivery',
                          value: 3,
                          selectedPaymentOption: selectedPaymentOption.value,
                          onChanged: (value) {
                            selectedPaymentOption.value = value!;
                          },
                        ),
                      ],
                    )),
                    SizedBox(height: height * 0.05),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(46, 184, 197, 0.5019607843137255),)),

                        onPressed: (){_showBottomSheet(cartProvider);},
                        child: Text(' Confirm '),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFormFieldWithIcon extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
final int maxlate;

  final TextInputType keytyp;
  TextFormFieldWithIcon(

      {
    required this.icon,
    required this.hintText,
    required this.controller, required this.maxlate, required this.keytyp,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxlate,
      keyboardType: keytyp,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
      ),
    );
  }
}

class PaymentMethodRadio extends StatelessWidget {
  final String title;
  final int value;
  final int selectedPaymentOption;
  final ValueChanged<int?> onChanged; // Change the parameter type here

  PaymentMethodRadio({
    required this.title,
    required this.value,
    required this.selectedPaymentOption,
    required this.onChanged, // Update the parameter type here
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<int>(
      value: value,
      groupValue: selectedPaymentOption,
      onChanged: onChanged,
      title: Text(title),
      secondary: Icon(getPaymentMethodIcon(title)),
    );
  }

  IconData getPaymentMethodIcon(String paymentMethod) {
    switch (paymentMethod) {
      case 'Google Pay':
        return Icons.payment;
      case 'PayPal':
        return Icons.payment;
      case 'Credit/Debit Card':
        return Icons.credit_card;
      case 'Cash on Delivery':
        return Icons.local_shipping;
      default:
        return Icons.payment;
    }
  }
}

String getPaymentMethodName(int paymentMethodValue) {
  switch (paymentMethodValue) {
    case 0:
      return 'Google Pay';
    case 1:
      return 'PayPal';
    case 2:
      return 'Credit/Debit Card';
    case 3:
      return 'Cash on Delivery';
    default:
      return 'Unknown';
  }
}

class FirebaseService {

}