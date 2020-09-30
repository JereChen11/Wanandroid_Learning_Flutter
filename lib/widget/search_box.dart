import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key key,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  final ValueChanged onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(35),
      ),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 15),
        autofocus: false,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: '动画',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15, ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.white,),
            onPressed: () {
              controller.clear();
            },
          ),
        ),
      ),
    );
  }
}
