import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileWidget extends StatefulWidget {
  static const routeName = 'ProfileWidget';

  const ProfileWidget({Key? key}) : super(key: key);
  ProfileWidgetState createState() => ProfileWidgetState();
}

class ProfileWidgetState extends State<ProfileWidget> {
  String currentLanguage = 'en';
  final List<Map<String, String>> languages = [
    {'name': 'arabic', 'value': 'ar'},
    {'name': 'english', 'value': 'en'}
  ];
  // UserModel userModel = new UserModel();
  String firstLetter = 'A';

  @override
  void initState() {
    // TODO: implement initState
    currentUser();
    super.initState();
  }

  void choiceLanguage(lang) {
    // translator.setNewLanguage(
    //   context,
    //   newLanguage: lang,
    //   remember: true,
    //   restart: true,
    // );
  }

  currentUser() async {
    // var data = await DBHelper.getData('cemex_user');
    // print(data);
    // setState(() {
    //   if (data.length > 0){
    //     userModel = UserModel.fromSqlJson(data[0]);
    //     print(userModel);
    //     firstLetter =  userModel.userName.substring(0,1).toUpperCase();
    //   }
    // });
  }

  @override
  Widget  build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('myAccount',
              style: TextStyle(
                  fontWeight: FontWeight.w400)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
//                  color: Colors.blue,
                    image: DecorationImage(
                        image: AssetImage('assets/images/splash.png'),
                        fit: BoxFit.cover)),
                child: Container(
                  width: double.infinity,
                  height: 170,
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(children: [
                      SizedBox(
                        height: 15,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
//                      backgroundImage: AssetImage(SHHNATY_BACK_GROUND),
                        radius: 60.0,
                        child: Text(firstLetter,
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // userName
                      Text('Abanob',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //userEmail
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                child: Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    elevation: 2.0,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Container(
                            width: 170,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellowAccent,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                     'companyDetails',
                                    style: TextStyle(
                                        letterSpacing: 2.0,
                                        fontWeight: FontWeight.w300),
                                  )
                                ])))),
                alignment:  currentLanguage != 'en'
                    ? Alignment.centerRight : Alignment.centerLeft,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.label,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text('Cemex',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20.0,

                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                        RotatedBox( quarterTurns: 0 ,
                            child:Icon(
                            Icons.call,
                            color: Colors.green,
                          )),
                          SizedBox(
                            width: 7,
                          ),
                          Text('0123',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18.0,

                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.whatshot,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text('flutter',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text('Assiut',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                child: Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    elevation: 2.0,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Container(
                            width: 170,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text('personal',
                                    style: TextStyle(
                                        letterSpacing: 2.0,
                                        fontWeight: FontWeight.w300),
                                  )
                                ])))),
                alignment:  currentLanguage != 'en'
                    ? Alignment.centerRight : Alignment.centerLeft,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.label,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text('Cemex ',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Abanob",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RotatedBox( quarterTurns: 0 ,
                              child:Icon(
                                Icons.call,
                                color: Colors.green,
                              )),
                          SizedBox(
                            width: 7,
                          ),
                          Text('010 ',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                child: Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    elevation: 2.0,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Container(
                            width: 170,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text('settings',
                                    style: TextStyle(
                                        letterSpacing: 2.0,
                                        fontWeight: FontWeight.w300),
                                  )
                                ])))),
                alignment:  currentLanguage != 'en'
                    ? Alignment.centerRight : Alignment.centerLeft,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(children: [
                              Icon(
                                Icons.language,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                currentLanguage != 'en'
                                    ?'arabic'
                                    :'english',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                          ),
                          Expanded(
                            child: PopupMenuButton<String>(
                              child: Text('language',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                  )),
                              onSelected: choiceLanguage,
                              initialValue: currentLanguage,
                              itemBuilder: (BuildContext context) {
                                return languages
                                    .map((Map<String, String> lang) {
                                  return PopupMenuItem<String>(
                                    value: lang['value'],
                                    child:
                                        Text(lang['name']??'',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            )),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                          child: Row(children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            Text('logout',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w400)),
                          ]),
                          onTap: () {
                            // DBHelper.deleteUser(userModel.id);
                            Navigator.pop(context);
                            // Navigator.of(context).pushNamedAndRemoveUntil(LoginWidget.routeName, (Route<dynamic> route) => false);

                          })
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        )));
  }
}
