import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/ui/addtravel/addtravel_presenter.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AddTravelScreen extends BaseScreen {
  final String id;
  final String activityId;
  AddTravelScreen(AppListener appListener, {this.id, this.activityId})
      : super(appListener);

  @override
  _AddTravelScreenState createState() => _AddTravelScreenState();
}

class _AddTravelScreenState
    extends BaseScreenState<AddTravelScreen, AddTravelPresenter>
    implements AddTravelContract {
  final _locNameController = TextEditingController(),
      _startDateController = TextEditingController(),
      _notesController = TextEditingController(),
      _endDateController = TextEditingController();

  List<ShowUps> showUpList = [];
  List<Sleeping> sleepingList = [];
  List<Flight> flightsList = [];

  bool qDarkmodeEnable= false;

  Travel travel = Travel();
   @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

     checkThemeMode();
  }

  void checkThemeMode() {
    if(Theme.of(context).platform == TargetPlatform.iOS){

      var qdarkMode = MediaQuery.of(context).platformBrightness;
      if (qdarkMode == Brightness.dark){
        setState(() {
          qDarkmodeEnable=true;
        });


      } else {
        setState(() {
          qDarkmodeEnable=false;
        });


      }
    }
  }
  @override
  Widget buildBody() {
    return Container(
      color: Color.fromRGBO(240, 243, 244, 0.5),
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                child: Icon(Icons.arrow_back
                ,color: qDarkmodeEnable?Colors.black:Colors.black87,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Align(
                child: Text(
                  "Add Travel",
                  style: textTheme.headline.apply(
                    color: qDarkmodeEnable?Colors.black:Colors.black87
                  ),
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.center,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Expanded(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Travel To",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _locNameController,
                    onChanged: (s) {
                      travel.location = s;
                    },
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: ""),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Arrival Date",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Select",
                        ),
                      ),
                    ),
                    onTap: () async {
                      DateTime selectedDate = DateTime.now();
                      final DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1953, 8),
                          lastDate: DateTime(2035));
                      if (picked != null && picked != selectedDate)
                        setState(() {
                          selectedDate = picked;
                          travel.startDate =
                              selectedDate.millisecondsSinceEpoch;
                          _startDateController.text =
                              DateFormat('MM-dd-yy').format(selectedDate);
                        });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Arrive Home Date",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Select",
                        ),
                      ),
                    ),
                    onTap: () async {
                      DateTime selectedDate = DateTime.now();
                      final DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1953, 8),
                          lastDate: DateTime(2035));
                      if (picked != null && picked != selectedDate)
                        setState(() {
                          selectedDate = picked;
                          travel.endDate = selectedDate.millisecondsSinceEpoch;
                          _endDateController.text =
                              DateFormat('MM-dd-yy').format(selectedDate);
                        });
                    },
                  ),
                  Padding(padding: EdgeInsets.all(5),),
	                TextField(
		                controller: _notesController,
		                onChanged: (s) {
			                travel.notes = s;
		                },
		                textCapitalization: TextCapitalization.sentences,
		                keyboardType: TextInputType.number,
		                decoration: InputDecoration(
			                border: OutlineInputBorder(),
			                hintText: "Notes",
		                ),
	                ),
                 
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Show Up"),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            showUpList.add(ShowUps());
                          });
                        },
                      )
                    ],
                  ),
                  ListView.builder(
                    itemCount: showUpList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      ShowUps showUp = showUpList[index];
                      final locController = TextEditingController();
                      locController.text = showUp.location;
                      final dateController = TextEditingController();
                      if (showUp.dateTime != null && showUp.dateTime > 0)
                        dateController.text = DateFormat('MM-dd-yy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                showUp.dateTime));
                      final timeController = TextEditingController();
                      if (showUp.dateTime != null && showUp.dateTime > 0)
                        timeController.text = DateFormat('kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                showUp.dateTime));
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: locController,
                                onChanged: (s) {
                                  showUp.location = s;
                                  showUpList[index] = showUp;
                                },
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Location",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              InkWell(
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: dateController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Date",
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  DateTime selectedDate = DateTime.now();
                                  final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(1953, 8),
                                      lastDate: DateTime(2035));
                                  if (picked != null && picked != selectedDate)
                                    setState(() {
                                      selectedDate = picked;
                                      showUp.dateTime =
                                          selectedDate.millisecondsSinceEpoch;
                                      showUpList[index] = showUp;
                                    });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              InkWell(
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: timeController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Time",
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  TimeOfDay selectedDate = TimeOfDay.now();
                                  final TimeOfDay picked = await showTimePicker(
                                      context: context,
                                      initialTime: selectedDate);
                                  if (picked != null && picked != selectedDate)
                                    setState(() {
                                      selectedDate = picked;
                                      DateTime now = DateTime.now();
                                      if (showUp.dateTime != null)
                                        DateTime.fromMillisecondsSinceEpoch(
                                            showUp.dateTime);
                                      showUp.dateTime = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              selectedDate.hour,
                                              selectedDate.minute)
                                          .millisecondsSinceEpoch;
                                      showUpList[index] = showUp;
                                    });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Hotel"),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            sleepingList.add(Sleeping());
                          });
                        },
                      )
                    ],
                  ),
                  ListView.builder(
                    itemCount: sleepingList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      Sleeping sleeping = sleepingList[index];
                      final locController = TextEditingController();
                      locController.text = sleeping.location;
                      final addressController= TextEditingController();
                      addressController.text= sleeping.address;
                      final fromDateController = TextEditingController();
//                      if (sleeping.fromDate != null && sleeping.fromDate > 0)
//                        fromDateController.text = DateFormat('MM-dd-yy').format(
//                            DateTime.fromMillisecondsSinceEpoch(
//                                sleeping.fromDate));
                    final toDateController = TextEditingController();
//                      if (sleeping.toDate != null && sleeping.toDate > 0)
//                        toDateController.text = DateFormat('MM-dd-yy').format(
//                            DateTime.fromMillisecondsSinceEpoch(
//                                sleeping.toDate));
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: locController,
                                onChanged: (s) {
                                  sleeping.location = s;
                                  sleepingList[index] = sleeping;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Hotel",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                               TextField(
                                    controller: fromDateController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Room",
                                    ),
                                    onChanged: (s){
                                      sleeping.room= s;
                                      sleepingList[index]=sleeping;
                                    },
                                  ),

