import 'package:flutter_test/flutter_test.dart';
import 'package:tezster_dart/chain/tezos/tezos_node_writer.dart';
import 'package:tezster_dart/contracts/contractType.dart';
import 'package:tezster_dart/contracts/tzip12/tzip12_contract.dart';
import 'package:tezster_dart/contracts/tzip16/tzip16-contract.dart';
import 'package:tezster_dart/chain/tezos/tezos_language_util.dart';
import 'package:tezster_dart/tezster_dart.dart';

void main() {
  String testPrivateKey =
      "edskRdVS5H9YCRAG8yqZkX2nUTbGcaDqjYgopkJwRuPUnYzCn3t9ZGksncTLYe33bFjq29pRhpvjQizCCzmugMGhJiXezixvdC";
  String testForgedOperation =
      "713cb068fe3ac078351727eb5c34279e22b75b0cf4dc0a8d3d599e27031db136040cb9f9da085607c05cac1ca4c62a3f3cfb8146aa9b7f631e52f877a1d363474404da8130b0b940ee";
  String testMnemonics =
      "luxury bulb roast timber sense stove sugar sketch goddess host meadow decorate gather salmon funny person canoe daring machine network camp moment wrong dice";

  KeyStoreModel _keyStoreModel = KeyStoreModel(
    secretKey:
        "edskRrDH2TF4DwKU1ETsUjyhxPC8aCTD6ko5YDguNkJjRb3PiBm8Upe4FGFmCrQqzSVMDLfFN22XrQXATcA3v41hWnAhymgQwc",
    publicKey: "edpku4ZfXDzF7CjPkX5LS8JFg1Znab3UKdhp18maKq2MrR82Gm9BTc",
    publicKeyHash: "tz1aPUfTyjtUcSnCfSvyykT67atDtVu7FePX",
  );

  test('Get Keys From Mnemonics and PassPhrase', () async {
    List<String> keys =
        await TezsterDart.getKeysFromMnemonic(mnemonic: testMnemonics);
    expect(keys[0],
        "edskRdVS5H9YCRAG8yqZkX2nUTbGcaDqjYgopkJwRuPUnYzCn3t9ZGksncTLYe33bFjq29pRhpvjQizCCzmugMGhJiXezixvdC");
    expect(keys[1], "edpkuLog552hecagkykJ3fTvop6grTMhfZY4TWbvchDWdYyxCHcrQL");
    expect(keys[2], "tz1g85oYHLFKDpNfDHPeBUbi3S7pUsgCB28q");
  });

  test('Restore account from secret key', () {
    List<String?> keys =
        TezsterDart.getKeysFromSecretKey(_keyStoreModel.secretKey);
    expect(keys[0], _keyStoreModel.secretKey);
    expect(keys[1], _keyStoreModel.publicKey);
    expect(keys[2], _keyStoreModel.publicKeyHash);
  });

  test('Sign Operation Group', () async {
    List<String> keys = await TezsterDart.signOperationGroup(
      forgedOperation: testForgedOperation,
      privateKey: testPrivateKey,
    );
    expect(keys[0],
        "edsigtrBnsjSngfP6LULUDeo84eJVks4LWReYrZBUjKQNJjhVsG7bksqZ7CKnRePMceMe3vgRHHbyd2CqRdC8iEAK5NcyNn4iEB");
    expect(keys[1],
        "713cb068fe3ac078351727eb5c34279e22b75b0cf4dc0a8d3d599e27031db136040cb9f9da085607c05cac1ca4c62a3f3cfb8146aa9b7f631e52f877a1d363474404da8130b0b940ee8c7ce5bf2968c1204c1c4b2ba98bcbd08fc4ad3cad706d39ac55e4dd61fde5a8496840ce2d377389a4ca7842bf613d3f096fda819c26e43adfb0cad1336a430d");
  });

  test('Unlock Fundraiser Identity', () async {
    List<String> keys = await TezsterDart.unlockFundraiserIdentity(
      mnemonic:
          "cannon rabbit obvious drama slogan net acoustic donor core acoustic clinic poem travel plunge winter",
      email: "lkbpoife.tobqgidu@tezos.example.org",
      passphrase: "5tjpU0cimq",
    );
    expect(keys[0],
        "edskRzNDm2dpqe2yd5zYAw1vmjr8sAwMubfcXajxdCNNr4Ud39BoppeqMAzoCPmb14mzfXRhjtydQjCbqU2VzWrsq6JP4D9GVb");
    expect(keys[1], "edpkvASxrq16v5Awxpz4XPTA2d6QFaCL8expPrPNcVgVbWxT84Kdw2");
    expect(keys[2], "tz1hhkSbaocSWm3wawZUuUdX57L3maSH16Pv");
  });

  test('Create Soft Signer', () async {
    await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(_keyStoreModel.secretKey, 'edsk'));
  });

  test('send-Transaction-Operation', () async {
    var signer = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(_keyStoreModel.secretKey, 'edsk'));
    const server = 'https://testnet.tezster.tech';

    var result = await TezsterDart.sendTransactionOperation(
      server,
      signer,
      _keyStoreModel,
      'tz1dTkCS1NQwapmafZwCoqBq1QhXmopKDLcj',
      500000,
      1500,
    );
    expect(true,
        result['operationGroupID'] != null && result['operationGroupID'] != '');
  });

  test('send-Delegation-Operation', () async {
    var signer = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(_keyStoreModel.secretKey, 'edsk'));
    const server = 'https://testnet.tezster.tech';

    var result = await TezsterDart.sendDelegationOperation(
      server,
      signer,
      _keyStoreModel,
      'tz1dTkCS1NQwapmafZwCoqBq1QhXmopKDLcj',
      10000,
    );

    expect(true,
        result['operationGroupID'] != null && result['operationGroupID'] != '');
  });

  test('restore identity from mnemonic', () async {
    List<String> keys = await TezsterDart.restoreIdentityFromDerivationPath(
        "m/44'/1729'/0'/0'",
        "curious roof motor parade analyst riot chronic actor pony random ring slot");
    expect(keys[0],
        'edskRzZLyGkhw9fmibXfqyMuEtEaa8Lxfqz9VBAq7LZbb4AfNQrgbtwW7Tv8qRyr44M89KrTTdLoxML29wEXc2864QuG1xWijP');
    expect(keys[1], 'edpkvPPibVYfQd7uohshcoS7Q2XXTD6vgsJWBrYHmDypkVabWh8czs');
    expect(keys[2], 'tz1Kx6NQZ2M4a9FssBswKyT25USCXWHcTbw7');
  });

  test("Get Contract Storage", () async {
    var contract = TezsterDart.getContract(
        "https://mainnet.api.tez.ie", "KT1DLif2x9BtK6pUq9ZfFVVyW5wN2kau9rkW");
    Map? x = await contract.getStorage();
    print(x);
  });

  test("Call entry point", () async {
    var contract = TezsterDart.getContract("https://florencenet.api.tez.ie",
        "KT1P5FNjJ4EdeRFLz1PryUu6P83KpSy7jVoh");

    var signer = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(_keyStoreModel.secretKey, 'edsk'));

    await contract.callEntrypoint(
        signer: signer,
        keyStore: _keyStoreModel,
        amount: 111,
        fee: 1000,
        gasLimit: 10000,
        storageLimit: 10000,
        entrypoint: 'make_payment',
        parameters: {"int": "0"},
        parameterFormat: TezosParameterFormat.Micheline);
  });
  test("List Entry point", () async {
    var contract = TezsterDart.getContract("https://florencenet.api.tez.ie",
        "KT1P5FNjJ4EdeRFLz1PryUu6P83KpSy7jVoh");
    print(await contract.listEntrypoints());
  });

  test("Get Contract Balance", () async {
    var contract = TezsterDart.getContract("https://florencenet.api.tez.ie",
        "KT1P5FNjJ4EdeRFLz1PryUu6P83KpSy7jVoh");
    print(await contract.getBalance());
  });

  test('Tzip 12 metadata test', () async {
    Tzip12Contract tzip12Contract = TezsterDart.getContract(
        'https://mainnet.api.tez.ie', 'KT1RJ6PbjHpwc3M5rw5s2Nbmefwbuwbdxton',
        contractType: ContractType.Tzip12) as Tzip12Contract;
    var metaData = await tzip12Contract.getMetadata();
    print(metaData);
  });

  test('Tzip 16 metadata View test', () async {
    Tzip16Contract tzip16Contract = TezsterDart.getContract(
        'https://mainnet.api.tez.ie', 'KT1StkBRUfJD9AuHAE4oQVi49qLQhsgeDcU1',
        contractType: ContractType.Tzip16) as Tzip16Contract;
    var metaView = await tzip16Contract.metadataViews();
    print(metaView);
  });

  test('Tzip 12 Token Id test', () async {
    var tzip12Contract = Tzip12Contract(
        address: 'KT1RJ6PbjHpwc3M5rw5s2Nbmefwbuwbdxton',
        rpcServer: 'https://mainnet.api.tez.ie');
    print(await tzip12Contract.getTokenMetadata(1392));
  });

  test('Michelson parser test', () {
    var data =
        """{"prim":"Right","args":[{"prim":"Left","args":[{"prim":"Left","args":[{"prim":"Pair","args":[{"prim":"Pair","args":[{"int":"331"},{"int":"99"}]},{"string":"tz1QQpKV6gd6VvGeSVddpXv85Y7mSJ4MVLdc"}]}]}]}]}""";
    var d = TezosLanguageUtil.translateMichelineToHex(data);
    print(d);
  });

  // group('FA1.2 Plenty Contract', () {
    
  // });
}
