import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login/Loginpage.dart';


class intropages extends StatefulWidget {
  const intropages({super.key});

  @override
  State<intropages> createState() => _intropagesState();
}

class _intropagesState extends State<intropages> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*100,
            width: MediaQuery.of(context).size.width*100,
            child: Image(image: AssetImage('assets/images/a1.png'),fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*20 ,
                  decoration: BoxDecoration(border: Border.all(color:Colors.black),borderRadius: BorderRadius.circular(30)),

                  child: TextButton(onPressed: () {
                    Get.to(Inntro2());

                  }, child: Text('Get Start',style: GoogleFonts.roboto(fontSize: 30,fontWeight: FontWeight.w900),)),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Inntro2() {

    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*100,
            width: MediaQuery.of(context).size.width*100,
            child: Image(image: AssetImage('assets/images/int3.png'),fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*20 ,
                  decoration: BoxDecoration(border: Border.all(color:Colors.black),borderRadius: BorderRadius.circular(30)),

                  child: TextButton(onPressed: () {
                    Get.to(Intro3());

                  }, child: Text('Next',style: GoogleFonts.roboto(fontSize: 30,fontWeight: FontWeight.w900),)),
                ),
              ),
            ),
          )
        ],
      ),
    ));

  }

  Intro3() {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Stack(
        children: [

          SizedBox(
            height: MediaQuery.of(context).size.height*100,
            width: MediaQuery.of(context).size.width*100,
            child: Image(image: AssetImage('assets/images/int2.png'),fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*20 ,
                  decoration: BoxDecoration(border: Border.all(color:Colors.black),borderRadius: BorderRadius.circular(30)),

                  child: TextButton(onPressed: () {
                   Get.offAll(LoginPage());

                  }, child: Text('Shop now',style: GoogleFonts.roboto(fontSize: 30,fontWeight: FontWeight.w900),)),
                ),
              ),
            ),
          ),
          Container(height: MediaQuery.of(context).size.height*0.04,color: Colors.black,),

        ],
      ),
    );
  }


}




