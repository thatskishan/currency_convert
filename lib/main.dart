import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/api_helper.dart';
import '../models/currency.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? currentVal;
  String? currentValTwo;
  String? amount;
  String? hintFrom;
  String? hintTo;
  int fromVal = 0;
  int toVal = 0;
  String? amountVal;
  @override
  Widget build(BuildContext context) {
    return Currency.isAndroid
        ? MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Simple Currency Converter",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    Switch(
                      value: Currency.isAndroid,
                      onChanged: (val) {
                        setState(() {
                          Currency.isAndroid = val;
                        });
                      },
                    ),
                  ],
                  backgroundColor: Colors.indigoAccent,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amount",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (val) {
                          amount = val;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          labelText: "Amount",
                          labelStyle: GoogleFonts.poppins(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "From",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.indigo,
                            )),
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(10),
                          underline: SizedBox(),
                          icon: const Icon(Icons.pin_drop),
                          menuMaxHeight: 300,
                          hint: Text(
                            hintFrom ?? "From",
                            style: GoogleFonts.poppins(),
                          ),
                          // value: currentVal,
                          items: Currency.myCurrency
                              .map(
                                (e) => DropdownMenuItem(
                                  onTap: () {
                                    setState(() {
                                      hintFrom = e['country'] +
                                          " " +
                                          e['currency_code'];
                                    });
                                  },
                                  value: e['currency_code'],
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e['country']),
                                      Text(e['currency_code']),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(
                              () {
                                currentVal = val.toString();
                                // hintFrom = val.toString();
                                print(currentVal);
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "To",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.indigo,
                            )),
                        child: DropdownButton(
                            borderRadius: BorderRadius.circular(10),
                            underline: SizedBox(),
                            icon: const Icon(Icons.pin_drop),
                            menuMaxHeight: 300,
                            hint: Text(
                              hintTo ?? "To",
                              style: GoogleFonts.poppins(),
                            ),
                            // value: currentValTwo,
                            items: Currency.myCurrency
                                .map(
                                  (e) => DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        hintTo = e['country'] +
                                            " " +
                                            e['currency_code'];
                                      });
                                    },
                                    value: e['currency_code'],
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(e['country']),
                                        Text(e['currency_code']),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                currentValTwo = val.toString();
                                // hintTo = val.toString();
                                print(currentValTwo);
                              });
                            }),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.indigoAccent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Convert",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: ApiHelper.apiHelper.getCurrency(
                              from: "${currentVal}",
                              to: "${currentValTwo}",
                              amount: "${amount}"),
                          builder: (context, snapShot) {
                            if (snapShot.hasError) {
                              return Text("${snapShot.error}");
                            } else if (snapShot.hasData) {
                              Map? p = snapShot.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Exchange Rate",
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${p!['new_amount']}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "${p!['new_currency']}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : CupertinoApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) => CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  backgroundColor: CupertinoColors.link,
                  middle: Text(
                    "Simple Currency Converter",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                    value: Currency.isAndroid,
                    onChanged: (val) {
                      setState(() {
                        Currency.isAndroid = val;
                      });
                    },
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amount",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CupertinoTextField(
                        onChanged: (val) {
                          amountVal = val;
                        },
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: CupertinoColors.link,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "From",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 130,
                        child: CupertinoPicker(
                            itemExtent: 32.5,
                            onSelectedItemChanged: (val) {
                              setState(() {
                                fromVal = val;
                                print(fromVal);
                              });
                            },
                            children: Currency.myCurrency
                                .map((e) => Text(
                                      e['country'],
                                      style: GoogleFonts.poppins(),
                                    ))
                                .toList()),
                      ),
                      Text(
                        "To",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 130,
                        child: CupertinoPicker(
                            itemExtent: 32.5,
                            onSelectedItemChanged: (val) {
                              setState(() {
                                toVal = val;
                                print(toVal);
                              });
                            },
                            children: Currency.myCurrency
                                .map((e) => Text(
                                      e['country'],
                                      style: GoogleFonts.poppins(),
                                    ))
                                .toList()),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.indigoAccent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Convert",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: ApiHelper.apiHelper.getCurrency(
                              from:
                                  "${Currency.myCurrency[fromVal]['currency_code']}",
                              to: "${Currency.myCurrency[toVal]['currency_code']}",
                              amount: "$amountVal"),
                          builder: (context, snapShot) {
                            if (snapShot.hasError) {
                              return Text("${snapShot.error}");
                            } else if (snapShot.hasData) {
                              Map? p = snapShot.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Exchange Rate",
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${p!['new_amount']}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "${p!['new_currency']}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            // return const Center(
                            //   child: CircularProgressIndicator(),
                            // );
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

// import 'package:currency_convert/views/simple_currency_converter.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     routes: {
//       '/': (context) => const SCC(),
//     },
//   ));
// }
