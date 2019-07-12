import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool showCountryOnly;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialog(this.elements, this.favoriteElements, {this.showCountryOnly});

  @override
  State<StatefulWidget> createState() => new _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  List<CountryCode> showedElements = [];
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    /// Optimize for ViewModels
    /// Using ListView.buidler is way better performance instaed
    /*
    widgets = <Widget>[]
      ..addAll(widget.favoriteElements
          .map(
            (f) => new SimpleDialogOption(
          child: _buildOption(f),
          onPressed: () {
            _selectItem(f);
          },
        ),
      )
          .toList())
      ..add(new Divider())
      ..addAll(showedElements
          .map(
            (e) => new SimpleDialogOption(
          key: Key(e.toLongString()),
          child: _buildOption(e),
          onPressed: () {
            _selectItem(e);
          },
        ),
      )
      .toList());
    */
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            onChanged: _filterElements,
          ),
        ],
      ),
      content: Container( // ref. https://stackoverflow.com/a/56355962
        width: double.maxFinite,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  ListView.builder(itemBuilder: (context, i) {
                    if (i < (widget?.favoriteElements?.length ?? 0)) {
                      final it = widget?.favoriteElements[i];
                      return it != null ? SimpleDialogOption(
                        child: _buildOption(it),
                        onPressed: () {
                          _selectItem(it);
                        },
                      ) : Container();
                    } else if ((widget?.favoriteElements?.length ?? 0) == i) {  /// FIXME: Avoid adding divier if favoriteElements is empty
                      return Divider();
                    } else if ((widget?.showedElements?.length ?? 0) == i) {
                      final it = widget?.showedElements[i];
                      return it != null ? SimpleDialogOption(
                        child: _buildOption(it),
                        onPressed: () {
                          _selectItem(it);
                        },
                      ) : Container();
                    }
                    return Contaienr();
                  },
                    shrinkWrap: true,
                    itemCount: (widget?.favoriteElements?.length ?? 0) + (showedElements?.length ?? 0) + 1,
                  )
              )
            ]
        ),
      ),
    );
  }

  Widget _buildOption(CountryCode e) {
    return Container(
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                e.flagUri,
                package: 'country_code_picker',
                width: 32.0,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              widget.showCountryOnly
                  ? e.toCountryStringOnly()
                  : e.toLongString(),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    showedElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      showedElements = widget.elements
          .where((e) =>
              e.code.contains(s) ||
              e.dialCode.contains(s) ||
              e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
