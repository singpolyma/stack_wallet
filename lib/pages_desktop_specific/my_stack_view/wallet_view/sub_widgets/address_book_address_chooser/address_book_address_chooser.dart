/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../models/isar/models/contact_entry.dart';
import '../../../../../providers/global/address_book_service_provider.dart';
import '../../../../../themes/stack_colors.dart';
import '../../../../../utilities/assets.dart';
import '../../../../../utilities/constants.dart';
import '../../../../../utilities/text_styles.dart';
import '../../../../../utilities/util.dart';
import '../../../../../wallets/crypto_currency/crypto_currency.dart';
import '../../../../../widgets/icon_widgets/x_icon.dart';
import '../../../../../widgets/stack_text_field.dart';
import '../../../../../widgets/textfield_icon_button.dart';
import 'sub_widgets/contact_list_item.dart';

class AddressBookAddressChooser extends StatefulWidget {
  const AddressBookAddressChooser({
    super.key,
    this.coin,
  });

  final CryptoCurrency? coin;

  @override
  State<AddressBookAddressChooser> createState() =>
      _AddressBookAddressChooserState();
}

class _AddressBookAddressChooserState extends State<AddressBookAddressChooser> {
  late final bool isDesktop;
  late final TextEditingController _searchController;
  late final FocusNode searchFieldFocusNode;

  String _searchTerm = "";

  int _compareContactFavorite(ContactEntry a, ContactEntry b) {
    if (a.isFavorite && b.isFavorite) {
      return 0;
    } else if (a.isFavorite) {
      return 1;
    } else {
      return -1;
    }
  }

  List<ContactEntry> pullOutFavorites(List<ContactEntry> contacts) {
    final List<ContactEntry> favorites = [];
    contacts.removeWhere((contact) {
      if (contact.isFavorite) {
        favorites.add(contact);
        return true;
      }
      return false;
    });

    return favorites;
  }

  List<ContactEntry> filter(List<ContactEntry> contacts, String searchTerm) {
    if (widget.coin != null) {
      contacts.removeWhere(
        (e) => e.addressesSorted.where((a) => a.coin == widget.coin!).isEmpty,
      );
    }

    contacts.retainWhere((e) => _matches(searchTerm, e));

    if (contacts.length < 2) {
      return contacts;
    }

    // redundant due to pullOutFavorites?
    contacts.sort(_compareContactFavorite);

    return contacts;
  }

  bool _matches(String term, ContactEntry contact) {
    final text = term.toLowerCase();
    if (contact.name.toLowerCase().contains(text)) {
      return true;
    }
    for (int i = 0; i < contact.addresses.length; i++) {
      if (contact.addresses[i].label.toLowerCase().contains(text) ||
          contact.addresses[i].coin.identifier.toLowerCase().contains(text) ||
          contact.addresses[i].coin.prettyName.toLowerCase().contains(text) ||
          contact.addresses[i].coin.ticker.toLowerCase().contains(text) ||
          contact.addresses[i].address.toLowerCase().contains(text)) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    isDesktop = Util.isDesktop;
    searchFieldFocusNode = FocusNode();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search field
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
            child: TextField(
              autocorrect: !isDesktop,
              enableSuggestions: !isDesktop,
              controller: _searchController,
              focusNode: searchFieldFocusNode,
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              style: isDesktop
                  ? STextStyles.desktopTextExtraSmall(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textFieldActiveText,
                      height: 1.8,
                    )
                  : STextStyles.field(context),
              decoration: standardInputDecoration(
                "Search",
                searchFieldFocusNode,
                context,
                desktopMed: isDesktop,
              ).copyWith(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 12 : 10,
                    vertical: isDesktop ? 18 : 16,
                  ),
                  child: SvgPicture.asset(
                    Assets.svg.search,
                    width: isDesktop ? 20 : 16,
                    height: isDesktop ? 20 : 16,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: UnconstrainedBox(
                          child: Row(
                            children: [
                              TextFieldIconButton(
                                child: const XIcon(),
                                onTap: () async {
                                  setState(() {
                                    _searchController.text = "";
                                    _searchTerm = "";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 32,
              right: 32,
              bottom: 32,
            ),
            child: Consumer(
              builder: (context, ref, _) {
                List<ContactEntry> contacts = ref
                    .watch(
                      addressBookServiceProvider
                          .select((value) => value.contacts),
                    )
                    .toList();

                contacts = filter(contacts, _searchTerm);

                final favorites = pullOutFavorites(contacts);

                final totalLength = favorites.length +
                    contacts.length +
                    2; // +2 for "fav" and "all" headers

                return ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: totalLength,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        key: const Key(
                          "addressBookCAddressChooserFavoritesHeaderItemKey",
                        ),
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Text(
                          "Favorites",
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
                        ),
                      );
                    } else if (index < favorites.length + 1) {
                      final id = favorites[index - 1].customId;
                      return ContactListItem(
                        key: Key("contactContactListItem_${id}_key"),
                        contactId: id,
                        filterByCoin: widget.coin,
                      );
                    } else if (index == favorites.length + 1) {
                      return Padding(
                        key: const Key(
                          "addressBookCAddressChooserAllContactsHeaderItemKey",
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          "All contacts",
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
                        ),
                      );
                    } else {
                      final id =
                          contacts[index - favorites.length - 2].customId;
                      return ContactListItem(
                        key: Key("contactContactListItem_${id}_key"),
                        contactId: id,
                        filterByCoin: widget.coin,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
