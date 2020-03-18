import 'package:flutter/material.dart';

class SubscriptionType {
  final int id;
  final IconData icon;
  final String name;
  final String label;
  final String example;

  static const int ACTOR = 1;
  static const int DIRECTOR = 2;
  static const int TITLE = 3;
  static const int NEW_EPISODE = 4;

  SubscriptionType(this.id, this.icon, this.name, this.label, this.example);

  SubscriptionType.actor() :
        this.id = ACTOR,
        this.icon = Icons.face,
        this.name = 'Actor',
        this.label = 'Full Name',
        this.example = 'e.g. Edward Norton';

  SubscriptionType.director() :
        this.id = DIRECTOR,
        this.icon = Icons.movie,
        this.name = 'Director',
        this.label = 'Full Name',
        this.example = 'e.g. David Fincher';

  SubscriptionType.title() :
        this.id = TITLE,
        this.icon = Icons.theaters,
        this.name = 'Title',
        this.label = 'Title',
        this.example = 'e.g. Star Trek';

  SubscriptionType.newEpisodes() :
      this.id = NEW_EPISODE,
      this.icon = Icons.tv,
      this.name = 'New Episodes',
      this.label = 'Title',
      this.example = 'e.g. Lost in Space';
}