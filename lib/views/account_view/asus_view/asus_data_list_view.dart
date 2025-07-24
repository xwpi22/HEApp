import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/services/asus/model/asus_vivowatch_data.dart';

class AsusDataListView extends StatefulWidget {
  final ASUSVivowatchData data;
  const AsusDataListView({super.key, required this.data});

  @override
  State<AsusDataListView> createState() => _AsusDataListViewState();
}

class _AsusDataListViewState extends State<AsusDataListView> {
  Widget _buildDataCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String bptype;
    final String spo2type;
    if (widget.data.latestBp['type'] == 129) {
      bptype = '背景量測';
    } else {
      bptype = '手動';
    }
    if (widget.data.latestSpO2['type'] == 0) {
      spo2type = '手動量測';
    } else {
      spo2type = '背景量測';
    }

    return ListView(
      children: [
        _buildDataCard('VivoWatch 手錶序號', widget.data.deviceId ?? '暫無資料'),
        _buildDataCard(
          '心率',
          widget.data.latestHb['heartrate'] != null &&
                  widget.data.latestHb['time'] != null
              ? '${widget.data.latestHb['heartrate']} Bpm\n測量時間：${widget.data.latestHb['time']}'
              : '暫無資料',
        ),
        _buildDataCard(
          '血壓',
          widget.data.latestBp['sys'] != null &&
                  widget.data.latestBp['dia'] != null &&
                  widget.data.latestBp['hr'] != null &&
                  widget.data.latestBp['deStressIndex'] != null &&
                  widget.data.latestBp['rmssd'] != null &&
                  widget.data.latestBp['time'] != null
              ? '收縮壓(SYS)：${widget.data.latestBp['sys']}\n'
                  '舒張壓(DIA)：${widget.data.latestBp['dia']}\n'
                  '測量時的心律：${widget.data.latestBp['hr']}\n'
                  '壓力指數：${widget.data.latestBp['deStressIndex']}\n'
                  '壓力指數的原始資料：${widget.data.latestBp['rmssd']}\n'
                  '量測方式：$bptype\n'
                  '測量時間：${widget.data.latestBp['time']}'
              : '暫無資料',
        ),
        _buildDataCard(
          '血氧',
          widget.data.latestSpO2['spo2'] != null &&
                  widget.data.latestSpO2['time'] != null
              ? '${widget.data.latestSpO2['spo2']} mm Hg\n量測方式：$spo2type\n測量時間：${widget.data.latestSpO2['time']}'
              : '暫無資料',
        ),
        _buildDataCard(
          '步數',
          widget.data.latestStep['steps'] != null &&
                  widget.data.latestStep['time'] != null
              ? '${widget.data.latestStep['steps']} 步\n測量時間：${widget.data.latestStep['time']}'
              : '暫無資料',
        ),
      ],
    );
  }
}
