import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextStyle inputStyle = TextStyle(
    fontSize: 18,
    color: Colors.black87,
  );

  final TextStyle labelStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
  );
  String _startMeasure;
  String _convertedMeasure;
  double _numberForm;

  void initState() {
    _numberForm = 0;
    super.initState();
  }

  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];
  final Map<String, int> _measuresMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };

  dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };
  String _resultMessage;

  void convert(double value, String from, String to) {
    int nFrom = _measuresMap[from];
    int nTo = _measuresMap[to];
    var multiplier = _formulas[nFrom.toString()][nTo];
    var result = value * multiplier;
    if (result == 0) {
      _resultMessage = 'This conversion cannot be performed';
    } else {
      _resultMessage =
          '${_numberForm.toString()} $_startMeasure are ${result.toString()} $_convertedMeasure';
    }
    setState(() {
      _resultMessage = _resultMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Measures Converter',
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Measures Converter'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Spacer(),
              TextField(
                style: inputStyle,
                decoration: InputDecoration(
                  hintText: "Please enter the value",
                ),
                onChanged: (text) {
                  var rv = double.tryParse(text);
                  if (rv != null) {
                    setState(() {
                      _numberForm = rv;
                    });
                  }
                },
              ),
              Spacer(),
              //Text((_numberForm==null)? '' : _numberForm.toString())
              Row(
                children: [
                  DropdownButton(
                    style: inputStyle,
                    hint: Text(
                      "Unit",
                      style: inputStyle,
                    ),
                    items: _measures.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _startMeasure = value;
                      });
                    },
                    value: _startMeasure,
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.blue[600],
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Spacer(),
                  DropdownButton(
                    hint: Text(
                      "Unit",
                      style: inputStyle,
                    ),
                    style: inputStyle,
                    items: _measures.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: inputStyle,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _convertedMeasure = value;
                      });
                    },
                    value: _convertedMeasure,
                  ),
                ],
              ),

              Spacer(
                flex: 1,
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Convert', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (_startMeasure.isEmpty ||
                      _convertedMeasure.isEmpty ||
                      _numberForm == 0) {
                    return;
                  } else {
                    convert(_numberForm, _startMeasure, _convertedMeasure);
                  }
                },
              ),

              Spacer(
                flex: 1,
              ),
              Text((_resultMessage == null) ? '' : _resultMessage,
                  style: labelStyle),
              Spacer(
                flex: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
