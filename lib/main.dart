
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jj/provider/DataProvider.dart';
import 'package:jj/provider/detail.dart';
import 'package:provider/provider.dart';
import 'package:jj/SearchAdd.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider.value(value: new DataProvider(),child: MyApp(),));
}
DataProvider dp;
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Future<Null> _onRefresh() async {
      dp.getList();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "基金管理",
      home: Scaffold(
        appBar: AppBar(
          title: Text("基金管理"),
          actions: [
            AddButton()
          ],
        ),
        body:
        RefreshIndicator(
          onRefresh: _onRefresh,
          ///刷新时执行这个方法
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child:   Dp(),
              ),
              SizedBox(
                height: 600,
                child:  ShowJJ(),
              )
            ],

          ),
        ),

      ),
    );

  }
}

class Dp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    dp = Provider.of<DataProvider>(context,listen: true);
    List list = dp.dplsit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(list!=null&&list.length>3?list[0]['f14'].toString()+':':'',style: TextStyle(fontSize: 20,fontFamily: "黑体"),),
              ),
              Container(
                padding: EdgeInsets.only(left: 5,right: 20),
                child: Text(list!=null&&list.length>3?list[0]['f3'].toString()+'%':'',style: TextStyle(fontSize: 20,fontFamily: "黑体",color: list!=null&&list.length>3?list[0]['f3'].toString().substring(0,1)=='-'?Colors.green:Colors.red:Colors.green),),
              ),
              Container(
                child: Text(list!=null&&list.length>3?list[1]['f14'].toString()+':':'',style: TextStyle(fontSize: 20,fontFamily: "黑体"),),
              ),
              Container(
                padding: EdgeInsets.only(left: 5,right: 20),
                child: Text(list!=null&&list.length>3?list[1]['f3'].toString()+'%':'',style: TextStyle(fontSize: 20,fontFamily: "黑体",color: list!=null&&list.length>3?list[1]['f3'].toString().substring(0,1)=='-'?Colors.green:Colors.red:Colors.green),),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(list!=null&&list.length>3?list[2]['f14'].toString()+':':'',style: TextStyle(fontSize: 20,fontFamily: "黑体")),
              ),
              Container(
                padding: EdgeInsets.only(left: 5,right: 20),
                child: Text(list!=null&&list.length>3?list[2]['f3'].toString()+'%':'',style: TextStyle(fontSize: 20,fontFamily: "黑体",color: list!=null&&list.length>3?list[2]['f3'].toString().substring(0,1)=='-'?Colors.green:Colors.red:Colors.green),),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(list!=null&&list.length>3?list[3]['f14'].toString()+':':'',style: TextStyle(fontSize: 20,fontFamily: "黑体"),),
              ),
              Container(
                padding: EdgeInsets.only(left: 5,right: 20),
                child: Text(list!=null&&list.length>3?list[3]['f3'].toString()+'%':'',style: TextStyle(fontSize: 20,fontFamily: "黑体",color: list!=null&&list.length>3?list[3]['f3'].toString().substring(0,1)=='-'?Colors.green:Colors.red:Colors.green),),
              )
            ],
          ),
        ),
      ],
    );
  }

}

class AddButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    toSearch(){
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return new SearchAdd();
      }));
    }
    return  Container(
      child: IconButton(icon: Icon(Icons.add_circle_outline), onPressed: toSearch),
    );
  }

}

class ShowJJ extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    dp = Provider.of<DataProvider>(context,listen: true);
    if(dp == null){
      return Center(child: CircularProgressIndicator(),);
    }
    return ListView.builder(
        itemCount: dp.dataList.length,
        itemBuilder: (context,index){
          return Dismissible(
            // 滑动背景色
            background: new Container(color: Theme.of(context).primaryColor),
            // 设置key标识
            key: new Key(dp.dataList[index]['code']),
            // 滑动回调
            onDismissed: (direction) {
              // 根据位置移除
              dp.deleteIndex(index);
              //do something

              // 提示
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("已移除")));
            },
            child: ListTile(
              onTap: (){
                Future.delayed(
                    Duration.zero,
                        (){Navigator.of(context).push( new MaterialPageRoute(builder: (context) =>
                        Chats(dp.dataList[index]['code'],dp.dataList[index]['name'])));
                    });
              },
              title: Text(dp.dataList[index]['name']),
              subtitle: Text(dp.dataList[index]['zdf'] == ''?'封闭期':dp.dataList[index]['zdf']+"%",style: TextStyle(
                  color: dp.dataList[index]['zdf'].toString().length>0 && dp.dataList[index]['zdf'].toString().substring(0,1)=='-'?Colors.green:Colors.red
              ),
              ),
              trailing: Container(
                  child: Text(dp.dataList[index]['code'],textAlign: TextAlign.right,),
                  padding: EdgeInsets.only(bottom: 0,top: 21)
              ),

            ),
          );}
    );
  }

}