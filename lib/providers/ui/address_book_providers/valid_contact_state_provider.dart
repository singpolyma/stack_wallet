/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'address_entry_data_provider.dart';

final validContactStateProvider =
    StateProvider.autoDispose.family<bool, List<int>>((ref, ids) {
  bool isValid = true;

  bool hasAtLeastOneValid = false;

  for (int i = 0; i < ids.length; i++) {
    final _valid = ref.watch(
      addressEntryDataProvider(ids[i]).select((value) => value.isValid),
    );

    final _isEmpty = ref.watch(
      addressEntryDataProvider(ids[i]).select((value) => value.isEmpty),
    );

    isValid = isValid && (_valid || _isEmpty);
    if (_valid) {
      hasAtLeastOneValid = true;
    }
  }
  return isValid && hasAtLeastOneValid;
});
