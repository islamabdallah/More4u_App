import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class BenefitRedeemScreen extends StatefulWidget {
  static const routeName = 'BenefitRedeemScreen';

  const BenefitRedeemScreen({Key? key}) : super(key: key);

  @override
  _BenefitRedeemScreenState createState() => _BenefitRedeemScreenState();
}

class _BenefitRedeemScreenState extends State<BenefitRedeemScreen> {
  // List<String> list = ['Java', 'Flutter', 'Kotlin', 'Swift', 'Objective-C'],
  var list =List.generate(500, (index) => '$index name');

    var selected = [];
  late TextEditingController tc;
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    tc = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    const mockResults = <AppProfile>[
      AppProfile('John Doe', 'jdoe@flutter.io',
          'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX4057996.jpg'),
      AppProfile('Paul', 'paul@google.com',
          'https://mbtskoudsalg.com/images/person-stock-image-png.png'),
      AppProfile('Fred', 'fred@google.com',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
      AppProfile('Brian', 'brian@flutter.io',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
      AppProfile('John', 'john@flutter.io',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
      AppProfile('Thomas', 'thomas@flutter.io',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
      AppProfile('Nelly', 'nelly@flutter.io',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
      AppProfile('Marie', 'marie@flutter.io',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
      AppProfile('Charlie', 'charlie@flutter.io',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
      AppProfile('Diana', 'diana@flutter.io',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
      AppProfile('Ernie', 'ernie@flutter.io',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
      AppProfile('Gina', 'fred@flutter.io',
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Redeem Card'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
//         mainAxisSize:MainAxisSize.min,
            children: [

              // ChipsInput<AppProfile>(
              //   initialValue: [
              //     AppProfile('John Doe', 'jdoe@flutter.io',
              //         'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX4057996.jpg')
              //   ],
              //   // decoration: InputDecoration(
              //   //   labelText: "Select People",
              //   // ),
              //   findSuggestions: (String query) {
              //     if (query.length > 2) {
              //       var lowercaseQuery = query.toLowerCase();
              //       return mockResults.where((profile) {
              //         return profile.name
              //                 .toLowerCase()
              //                 .contains(query.toLowerCase()) ||
              //             profile.email.toLowerCase().contains(query.toLowerCase());
              //       }).toList(growable: false)
              //         ..sort((a, b) => a.name
              //             .toLowerCase()
              //             .indexOf(lowercaseQuery)
              //             .compareTo(b.name.toLowerCase().indexOf(lowercaseQuery)));
              //     } else {
              //       return const <AppProfile>[];
              //     }
              //   },
              //   onChanged: (data) {
              //     print(data);
              //   },
              //   chipBuilder: (context, state, profile) {
              //     return InputChip(
              //       key: ObjectKey(profile),
              //       label: Text(profile.name),
              //       avatar: CircleAvatar(
              //         backgroundImage: NetworkImage(profile.imageUrl),
              //       ),
              //       onDeleted: () => state.deleteChip(profile),
              //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //     );
              //   },
              //   suggestionBuilder: (context, state, profile) {
              //     return ListTile(
              //       key: ObjectKey(profile),
              //       leading: CircleAvatar(
              //         backgroundImage: NetworkImage(profile.imageUrl),
              //       ),
              //       title: Text(profile.name),
              //       subtitle: Text(profile.email),
              //       onTap: () => state.selectSuggestion(profile),
              //     );
              //   },
              // ),
              SizedBox(height: 20,),
              ChipsInput<String>(
                decoration: InputDecoration(
                  labelText: "Participants",
                  border: OutlineInputBorder()
                ),
                findSuggestions: (String query) {
                  if (query.length > 0) {
                    var lowercaseQuery = query.toLowerCase();
                    return list.where((name) {
                      return name
                          .toLowerCase()
                          .contains(query.toLowerCase());
                    }).toList(growable: false)
                      ..sort((a, b) => a
                          .toLowerCase()
                          .indexOf(lowercaseQuery)
                          .compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
                  } else {
                    return [];
                  }
                },
                onChanged: (data) {
                  print(data);
                },
                chipBuilder: (context, state, name) {
                  return InputChip(
                    key: ObjectKey(name),
                    label: Text(name),
                    avatar: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile_avatar_placeholder.png'),
                    ),
                    onDeleted: () => state.deleteChip(name),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                },
                suggestionBuilder: (context, state, name) {
                  return ListTile(
                    key: ObjectKey(name),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile_avatar_placeholder.png'),
                    ),
                    title: Text(name),
                    onTap: () => state.selectSuggestion(name),
                  );
                },
              ),
              SizedBox(height: 20,),
              DateTimeField(
                controller: startDate,
                // validator: (value) => deliverDate == null ? translator.translate('required') : null,
                decoration: InputDecoration(
                  hintText: 'Date From',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),                                              contentPadding: EdgeInsets.all(3.0),
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                  ),
                ),
                format:  DateFormat("dd-MM-yyyy"),
                onShowPicker: (context, currentValue) async {
                 return showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  // if (date != null) {
                  //   final time = await showTimePicker(
                  //     context: context,
                  //     initialTime:
                  //     TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  //   );
                  //   return DateTimeField.combine(date, time);
                  // } else {
                  //   return currentValue;
                  // }
                },
                onChanged: (value){
                  setState(() {
                    // deliverDate = value;
                  });
                },
              ),
              SizedBox(height: 20,),
              DateTimeField(
                controller: endDate,
                // validator: (value) => deliverDate == null ? translator.translate('required') : null,
                decoration: InputDecoration(
                  hintText: 'To',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),                                              contentPadding: EdgeInsets.all(3.0),
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                  ),
                ),
                format:  DateFormat("dd-MM-yyyy"),
                onShowPicker: (context, currentValue) async {
                 return showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  // if (date != null) {
                  //   final time = await showTimePicker(
                  //     context: context,
                  //     initialTime:
                  //     TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  //   );
                  //   return DateTimeField.combine(date, time);
                  // } else {
                  //   return currentValue;
                  // }
                },
                onChanged: (value){
                  setState(() {
                    // deliverDate = value;
                  });
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                maxLines: 4,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  label: Text('Message'),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold),
                  // prefixText: 'Question: ',
                 prefixIcon: const Icon(
                    Icons.article,
                    size: 26,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: OutlineInputBorder(),
                  // focusedBorder: InputBorder.none,
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                print(startDate.text);
              }, child: Text('submit'))
            ],
          ),
        ),
      ),
    );
  }
}

class AppProfile {
  final String name;
  final String email;
  final String imageUrl;

  const AppProfile(this.name, this.email, this.imageUrl);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppProfile &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
