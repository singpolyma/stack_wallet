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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app_config.dart';
import '../../../../db/hive/db.dart';
import '../../../../providers/global/prefs_provider.dart';
import '../../../../providers/global/price_provider.dart';
import '../../../../services/exchange/exchange_data_loading_service.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../themes/theme_providers.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/text_styles.dart';
import '../../../../utilities/util.dart';
import '../../../../widgets/desktop/desktop_dialog.dart';
import '../../../../widgets/desktop/desktop_dialog_close_button.dart';
import '../../../../widgets/desktop/primary_button.dart';
import '../../../../widgets/desktop/secondary_button.dart';
import '../../../../widgets/rounded_white_container.dart';

class StackPrivacyDialog extends ConsumerStatefulWidget {
  const StackPrivacyDialog({super.key});

  @override
  ConsumerState<StackPrivacyDialog> createState() => _StackPrivacyDialog();
}

class _StackPrivacyDialog extends ConsumerState<StackPrivacyDialog> {
  late final bool isDesktop;
  late bool isEasy;
  late bool infoToggle;

  @override
  void initState() {
    isDesktop = Util.isDesktop;
    isEasy = ref.read(prefsChangeNotifierProvider).externalCalls;
    infoToggle = isEasy;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DesktopDialog(
      maxHeight: 650,
      maxWidth: 600,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  "Choose Your ${AppConfig.prefix} Experience",
                  style: STextStyles.desktopH3(context),
                  textAlign: TextAlign.center,
                ),
              ),
              const DesktopDialogCloseButton(),
            ],
          ),
          const SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: PrivacyToggle(
              externalCallsEnabled: isEasy,
              onChanged: (externalCalls) {
                isEasy = externalCalls;
                setState(() {
                  infoToggle = isEasy;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: RoundedWhiteContainer(
              borderColor: Theme.of(context)
                  .extension<StackColors>()!
                  .textFieldDefaultBG,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: isDesktop
                        ? STextStyles.desktopTextExtraExtraSmall(context)
                        : STextStyles.label(context).copyWith(
                            fontSize: 12.0,
                          ),
                    children: infoToggle
                        ? [
                            if (Constants.enableExchange)
                              const TextSpan(
                                text:
                                    "Exchange data preloaded for a seamless experience.",
                              ),
                            const TextSpan(
                              text:
                                  "\n\nCoinGecko enabled: (24 hour price change shown in-app, total wallet value shown in USD or other currency).",
                            ),
                            TextSpan(
                              text: "\n\nRecommended for most crypto users.",
                              style: isDesktop
                                  ? STextStyles.desktopTextExtraExtraSmall600(
                                      context,
                                    )
                                  : TextStyle(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .textDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                            ),
                          ]
                        : [
                            const TextSpan(
                              text:
                                  "Exchange data not preloaded (slower experience).",
                            ),
                            const TextSpan(
                              text:
                                  "\n\nCoinGecko disabled (price changes not shown, no wallet value shown in other currencies).",
                            ),
                            TextSpan(
                              text:
                                  "\n\nRecommended for the privacy conscious.",
                              style: isDesktop
                                  ? STextStyles.desktopTextExtraExtraSmall600(
                                      context,
                                    )
                                  : TextStyle(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .textDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                            ),
                          ],
                  ),
                ),
              ),
            ),
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: "Cancel",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: PrimaryButton(
                    label: "Save",
                    onPressed: () {
                      ref.read(prefsChangeNotifierProvider).externalCalls =
                          isEasy;

                      DB.instance
                          .put<dynamic>(
                        boxName: DB.boxNamePrefs,
                        key: "externalCalls",
                        value: isEasy,
                      )
                          .then((_) {
                        if (isEasy) {
                          if (AppConfig.hasFeature(AppFeature.swap)) {
                            unawaited(
                              ExchangeDataLoadingService.instance.loadAll(),
                            );
                          }
                          ref
                              .read(priceAnd24hChangeNotifierProvider)
                              .start(true);
                        }
                      });
                      if (isDesktop) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyToggle extends ConsumerStatefulWidget {
  const PrivacyToggle({
    super.key,
    required this.externalCallsEnabled,
    this.onChanged,
  });

  final bool externalCallsEnabled;
  final void Function(bool)? onChanged;

  @override
  ConsumerState<PrivacyToggle> createState() => _PrivacyToggleState();
}

class _PrivacyToggleState extends ConsumerState<PrivacyToggle> {
  late bool externalCallsEnabled;

  late final bool isDesktop;

  @override
  void initState() {
    isDesktop = Util.isDesktop;
    // initial toggle state
    externalCallsEnabled = widget.externalCallsEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final easyFile =
        ref.watch(themeProvider.select((value) => value.assets.personaEasy));
    final incognitoFile = ref
        .watch(themeProvider.select((value) => value.assets.personaIncognito));

    return Row(
      children: [
        Expanded(
          child: RawMaterialButton(
            elevation: 0,
            hoverElevation: 0,
            fillColor: Theme.of(context).extension<StackColors>()!.popupBG,
            shape: RoundedRectangleBorder(
              side: !externalCallsEnabled
                  ? BorderSide.none
                  : BorderSide(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .infoItemIcons,
                      width: 2,
                    ),
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius * 2,
              ),
            ),
            onPressed: () {
              setState(() {
                // update toggle state
                externalCallsEnabled = true;
              });
              // call callback with newly set value
              widget.onChanged?.call(externalCallsEnabled);
            },
            child: Padding(
              padding: const EdgeInsets.all(
                12,
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isDesktop)
                        const SizedBox(
                          height: 10,
                        ),
                      //
                      (easyFile.endsWith(".png"))
                          ? Image.file(
                              File(
                                easyFile,
                              ),
                              width: 120,
                              height: 120,
                            )
                          : SvgPicture.file(
                              File(
                                easyFile,
                              ),
                              width: 120,
                              height: 120,
                            ),
                      if (isDesktop)
                        const SizedBox(
                          height: 12,
                        ),
                      Center(
                        child: Text(
                          "Easy Crypto",
                          style: isDesktop
                              ? STextStyles.desktopTextSmall(context)
                              : STextStyles.label700(context),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Recommended",
                          style: isDesktop
                              ? STextStyles.desktopTextExtraExtraSmall(context)
                              : STextStyles.label(context),
                        ),
                      ),
                      if (isDesktop)
                        const SizedBox(
                          height: 12,
                        ),
                    ],
                  ),
                  if (externalCallsEnabled)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: SvgPicture.asset(
                        Assets.svg.checkCircle,
                        width: 20,
                        height: 20,
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .infoItemIcons,
                      ),
                    ),
                  if (!externalCallsEnabled)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .textFieldDefaultBG,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: RawMaterialButton(
            elevation: 0,
            hoverElevation: 0,
            fillColor: Theme.of(context).extension<StackColors>()!.popupBG,
            shape: RoundedRectangleBorder(
              side: externalCallsEnabled
                  ? BorderSide.none
                  : BorderSide(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .infoItemIcons,
                      width: 2,
                    ),
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius * 2,
              ),
            ),
            onPressed: () {
              setState(() {
                // update toggle state
                externalCallsEnabled = false;
              });
              // call callback with newly set value
              widget.onChanged?.call(externalCallsEnabled);
            },
            child: Padding(
              padding: const EdgeInsets.all(
                12,
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isDesktop)
                        const SizedBox(
                          height: 10,
                        ),
                      (incognitoFile.endsWith(".png"))
                          ? Image.file(
                              File(
                                incognitoFile,
                              ),
                              width: 120,
                              height: 120,
                            )
                          : SvgPicture.file(
                              File(
                                incognitoFile,
                              ),
                              width: 120,
                              height: 120,
                            ),
                      // SvgPicture.asset(
                      //   Assets.svg.personaIncognito(context),
                      //   width: 120,
                      //   height: 120,
                      // ),
                      if (isDesktop)
                        const SizedBox(
                          height: 12,
                        ),
                      Center(
                        child: Text(
                          "Incognito",
                          style: isDesktop
                              ? STextStyles.desktopTextSmall(context)
                              : STextStyles.label700(context),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Privacy conscious",
                          style: isDesktop
                              ? STextStyles.desktopTextExtraExtraSmall(context)
                              : STextStyles.label(context),
                        ),
                      ),
                      if (isDesktop)
                        const SizedBox(
                          height: 12,
                        ),
                    ],
                  ),
                  if (!externalCallsEnabled)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: SvgPicture.asset(
                        Assets.svg.checkCircle,
                        width: 20,
                        height: 20,
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .infoItemIcons,
                      ),
                    ),
                  if (externalCallsEnabled)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .textFieldDefaultBG,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
