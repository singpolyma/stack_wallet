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
import 'package:flutter_svg/svg.dart';
import 'package:tuple/tuple.dart';

import '../../../exceptions/wallet/insufficient_balance_exception.dart';
import '../../../models/paynym/paynym_account_lite.dart';
import '../../../notifications/show_flush_bar.dart';
import '../../../providers/global/locale_provider.dart';
import '../../../providers/global/wallets_provider.dart';
import '../../../route_generator.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/text_styles.dart';
import '../../../wallets/isar/providers/wallet_info_provider.dart';
import '../../../wallets/models/tx_data.dart';
import '../../../wallets/wallet/wallet_mixin_interfaces/paynym_interface.dart';
import '../../../widgets/custom_buttons/paynym_follow_toggle_button.dart';
import '../../../widgets/desktop/desktop_dialog.dart';
import '../../../widgets/desktop/primary_button.dart';
import '../../../widgets/desktop/secondary_button.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/qr.dart';
import '../../../widgets/rounded_container.dart';
import '../../../widgets/stack_dialog.dart';
import '../../send_view/confirm_transaction_view.dart';
import '../../send_view/send_view.dart';
import '../paynym_home_view.dart';
import '../subwidgets/paynym_bot.dart';
import 'confirm_paynym_connect_dialog.dart';

class PaynymDetailsPopup extends ConsumerStatefulWidget {
  const PaynymDetailsPopup({
    super.key,
    required this.walletId,
    required this.accountLite,
  });

  final String walletId;
  final PaynymAccountLite accountLite;

  @override
  ConsumerState<PaynymDetailsPopup> createState() => _PaynymDetailsPopupState();
}

class _PaynymDetailsPopupState extends ConsumerState<PaynymDetailsPopup> {
  bool _showInsufficientFundsInfo = false;

  Future<void> _onSend() async {
    final wallet = ref.read(pWallets).getWallet(widget.walletId);
    await Navigator.of(context).pushNamed(
      SendView.routeName,
      arguments: Tuple3(
        wallet.walletId,
        wallet.info.coin,
        widget.accountLite,
      ),
    );
  }

