import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/res/dimens.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key key,
    this.onChanged,
  }) : super(key: key);

  final ValueChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      height: 30,
      margin: EdgeInsets.only(
          left: Dimens.default_padding, right: Dimens.default_padding),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: Colors.white, fontSize: Dimens.default_size_sp),
        autofocus: false,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 5),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search',
          hintStyle:
              TextStyle(color: Colors.white, fontSize: Dimens.default_size_sp),
        ),
      ),
    );
  }
}
