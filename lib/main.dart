import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

double spacing = 2;

class Element {
  String name, symbol, wiki, category, group, period, block, electronsPerShell;
  int atomicNumber;
  String atomicWeight, electronConfiguration, density;
  Color color;
  Element.fromJson(json)
      : name = json["name"],
        symbol = json["symbol"],
        wiki = json["source"],
        category = json["category"],
        atomicNumber = json["number"],
        atomicWeight = json["atomic_weight"],
        group = json["group"],
        period = json["period"],
        block = json["block"],
        electronsPerShell = json["electrons_per_shell"],
        electronConfiguration = json["electrons_configuration"],
        density = json["density"],
        color = Color(json["colors"][0]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String elementsJsonString =
      await rootBundle.loadString("assets/elements.json");
  Map<String, dynamic> elementsJson = jsonDecode(elementsJsonString);
  final elementsList = elementsJson["elements"] as List;
  final elements = elementsList
      .map((json) => (json == null ? null : Element.fromJson(json)))
      .toList();
  runApp(PeriodicTable(elements));
}

class PeriodicTable extends StatelessWidget {
  PeriodicTable(this.elements);
  final List<Element> elements;

  @override
  Widget build(BuildContext context) {
    double elementSize = 60;
    double rows = 10;

    List<Widget> elementsWidgets = elements
        .map((elem) =>
            elem == null ? ElementWidget.blank() : ElementWidget(elem))
        .toList();

    return MaterialApp(
      title: 'Periodic Table',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        //backgroundColor: Color.fromARGB(255, 35, 38, 40),
        appBar: AppBar(
          title: Text("Periodic Table"),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: (elementSize + 2 * spacing) * rows,
            child: GridView.count(
              crossAxisCount: rows.floor(),
              scrollDirection: Axis.horizontal,
              children: elementsWidgets,
            ),
          ),
        ),
      ),
    );
  }
}

class ElementWidget extends StatelessWidget {
  ElementWidget(this.elem, [this.isInTable = true]);

  static double elementSize = 60;
  final Element elem;
  final bool isInTable;

  void loadElementPage(Element elem, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ElementPage(elem)));
  }

  static Widget blank() {
    return Container(
      height: elementSize,
      width: elementSize,
      color: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "hero_" + elem.symbol,
      child: Container(
        margin: EdgeInsets.all(spacing),
        color: elem.color,
        width: elementSize,
        height: elementSize,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => isInTable ? loadElementPage(elem, context) : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  elem.atomicNumber.toString(),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  elem.symbol,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  elem.name,
                  style: TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ElementPage extends StatelessWidget {
  ElementPage(this.element);
  final Element element;

  @override
  Widget build(BuildContext context) {
    Color color1 = Colors.deepPurple[100];
    Color color2 = Colors.deepPurple[300];

    return Scaffold(
      appBar: AppBar(
        title: Text(element.name),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: Center(
              child: ElementWidget(element, false),
            ),
          ),
          Divider(color: Colors.black,height: 1,),
          ElementPageLine("Category", element.category, color1),
          Divider(color: Colors.black, height: 1,),
          ElementPageLine("Group", element.group, color2),
          Divider(color: Colors.black, height: 1,),
          ElementPageLine("Period", element.period, color1),
          Divider(color: Colors.black, height: 1,),
          ElementPageLine("Block", element.block, color2),
          Divider(color: Colors.black, height: 1,),
          ElementPageLine("Atomic weight", element.atomicWeight, color1),
          Divider(color: Colors.black, height: 1,),
          ElementPageLine("Electrons per shell", element.electronsPerShell, color2),
          Divider(color: Colors.black, height: 1,),
          ElementPageLine("Electron configuration", element.electronConfiguration, color1),
          Divider(color: Colors.black, height: 1,),
          ElementPageLine("Density", element.density, color2),
          Divider(color: Colors.black, height: 1,),
          ElementPageLine("Wikipedia", element.wiki, color1),
        ],
      ),
    );
  }
}

class ElementPageLine extends StatelessWidget {
  ElementPageLine(this.first, this.second, [this.background = Colors.red]);
  final String first, second;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: background,
              padding: EdgeInsets.only(top: 20, bottom: 20, right: 10),
              child: Text(first,
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.w600),),
            ),
          ),
          VerticalDivider(color: Colors.black,width: 1,),
          Expanded(
            child: Container(
              color: background,
              padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
              child: SingleChildScrollView(
                child: Text(second, maxLines: 1,),
                scrollDirection: Axis.horizontal,),
            ),
          ),
        ],
      ),
    );
  }
}
