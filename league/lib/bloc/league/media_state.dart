import 'package:league/bloc/league/league_models.dart';

class MediaState {
  bool isLoading;
  ImageGalleryModel imageGallery;
  List<Sponser> sponsers;

  MediaState({this.isLoading, this.imageGallery, this.sponsers});
}
