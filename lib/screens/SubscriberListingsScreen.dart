import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/SubscriberListing.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:ondemand_overdrive/services/NavigationService.dart';
import 'package:ondemand_overdrive/widgets/NoConnectionNotification.dart';
import 'package:ondemand_overdrive/widgets/SubscriptionServicesSignIn.dart';
import 'package:provider/provider.dart';
import 'ListingDetailScreen.dart';
import 'SubscriptionsScreen.dart';

class SubscriberListingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Listings'),
      ),
      body: SubscriptionServicesSignIn(
        signedInWidget: SubscriberListings(),
        onSignedIn: Provider.of<AccountProvider>(context, listen: false).getSubscriberListings,
      ),
    );
  }
}

class SubscriberListings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, account, child) {
        switch (account.subscriberListingsState){
          case SubscriberListingsState.Fetching:
            return Center(
              child: CircularProgressIndicator(),
            );
          case SubscriberListingsState.Retrieved:
            if (account.subscriberListings.length == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('There are no recent listings matching your subscriptions',
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 16.0),
                  RaisedButton(
                    child: Text('Subscriptions'),
                    onPressed: () => _pushSubscriptionScreen(context),
                  )
                ],
              );
            }

            //TODO make this a custom scroll view.
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Center(
                    child: AdmobBanner(
                      adUnitId: kReleaseMode ? 'ca-app-pub-1438831506348729/4587186852' : 'ca-app-pub-3940256099942544/6300978111',
                      adSize: AdmobBannerSize.BANNER,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                      padding: EdgeInsets.all(16.0),
                      itemCount: account.subscriberListings.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.transparent,
                          height: 16.0,
                        );
                      },
                      itemBuilder: (context, index) {
                        SubscriberListing listing = account.subscriberListings[index];
                        return SubscriberListingTile(
                          listing: listing,
                        );
                      }),
                )
              ],
            );
          case SubscriberListingsState.Error:
            return NoConnectionNotification(
              onRefresh: account.getSubscriberListings,
            );
          default:
            throw new Exception('Argument out of range');
        }
      },
    );
  }

  _pushSubscriptionScreen(context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return SubscriptionsScreen();
        },
      ),
    );
  }
}

class SubscriberListingTile extends StatelessWidget {
  final SubscriberListing listing;

  SubscriberListingTile({Key key, this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pushListingDetailPage(context, listing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInImage(
            image: NetworkImage(listing.coverImage),
            fit: BoxFit.fitHeight,
            height: 80.0,
            placeholder: AssetImage('assets/images/placeholder-trans.png'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('added ${_formatDate(listing.dateAdded)}',
                      style: TextStyle(
                        color: Colors.teal,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                ]
              ),
            ),
          )
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  _pushListingDetailPage(context, SubscriberListing listing) {
      NavigationService().navigateToListingDetailScreen(listing.id);
  }
}
