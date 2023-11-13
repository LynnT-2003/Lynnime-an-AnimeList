import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lynnime_application_2/models/anime.dart' as AnimeModel;
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Future<List<AnimeModel.Anime>> getAnimeList() async {
  // QuerySnapshot snapshot = await _db.collection('anime-list-demo').get();

  // return snapshot.docs.map((doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return AnimeModel.Anime(
  //     title: data['title'],
  //     synopsis: data['synopsis'],
  //     genre: List<String>.from(data['genre']),
  //     aired: data['aired'],
  //     episodes: data['episodes'],
  //     members: data['members'],
  //     popularity: data['popularity'],
  //     ranked: data['ranked'],
  //     score: data['score'].toDouble(),
  //     imgUrl: data['img_url'],
  //     link: data['link'],
  //   );
  // }).toList();

  //   try {
  //     QuerySnapshot snapshot = await _db.collection('anime-list-demo').get();

  //     return snapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return AnimeModel.Anime(
  //         title: data['title'],
  //         synopsis: data['synopsis'],
  //         genre: List<String>.from(data['genre']),
  //         aired: data['aired'],
  //         episodes: data['episodes'],
  //         members: data['members'],
  //         popularity: data['popularity'],
  //         ranked: data['ranked'],
  //         score: data['score'].toDouble(),
  //         imgUrl: data['img_url'],
  //         link: data['link'],
  //       );
  //     }).toList();
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //     return []; // Return an empty list or handle the error accordingly
  //   }
  // }

  // List<AnimeModel.Anime> getAnimeList(AsyncSnapshot<QuerySnapshot> snapshot) {
  //   return snapshot.data!.docs.map((doc) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     return AnimeModel.Anime(
  //       title: data['title'],
  //       synopsis: data['synopsis'],
  //       genre: List<String>.from(data['genre']),
  //       aired: data['aired'],
  //       episodes: data['episodes'],
  //       members: data['members'],
  //       popularity: data['popularity'],
  //       ranked: data['ranked'],
  //       score: data['score'].toDouble(),
  //       imgUrl: data['img_url'],
  //       link: data['link'],
  //     );
  //   }).toList();

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('anime-list-demo');

  // Future<void> getData() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _collectionRef.get();
  //     final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //     print(allData);
  //     ;
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //   }
  // }

  Future<List<Map<String, dynamic>>> getData() async {
    try {
      QuerySnapshot querySnapshot = await _collectionRef.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching data: $e');
      return []; // Return an empty list or handle the error accordingly
    }
  }
}
