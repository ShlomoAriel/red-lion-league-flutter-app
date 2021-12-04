import 'package:league/bloc/league/league_models.dart';

class MediaState {
  bool? isLoading;
  ImageGalleryModel? imageGallery;
  List<Sponsor>? sponsors;

  MediaState({this.isLoading, this.imageGallery, this.sponsors});
}