  Future<void> _onConnectPressed() async {
    bool canPop = false;
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async => canPop,
          child: const LoadingIndicator(
            width: 200,
          ),
        ),
      ),
    );

    final wallet =
        ref.read(pWallets).getWallet(widget.walletId) as PaynymInterface;
    final coin = ref.read(pWalletCoin(widget.walletId));

    if (await wallet.hasConnected(widget.accountLite.code)) {
      canPop = true;
      Navigator.of(context).pop();
      // TODO show info popup
      return;
    }

    final rates = await ref.read(pWallets).getWallet(widget.walletId).fees;

    TxData preparedTx;

    try {
      preparedTx = await wallet.prepareNotificationTx(
        selectedTxFeeRate: rates.medium,
        targetPaymentCodeString: widget.accountLite.code,
      );
    } on InsufficientBalanceException catch (_) {
      if (mounted) {
        canPop = true;
        Navigator.of(context).pop();
      }
      setState(() {
        _showInsufficientFundsInfo = true;
      });
      return;
    } catch (e) {
      if (mounted) {
        canPop = true;
        Navigator.of(context).pop();
      }

      await showDialog<void>(
        context: context,
        builder: (context) => StackOkDialog(
          title: "Error",
          message: e.toString(),
        ),
      );
      return;
    }

    if (mounted) {
      // We have enough balance and prepared tx should be good to go.

      canPop = true;
      // close loading
      Navigator.of(context).pop();

      // Close details
      Navigator.of(context).pop();

      // show info pop up
      await showDialog<void>(
        context: context,
        builder: (context) => ConfirmPaynymConnectDialog(
          nymName: widget.accountLite.nymName,
          locale: ref.read(localeServiceChangeNotifierProvider).locale,
          onConfirmPressed: () {
            Navigator.of(context).push(
              RouteGenerator.getRoute(
                builder: (_) => ConfirmTransactionView(
                  walletId: widget.walletId,
                  routeOnSuccessName: PaynymHomeView.routeName,
                  isPaynymNotificationTransaction: true,
                  txData: preparedTx,
                  onSuccess: () {
                    // do nothing extra
                  },
                ),
              ),
            );
          },
          amount: preparedTx.amount! + preparedTx.fee!,
          coin: coin,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet =
        ref.watch(pWallets).getWallet(widget.walletId) as PaynymInterface;

    return DesktopDialog(
      maxWidth: MediaQuery.of(context).size.width - 32,
      maxHeight: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 24,
              right: 24,
              bottom: 16,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        PayNymBot(
                          paymentCodeString: widget.accountLite.code,
                          size: 36,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.accountLite.nymName,
                              style: STextStyles.w600_14(context),
                            ),
                            FutureBuilder(
                              future:
                                  wallet.hasConnected(widget.accountLite.code),
                              builder: (context, AsyncSnapshot<bool> snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data == true) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Connected",
                                        style: STextStyles.w500_12(context)
                                            .copyWith(
                                          color: Theme.of(context)
                                              .extension<StackColors>()!
                                              .accentColorGreen,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: wallet.hasConnected(widget.accountLite.code),
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          if (snapshot.data!) {
                            return PrimaryButton(
                              label: "Send",
                              buttonHeight: ButtonHeight.xl,
                              icon: SvgPicture.asset(
                                Assets.svg.circleArrowUpRight,
                                width: 14,
                                height: 14,
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .buttonTextPrimary,
                              ),
                              iconSpacing: 8,
                              width: 100,
                              onPressed: _onSend,
                            );
                          } else {
                            return PrimaryButton(
                              label: "Connect",
                              buttonHeight: ButtonHeight.xl,
                              icon: SvgPicture.asset(
                                Assets.svg.circlePlusFilled,
                                width: 13,
                                height: 13,
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .buttonTextPrimary,
                              ),
                              iconSpacing: 8,
                              width: 128,
                              onPressed: _onConnectPressed,
                            );
                          }
                        } else {
                          return const SizedBox(
                            height: 32,
                            child: LoadingIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
                if (_showInsufficientFundsInfo)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      RoundedContainer(
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .warningBackground,
                        child: Text(
                          "Adding a PayNym to your contacts requires a one-time "
                          "transaction fee for creating the record on the "
                          "blockchain. Please deposit more "
                          "${ref.watch(pWalletCoin(widget.walletId)).ticker} "
                          "into your wallet and try again.",
                          style: STextStyles.infoSmall(context).copyWith(
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .warningForeground,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).extension<StackColors>()!.backgroundAppBar,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 16,
              right: 24,
              bottom: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 86),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "PayNym address",
                          style: STextStyles.infoSmall(context).copyWith(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.accountLite.code,
                          style: STextStyles.infoSmall(context).copyWith(
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textDark,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                QR(
                  padding: const EdgeInsets.all(0),
                  size: 100,
                  data: widget.accountLite.code,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Row(
              children: [
                Expanded(
                  child: PaynymFollowToggleButton(
                    walletId: widget.walletId,
                    paymentCodeStringToFollow: widget.accountLite.code,
                    style: PaynymFollowToggleButtonStyle.detailsPopup,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: SecondaryButton(
                    label: "Copy",
                    buttonHeight: ButtonHeight.xl,
                    iconSpacing: 8,
                    icon: SvgPicture.asset(
                      Assets.svg.copy,
                      width: 12,
                      height: 12,
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .buttonTextSecondary,
                    ),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: widget.accountLite.code,
                        ),
                      );
                      unawaited(
                        showFloatingFlushBar(
                          type: FlushBarType.info,
                          message: "Copied to clipboard",
                          iconAsset: Assets.svg.copy,
                          context: context,
                        ),
                      );
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
