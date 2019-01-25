import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:gumby_project/models/vote.dart';

class VoteChart extends StatelessWidget {

  final List<Vote> votes;

  VoteChart(this.votes);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;
    charts.Color green = charts.Color(
      r: primaryColor.red,
      g: primaryColor.green,
      b: primaryColor.blue,
      a: primaryColor.alpha,
    );
    Color secondaryColor = theme.accentColor;
    charts.Color red = charts.Color(
      r: secondaryColor.red,
      g: secondaryColor.green,
      b: secondaryColor.blue,
      a: secondaryColor.alpha,
    );

    List<charts.Series<VoteCount, String>> seriesList = [
      charts.Series<VoteCount, String>(
        id: 'Keep',
        colorFn: (_, __) => green,
        domainFn: (VoteCount v, _) => v.key,
        measureFn: (VoteCount v, _) => v.count,
        data: _freqList(1),
        labelAccessorFn: (VoteCount v, _) => v.count.toString(),
      ),
      charts.Series<VoteCount, String>(
        id: 'Reset',
        colorFn: (_, __) => red,
        domainFn: (VoteCount v, _) => v.key,
        measureFn: (VoteCount v, _) => v.count,
        data: _freqList(-1),
        labelAccessorFn: (VoteCount v, _) => v.count.toString(),
      ),
    ];

    charts.BarChart chart = charts.BarChart(
      seriesList,
      layoutConfig: charts.LayoutConfig(
        topMarginSpec: charts.MarginSpec.fixedPixel(0),
        rightMarginSpec: charts.MarginSpec.defaultSpec,
        leftMarginSpec: charts.MarginSpec.defaultSpec,
        bottomMarginSpec: charts.MarginSpec.defaultSpec,
      ),
      animate: true,
      defaultInteractions: false,
      animationDuration: Duration(milliseconds: 500),
      barGroupingType: charts.BarGroupingType.stacked,
      primaryMeasureAxis: charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec<num>()),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec<String>(
          tickLengthPx: 0,
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            fontFamily: theme.textTheme.body1.fontFamily,
            color: charts.MaterialPalette.gray.shade600,
          ),
        ),
        showAxisLine: false,
      ),
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Past Week',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(
            height: 100.0,
            child: chart,
          ),
        ],
      ),
    );
  }

  List<VoteCount> _freqList(int voteType) {
    Map<String, num> freqs = {
      "A": 0,
      "B": 0,
      "C": 0,
      "D": 0,
      "E": 0,
      "F": 0,
      "G": 0,
      "H": 0,
    };
    votes.forEach((Vote v) {
      if (v.val == voteType) freqs[v.key] += 1;
    });
    List<VoteCount> counts = List();
    freqs.forEach((String key, num count) => counts.add(VoteCount(key, count)));
    return counts;
  }
}

class VoteCount {
  final String key;
  final int count;
  VoteCount(this.key, this.count);
}

