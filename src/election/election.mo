import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import List "mo:base/List";
import HashMap  "mo:base/HashMap";
import Text "mo:base/Text";

actor class Election (_name: Text, _options: [Text]) = this {
    Debug.print("Election Works!");

    let name = _name;
    let options : [Text] = _options;

    var voters = List.nil<Principal>();
    var votes = HashMap.HashMap<Text, Nat>(1, Text.equal, Text.hash);

    public query func getName() : async Text {
        return name;
    };

    public query func getPrincipal () : async Principal {
        return Principal.fromActor(this);
    };

    public query func getOptions() : async [Text] {
        return options;
    };

    public query func getYes() : async Nat {
        var yesCount : Nat = switch (votes.get("Yes")) {
            case null 0;
            case (?result) result;
        };
        return yesCount;
    };

    public query func getNo() : async Nat {
        var noCount : Nat = switch (votes.get("No")) {
            case null 0;
            case (?result) result;
        };
        return noCount;
    };
    
    public shared (msg) func vote(option: Text) {
        let caller = msg.caller;
        Debug.print(debug_show(option));

        if (option != "Yes" and option != "No") {
            Debug.print("Invalid Option");
            return;
        };

        let found = List.find(voters, func(listItem: Principal) : Bool { listItem == caller });
        switch (found) {
            case (null) {
                Debug.print("First Time! You Can Vote!");
                voters := List.push(caller, voters);
            };
            case (?found) {
                Debug.print("You Already Voted!");
                return;
            };
        };

        var votesCount : Nat = switch (votes.get(option)) {
            case null 0;
            case (?result) result;
        };
        Debug.print("votesCount");
        Debug.print(debug_show(votesCount));

        votes.put(option, votesCount + 1);
    };

    public query func getVoters() : async List.List<Principal> {
        return voters;
    };
};