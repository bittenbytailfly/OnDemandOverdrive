import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/providers/ListingsProvider.dart';
import 'package:provider/provider.dart';

class FilterDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const largerFontStyle = TextStyle(fontSize: 18);
    return Drawer(
      child: Consumer<ListingsProvider>(
        builder: (context, provider, child){
          return CustomScrollView(slivers: <Widget>[
            _buildDrawerHeaderSliver(largerFontStyle),
            _buildListingTypeFilterHeaderSliver(provider),
            _buildListingTypeFilterSliver(provider, largerFontStyle),
            _buildDividingSliver(),
            _buildGenreFilterHeaderSliver(provider),
            _buildGenreFilterSliver(provider, largerFontStyle),
          ]);
        },
      ),
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

  Widget _buildListingTypeFilterHeaderSliver(ListingsProvider provider) {
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
          value: provider.listingTypeFilter.hasSelectedItems(),
          onChanged: (bool checked) {
            provider.listingTypeFilter.toggleAll(checked);
          },
        )
      ]),
    );
  }

  Widget _buildGenreFilterHeaderSliver(ListingsProvider provider) {
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
          value: provider.genreFilter.hasSelectedItems(),
          onChanged: (bool checked) {
            provider.genreFilter.toggleAll(checked);
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

  Widget _buildGenreFilterSliver(ListingsProvider provider, TextStyle largerFontStyle) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
        return CheckboxListTile(
          title: Text(
            provider.genreFilter[i].name,
            style: largerFontStyle,
          ),
          value: provider.genreFilter[i].isSelected,
          onChanged: (bool checked) {
            provider.genreFilter[i].toggle(checked);
          },
        );
      }, childCount: provider.genreFilter.length),
    );
  }

  Widget _buildListingTypeFilterSliver(ListingsProvider provider, TextStyle largerFontStyle) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
        var label = provider.listingTypeFilter[i].name[0].toUpperCase() +
            provider.listingTypeFilter[i].name.substring(1);
        return CheckboxListTile(
          title: Text(
            label,
            style: largerFontStyle,
          ),
          value: provider.listingTypeFilter[i].isSelected,
          onChanged: (bool checked) {
            provider.listingTypeFilter[i].toggle(checked);
          },
        );
      }, childCount: provider.listingTypeFilter.length),
    );
  }
}


