import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider extends ChangeNotifier{
  var httpClient;
  List dataList;
  Set<String> codes;
  var dplsit;
  var time;
  DataProvider(){
    if(codes == null){
      codes = new Set();
      codes.add("162605");
      codes.add("260108");
      codes.add("161725");
      codes.add("011130");
    }
    Future<SharedPreferences> sharedPreferences =  SharedPreferences.getInstance();
    sharedPreferences.then((value) => {
      codes = value.getStringList("codes")==null?codes:value.getStringList("codes").toSet(),
      getList()
    });
    httpClient = new HttpClient();
    dplsit = List();
    dataList = List();
    getList();

    var time = Timer.periodic(
        Duration(milliseconds: 1500),
            (t){
              this.time = t;
              getList();
            }
    );
  }
  void flush(){
    notifyListeners();
  }
  void deleteIndex(int index){
    String code = dataList[index]['code'];
    this.codes.remove(code);
    dataList.removeAt(index);
    Future<SharedPreferences> sharedPreferences =  SharedPreferences.getInstance();
    sharedPreferences.then((value) => {
      value.setStringList("codes", this.codes.toList())
    });


  }
  void addList(String code){
    this.codes.add(code);
    Future<SharedPreferences> sharedPreferences =  SharedPreferences.getInstance();
    sharedPreferences.then((value) => {
      value.setStringList("codes", this.codes.toList())
    });
    getList();
    notifyListeners();
  }
  // ignore: missing_return
  Future getList(){
    Future f  =  matchJJName();
    f.then((value) => {
      dataList = value,
      notifyListeners()
    });

  }
  @override
  void dispose() {
    dataList = null;
    this.time.cancel();
  }
  //https://push2.eastmoney.com/api/qt/ulist.np/get?fltt=2&fields=f2,f3,f4,f12,f14&secids=1.000001,1.000300,0.399001,0.399006&v=0.41877556799466187

  Future<List<Map>> matchJJName() async {
    Uri uri1 =  Uri.parse("https://push2.eastmoney.com/api/qt/ulist.np/get?fltt=2&fields=f2,f3,f4,f12,f14&secids=1.000001,1.000300,0.399001,0.399006&v=0.41877556799466187");
    var request1 = await httpClient.getUrl(uri1);
    var response1 = await request1.close();
    String responseBody1 = await response1.transform(utf8.decoder).join();
    int begin = responseBody1.indexOf("diff")+6;
    String newstr = responseBody1.substring(begin,responseBody1.length-2);
    var dplsit = json.decode(newstr);
    this.dplsit = dplsit;

   String code = this.codes.join(",");
    Uri uri =  Uri.parse("http://fund.eastmoney.com/Data/FundCompare_Interface.aspx?t=0&bzdm="+code+"&v=0.681049632585115");
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    String newStr = responseBody.substring(17);
    newStr = newStr.substring(0,newStr.length-3);
    List<String> split = newStr.split("\"");
//    print(split.length);
    int i =0;
    List<Map> list = List();
    for (String value in split) {
        if(i%2 == 0){
          List<String> model = value.split(",");
          Map m = new Map();
          m.addEntries({
            MapEntry("code", model[0]),
            MapEntry("name", model[1]),
            MapEntry("jz", model[4]),
            MapEntry("zdf", model[5]),
            MapEntry("now", model[6]),
          });
          list.add(m);
        }
        i++;
    }
    return list;



//    print(list);
  }
}