import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/all-const/colors.dart';
import 'package:to_do_app/model/itemToDo.dart';
import 'package:to_do_app/widgets/item.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool is_dark_mode =
      false; //mode controls transition between light mode and dark mode.
  //dark mode is denoted by true true, light mode is denoted by false.
  final _to_do_Controller = TextEditingController();
  List<itemToDo> foundits = [];
  final List<itemToDo> list = itemToDo.generateDefaultList();

  @override
  void initState() {
    is_dark_mode = false;
    foundits = list;
    super.initState();
  }

  void switchColorScheme() {
    //switches between light mode and dark mode
    setState(() {
      is_dark_mode = !is_dark_mode;
    });
  }

  void handleItemDeletion(String item_id) {
    setState(() => {list.removeWhere((element) => element.ID == item_id)});
  }

  void handleItemAddition(String item_text) {
    if (item_text.replaceAll(' ', '') == '') {
      return;
    }
    setState(() => {
          list.add(new itemToDo(
            ID: DateTime.now().millisecondsSinceEpoch.toString(),
            text: item_text.trim(),
          ))
        });
    _to_do_Controller.clear();
  }

  void handleToDoItemChange(itemToDo item) {
    setState(() {
      item.isDone = !item.isDone;
    });
  }

  void runFilter(String userEntry) {
    userEntry = userEntry.trim();
    List<itemToDo> result = [];
    if (userEntry.isEmpty) {
      result = list;
    } else {
      result = list
          .where((element) =>
              element.text!.toLowerCase().contains(userEntry.toLowerCase()))
          .toList();
    }

    setState(() => {foundits = result});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (is_dark_mode) ? blackMain : alternative,
      appBar: buildBar(),
      //appBar: AppBar(),
      body: Stack(children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                createSearcher(),
                createYAxisList(),
              ],
            )),
        createAlign()
      ]),
    );
  }

  Align createAlign() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Row(children: [
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _to_do_Controller,
                    decoration: InputDecoration(
                      hintText: 'Enter new ToDo task here',
                      border: InputBorder.none,
                    ),
                  ))),
          Container(
              margin: EdgeInsets.only(
                bottom: 20,
                right: 20,
              ),
              child: ElevatedButton(
                onPressed: () => handleItemAddition(_to_do_Controller.text),
                child: Text('+', style: new TextStyle(fontSize: 35)),
                style: ElevatedButton.styleFrom(
                  primary: tdBlue,
                  minimumSize: Size(50, 50),
                  elevation: 10,
                ),
              )),
        ]));
  }

  Expanded createYAxisList() {
    return Expanded(
      child: ListView(children: [
        Container(
            margin: EdgeInsets.only(top: 50, bottom: 20),
            child: Text(
              "To-Do Items!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: (is_dark_mode) ? tdBGColor : Colors.black,
              ),
            )),
        for (itemToDo todo1 in foundits
            .reversed) //reversed so that that items can follow FILO order, more convenient for the user(I think)
          item(
            todo: todo1,
            onItemChanged: handleToDoItemChange,
            onItemDeletion: handleItemDeletion,
            c_mode: is_dark_mode,
          )
      ]),
    );
  }

  //Creates the search box text field for the home screen.
  Container createSearcher() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: tdBGColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        onChanged: (val) => runFilter(val),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search To-Do here',
          hintStyle: TextStyle(color: tdBlack),
        ),
      ),
    );
  }

  //This function is used to build the app bar to be used in the application's homescreen.
  AppBar buildBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app_rounded,
                color: tdBlue,
                size: 30,
              ),
              onPressed: () => {SystemNavigator.pop()},
            ),
            Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Tooltip(
                      textStyle: TextStyle(
                        fontSize: 13,
                      ),
                      preferBelow: true,
                      message: "Light Mode",
                      child: IconButton(

                          //tooltip: 'Light/Dark mode',
                          icon: Icon(Icons.format_paint_rounded),
                          color: Colors.blue.shade400,
                          onPressed: () => {switchColorScheme()}),
                    )))
          ],
        ));
  }
}
