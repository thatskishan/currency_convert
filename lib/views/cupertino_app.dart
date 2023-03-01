import 'package:currency_convert/models/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/api_helper.dart';

class SCCios extends StatefulWidget {
  const SCCios({Key? key}) : super(key: key);

  @override
  State<SCCios> createState() => _SCCiosState();
}

class _SCCiosState extends State<SCCios> {
  int fromVal = 0;
  int toVal = 0;
  String? amountVal;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
                    from: "${Currency.myCurrency[fromVal]['currency_code']}",
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
    );
  }
}
