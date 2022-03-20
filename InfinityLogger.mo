import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Deque "mo:base/Deque";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

import Logger "mo:ic-logger/Logger";

shared(msg) actor class InfinityLogger() {
    let OWNER = msg.caller;

    var state : Buffer.Buffer<Logger.State<Text>> = Buffer.Buffer<Logger.State<Text>>(100);

    var index : Nat = 0;


    public shared (msg) func append(msgs: [Text]) {
        if (state.get(index).num_of_buckets > 100) {
            let newLogger = Logger.new<Text>(0, null);
            state.add(newLogger);
            index := index + 1;
        };

        let logger = Logger.Logger<Text>(state.get(index));
        logger.append(msgs);
    };

    public query (msg) func view(from: Nat, to: Nat) : async Logger.View<Text> {
        assert(to - from < 100);
        let startIndex = from / 100;
        let number = to - from;
        let logger = Logger.Logger<Text>(state.get(index));
        logger.view(0, number);
    }
}