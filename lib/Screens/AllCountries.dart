import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'Country.dart';

class AllCountries extends StatefulWidget {
  const AllCountries({Key? key}) : super(key: key);

  @override
  State<AllCountries> createState() => _AllCountriesState();
}

class _AllCountriesState extends State<AllCountries> {
  var count;
  List countries = [];
  List filteredCountries = [];
  bool isSearching = false;
  getCountries() async {
    var response = await Dio().get('https://restcountries.com/v2/all');
    print(response.data.length);
    count = response.data.length;
    return response.data;
  }

  @override
  void initState() {
    getCountries().then((data) {
      setState(() {
        countries = filteredCountries = data;
      });
    });
    super.initState();
  }

  void _filterCountries(value) {
    setState(() {
      filteredCountries = countries
          .where((country) =>
              country['name'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(countries);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: !isSearching
            ? Text('All Countries ')
            : TextField(
                onChanged: (value) {
                  _filterCountries(value); //when changed the function is called
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white),
                    hintText: 'Search Country Here',
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      filteredCountries = countries;
                    });
                  },
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search)),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: filteredCountries.length > 0
            ? ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      // print('hello2');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              Country(filteredCountries[index]),
                        ),
                      );
                    },
                    //style for button
                    // style: ElevatedButton.styleFrom(
                    //     primary: Colors.deepPurpleAccent,
                    //     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    //     textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        child: Text(
                          filteredCountries[index]['name'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
