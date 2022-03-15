import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';


Future<void> backgroundHandler(RemoteMessage message) async{
  print("_______background1: ${message.data.toString()}");

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await FlutterDownloader.initialize();

  runApp(Medle());
}

class Medle extends StatefulWidget {
  @override
  _MedleState createState() => _MedleState();
}

class _MedleState extends State<Medle> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  Controller_download download = Get.put(Controller_download(), permanent: true);
  //=====================================================================================
  CtrlConnect ctrl1 = Get.put(CtrlConnect(), permanent: true,);
  CtrlMedleUser ctrl2 = Get.put(CtrlMedleUser(), permanent: true);
  CtrlStart ctrl3 = Get.put(CtrlStart(), permanent: true);
  CtrlParentJournal ctrl4 = Get.put(CtrlParentJournal(), permanent: true);
  CtrlParentLesson ctrl5 = Get.put(CtrlParentLesson(), permanent: true);
  CtrlParentSchedule ctrl6 = Get.put(CtrlParentSchedule(), permanent: true);
  CtrlStudentJournal ctrl7 = Get.put(CtrlStudentJournal(), permanent: true);
  CtrlStudentLesson ctrl8 = Get.put(CtrlStudentLesson(), permanent: true);
  CtrlStudentSchedule ctrl9 = Get.put(CtrlStudentSchedule(), permanent: true);
  Controller_teacher_content ctrl10 = Get.put(Controller_teacher_content(), permanent: true);
  Controller_teacher_play ctrl11 = Get.put(Controller_teacher_play(), permanent: true);
  CtrlTeacherClass ctrl12 = Get.put(CtrlTeacherClass(), permanent: true);
  CtrlTeacherClassInput ctrl13 = Get.put(CtrlTeacherClassInput(), permanent: true);
  CtrlTeacherProfile ctrl14 = Get.put(CtrlTeacherProfile(), permanent: true);
  CtrlTeacherSchedule ctrl15 = Get.put(CtrlTeacherSchedule(), permanent: true);
  CtrlTeacherScheduleInput ctrl16 = Get.put(CtrlTeacherScheduleInput(), permanent: true);
  CtrlTeacherScheduleMy ctrl17 = Get.put(CtrlTeacherScheduleMy(), permanent: true);
  Controller_user ctrl18 = Get.put(Controller_user(), permanent: true);
  Controller_book ctrl19 = Get.put(Controller_book(), permanent: true);
  Controller_book_chapter ctrl20 = Get.put(Controller_book_chapter(), permanent: true);
  Controller_book_page ctrl21 = Get.put(Controller_book_page(), permanent: true);
  Controller_content_play ctrl22 = Get.put(Controller_content_play(), permanent: true);

  Controller_interactive ctrl24 = Get.put(Controller_interactive(), permanent: true);
  Controller_lesson ctrl25 = Get.put(Controller_lesson(), permanent: true);
  Controller_level ctrl26 = Get.put(Controller_level(), permanent: true,);
  Controller_subject ctrl27 = Get.put(Controller_subject(), permanent: true);
  Controller_version ctrl28 = Get.put(Controller_version(), permanent: true);
  Controller_video ctrl29 = Get.put(Controller_video(), permanent: true);
  CtrlAdditionalContent ctrl30 = Get.put(CtrlAdditionalContent(), permanent: true);
  CtrlSearch ctrl31 = Get.put(CtrlSearch(), permanent: true);
  Controller_tele_schedule ctrl32 = Get.put(Controller_tele_schedule(), permanent: true);
  CtrlGuide ctrl33 = Get.put(CtrlGuide(), permanent: true);
  CtrlDebug ctrl34 = Get.put(CtrlDebug(), permanent: true);
  CtrlPush ctrl35 = Get.put(CtrlPush(), permanent: true);
  CtrlLab ctrl36 = Get.put(CtrlLab(), permanent: true);
  //=====================================================================================
  ReceivePort _port = ReceivePort();
  // FirebaseAnalytics analytics = FirebaseAnalytics();
  GetStorage box = GetStorage();

  void initState() {
    super.initState();

    print("route: '${Get.currentRoute}'");
    FirebaseMessaging.instance.subscribeToTopic("medle");

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        print("_________after init, get msg from background handler1: ${message.notification}");
        box.write("push_data", message.data);
        if(Get.currentRoute != "/" && Get.currentRoute != "/news" && Get.currentRoute != ""){
          if(box.hasData("push_data")){
            print("changing route from initialMessage ===> route: '${Get.currentRoute}'");
            Get.toNamed("/news");
          }
        };
        // LocalNotificationService.display(message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        print("______foreground1: ${message.data}");
        Get.snackbar(
            message.notification.title,
            message.notification.body,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.black,
            icon: Image.asset("images/ic_read_appbar.png"),
            backgroundGradient: LinearGradient(colors: [Color(0xffeecda3), Color(0xffef629f)]),
            shouldIconPulse: true,
            onTap: (GetBar){
              print("___msg foreground: ${message.data}");
            }
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      print("__________background but not closed1: ${message.notification.toString()}");
      box.write("push_data", message.data);
      if(Get.currentRoute != "/" || Get.currentRoute != "/news" || Get.currentRoute != ""){
        if(box.hasData("push_data")){
          print("changing route from on msg open");
          Get.toNamed("/news");
        }
      };
      // LocalNotificationService.display(message);
    });

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      download.progress = "$progress";
      download.loading = "${status.value}" != "3";
      setState(() {});
    });

    // FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      // _source.keys.toList()[0] == ConnectivityResult.none
      //   ? OfflineScreen()
      GetMaterialApp(
        navigatorObservers: [
          // FirebaseAnalyticsObserver(analytics: analytics),
        ],
        enableLog: false,
        title: 'Medle',
        defaultTransition: Transition.fade,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.transparent,
              elevation: 3,
            ),
            tabBarTheme: TabBarTheme(),
            dialogTheme: DialogTheme(
              elevation: 3,
              backgroundColor: Colors.transparent,
            ),
            fontFamily: 'Lato'
        ),
        initialRoute: "/",
        getPages: [
          GetPage(name: '/', page: () => Asplash()),//A_landing()),//A_splash()
          //==================MEDLE======================
          GetPage(name: '/news', page: () => Anews()),
          //=============================================
          GetPage(name: '/medle', page: () => Amain()),
          //=============================================
          GetPage(name: '/medle_tele_more', page: () => AteleMore()),
          GetPage(name: '/medle_tele_videos', page: () => AteleVideos()),
          GetPage(name: '/medle_tele_specific', page: () => AteleSpecific()),
          GetPage(name: '/medle_tele_schedule', page: () => AteleSchedule()),
          //=============================================
          GetPage(name: '/medle_book_specific', page: () => AbookSpecific()),
          GetPage(name: '/medle_book_more', page: () => AbookMore()),
          GetPage(name: '/medle_book_read', page: () => AbookRead()),
          GetPage(name: '/medle_book_read_pdf_online', page: () => AbookReadPdf()),
          GetPage(name: '/medle_book_read_specific', page: () => AbookReadSpecific()),
          //=============================================
          GetPage(name: '/medle_subject_more', page: () => AsubjectMore()),
          GetPage(name: '/medle_subject_specific', page: () => AsubjectSpecific()),
          GetPage(name: '/medle_subject_detail', page: () => AsubjectDetail()),
          GetPage(name: '/medle_subject_play', page: () => AsubjectPlay()),
          //=============================================
          GetPage(name: '/medle_additional_content', page: () => AadditionalSpecific()),
          //=============================================
          GetPage(name: '/medle_interactive_more', page: () => AinteractiveMore()),
          GetPage(name: '/medle_test', page: () => Atest()),
          //=============================================
          GetPage(name: '/medle_guide', page: () => Aguide()),
          GetPage(name: '/medle_guide_more', page: () => AguideMore()),
          //=============================================
          GetPage(name: '/lab_more', page: () => AlabMore()),
          GetPage(name: '/lab', page: () => Alab()),
          //=============================================
          //=============================================
          //=============================================
          //=============================================
        ],
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        showSemanticsDebugger: false,
        // home: A_splash(),
      );
  }
}
