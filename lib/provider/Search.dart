import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier{
  var httpClient;
  List dataList;
  SearchProvider(){
    httpClient = new HttpClient();
    dataList = List();
  }

  // ignore: missing_return
  void getList(String input){
    Future f  =  search(input);
    f.then((value) => {
      dataList = value==null?List():value,
      notifyListeners()
    });

  }
  @override
  void dispose() {
    dataList = null;
  }
  Future<List<Map>> search(String input) async {
    Uri uri = Uri.parse(
        "http://fundsuggest.eastmoney.com/FundCode.aspx?input=" + input +
            "&count=20");
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
//    String newStr = responseBody.substring(13);
//    newStr = newStr.substring(0, newStr.length - 3);
    List<String> split = responseBody.split("\"");
    int i = 0;
    List<Map> list = List();
    for (String value in split) {
      if (i % 2 != 0) {
        List<String> model = value.split(",");
        Map m = new Map();
        m.addEntries({
          MapEntry("code", model[0]),
          MapEntry("name", model[2]),
          MapEntry("type", model[3]),
        });
        list.add(m);
      }
      i++;
    }
    return list;


//    print(list);
//  }
  }}