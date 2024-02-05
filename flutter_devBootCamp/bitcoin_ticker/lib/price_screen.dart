import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }
    // return dropdownItems;
    return DropdownButton<String>(
      value: selectedCurrency,
      // items: getDropDownItems(),
      items: dropdownItems,
      onChanged: (value) {
        setState(
          () {
            if (value != null) selectedCurrency = value;
            print(value);
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> currecies = [Text('USD')];

    for (String currency in currenciesList) {
      currecies.add(
        Text(currency),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: currecies,
    );
  }

  List<Text> getSimpleCurrencyList() {
    List<Text> currecies = [];
    for (String currency in currenciesList) {
      currecies.add(
        Text(currency),
      );
    }
    return currecies;
  }

  List<DropdownMenuItem<String>> getDropDownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }
    return dropdownItems;
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else // if (Platform.isAndroid) {
      return androidDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ? USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: androidDropdown(),
            // child: getPicker(),
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            // children: [
            //   Text('USD'),
            //   Text('CAD'),
            //   Text('JPY'),
            //   Text('USD'),
            //   Text('CAD'),
            //   Text('JPY'),
            // ],
          )
          // child: DropdownButton<String>(
          //   value: selectedCurrency,
          //   items: getDropDownItems(), // [
          //
          //   // DropdownMenuItem(
          //   //   child: Text('USD'),
          //   //   value: 'USD',
          //   // ),
          //   // DropdownMenuItem(
          //   //   child: Text('JPY'),
          //   //   value: 'JPY',
          //   // ),
          //   // DropdownMenuItem(
          //   //   child: Text('GBP'),
          //   //   value: 'GBP',
          //   // ),
          //   //],
          //   onChanged: (value) {
          //     print(value);
          //     setState(
          //       () {
          //         if (value != null) selectedCurrency = value;
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
