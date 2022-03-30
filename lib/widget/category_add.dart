import 'package:flutter/material.dart';

class CategoryAdd extends StatelessWidget {
  final String? name;
  final ValueChanged<String> onChangedname;

  const CategoryAdd({
    Key? key,
    this.name = '',
    required this.onChangedname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildname(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );
  Widget buildname() => TextFormField(
        maxLines: 1,
        initialValue: name,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.category),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "@name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (title) {
          if (title != null && title.isEmpty) return 'The name cannot be empty';
        },
        onChanged: onChangedname,
      );

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
