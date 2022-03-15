import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medle/controllers/user/controller_user.dart';
import 'package:medle/util/req/requests.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'constant.dart';


String prefix = "https://test.url"; //=> public url
Controller_user user = Get.put(Controller_user());
final box = GetStorage();

Future post({
  String url,
  bool cookie,
  Map body,
  Function onErr,
  Function onRes,
}) async {

  if("${box.read("medleUrl")}".contains("kub.esis.edu.mn"))
    prefix = "https://kub.esis.edu.mn/econtent/";
  else
    prefix = "https://hub.esis.edu.mn/esis/";

  String strUrl = "$prefix$url";
  if (url.contains("http")) strUrl = url;
  print("_______ post: $strUrl");
  SystemChannels.textInput.invokeMethod('TextInput.hide');

  bool connected = false;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    connected = true;
  }
  var headers = {
    "Accept":"application/json",
    "Content-Type": "application/json",
    if(user.user != null) "Authorization":"Bearer ${user.user.token}"};
  print("header1: $headers");
  print("encoded body: ${jsonEncode(body)}");

  if(connected){
    try {
      var response = await Requests.post(
        strUrl,
        persistCookies: cookie ?? true,
        headers: headers,
        body: jsonEncode(body),
      );
      print("${response.statusCode} bn");
      if (response.statusCode == 200) {
        Map res = jsonDecode(response.body);

        switch (res["SUCCESS_CODE"]) {
          case 200:case 205:case 201:onRes(res);break;
          case 203: onErr({"status": 203, "msg": res["RESPONSE_MESSAGE"]});break;
          case 403:case 401:
            Get.toNamed("/main", arguments: PagePublic.login);
            user.tabIndex = 3;
            Get.snackbar("Гарлаа", "Холболт салсан байна, та дахин нэвтэрнэ үү.", snackPosition: SnackPosition.BOTTOM);
            break;
          default:
            onErr(res);
        }
      } else {
        switch (response.statusCode) {
          case 203:
            Map res = jsonDecode(response.body);
            onErr({"status": 203, "msg": res["RESPONSE_MESSAGE"]});break;
          case 500:
            try{
              Map res = jsonDecode(response.body);
              if(res.containsKey("SUCCESS_CODE")){
                if(res["SUCCESS_CODE"] == 401){
                  Get.toNamed("/main", arguments: PagePublic.login);
                  user.tabIndex = 3;
                  Get.snackbar("Гарлаа", "Холболт салсан байна, та дахин нэвтэрнэ үү.", snackPosition: SnackPosition.BOTTOM);
                }else{
                  onErr({"status": 500, "msg": "${res["RESPONSE_MESSAGE"]}"});
                }
              }
            }catch(e){
              onErr({"status": 500, "msg": "Хүсэлт амжилтгүй."});
            }
            print("__>> ${response.body}");
            break;
          case 403:case 401:
            Get.toNamed("/main", arguments: PagePublic.login);
            user.tabIndex = 3;
            Get.snackbar("Гарлаа", "Холболт салсан байна, та дахин нэвтэрнэ үү.", snackPosition: SnackPosition.BOTTOM);
          break;
            break;
          default:
            onErr({"status": 500, "msg": "Хүсэлт амжилтгүй."});
            print("__>> ${response.body}");
            break;
        }
      }
    } on SocketException {
      onErr({"status": 500, "msg": "Алдаа гарлаа. Та дахин оролдоно уу."});
      print('socket exception on post');
    } catch (e) {
      String err = "$e";
      if("$e".contains("imeout"))
        err = "Интернет холболтийн хурдаа шалгана уу.";
      onErr({"status": 500, "msg": "$err"});
    }
  }else{
    onErr({"status": 600, "msg": "Интернет холболт байхгүй байна.\n\nТа утасныхаа тохиргоог шалгана уу."});
  }


}

Future get({String url, Function onErr, Function onRes}) async {

  if("${box.read("medleUrl")}".contains("kub.esis.edu.mn"))
    prefix = "https://kub.esis.edu.mn/econtent/";
  else
    prefix = "https://hub.esis.edu.mn/esis/";

  String strUrl = "$prefix$url";
  if (url.contains("http")) strUrl = url;
  print("_____ getmaa: $strUrl");
  // print("_____ get: TOKEN=> ${user.user.token}");
  SystemChannels.textInput.invokeMethod('TextInput.hide');

  bool connected = false;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    connected = true;
  }

  if(connected){
    try {
      var response = await Requests.get(
        strUrl, persistCookies: true, json: true,
        headers: { "Accept":"application/json", if(user.user != null)"Authorization":"Bearer ${user.user.token}"},
      );
      print("____get status: ${response.statusCode}");
      if (response.statusCode == 200) {
        Map res = jsonDecode(response.body);
        if(res.containsKey("code") && res["code"] == 200){
          onRes(res);
          return;
        }
        print("_____> ${res["SUCCESS_CODE"]}");
        switch (res["SUCCESS_CODE"]) {
          case 200:
            onRes(res);
            break;
          case 205:case 201:onRes({"RESULT": []});break;
          case 203: onErr({"status": 203, "msg": res["RESPONSE_MESSAGE"]});break;
          case 403:case 401:
            Get.toNamed("/main", arguments: PagePublic.login);
            user.tabIndex = 3;
            print("_____logout err: 3");
            Get.snackbar("Гарлаа", "Холболт салсан байна, та дахин нэвтэрнэ үү.", snackPosition: SnackPosition.BOTTOM);
            break;
          default:
            onErr(
                {"status": res["SUCCESS_CODE"], "msg": res["RESPONSE_MESSAGE"]});
        }
      } else {
        switch (response.statusCode) {
          case 201:
          case 205:
            onRes({"RESULT": []});
            break;
          case 203:
            Map res = jsonDecode(response.body);
            onErr({"status": 203, "msg": res["RESPONSE_MESSAGE"]});break;
          case 500:
            Map res = jsonDecode(response.body);
            if(res.containsKey("SUCCESS_CODE") && res["SUCCESS_CODE"] == 401){
              print("_____logout err: 1 $url => $res");
              Get.toNamed("/main", arguments: PagePublic.login);
              user.tabIndex = 3;
              Get.snackbar("Гарлаа", "Холболт салсан байна, та дахин нэвтэрнэ үү.", snackPosition: SnackPosition.BOTTOM);
            }else{
              onErr({"status": 500, "msg": "Хүсэлт амжилтгүй."});
              print("__3>> ${response.body}");
            }
            break;
          case 403:case 401:
            Get.toNamed("/main", arguments: PagePublic.login);
            user.tabIndex = 3;
            print("_____logout err: 2");
            Get.snackbar("Гарлаа", "Холболт салсан байна, та дахин нэвтэрнэ үү.", snackPosition: SnackPosition.BOTTOM);
            break;
          default:
            onErr({
              "status": 500,
              "msg": "Хүсэлт амжилтгүй. ${response.statusCode}"
            });
            print("_4_>> ${response.body}");
            break;
        }
      }
    } catch (e) {
      String err = "$e";
      if("$e".contains("imeout"))
        err = "Интернет холболтийн хурдаа шалгана уу.";
      onErr({"status": 500, "msg": "$err"});
    }
  }else{
    onErr({"status": 600, "msg": "Интернет холболт байхгүй байна.\n\nТа утасныхаа тохиргоог шалгана уу."});
  }
}
