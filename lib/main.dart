import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:handpump_supervisor/routes/routes.dart';
import 'package:handpump_supervisor/view/screens/my_work_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/strings.dart';
import 'constant/constants.dart';
import 'package:http/http.dart' as http;
import 'controllers/language_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('SupervisorId');
    print("worknmanager");
    if (userId == null) {
      // User ID is null, skip the task
      return Future.value(true);
    }

    // Initialize the Geolocator and get the location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    String currentAddress=await getFormattedAddress1(position.latitude, position.longitude);
    // Send the location to the server (replace with your own API call)
    await updateUserLocation(position.latitude, position.longitude,currentAddress);

    return Future.value(true);
  });
}
updateUserLocation(double lat,double long,String currentAddress)async{
  // await Future.delayed(Duration(seconds: 120));
  try{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var userId=await prefs.getString('SupervisorId');
    String Url='${Constants.BASE_URL}emp_location';

    if(userId==null){
      return;
    }
    else{
      Map data={
        'user_id': userId,
        'lat': lat, 'log': long, 'address':currentAddress,'date_time':new DateTime.now().toString(),
      };
      print("data ${data}");
      // print("data of loction $data");
      final response=await http.post(Uri.parse(Url),body:json.encode(data),headers: {
        'Content-type':"application/json"
      });
      if(response.statusCode == 200){
        print("Location updated");
      }
      else{
        print("locatino cannont be updated");
      }
    }
  }
  catch(er){
    print("errrorr $er");
    Get.snackbar(
      'Alert',
      'Please try again later.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
getFormattedAddress1(double latitude, double longitude) async {
  print("lat $latitude");
  print("long $longitude");
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Constants.Google_Map_key}'));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    // print("api  data $data");
    if (data['status'] == 'OK' && data['results'].length > 0) {
      var result = data['results'][0];
      var formattedAddress = result['formatted_address'];
      // / print("formated Addres $formattedAddress");
      // address.value = formattedAddress;

      return formattedAddress;

      // for (var component in data['results'][0]['address_components']) {
      //   var types = List<String>.from(component['types']);
      //   if (types.contains('locality')) {
      //     city.value = component['long_name'];
      //   }
      //   if (types.contains('sublocality_level_1')) {
      //     zone.value = component['long_name'];
      //   }
      //   if (types.contains('administrative_area_level_1')) {
      //     state.value = component['long_name'];
      //   }
      // }
    } else {
      print('No results found');
    }
  } else {
    print('Error fetching address');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('SupervisorId');

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    enableVibration: true
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.blue));

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.data!.toString()}');
      _showNotification(message.notification!);
    }
  });

  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   Get.to(MyWorkScreen());
  // });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(userId: userId));
}

Future<void> _showNotification(RemoteNotification notification) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound("claim")
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformChannelSpecifics,
  );
}

class MyApp extends StatelessWidget {
  final String? userId;

  const MyApp({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.to(MyWorkScreen());
    });
    final LanguageController languagecontrollers = Get.put(LanguageController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Handpump Supervisor",
      translations: Strings(),
      locale: languagecontrollers.locale,
      fallbackLocale: Locale('hi', 'IN'),
      supportedLocales: [
        Locale('hi', 'IN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: "/",
      popGesture: true,
      getPages: Routes.getPages,
    );
  }
}
