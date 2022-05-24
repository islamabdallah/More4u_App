import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';
import '../benefit_details/beneifit_detailed_screen.dart';

class BenefitCard extends StatelessWidget {
  const BenefitCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, BenefitDetailedScreen.routeName);
        },
        child: Card(
          elevation: 8,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                child: Image.asset(
                  'assets/images/hbd.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: Text(
                  'BD benifit',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.token,
                      size: 18,
                      color: mainColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Indivisual',
                      style: TextStyle(color: mainColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: Text(
                  '0/3',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16,right: 16, bottom: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('Redeem'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