//                                onTap: () async {
//                                  DateTime selectedDate = DateTime.now();
//                                  final DateTime picked = await show(
//                                      context: context,
//                                      initialDate: selectedDate,
//                                      firstDate: DateTime(2015, 8),
//                                      lastDate: DateTime(2101));
//                                  if (picked != null && picked != selectedDate)
//                                    setState(() {
//                                      selectedDate = picked;
//                                      sleeping.fromDate =
//                                          selectedDate.millisecondsSinceEpoch;
//                                      sleepingList[index] = sleeping;
//                                    });
//                                },

                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              TextField(
                                    controller: toDateController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Info",
                                    ),
                                    onChanged: (s){
                                      sleeping.info= s;
                                      sleepingList[index]= sleeping;
                                    },
                                  ),

//                                onTap: () async {
//                                  DateTime selectedDate = DateTime.now();
//                                  final DateTime picked = await show(
//                                      context: context,
//                                      initialDate: selectedDate,
//                                      firstDate: DateTime(2015, 8),
//                                      lastDate: DateTime(2101));
//                                  if (picked != null && picked != selectedDate)
//                                    setState(() {
//                                      selectedDate = picked;
//                                      sleeping.toDate =
//                                          selectedDate.millisecondsSinceEpoch;
//                                      sleepingList[index] = sleeping;
//                                    });
//                                },

                              Padding(padding: EdgeInsets.all(2),),
                              TextField(
                                controller: addressController,
                                textCapitalization: TextCapitalization.words,
                                onChanged: (s) {
                                  sleeping.address = s;
                                  sleepingList[index] = sleeping;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Location (Click + for maps)",
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () async {
//                                      var place =
//                                      await PluginGooglePlacePicker
//                                          .showAutocomplete(
//                                        mode: PlaceAutocompleteMode
//                                            .MODE_OVERLAY,
//                                        countryCode: "US",
//                                        typeFilter: TypeFilter.ESTABLISHMENT,
//                                      );
////                                      latitude = place.latitude;
////                                      longitude = place.longitude;
////                                      _locController.text =
////                                      (place.name + ',' + place.address);
                                    },
                                  ),
//                                  labelText: "Location (Click + for maps)"
//                                      : "",
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                  ),
                                
                                ),
                              
                                style: textTheme.subhead.copyWith(
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Flights"),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            flightsList.add(Flight());
                          });
                        },
                      )
                    ],
                  ),
                  ListView.builder(
                    itemCount: flightsList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      Flight flight = flightsList[index];
                      final _airlineController = TextEditingController();
                      _airlineController.text = flight.airline;
                      final _flightController = TextEditingController();
                      _flightController.text = flight.flight;
                      final _toAirportController = TextEditingController();
                      _toAirportController.text = flight.toAirport;
                      final _fromAirportController = TextEditingController();
                      _fromAirportController.text = flight.fromAirport;
                      final departureDateTimeController =
                          TextEditingController();

                      if (flight.departureDateTime != null &&
                          flight.departureDateTime > 0)
                        departureDateTimeController.text =
                            DateFormat('MM-dd-yy kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    flight.departureDateTime));

                      final arrivalDateTimeController = TextEditingController();
                      if (flight.arrivalDateTime != null &&
                          flight.arrivalDateTime > 0)
                        arrivalDateTimeController.text =
                            DateFormat('MM-dd-yy kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    flight.arrivalDateTime));
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: departureDateTimeController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Departure Date and Time",
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  DateTime selectedDate = DateTime.now();
                                  final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(1953, 8),
                                      lastDate: DateTime(2035));
                                  if (picked != null &&
                                      picked != selectedDate) {
                                    TimeOfDay selectedTime = TimeOfDay.now();
                                    final TimeOfDay pickedTime =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: selectedTime);
                                    if (picked != null &&
                                        pickedTime != selectedTime)
                                      setState(() {
                                        selectedDate = picked;
                                        flight.departureDateTime =
                                            selectedDate.millisecondsSinceEpoch;
                                        flightsList[index] = flight;
                                        selectedTime = pickedTime;
                                        DateTime now =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                flight.departureDateTime);
                                        flight.departureDateTime = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                selectedTime.hour,
                                                selectedTime.minute)
                                            .millisecondsSinceEpoch;
                                        flightsList[index] = flight;
                                      });
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              InkWell(
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: arrivalDateTimeController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Arrival Date Time",
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  DateTime selectedDate = DateTime.now();
                                  final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(1953, 8),
                                      lastDate: DateTime(2035));
                                  if (picked != null &&
                                      picked != selectedDate) {
                                    TimeOfDay selectedTime = TimeOfDay.now();
                                    final TimeOfDay pickedTime =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: selectedTime);
                                    if (picked != null &&
                                        pickedTime != selectedTime)
                                      setState(() {
                                        selectedDate = picked;
                                        flight.arrivalDateTime =
                                            selectedDate.millisecondsSinceEpoch;
                                        flightsList[index] = flight;
                                        selectedTime = pickedTime;
                                        DateTime now =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                flight.departureDateTime);
                                        flight.arrivalDateTime = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                selectedTime.hour,
                                                selectedTime.minute)
                                            .millisecondsSinceEpoch;
                                        flightsList[index] = flight;
                                      });
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              TextField(
                                onChanged: (s) {
                                  flight.airline = s;
                                  flightsList[index] = flight;
                                },
                                controller: _airlineController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Airline",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              TextField(
                                onChanged: (s) {
                                  flight.flight = s;
                                  flightsList[index] = flight;
                                },
                                controller: _flightController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Flight #",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              TextField(
                                onChanged: (s) {
                                  flight.recordLocator = s;
                                  flightsList[index] = flight;
                                },
                                controller: _flightController,
                                textCapitalization:
                                TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Record Locator",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              TextField(
                                onChanged: (s) {
                                  flight.fromAirport = s;
                                  flightsList[index] = flight;
                                },
                                controller: _fromAirportController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Departing Airport",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              TextField(
                                onChanged: (s) {
                                  flight.toAirport = s;
                                  flightsList[index] = flight;
                                },
                                controller: _toAirportController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Arriving Airport",
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  RaisedButton(
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop(travel);
                      });
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  AddTravelPresenter get presenter => AddTravelPresenter(this);

  @override
  void initState() {
    super.initState();
    if (widget.id != null && widget.id.isNotEmpty) {
      presenter.getTravel(widget.activityId, widget.id);
    } else {
      travel.id = randomString(19);
      travel.showupList = showUpList;
      travel.sleepingList = sleepingList;
      travel.flightList = flightsList;
    }
  }

  @override
  void getTravelDetails(Travel res) {
    setState(() {
      travel = res;
      showUpList = res.showupList;
      sleepingList = res.sleepingList;
      flightsList = res.flightList;
      _locNameController.text = res.location;
      _notesController.text = res.notes;
      _startDateController.text = DateFormat('MM-dd-yy')
          .format(DateTime.fromMillisecondsSinceEpoch(travel.startDate));
      _endDateController.text = DateFormat('MM-dd-yy')
          .format(DateTime.fromMillisecondsSinceEpoch(travel.endDate));
    });
  }
}
