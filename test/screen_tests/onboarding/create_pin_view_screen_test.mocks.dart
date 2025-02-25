// Mocks generated by Mockito 5.4.4 from annotations
// in stackwallet/test/screen_tests/onboarding/create_pin_view_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:ui' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/models/node_model.dart' as _i7;
import 'package:stackwallet/services/node_service.dart' as _i6;
import 'package:stackwallet/services/wallets_service.dart' as _i3;
import 'package:stackwallet/utilities/flutter_secure_storage_interface.dart'
    as _i2;
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart'
    as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSecureStorageInterface_0 extends _i1.SmartFake
    implements _i2.SecureStorageInterface {
  _FakeSecureStorageInterface_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WalletsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockWalletsService extends _i1.Mock implements _i3.WalletsService {
  MockWalletsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<Map<String, _i3.WalletInfo>> get walletNames =>
      (super.noSuchMethod(
        Invocation.getter(#walletNames),
        returnValue: _i4.Future<Map<String, _i3.WalletInfo>>.value(
            <String, _i3.WalletInfo>{}),
      ) as _i4.Future<Map<String, _i3.WalletInfo>>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  void addListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [NodeService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNodeService extends _i1.Mock implements _i6.NodeService {
  MockNodeService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.SecureStorageInterface get secureStorageInterface => (super.noSuchMethod(
        Invocation.getter(#secureStorageInterface),
        returnValue: _FakeSecureStorageInterface_0(
          this,
          Invocation.getter(#secureStorageInterface),
        ),
      ) as _i2.SecureStorageInterface);
  @override
  List<_i7.NodeModel> get primaryNodes => (super.noSuchMethod(
        Invocation.getter(#primaryNodes),
        returnValue: <_i7.NodeModel>[],
      ) as List<_i7.NodeModel>);
  @override
  List<_i7.NodeModel> get nodes => (super.noSuchMethod(
        Invocation.getter(#nodes),
        returnValue: <_i7.NodeModel>[],
      ) as List<_i7.NodeModel>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i4.Future<void> updateDefaults() => (super.noSuchMethod(
        Invocation.method(
          #updateDefaults,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> setPrimaryNodeFor({
    required _i8.CryptoCurrency? coin,
    required _i7.NodeModel? node,
    bool? shouldNotifyListeners = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #setPrimaryNodeFor,
          [],
          {
            #coin: coin,
            #node: node,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i7.NodeModel? getPrimaryNodeFor({required _i8.CryptoCurrency? currency}) =>
      (super.noSuchMethod(Invocation.method(
        #getPrimaryNodeFor,
        [],
        {#currency: currency},
      )) as _i7.NodeModel?);
  @override
  List<_i7.NodeModel> getNodesFor(_i8.CryptoCurrency? coin) =>
      (super.noSuchMethod(
        Invocation.method(
          #getNodesFor,
          [coin],
        ),
        returnValue: <_i7.NodeModel>[],
      ) as List<_i7.NodeModel>);
  @override
  _i7.NodeModel? getNodeById({required String? id}) =>
      (super.noSuchMethod(Invocation.method(
        #getNodeById,
        [],
        {#id: id},
      )) as _i7.NodeModel?);
  @override
  List<_i7.NodeModel> failoverNodesFor(
          {required _i8.CryptoCurrency? currency}) =>
      (super.noSuchMethod(
        Invocation.method(
          #failoverNodesFor,
          [],
          {#currency: currency},
        ),
        returnValue: <_i7.NodeModel>[],
      ) as List<_i7.NodeModel>);
  @override
  _i4.Future<void> add(
    _i7.NodeModel? node,
    String? password,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #add,
          [
            node,
            password,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> delete(
    String? id,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [
            id,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> setEnabledState(
    String? id,
    bool? enabled,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setEnabledState,
          [
            id,
            enabled,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> edit(
    _i7.NodeModel? editedNode,
    String? password,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #edit,
          [
            editedNode,
            password,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> updateCommunityNodes() => (super.noSuchMethod(
        Invocation.method(
          #updateCommunityNodes,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  void addListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
