import 'package:flutter/material.dart';

class SubscriptionType {
  final int id;
  final IconData icon;
  final String name;
  final String label;
  final String example;

  SubscriptionType(this.id, this.icon, this.name, this.label, this.example);

  SubscriptionType.actor() :
        this.id = 1,
        this.icon = Icons.face,
        this.name = 'Actor',
        this.label = 'Full Name',
        this.example = 'e.g. Edward Norton';

  SubscriptionType.director() :
        this.id = 2,
        this.icon = Icons.movie,
        this.name = 'Director',
        this.label = 'Full Name',
        this.example = 'e.g. David Fincher';

  SubscriptionType.title() :
        this.id = 3,
        this.icon = Icons.theaters,
        this.name = 'Title',
        this.label = 'Title',
        this.example = 'e.g. Fight Club';
}