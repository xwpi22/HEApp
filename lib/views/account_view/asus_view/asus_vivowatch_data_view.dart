import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/asus/model/asus_vivowatch_data.dart';
import 'package:heapp/services/asus/service/asus_vivowatch_service.dart';
import 'package:heapp/services/crud/services/crud_service.dart';
import 'package:heapp/views/account_view/asus_view/asus_data_list_view.dart';

class ASUSVivoWatchDataView extends StatefulWidget {
  const ASUSVivoWatchDataView({super.key});

  @override
  State<ASUSVivoWatchDataView> createState() => _ASUSVivoWatchDataViewState();
}

class _ASUSVivoWatchDataViewState extends State<ASUSVivoWatchDataView> {
  late Future<ASUSVivowatchData> data;
  late String watchSerialNumber;

  @override
  void initState() {
    super.initState();
    watchSerialNumber = Services().getAsusSn();
    if (watchSerialNumber.isNotEmpty) {
      data = ASUSVivowatchService().fetchData(watchSerialNumber);
    }
  }

  void _refreshData() {
    if (watchSerialNumber.isNotEmpty) {
      setState(() {
        data = ASUSVivowatchService().fetchData(watchSerialNumber);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (watchSerialNumber.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: globColor,
          title: Text('未綁定Asus VivoWatch', style: TextStyle(fontSize: 20.sp)),
        ),
        body: const Center(
            child: Text(
          '尚未綁定Asus VivoWatch\n請提供VivoWatch 序號給醫生做設定',
          textAlign: TextAlign.center,
        )),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globColor,
        title: Text(
          'ASUS VivoWatch 生理數據',
          style: TextStyle(fontSize: 20.sp),
        ),
        toolbarHeight: 60.h,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _refreshData,
          ),
        ],
      ),
      extendBodyBehindAppBar: false,
      body: FutureBuilder<ASUSVivowatchData>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('錯誤: ${snapshot.error}\n請重新整理頁面'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return AsusDataListView(data: data);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
