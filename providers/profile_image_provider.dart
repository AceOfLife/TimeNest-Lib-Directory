import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository_provider.dart';

final profileImageUploadProvider =
    FutureProvider.family<void, File>(
  (ref, imageFile) {
    return ref
        .read(authRepositoryProvider)
        .uploadProfilePhoto(
          imageFile,
        );
  },
);