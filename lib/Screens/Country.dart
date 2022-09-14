import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:numeral/numeral.dart';

import 'CountryMap.dart';

class Country extends StatelessWidget {
  final Map country;
  Country(this.country);

  @override
  Widget build(BuildContext context) {
    var checkCapital;
    var checkPopulation;
    var checkFlag;
    var checkCurrency;
    var checkRegion;
    var checkNativeName;
    var checkTimeZone;
    var checkLanguages = ' ';
    bool isFlag = false;
    var errorInfo;
    var checkLatLang = false;

    if (country['latlng'] == null) {
      checkLatLang = true;
    }

    if (country['capital'] == null) {
      checkCapital = 'Capital not found in data';
    } else {
      checkCapital = country['capital'];
    }
    if (country['name'] == 'Antarctica') {
      checkCurrency = 'Currency not found in data';
    } else if (country['currencies'][0]['name'] == null) {
      checkCurrency = 'Currency not found in data';
    } else {
      checkCurrency = country['currencies'][0]['name'] +
          " '" +
          country['currencies'][0]['symbol'] +
          "'";
    }

    // var population;
    // population = Numeral(country['population']).format();
    if (country['population'] == null) {
      checkPopulation = 'Population not found in data';
    } else {
      checkPopulation = Numeral(country['population']).format();
    }

    if (country['region'] == null) {
      checkRegion = 'Region not found in data';
    } else {
      checkRegion = country['region'];
    }

    if (country['nativeName'] == null) {
      checkNativeName = 'Native Name not found in data';
    } else {
      checkNativeName = country['nativeName'];
    }

    if (country['flag'] == null) {
      checkFlag = 'Flag not found in data';
    } else {
      try {
        checkFlag = SvgPicture.network(country['flag'], width: 200);
        print('************HERE CHECK: ' + country['flag']);
      } catch (e) {
        isFlag = true;
        errorInfo = Error();
        print("************************* HEREEE: " + errorInfo);
      }
    }

    if (country['timezones'] == null) {
      checkTimeZone = 'Time Zone not found in data';
    } else {
      checkTimeZone = country['timezones'].toString();
    }

    if (country['languages'] == null) {
      checkLanguages = 'Languages not found in data';
    } else {
      var le = country['languages'].length;
      for (int i = 0; i < le; i++) {
        checkLanguages = checkLanguages +
            " " +
            country['languages'][i]['name'].toString() +
            ". ";
      }
      // checkLanguages =  country['languages'].toString();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(country['name']),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: <Widget>[
            FlipCard(
              front: CountryCard(title: 'Capital'),
              back: CountryDetailCard(title: checkCapital),
            ),
            FlipCard(
              front: CountryCard(title: 'Population'),
              back: CountryDetailCard(title: checkPopulation.toString()),
            ),
            FlipCard(
              front: CountryCard(title: 'Currency'),
              back: CountryDetailCard(title: checkCurrency),
            ),
            FlipCard(
              front: CountryCard(title: 'Flag'),
              back: Card(
                color: Colors.blueAccent,
                elevation: 10,
                child: Center(
                    child:
                        !isFlag ? checkFlag : Text('Flag Not Found in Data')),
              ),
            ),
            FlipCard(
              front: CountryCard(title: 'Continent/Region'),
              back: CountryDetailCard(title: checkRegion),
            ),
            FlipCard(
              front: CountryCard(title: 'Native Name'),
              back: CountryDetailCard(title: checkNativeName),
            ),
            FlipCard(
              front: CountryCard(title: 'Time Zone'),
              back: CountryDetailCard(title: checkTimeZone),
            ),
            FlipCard(
              front: CountryCard(title: 'Languages'),
              back: CountryDetailCard(title: checkLanguages),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => CountryMap(country['name'], //passes country's name and latlang in country map screen
                          !checkLatLang ? country['latlng'] : [0.0, 0.0] //if its null it passes latlng 0.0, 0.0 so it wont throw null error
                      ),
                    ),
                  );
                }, //hello
                child: CountryCard(title: 'Show On Map')),
            //back: CountryDetailCard(title: 'hello'),
          ],
        ),
      ),
    );
  }
}

class CountryDetailCard extends StatelessWidget {
  final String title;

  const CountryDetailCard({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      elevation: 10,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CountryCard extends StatelessWidget {
  final String title;

  const CountryCard({
    Key? key, //? used so the key is not required to be added as a parameter
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Center(
          child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
    );
  }
}
