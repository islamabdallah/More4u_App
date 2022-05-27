import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';
import '../../domain/entities/benefit.dart';
import '../benefit_details/beneifit_detailed_screen.dart';
import '../benefit_redeem/BenefitRedeemScreen.dart';

class BenefitCard extends StatelessWidget {
  final Benefit benefit;
  const BenefitCard({Key? key, required this.benefit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, BenefitDetailedScreen.routeName,arguments: benefit);
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
                  benefit.name,
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
                      benefit.benefitType,
                      style: TextStyle(color: mainColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: Text(
                  '${benefit.timesEmployeeReceiveThisBenefit}/${benefit.times}',
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
                      onPressed: benefit != null
                          ? (benefit.employeeCanRedeem
                          ? () {
                        Navigator.pushNamed(context,
                            BenefitRedeemScreen.routeName,arguments: benefit);
                      }
                          : null)
                          : null,
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
