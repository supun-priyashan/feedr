import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: ListView(children: <Widget>[
          Center(
              child: Text(
            'Students',
            style: TextStyle(
                fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
          )),
          DataTable(
            columns: [
              DataColumn(label: Text('UserNo')),
              DataColumn(label: Text('First Name')),
              DataColumn(label: Text('Last Name')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('1')),
                DataCell(Text('Arya')),
                DataCell(Text('6')),
              ]),
              DataRow(cells: [
                DataCell(Text('12')),
                DataCell(Text('John')),
                DataCell(Text('9')),
              ]),
              DataRow(cells: [
                DataCell(Text('42')),
                DataCell(Text('Tony')),
                DataCell(Text('8')),
              ]),
            ],
          ),
        ]));
  }
}
