
import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jj/provider/DetailProvider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

DetailProvider dp;

class Chats extends StatelessWidget{
  String code;
  String name;
  Chats(String code,String name){
    this.code = code;
    this.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (BuildContext context)=>DetailProvider(code),),
        ],
        child: Column(
          children: [
            Jjjl(),
            Info(code),
            chat()
          ],
        )

        )
      );
  }
}

class Jjjl extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    dp = Provider.of<DetailProvider>(context,listen: true);
    List<Widget> tiles = List();
    for (var value in dp.jjjlList) {
       //有几个基金经理 一般是一个
      tiles.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('基金经理:'),
                  Text(value['name'].toString()),
                ],
              ));
      tiles.add(
        Container(
            margin: EdgeInsets.only(top: 5),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('累计任职时间:'),
              Text(value['workTime'].toString()),
            ],
          )),
        );

      tiles.add(
        Container(
          margin: EdgeInsets.only(top: 5),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('现任基金资产规模:'),
              Text(value['fundSize'].toString()),
              Divider(height:10.0,indent:0.0,color: Colors.red,)
            ],
          )),

        );


  }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: tiles
      );


  }

}


class Info extends StatelessWidget{
  String code;
  Info(String code){
    this.code = code;
  }
  @override
  Widget build(BuildContext context) {
    dp = Provider.of<DetailProvider>(context,listen: true);
    Widget divider = Divider(height:10.0,indent:0.0,color: Colors.red,);
      return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                    Container(
                      child:   Text("近一年收益率:"),
                      margin: EdgeInsets.only(top: 5),
                    ),
                   Container(
                     child:  Text(dp.syl!=null&&dp.syl.length==4?dp.syl[0]+"%":"获取失败",style: TextStyle(color: Colors.red),),
                     margin: EdgeInsets.only(right: 20,top: 5),
                   ),
                   Container(
                     child:     Text("近六个月收益率:",),
                     margin: EdgeInsets.only(top: 5),
                   ),
                   Container(
                     child:  Text(dp.syl!=null&&dp.syl.length==4?dp.syl[1]+"%":"获取失败",style: TextStyle(color: Colors.red)),
                   )
                 ],
               ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child:        Text("近三个月收益率:"),
                    margin: EdgeInsets.only(top: 5),
                  ),
                  Container(
                    child:   Text(dp.syl!=null&&dp.syl.length==4?dp.syl[2]+"%":"获取失败",style: TextStyle(color: Colors.red)),
                    margin: EdgeInsets.only(right: 20),
                  ),
                  Container(
                    child:         Text("近一个月收益率:"),
                  ),
                  Container(
                    child:    Text(dp.syl!=null&&dp.syl.length==4?dp.syl[3]+"%":"获取失败",style: TextStyle(color: Colors.red)),
                  ),
                  divider
                ],
              ),
            ]
      );
  }

}

class chat extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    dp = Provider.of<DetailProvider>(context,listen: true);
    var data = dp.jsonArray;
   return  Container(
     margin: EdgeInsets.only(top: 10),
     height: 560,
     child:  CupertinoScrollbar(
       child: ListView.builder(
           shrinkWrap: true,
           itemCount:  data== null?0:data.length,
//           reverse: true,
           itemBuilder:(context,index){
             return ListTile(
               title: Text(data[index]['equityReturn'].toString(),style: TextStyle(color: data[index]['equityReturn'].toString().substring(0,1)=='-'?Colors.green:Colors.red,)),
               subtitle: Text(data[index]['y'].toString()),
               trailing: Container(
                   child: Text(formatDate(DateTime.fromMicrosecondsSinceEpoch(int.parse(data[index]['x'].toString()) * 1000),[yyyy, '年', mm, '月', dd]),textAlign: TextAlign.right,),
                   padding: EdgeInsets.only(bottom: 0,top: 21)
               ),
             );
           }
       ),
     )
   );
  }

}