import Debug "mo:base/Debug";
import Principal "mo:base/Principal";

actor class Election (_name: Text) = this {
    Debug.print("Election Works!");

    let name = _name;

    public query func getName() : async Text {
        return name;
    };

    public query func getPrincipal () : async Principal {
        return Principal.fromActor(this);
    };
}