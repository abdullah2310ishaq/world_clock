import 'package:flutter/material.dart';
import 'package:abdullah2/services/world_time.dart';

void main() => runApp(MaterialApp(home: ChooseLocation()));

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  TextEditingController editingController = TextEditingController();
  late Future<List<WorldTime>> _future; // Add the type explicitly
  String searchString = "";

  @override
  void initState() {
    super.initState();
    _future = WorldTime.getCountriesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          "Choose a Location",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.normal, // Unbold the text
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[900], // Set the background color
        child: Column(
          children: [
            Container(
              color: Colors.grey[900],
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.grey[800], // Set the search bar background color
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchString = value.toLowerCase();
                            });
                          },
                          controller: editingController,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<WorldTime>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final filteredData = snapshot.data!
                        .where((item) =>
                        item.location.toLowerCase().contains(searchString))
                        .toList();

                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.white), // Set the card border color
                          ),
                          color: Colors.grey[900], // Set the card background color
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[800], // Set the circle avatar color
                              child: Text(
                                item.location.substring(0, 1),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            onTap: () async {
                              await item.getTime();
                              Navigator.pop(context, {
                                "location": item.location,
                                "time": item.time,
                                "isDaytime": item.isDaytime,
                                "url": item.url,
                              });
                            },
                            title: Text(
                              item.location,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey[900]!),
                      ),
                    );
                  } else {
                    return Text(
                      "Error!",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
