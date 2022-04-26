# The eventors with Flutter



![flutersqflite](https://user-images.githubusercontent.com/50522333/163177609-e188401d-dafb-408e-af6e-3316d53cef44.png)

Mobile application using Flutter framework and sqflite database


### Home screen

![homescreen](https://user-images.githubusercontent.com/50522333/160896975-e16ba49b-aa8f-432b-afbe-f22ec32db554.png)

Во Home screen има две копче,за логирање и регистрација на корисник.Тие се поставени во еден Column и при клик на копче ке редиректира во содветен page.

```dart
MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    // defining the shape
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
```


### Register screen

![register_screen](https://user-images.githubusercontent.com/50522333/163180331-1be3e412-075f-41bb-bb7d-232abc1dfb86.png)

За да се користи апликацијата прво треба секој корисник да креира свој профил.Доколку внесе username или email што веќе постој во база тогаш ке му пратиме порака дека постој тој username/email,но доколку има профил тој корисник при клик на Login ке го редиректира кај Login page(Sing in).За да ги земаме податоците од input користиме state & formstate.

```dart
//Create text form field
Widget buildUsername() => TextFormField(
        maxLines: 1,
        initialValue: username,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (title) {
          if (title != null && title.isEmpty)
            return 'The username cannot be empty';
          else if (UserDatabase.instance.getByUsername(title!) == -1) {
            return 'The username exists';
          }
        },
        onChanged: onChangedUsername,
      );
```



### Login screen

![login](https://user-images.githubusercontent.com/50522333/160896969-4d5b238e-35a6-424e-b0c3-72962156ef6b.png)

Исто така и кај Sign in користиме state & formstate и проверки дали тој корисник постој,дали лозинка е точен.

```dart
Future login() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final user =
          await UserDatabase.instance.getLogin(this.username, this.password);
      if (user == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', this.username);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EventPage()));
      } else {
        Fluttertoast.showToast(
            msg: "Invalid username or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
```




### Events screen 

| ![events_screen](https://user-images.githubusercontent.com/50522333/160788276-692a0bf9-1bf9-4f98-98f0-a10db178023d.png) | ![events_by_category](https://user-images.githubusercontent.com/50522333/160788266-600ba6cd-245b-4190-83c4-c4d26d3a46b1.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |

Главната страница е Event page каде се листат сите event-и што се креирани од корисниците.Тие се поделни по категории каде во категорија All се листат сите,но за другите ке се листат event-ите според неговата категорија.За избирање на категорија користиме Provider.При клик на event card ке редиректира кај event details.

```dart
Consumer<AppState>(
                        builder: (context, appState, _) => Column(
                          children: <Widget>[
                            for (final event in events!.where((e) =>
                                e.categoryId == appState.selectedCategoryId))
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetailsPage(event: event)));
                                },
                                child: EventWidget(
                                  event: event,
                                ),
                              )
                          ],
                        ),
                      ),
```



### Event details

| ![event_details](https://user-images.githubusercontent.com/50522333/160788234-e546700f-1925-4b2b-90d3-564063c3a2ab.png) | ![detials2](https://user-images.githubusercontent.com/50522333/160805343-7a7db37c-dab0-4360-9ab8-1c11fa88780e.png) | ![going](https://user-images.githubusercontent.com/50522333/160788289-2b7c167d-375a-4ab9-9f88-5e5826a313fe.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |

Во event details се прикажуваат сите информации за event-ите.Исто така користиме и google maps каде при клик на локацијата на event ке се отвара google map.Користиме две копчиња каде секој корисник може да стистне еден од тие копчиња,доколку стисне Going тоа значи дека тој корисник ке оди во тој или доколку стисне Interesed дека е интересиран за тој event.

```dart
addGoingParticipant(int? event) async {
    final participant =
        await ParticipantDatabase.instance.getParticipantByEvent(event);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('username').toString();
    String going = participant.going! + user.toString() + ",";
    setState(() {
      hasPresedGoing = true;
      hasPresedInteresed = false;
    });
    final participantObj = participant.copy(
        eventId: event, going: going, interesed: participant.interesed);
    await ParticipantDatabase.instance.update(participantObj);
  }
```



### Maps

| ![map_event](https://user-images.githubusercontent.com/50522333/160788312-8068c3f6-762e-4710-9147-4896a4429abe.png) | ![all_maps](https://user-images.githubusercontent.com/50522333/160788214-bbf05b7a-a340-4f70-aa74-2fedd92f71d2.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |

Во првата слика се редиректира од Event details доколку корисникот кликува во локација.

Во втората слика при клик на Maps икона во bottomNavigationBar ке редиректира во Map screen каде ке се листат сите локации од сите event-и што постојат во апликацијата.

```dart
 createMarkers() async {
    for (int i = 0; i < this.events.length; i++) {
      var data =
          await Geocoder.local.findAddressesFromQuery(events[i].location);
      double latitude = data.first.coordinates.latitude;
      double longitude = data.first.coordinates.longitude;

      LatLng pos = LatLng(latitude, longitude);
      MarkerId markerId = MarkerId(i.toString());
      Marker marker = Marker(
        markerId: markerId,
        position: pos,
        infoWindow: InfoWindow(
            title: "Event: " + events[i].title,
            snippet: "Start at: " + convertDateTime(events[i].startTime)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      setState(() {
        markers[markerId] = marker;
      });
    }
  }
  
  GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: Set<Marker>.of(markers.values),
            onCameraMove: (came) => createMarkers(),
          )
```



### My created events and profile

| ![my_event_page_new](https://user-images.githubusercontent.com/50522333/163176871-4d5688f0-23aa-4c96-8977-b44b7e088b36.png) | ![profile](https://user-images.githubusercontent.com/50522333/160788342-37e07434-f608-4a63-a4e2-ee5144867419.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |

Во првата слика се прикажуваат сите event-и што сме ги креирале каде може да правиме едитирање или бришење на одреден event

```dart
editEvent() {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventFormPage(event: widget.event),
        ));
  }

  deleteEvent() async {
    await EventDatabase.instance.delete(widget.event.id!);

    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyEvents(),
        ));
  }
```

Во втората слика е нашиот профил каде може да ставиме profile image од камерата,исто така ако сакаме правиме logout тогаш може да го направиме при клик на копчето Log out.

```dart
choiceImage() async {
    var pickedImage =
        await ImagePicker.platform.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      final user = this.userState.copy(
          username: this.userState.username,
          email: this.userState.email,
          password: this.userState.password,
          images: imageData);
      await UserDatabase.instance.update(user);
      this.userState = (await UserDatabase.instance
          .readUserByUsername(this.userState.username))!;
      return imageData;
    } else {
      return null;
    }
  }
  
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext ctx) => HomePage()));
  }
```

### Database

```dart
class CategoryDatabase {
  static final CategoryDatabase instance = CategoryDatabase._init();

  static Database? _database;

  CategoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('eventCategory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableCategory ( 
  ${CateogryFields.id} $idType, 
  ${CateogryFields.name} $textType
  )
''');
  }
  
  Future<Category> create(Category category) async {
    final db = await instance.database;

    final id = await db.insert(tableCategory, category.toJson());

    return category.copy(id: id);
  }
  
  Future<List<Category>> readAllCategories() async {
    final db = await instance.database;
    final result = await db.query(tableCategory);

    return result.map((json) => Category.fromJson(json)).toList();
  }
  
   Future<Category?> readByCategory(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategory,
      columns: CateogryFields.values,
      where: '${CateogryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<int> update(Category category) async {
    final db = await instance.database;

    return db.update(
      tableCategory,
      category.toJson(),
      where: '${CateogryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableCategory,
      where: '${CateogryFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
```



