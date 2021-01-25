import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jj/main.dart';
import 'package:jj/provider/DataProvider.dart';
import 'package:provider/provider.dart';

import 'provider/Search.dart';
final FocusNode focusNode = FocusNode();
SearchProvider sp;
class SearchAdd extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var size =MediaQuery.of(context).size;
    TextEditingController _textController = TextEditingController();
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("添加自选"),
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child:  Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        focusNode: focusNode,
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: '基金名称/代码',
                          contentPadding: const EdgeInsets.all(10.0),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (text) => sp.getList(text),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SingleChildScrollView(
                      child:  MultiProvider(
                          providers: [
                            ChangeNotifierProvider(create: (BuildContext context)=>SearchProvider(),),
                          ],
                          child: Container(
                            height: size.height-180,
                            width: size.width,
                            child: MyShow(),
                          )
                      ),
                    )

                  ],
                )
              ],

            ),
            onTap: () => focusNode.unfocus()
        ),

      );
  }

}

class MyShow extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    sp = Provider.of<SearchProvider>(context,listen: true);
    dp = Provider.of<DataProvider>(context,listen: true);
    if(sp == null){
      return Center(child: CircularProgressIndicator(),);
    }
     return
           ListView.builder(
               shrinkWrap: true,
               controller: _controller,
               itemCount: sp.dataList.length,
               itemBuilder: (context,index){
                 return ListTile(
                   title: Text(sp.dataList[index]['name']),
                   subtitle: Text(sp.dataList[index]['code']),
                   trailing: Container(
                       child: RaisedButton(
//                         padding: EdgeInsets.only(bottom: 10),
                         child: Text('加入'),
                         onPressed: (){
                           print(dp.codes);
                           dp.addList(sp.dataList[index]['code']);
                           Navigator.pop(context);

                         },
                         color: Colors.blue[200],
                         splashColor:Colors.yellow[100],
                       ),
                       padding: EdgeInsets.only(bottom: 0,top: 21)
                   ),

                 );}
           );

  }

}