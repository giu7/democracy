import Debug "mo:base/Debug";
import Principal "mo:base/Principal";

actor class Election (_name: Text, _options: [Text]) = this {
    Debug.print("Election Works!");

    let name = _name;
    let options : [Text] = _options;

    public query func getName() : async Text {
        return name;
    };

    public query func getPrincipal () : async Principal {
        return Principal.fromActor(this);
    };

    public query func getOptions() : async [Text] {
        return options;
    };

    public query func getFirstOption() : async Text {
        return options[0];
    };

    public query func getSecondOption() : async Text {
        return options[1];
    };

    public query func getOptionsSize() : async Nat {
        return options.size();
    };
};