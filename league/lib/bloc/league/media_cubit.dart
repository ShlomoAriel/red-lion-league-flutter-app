import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/media_state.dart';
import 'league_repository.dart';
import 'league_models.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaState(isLoading: true, imageGallery: defaultGallery()));

  void init() async {
    var gallery = await (getGallery());
    var sponsors = await getSponsors();
    if (gallery!.imageURLs!.length > 0) {
      MediaState state =
          new MediaState(isLoading: false, imageGallery: gallery, sponsors: sponsors);
      emit(state);
    }
  }

  static ImageGalleryModel defaultGallery() {
    return ImageGalleryModel(imageURLs: [
      'https://i.imgur.com/128iWylh.jpg',
      'https://i.imgur.com/IOOuJPzh.jpg',
      'https://i.imgur.com/CDTbIghh.jpg',
      'https://i.imgur.com/cEp4nvhh.jpg',
      'https://i.imgur.com/c0WQhRIh.jpg',
      'https://i.imgur.com/jJD28Srh.jpg',
      'https://i.imgur.com/ehdBfUkh.jpg',
      'https://i.imgur.com/oBAXUCqh.jpg',
      'https://i.imgur.com/ZAwJAlAh.jpg',
      'https://i.imgur.com/jJD28Srh.jpg',
      'https://i.imgur.com/7cSF86Mh.jpg',
      'https://i.imgur.com/pA6NAkph.jpg'
    ]);
  }
}
