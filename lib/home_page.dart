import 'package:flutter/material.dart';
import 'location_model.dart';
import 'location_db_service.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Loc> _loclist = [];
  var locationdbservice = LocationDBService();
  var location = Loc();

  @override
  void initState() {
    getLocations();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getLocations() async {
    _loclist = [];
    var locations = await locationdbservice.readLocations();
    locations.forEach((location) {
      setState(() {
        var locationModel = Loc();
        locationModel.lat = location['lat'];
        locationModel.lon = location['lon'];
        locationModel.name = location['name'];
        locationModel.note = location['note'];
        locationModel.id = location['id'];
        _loclist.add(locationModel);
      });
    });
  }

  Widget dnmButton() {
    return Container(
        width: 250,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          clipBehavior: Clip.antiAlias,
          onPressed: () async {
            location.name = "lorem ipsum";
            location.note = "evet ipsum";

            var result = await locationdbservice.saveLocation(location);
            setState(() {
              getLocations();
            });
            print(result);
          },
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.white38, Colors.white70])),
            child: Container(
              constraints: BoxConstraints(maxHeight: 300, minWidth: 50),
              alignment: Alignment.center,
              child: Text(
                "DB DENEME",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  Widget saveButton() {
    return Container(
        width: 250,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          clipBehavior: Clip.antiAlias,
          onPressed: () {},
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.white38, Colors.white70])),
            child: Container(
              constraints: BoxConstraints(maxHeight: 300, minWidth: 50),
              alignment: Alignment.center,
              child: Text(
                "KONUMU KAYDET",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  locationsButton(BuildContext context) {
    return Container(
        width: 250,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          clipBehavior: Clip.antiAlias,
          onPressed: () {
            popUpScreen();
          },
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.white70, Colors.white38])),
            child: Container(
              constraints: BoxConstraints(maxHeight: 300, minWidth: 50),
              alignment: Alignment.center,
              child: Text(
                "KONUMLARIM",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  void popUpScreen() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
                color: Colors.blue[600],
                height: MediaQuery.of(context).size.height * .8,
                child: ListView.builder(
                    itemCount: _loclist.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                          child: Card(
                            child: ListTile(
                              leading: Text(_loclist[index].name),
                              title: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  var result = await locationdbservice
                                      .deleteLocation(_loclist[index].id);
                                  mystate(() {
                                    this._loclist.removeAt(index);
                                  });
                                  if (result > 0) {
                                    Toast.show("Silindi", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                    getLocations();
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ));
                    }));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[300],
        body: Center(
          child: Container(
            padding: EdgeInsets.only(top: 400),
            child: Column(
              children: [
                dnmButton(),
                SizedBox(
                  height: 30,
                ),
                saveButton(),
                SizedBox(
                  height: 30,
                ),
                locationsButton(context)
              ],
            ),
          ),
        ));
  }
}
