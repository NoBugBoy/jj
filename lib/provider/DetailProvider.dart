import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class DetailProvider extends ChangeNotifier{
  HttpClient httpClient;
  List<dynamic> jsonArray;
  List<dynamic> jjjlList;
  List<String> syl;
  DetailProvider(String code){
    httpClient = new HttpClient();
    this.syl = List();
    this.jjjlList = List();
    getList(code);
  }

  @override
  void dispose() {

  }

  Future getList(String code) {
    Future f = rquestList(code);
    f.then((value) =>
    {
//      jsonArray = value,
      notifyListeners()
    });
  }
    Future<List<dynamic>> rquestList(String code) async {
      //http://fund.eastmoney.com/pingzhongdata/161725.js?v=20210116135354
      Uri uri = Uri.parse(
          "http://fund.eastmoney.com/pingzhongdata/"+code+".js?v=20210116135354");
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      String responseBody = await response.transform(utf8.decoder).join();
      String newStr = responseBody.substring(17);
      newStr = newStr.substring(0, newStr.length - 3);
      int over = newStr.indexOf("var Data_ACWorthTrend") - 11;
      int begin = newStr.indexOf("Data_netWorthTrend = ") + 21;
      String str = newStr.substring(begin, over);
      jsonArray = json.decode(str).reversed.toList();
      int over1 = newStr.indexOf("Data_fundSharesPositions")-17;
      int begin1 = newStr.indexOf("syl_1n")+8;
      var info = newStr.substring(begin1,over1).replaceAll('/*近6月收益率*/var syl_6y="', '').replaceAll('/*近三月收益率*/var syl_3y="', "").replaceAll('/*近一月收益率*/var syl_1y="', "");
      this.syl = info.split('";');
//      print(this.syl);
      int over2 = newStr.indexOf("*申购赎回*")-3;
      int begin2 = newStr.indexOf("Data_currentFundManager")+25;
      var jjjl = newStr.substring(begin2,over2);
      this.jjjlList = json.decode(jjjl);
      return   jsonArray.reversed.toList();
////    print(split.length);
//    int i =0;
//    List<Map> list = List();
//    for (String value in split) {
//      if(i%2 == 0){
//        List<String> model = value.split(",");
//        Map m = new Map();
//        m.addEntries({
//          MapEntry("code", model[0]),
//          MapEntry("name", model[1]),
//          MapEntry("jz", model[4]),
//          MapEntry("zdf", model[5]),
//        });
//        list.add(m);
//      }
//      i++;
//    }
//    return list;
    }
  }
