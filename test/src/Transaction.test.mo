import M "mo:matchers/Matchers";
import S "mo:matchers/Suite";
import T "mo:matchers/Testable";
import Transaction "../../src/Transaction";
import Utils "../../src/Utils";

let context = Transaction.allocContext();

//
// getRecoveryId
//
let getRecoveryId = S.suite("getRecoveryId", [
    S.test("valid",
      do {
        let pubkey = Utils.hexTextToNat8Array("02c397f23149d3464517d57b7cdc8e287428407f9beabfac731e7c24d536266cd1");
        let signature = Utils.hexTextToNat8Array("29edd4e1d65e1b778b464112d2febc6e97bb677aba5034408fd27b49921beca94c4e5b904d58553bcd9c788360e0bd55c513922cf1f33a6386033e886cd4f77f");
        let message = Utils.hexTextToNat8Array("79965df63d7d9364f4bc8ed54ffd1c267042d4db673e129e3c459afbcb73a6f1");
        Transaction.getRecoveryId(message, signature, pubkey, context)
      },
      M.equals(T.result<Nat8, Text>(T.nat8(0), T.text(""), #ok(0: Nat8)))
    ),
    S.test("invalid signature",
      do {
        let pubkey = Utils.hexTextToNat8Array("02c397f23149d3464517d57b7cdc8e287428407f9beabfac731e7c24d536266cd1");
        let signature = Utils.hexTextToNat8Array("");
        let message = Utils.hexTextToNat8Array("79965df63d7d9364f4bc8ed54ffd1c267042d4db673e129e3c459afbcb73a6f1");
        Transaction.getRecoveryId(message, signature, pubkey, context)
      },
      M.equals(T.result<Nat8, Text>(T.nat8(0), T.text(""), #err("Invalid signature")))
    ),
    S.test("invalid message",
      do {
        let pubkey = Utils.hexTextToNat8Array("02c397f23149d3464517d57b7cdc8e287428407f9beabfac731e7c24d536266cd1");
        let signature = Utils.hexTextToNat8Array("29edd4e1d65e1b778b464112d2febc6e97bb677aba5034408fd27b49921beca94c4e5b904d58553bcd9c788360e0bd55c513922cf1f33a6386033e886cd4f77f");
        let message = Utils.hexTextToNat8Array("");
        Transaction.getRecoveryId(message, signature, pubkey, context)
      },
      M.equals(T.result<Nat8, Text>(T.nat8(0), T.text(""), #err("Invalid message")))
    ),
    S.test("invalid public key",
      do {
        let pubkey = Utils.hexTextToNat8Array("");
        let signature = Utils.hexTextToNat8Array("29edd4e1d65e1b778b464112d2febc6e97bb677aba5034408fd27b49921beca94c4e5b904d58553bcd9c788360e0bd55c513922cf1f33a6386033e886cd4f77f");
        let message = Utils.hexTextToNat8Array("79965df63d7d9364f4bc8ed54ffd1c267042d4db673e129e3c459afbcb73a6f1");
        Transaction.getRecoveryId(message, signature, pubkey, context)
      },
      M.equals(T.result<Nat8, Text>(T.nat8(0), T.text(""), #err("Invalid public key")))
    ),
]);

S.run(getRecoveryId);

//
// decodeAccessList
//
let decodeAccessList = S.suite("decodeAccessList", [
    S.test("decode valid",
      do {
        let access_list = "f872f85994de0b295669a9fd93d5f28d9ec85e40f4cb697baef842a00000000000000000000000000000000000000000000000000000000000000003a00000000000000000000000000000000000000000000000000000000000000007d694bb9bc244d798123fde783fcc1c72d3bb8c189413c0";
        Transaction.decodeAccessList(Utils.hexTextToNat8Array(access_list))
      },
      M.equals(T.array<(Text, [Text])>(T.tuple2<Text, [Text]>(T.text(""), T.array<Text>(T.text(""), []), ("", [])), [
        (
          "de0b295669a9fd93d5f28d9ec85e40f4cb697bae",
          [
            "0000000000000000000000000000000000000000000000000000000000000003",
            "0000000000000000000000000000000000000000000000000000000000000007",
          ],
        ),
        (
          "bb9bc244d798123fde783fcc1c72d3bb8c189413",
          [],
        ),
      ]))
    ),
]);

S.run(decodeAccessList);