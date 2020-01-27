import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/FilterList.dart';

class FilterDrawer extends StatefulWidget {
  final List<String> genres;
  final FilterList listingTypeFilter;
  final FilterList genreFilter;

  FilterDrawer({Key key, this.genres, this.listingTypeFilter, this.genreFilter}) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  @override
  Widget build(BuildContext context) {
    return _buildDrawer();
  }

  Widget _buildDrawer() {
    const largerFontStyle = TextStyle(fontSize: 18);
    return Drawer(
      child: CustomScrollView(slivers: <Widget>[
        _buildDrawerHeaderSliver(largerFontStyle),
        _buildListingTypeFilterHeaderSliver(),
        _buildListingTypeFilterSliver(largerFontStyle),
        _buildDividingSliver(),
        _buildGenreFilterHeaderSliver(),
        _buildGenreFilterSliver(largerFontStyle),
      ])
    );
  }

  Widget _buildDrawerHeaderSliver(TextStyle largerFontStyle){
    return SliverList(
      delegate: SliverChildListDelegate([
        AppBar(
          actions: [
            new Container(),
          ],
          automaticallyImplyLeading: false,
          title: Text(
            'Filter Results',
            style: largerFontStyle,
          ),
        )
      ]),
    );
  }

  Widget _buildListingTypeFilterHeaderSliver() {
    return SliverList(
      delegate: SliverChildListDelegate([
        CheckboxListTile(
          title: const Text(
            'Listing Type',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          value: widget.listingTypeFilter.hasSelectedItems(),
          onChanged: (bool checked) {
            widget.listingTypeFilter.toggleAll(checked);
          },
        )
      ]),
    );
  }

  Widget _buildGenreFilterHeaderSliver() {
    return SliverList(
      delegate: SliverChildListDelegate([
        CheckboxListTile(
          title: const Text(
            'Genre',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          value: widget.genreFilter.hasSelectedItems(),
          onChanged: (bool checked) {
            widget.genreFilter.toggleAll(checked);
          },
        )
      ]),
    );
  }

  Widget _buildDividingSliver() {
    return SliverList(
      delegate: SliverChildListDelegate([Divider()]),
    );
  }

  Widget _buildGenreFilterSliver(TextStyle largerFontStyle) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
        return CheckboxListTile(
          title: Text(
            widget.genreFilter[i].name,
            style: largerFontStyle,
          ),
          value: widget.genreFilter[i].isSelected,
          onChanged: (bool checked) {
            widget.genreFilter[i].toggle(checked);
          },
        );
      }, childCount: widget.genreFilter.length),
    );
  }

  Widget _buildListingTypeFilterSliver(TextStyle largerFontStyle) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
        var label = widget.listingTypeFilter[i].name[0].toUpperCase() +
            widget.listingTypeFilter[i].name.substring(1);
        return CheckboxListTile(
          title: Text(
            label,
            style: largerFontStyle,
          ),
          value: widget.listingTypeFilter[i].isSelected,
          onChanged: (bool checked) {
            this.widget.listingTypeFilter[i].toggle(checked);
          },
        );
      }, childCount: widget.listingTypeFilter.length),
    );
  }
}


