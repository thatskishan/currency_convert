import 'package:currency_convert/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/api_helper.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  String? currentVal;
  String? currentValTwo;
  String? amount;
  String? hintFrom;
  String? hintTo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Simple Currency Converter",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton(
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
                            hintFrom = e['country'] + " " + e['currency_code'];
                          });
                        },
                        value: e['currency_code'],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    currentVal = val.toString();
                    // hintFrom = val.toString();
                    print(currentVal);
                  });
                }),
            DropdownButton(
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
                            hintTo = e['country'] + " " + e['currency_code'];
                          });
                        },
                        value: e['currency_code'],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            TextFormField(
              onChanged: (val) {
                setState(() {
                  amount = val;
                });
              },
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
                    return Column(children: [
                      Text("${p!['new_amount']}"),
                    ]);
                  }
                  return const Center(
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
