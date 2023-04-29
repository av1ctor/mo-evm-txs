import Error "mo:base/Error";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Helper "transactions/Helper";
import Transaction "Transaction";
import Types "Types";
import AU "utils/ArrayUtils";
import EcdsaApi "interfaces/EcdsaApi";

module {
    public func deploy(
        bytecode: [Nat8],
        maxPriorityFeePerGas: Nat64,
        gasLimit: Nat64,
        maxFeePerGas: Nat64,
        chainId: Nat64,
        keyName: Text,
        principal: Principal,
        publicKey: [Nat8],
        nonce: Nat64,
        ctx: Helper.Context,
        api: EcdsaApi.API
    ): async* Result.Result<(Types.TransactionType, [Nat8]), Text> {
        let tx: Types.Transaction1559 = {
            nonce;
            chainId;
            maxPriorityFeePerGas;
            maxFeePerGas;
            gasLimit;
            to = "0x";
            value = 0;
            data = "0x" # AU.toText(bytecode);
            accessList = [];
            v = "0x00";
            r = "0x00";
            s = "0x00";
        };
        switch(Transaction.serialize(#EIP1559(?tx))) {
            case (#err(msg)) {
                return #err(msg);
            };
            case (#ok(rawTx)) {
                return await* Transaction.signWithPrincipal(
                    rawTx, chainId, keyName, principal, publicKey, ctx, api);
            };
        };
    };
}