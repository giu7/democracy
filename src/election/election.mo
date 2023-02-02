import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import List "mo:base/List";

actor class Election (_name: Text, _options: [Text]) = this {
    Debug.print("Election Works!");

    let name = _name;
    let options : [Text] = _options;

    var voters = List.nil<Principal>();

    public query func getName() : async Text {
        return name;
    };

    public query func getPrincipal () : async Principal {
        return Principal.fromActor(this);
    };

    public query func getOptions() : async [Text] {
        return options;
    };

    public shared (msg) func vote() {
        let caller = msg.caller;

        let found = List.find(voters, func(listItem: Principal) : Bool { listItem == caller });
        switch (found) {
            case (null) {
                Debug.print("First Time! You Can Vote!");
                voters := List.push(caller, voters);
            };
            case (?found) {
                Debug.print("You Already Voted!");
            };
        };
    };


/*     public query func ownerOfDip721(token_id: Types.TokenId) : async Types.OwnerResult {
        let item = List.find(nfts, func(token: Types.Nft) : Bool { token.id == token_id });
        switch (item) {
        case (null) {
            return #Err(#InvalidTokenId);
        };
        case (?token) {
            return #Ok(token.owner);
        };
        };
    }; */

    public query func getVoters() : async List.List<Principal> {
        return voters;
    };
};