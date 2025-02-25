/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../notifications/show_flush_bar.dart';
import '../../../../pages/add_wallet_views/new_wallet_recovery_phrase_view/sub_widgets/mnemonic_table.dart';
import '../../../../providers/global/secure_store_provider.dart';
import '../../../../providers/global/wallets_provider.dart';
import '../../../../route_generator.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/clipboard_interface.dart';
import '../../../../utilities/text_styles.dart';
import '../../../../wallets/isar/providers/wallet_info_provider.dart';
import '../../../../widgets/desktop/desktop_dialog.dart';
import '../../../../widgets/desktop/desktop_dialog_close_button.dart';
import '../../../../widgets/desktop/primary_button.dart';
import '../../../../widgets/desktop/secondary_button.dart';

class DeleteWalletKeysPopup extends ConsumerStatefulWidget {
  const DeleteWalletKeysPopup({
    super.key,
    required this.walletId,
    required this.words,
    this.clipboardInterface = const ClipboardWrapper(),
  });

  final String walletId;
  final List<String> words;
  final ClipboardInterface clipboardInterface;

  static const String routeName = "/desktopDeleteWalletKeysPopup";

  @override
  ConsumerState<DeleteWalletKeysPopup> createState() =>
      _DeleteWalletKeysPopup();
}

class _DeleteWalletKeysPopup extends ConsumerState<DeleteWalletKeysPopup> {
  late final String _walletId;
  late final List<String> _words;
  late final ClipboardInterface _clipboardInterface;

  @override
  void initState() {
    _walletId = widget.walletId;
    _words = widget.words;
    _clipboardInterface = widget.clipboardInterface;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DesktopDialog(
      maxWidth: 614,
      maxHeight: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                ),
                child: Text(
                  "Wallet keys",
                  style: STextStyles.desktopH3(context),
                ),
              ),
              DesktopDialogCloseButton(
                onPressedOverride: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          Text(
            "Recovery phrase",
            style: STextStyles.desktopTextMedium(context),
          ),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Text(
                "Please write down your recovery phrase in the correct order and "
                "save it to keep your funds secure. You will be shown your recovery phrase on the next screen.",
                style: STextStyles.desktopTextExtraExtraSmall(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: RawMaterialButton(
              hoverColor: Colors.transparent,
              onPressed: () async {
                await _clipboardInterface.setData(
                  ClipboardData(text: _words.join(" ")),
                );
                if (mounted) {
                  unawaited(
                    showFloatingFlushBar(
                      type: FlushBarType.info,
                      message: "Copied to clipboard",
                      iconAsset: Assets.svg.copy,
                      context: context,
                    ),
                  );
                }
              },
              child: MnemonicTable(
                words: widget.words,
                isDesktop: true,
                itemBorderColor: Theme.of(context)
                    .extension<StackColors>()!
                    .buttonBackSecondary,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: "Continue",
                    onPressed: () async {
                      await Navigator.of(context).push(
                        RouteGenerator.getRoute(
                          builder: (context) {
                            return ConfirmDelete(
                              walletId: _walletId,
                            );
                          },
                          settings: const RouteSettings(
                            name: "/desktopConfirmDelete",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

class ConfirmDelete extends ConsumerStatefulWidget {
  const ConfirmDelete({
    super.key,
    required this.walletId,
  });

  final String walletId;

  @override
  ConsumerState<ConfirmDelete> createState() => _ConfirmDeleteState();
}

class _ConfirmDeleteState extends ConsumerState<ConfirmDelete> {
  @override
  Widget build(BuildContext context) {
    return DesktopDialog(
      maxHeight: 350,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DesktopDialogCloseButton(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Thanks! "
                "\n\nYour wallet will be deleted.",
                style: STextStyles.desktopH2(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecondaryButton(
                    width: 250,
                    buttonHeight: ButtonHeight.xl,
                    label: "Cancel",
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    width: 250,
                    buttonHeight: ButtonHeight.xl,
                    label: "Continue",
                    onPressed: () async {
                      await ref.read(pWallets).deleteWallet(
                            ref.read(pWalletInfo(widget.walletId)),
                            ref.read(secureStoreProvider),
                          );

                      if (mounted) {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
