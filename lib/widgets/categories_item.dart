import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news.dart';

var cat = {
  0: "null",
  1: "politics",
  2: "health",
  3: "technology",
  4: "travel",
  5: "education",
  6: "environment",
  7: "economics-business",
  8: "covid-19",
};
class CategoriesItem extends StatefulWidget {
  // final int value;
  // final String title;
  // CategoriesItem(this.value,this.title);
  @override
  _CategoriesItemState createState() => _CategoriesItemState();
}

class Apply {
  static var radio1 = cat.keys
      .firstWhere((k) => cat[k] == '${News.newsCategory}', orElse: () => null);
  static void applyButton(BuildContext context) async {
    News.newsCategory = cat[Apply.radio1];
    if (Apply.radio1 != 0){
      await Provider.of<News>(context, listen: false)
          .getNewsByCategory(cat[Apply.radio1]);
    }
    else {
      await Provider.of<News>(context, listen: false)
          .getRecentNews();
      await Provider.of<News>(context, listen: false)
          .getTopNews();
    }
    Navigator.of(context).pop();
  }

}

class _CategoriesItemState extends State<CategoriesItem> {
  void changeRadio(int val) {
    setState(() {
      Apply.radio1 = val;
    });
  }

  Widget _buildRadioListTile(int val, String title) {
    return RadioListTile(
      value: val,
      groupValue: Apply.radio1,
      onChanged: changeRadio,
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRadioListTile(0, 'All'),
          Divider(),
          _buildRadioListTile(1, 'Politics'),
          Divider(),
          _buildRadioListTile(2, 'Health'),
          Divider(),
          _buildRadioListTile(3, 'Technology'),
          Divider(),
          _buildRadioListTile(4, 'Travel'),
          Divider(),
          _buildRadioListTile(5, 'Education'),
          Divider(),
          _buildRadioListTile(6, 'Environment'),
          Divider(),
          _buildRadioListTile(7, 'Economics-business'),
          Divider(),
          _buildRadioListTile(8, 'Covid-19'),
          Divider()
        ],
      ),
    );
  }
}
